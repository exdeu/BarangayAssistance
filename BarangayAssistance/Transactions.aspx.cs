using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace BarangayAssistance
{
    public partial class Transactions : System.Web.UI.Page
    {
        private bool ShowingMyTransactions
        {
            get { return ViewState["ShowingMyTransactions"] != null && (bool)ViewState["ShowingMyTransactions"]; }
            set { ViewState["ShowingMyTransactions"] = value; }
        }
        private void LoadPublicTransactions()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

            StringBuilder query = new StringBuilder(@"
        SELECT
            full_name,
            assistance_type,
            estimated_amount_requested,
            date_submitted,
            status
        FROM assistance_applications
        WHERE status IN ('Approved', 'Released')
    ");

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;

                AddPublicTypeFilter(query, cmd);
                AddPublicStatusFilter(query, cmd);

                if (!string.IsNullOrWhiteSpace(pubDateFrom.Text))
                {
                    query.Append(" AND CAST(date_submitted AS DATE) >= @pubDateFrom");
                    cmd.Parameters.AddWithValue("@pubDateFrom", DateTime.Parse(pubDateFrom.Text).Date);
                }

                if (!string.IsNullOrWhiteSpace(pubDateTo.Text))
                {
                    query.Append(" AND CAST(date_submitted AS DATE) <= @pubDateTo");
                    cmd.Parameters.AddWithValue("@pubDateTo", DateTime.Parse(pubDateTo.Text).Date);
                }

                query.Append(" ORDER BY date_submitted DESC");
                cmd.CommandText = query.ToString();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvPublicTransactions.DataSource = dt;
                gvPublicTransactions.DataBind();

                LoadPublicDashboardSummary();
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string role = Session["role"] == null ? "" : Session["role"].ToString();

                if (string.IsNullOrEmpty(role))
                {
                    pnlDashboardLayout.Visible = false;
                    pnlPublicNav.Visible = true;
                    pnlPublicTransactions.Visible = true;

                    LoadPublicTransactions();
                }
                else
                {
                    pnlDashboardLayout.Visible = true;
                    pnlPublicNav.Visible = false;
                    pnlPublicTransactions.Visible = false;


                    if (role == "Beneficiary")
                    {
                        btnMyTransactions.Visible = true;
                        ShowingMyTransactions = true;
                        LoadTransactions(true);
                    }
                    else
                    {
                        btnMyTransactions.Visible = false;
                        ShowingMyTransactions = false;
                        LoadTransactions(false);
                    }
                }
            }
        }

        public bool IsAdmin()
        {
            return Session["role"] != null && Session["role"].ToString() == "Admin";
        }

        private void LoadTransactions(bool beneficiaryOnly)
        {
            string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

            StringBuilder query = new StringBuilder(@"
                SELECT
                    application_id,
                    full_name,
                    beneficiary_type,
                    assistance_type,
                    estimated_amount_requested,
                    urgency_level,
                    status,
                    date_submitted
                FROM assistance_applications
                WHERE 1 = 1
            ");

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;

                // Filter by beneficiary if needed
                if (beneficiaryOnly)
                {
                    if (Session["UserID"] == null)
                    {
                        lblMessage.Text = "Please login to view your transactions.";
                        return;
                    }

                    query.Append(" AND beneficiary_id = @beneficiary_id");
                    cmd.Parameters.AddWithValue("@beneficiary_id",
                        Convert.ToInt32(Session["UserID"]));
                }

                // Type filters
                AddTypeFilter(query, cmd);

                // Status filters
                AddStatusFilter(query, cmd);

                // Date filters
                if (!string.IsNullOrWhiteSpace(txtDateFrom.Text))
                {
                    query.Append(" AND CAST(date_submitted AS DATE) >= @dateFrom");
                    cmd.Parameters.AddWithValue("@dateFrom",
                        DateTime.Parse(txtDateFrom.Text).Date);
                }

                if (!string.IsNullOrWhiteSpace(txtDateTo.Text))
                {
                    query.Append(" AND CAST(date_submitted AS DATE) <= @dateTo");
                    cmd.Parameters.AddWithValue("@dateTo",
                        DateTime.Parse(txtDateTo.Text).Date);
                }

                query.Append(" ORDER BY date_submitted DESC");
                cmd.CommandText = query.ToString();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTransactions.DataSource = dt;
                gvTransactions.DataBind();

                lblMessage.Text = dt.Rows.Count + " application(s) found.";
            }
        }

        private void AddTypeFilter(StringBuilder query, SqlCommand cmd)
        {
            StringBuilder values = new StringBuilder();
            int count = 0;

            AddFilterValue(values, cmd, ref count, chkMedical.Checked, "Medical", "type");
            AddFilterValue(values, cmd, ref count, chkFinancial.Checked, "Financial", "type");
            AddFilterValue(values, cmd, ref count, chkBurial.Checked, "Burial", "type");
            AddFilterValue(values, cmd, ref count, chkEducational.Checked, "Educational", "type");
            AddFilterValue(values, cmd, ref count, chkFood.Checked, "Food", "type");
            AddFilterValue(values, cmd, ref count, chkEmergency.Checked, "Emergency", "type");

            if (count > 0)
                query.Append(" AND assistance_type IN (" + values + ")");
        }

        private void AddStatusFilter(StringBuilder query, SqlCommand cmd)
        {
            StringBuilder values = new StringBuilder();
            int count = 0;

            AddFilterValue(values, cmd, ref count, chkPending.Checked, "Pending", "status");
            AddFilterValue(values, cmd, ref count, chkApproved.Checked, "Approved", "status");
            AddFilterValue(values, cmd, ref count, chkRejected.Checked, "Rejected", "status");
            AddFilterValue(values, cmd, ref count, chkReleased.Checked, "Released", "status");

            if (count > 0)
                query.Append(" AND status IN (" + values + ")");
        }

        private void AddFilterValue(StringBuilder values, SqlCommand cmd,
            ref int count, bool isChecked, string value, string prefix)
        {
            if (isChecked)
            {
                string paramName = "@" + prefix + count;
                if (count > 0) values.Append(", ");
                values.Append(paramName);
                cmd.Parameters.AddWithValue(paramName, value);
                count++;
            }
        }

        protected void btnApplyFilter_Click(object sender, EventArgs e)
        {
            LoadTransactions(ShowingMyTransactions);
        }

        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            chkMedical.Checked = false;
            chkFinancial.Checked = false;
            chkBurial.Checked = false;
            chkEducational.Checked = false;
            chkFood.Checked = false;
            chkEmergency.Checked = false;
            chkPending.Checked = false;
            chkApproved.Checked = false;
            chkRejected.Checked = false;
            chkReleased.Checked = false;
            txtDateFrom.Text = "";
            txtDateTo.Text = "";

            LoadTransactions(ShowingMyTransactions);
        }

        protected void btnMyTransactions_Click(object sender, EventArgs e)
        {
            ShowingMyTransactions = true;
            LoadTransactions(true);
        }

        protected void gvTransactions_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName != "ApproveApplication" && e.CommandName != "RejectApplication")
                return;

            if (!IsAdmin())
            {
                lblMessage.Text = "⚠️ Only admins can do this.";
                return;
            }

            int appId = Convert.ToInt32(e.CommandArgument);
            bool isApprove = e.CommandName == "ApproveApplication";
            string newStatus = isApprove ? "Approved" : "Rejected";

            string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    string updateQuery = @"
                UPDATE assistance_applications
                SET status = @status,
                    date_updated = GETDATE()
                WHERE application_id = @application_id
                AND status = 'Pending'";

                    int rowsAffected;

                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@status", newStatus);
                        cmd.Parameters.AddWithValue("@application_id", appId);

                        rowsAffected = cmd.ExecuteNonQuery();
                    }

                    if (rowsAffected == 0)
                    {
                        transaction.Rollback();
                        lblMessage.Text = "⚠️ This application was already processed or does not exist.";
                        return;
                    }

                    int beneficiaryId = 0;
                    string fullName = "";
                    string assistanceType = "";

                    string selectQuery = @"
                SELECT beneficiary_id, full_name, assistance_type
                FROM assistance_applications
                WHERE application_id = @application_id";

                    using (SqlCommand cmd = new SqlCommand(selectQuery, conn, transaction))
                    {
                        cmd.Parameters.AddWithValue("@application_id", appId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                beneficiaryId = Convert.ToInt32(reader["beneficiary_id"]);
                                fullName = reader["full_name"].ToString();
                                assistanceType = reader["assistance_type"].ToString();
                            }
                        }
                    }

                    string beneficiaryTitle = isApprove
                        ? "Application Approved"
                        : "Application Rejected";

                    string beneficiaryMessage = isApprove
                        ? "Your " + assistanceType + " assistance application has been approved. Please wait for claiming instructions from the barangay office."
                        : "Your " + assistanceType + " assistance application has been rejected. Please visit the barangay office for more information.";

                    InsertNotification(
                        conn,
                        transaction,
                        beneficiaryId,
                        beneficiaryTitle,
                        beneficiaryMessage,
                        "Beneficiary"
                    );

                    string adminTitle = isApprove
                        ? "Application Approved"
                        : "Application Rejected";

                    string adminMessage = isApprove
                        ? "Application #" + appId + " for " + fullName + " (" + assistanceType + ") has been approved."
                        : "Application #" + appId + " for " + fullName + " (" + assistanceType + ") has been rejected.";

                    InsertNotification(
                        conn,
                        transaction,
                        null,
                        adminTitle,
                        adminMessage,
                        "Admin"
                    );

                    transaction.Commit();

                    lblMessage.Text = isApprove
                        ? "✅ Application approved and notification saved."
                        : "❌ Application rejected and notification saved.";

                    LoadTransactions(ShowingMyTransactions);
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
        }
        private void InsertNotification( SqlConnection conn, SqlTransaction transaction, int? beneficiaryId, string title, string message, string type)
        {
            string query = @"
                INSERT INTO notifications
                (beneficiary_id, title, message, type, is_read, date_created, date_read)
                VALUES
                (@beneficiary_id, @title, @message, @type, 0, GETDATE(), NULL)";

            using (SqlCommand cmd = new SqlCommand(query, conn, transaction))
            {
                if (beneficiaryId.HasValue)
                    cmd.Parameters.AddWithValue("@beneficiary_id", beneficiaryId.Value);
                else
                    cmd.Parameters.AddWithValue("@beneficiary_id", DBNull.Value);

                cmd.Parameters.AddWithValue("@title", title);
                cmd.Parameters.AddWithValue("@message", message);
                cmd.Parameters.AddWithValue("@type", type);

                cmd.ExecuteNonQuery();
            }
        }
        private void AddPublicTypeFilter(StringBuilder query, SqlCommand cmd)
        {
            StringBuilder values = new StringBuilder();
            int count = 0;

            AddFilterValue(values, cmd, ref count, pubChkMedical.Checked, "Medical", "pubType");
            AddFilterValue(values, cmd, ref count, pubChkFinancial.Checked, "Financial", "pubType");
            AddFilterValue(values, cmd, ref count, pubChkBurial.Checked, "Burial", "pubType");
            AddFilterValue(values, cmd, ref count, pubChkEducational.Checked, "Educational", "pubType");
            AddFilterValue(values, cmd, ref count, pubChkFood.Checked, "Food", "pubType");
            AddFilterValue(values, cmd, ref count, pubChkEmergency.Checked, "Emergency", "pubType");

            if (count > 0)
                query.Append(" AND assistance_type IN (" + values + ")");
        }

        private void AddPublicStatusFilter(StringBuilder query, SqlCommand cmd)
        {
            StringBuilder values = new StringBuilder();
            int count = 0;

            AddFilterValue(values, cmd, ref count, pubChkApproved.Checked, "Approved", "pubStatus");
            AddFilterValue(values, cmd, ref count, pubChkReleased.Checked, "Released", "pubStatus");

            if (count > 0)
                query.Append(" AND status IN (" + values + ")");
        }
        private void LoadPublicDashboardSummary()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

            string query = @"
                SELECT
                    COUNT(*) AS TotalRecords,

                    ISNULL(SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END),0) AS ApprovedCount,
                    ISNULL(SUM(CASE WHEN status = 'Released' THEN 1 ELSE 0 END),0) AS ReleasedCount,

                    ISNULL(SUM(estimated_amount_requested), 0) AS TotalAmount,

                    ISNULL(AVG(estimated_amount_requested), 0) AS AvgAmount,
                    ISNULL(MAX(estimated_amount_requested), 0) AS MaxAmount,

                    ISNULL(SUM(CASE WHEN assistance_type = 'Medical' THEN 1 ELSE 0 END),0) AS MedicalCount,
                    ISNULL(SUM(CASE WHEN assistance_type = 'Financial' THEN 1 ELSE 0 END),0) AS FinancialCount,

                    ISNULL(SUM(CASE 
                        WHEN date_submitted >= DATEADD(DAY, -7, GETDATE()) 
                        THEN 1 ELSE 0 END),0) AS RecentCount

                FROM assistance_applications
                WHERE status IN ('Approved', 'Released')
                ";

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        int total = Convert.ToInt32(reader["TotalRecords"]);
                        int approved = Convert.ToInt32(reader["ApprovedCount"]);
                        int released = Convert.ToInt32(reader["ReleasedCount"]);

                        decimal totalAmount = Convert.ToDecimal(reader["TotalAmount"]);
                        decimal avgAmount = Convert.ToDecimal(reader["AvgAmount"]);
                        decimal maxAmount = Convert.ToDecimal(reader["MaxAmount"]);

                        int medical = Convert.ToInt32(reader["MedicalCount"]);
                        int financial = Convert.ToInt32(reader["FinancialCount"]);
                        int recent = Convert.ToInt32(reader["RecentCount"]);

                        // existing
                        lblPublicTotal.Text = total.ToString();
                        lblPublicApproved.Text = approved.ToString();
                        lblPublicReleased.Text = released.ToString();
                        lblPublicAmount.Text = "₱" + totalAmount.ToString("N2");

                        // new
                        lblPublicAverage.Text = "₱" + avgAmount.ToString("N2");
                        lblPublicHighest.Text = "₱" + maxAmount.ToString("N2");
                        lblPublicMedical.Text = medical.ToString();
                        lblPublicFinancial.Text = financial.ToString();
                        lblPublicRecent.Text = recent.ToString();

                        // approval rate
                        double rate = total > 0 ? (approved * 100.0) / total : 0;
                        lblPublicApprovalRate.Text = rate.ToString("0.00") + "%";
                    }
                }
            }
        }
        protected void btnPublicApplyFilter_Click(object sender, EventArgs e)
        {
            LoadPublicTransactions();
        }

        protected void btnPublicClearFilter_Click(object sender, EventArgs e)
        {
            pubChkMedical.Checked = false;
            pubChkFinancial.Checked = false;
            pubChkBurial.Checked = false;
            pubChkEducational.Checked = false;
            pubChkFood.Checked = false;
            pubChkEmergency.Checked = false;

            pubChkApproved.Checked = false;
            pubChkReleased.Checked = false;

            pubDateFrom.Text = "";
            pubDateTo.Text = "";

            LoadPublicTransactions();
        }
    }
}