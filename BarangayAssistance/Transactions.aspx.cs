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
            get
            {
                return ViewState["ShowingMyTransactions"] != null &&
                       (bool)ViewState["ShowingMyTransactions"];
            }
            set
            {
                ViewState["ShowingMyTransactions"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bool isLoggedIn = Session["username"] != null;

                if (!isLoggedIn)
                {
                    pnlDashboardLayout.Visible = false;
                    pnlPublicNav.Visible = true;

                    LoadTransactions(false); // show all for public
                }
                else
                {
                    pnlDashboardLayout.Visible = true;
                    pnlPublicNav.Visible = false;

                    string role = Session["role"] == null ? "" : Session["role"].ToString();

                    // 🔥 CONTROL NAV PANELS
                    navAdmin.Visible = role == "Admin";
                    navBeneficiary.Visible = role == "User" || role == "Beneficiary";

                    if (role == "User" || role == "Beneficiary")
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
            return Session["role"] != null &&
                   Session["role"].ToString() == "Admin";
        }

        private void LoadTransactions(bool beneficiaryOnly)
        {
            string connStr = ConfigurationManager
                .ConnectionStrings["BarangayDB"].ConnectionString;

            StringBuilder query = new StringBuilder(@"
                SELECT
                    application_id,
                    beneficiary_id,
                    full_name,
                    beneficiary_type,
                    contact_number,
                    assistance_type,
                    preferred_date,
                    estimated_amount_requested,
                    urgency_level,
                    reason_for_application,
                    additional_notes,
                    status,
                    date_submitted,
                    date_updated
                FROM assistance_applications
                WHERE 1 = 1
            ");

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.Connection = conn;

                if (beneficiaryOnly)
                {
                    if (Session["username"] == null)
                    {
                        lblMessage.Text = "Please login to view your transactions.";
                        return;
                    }

                    query.Append(@"
                        AND beneficiary_id = (
                            SELECT beneficiary_id
                            FROM beneficiaries
                            WHERE username = @username
                        )
                    ");

                    cmd.Parameters.AddWithValue("@username", Session["username"].ToString());
                }

                AddTypeFilter(query, cmd);
                AddStatusFilter(query, cmd);

                if (!string.IsNullOrWhiteSpace(txtDateFrom.Text))
                {
                    query.Append(" AND CAST(date_submitted AS DATE) >= @dateFrom");
                    cmd.Parameters.AddWithValue("@dateFrom", DateTime.Parse(txtDateFrom.Text).Date);
                }

                if (!string.IsNullOrWhiteSpace(txtDateTo.Text))
                {
                    query.Append(" AND CAST(date_submitted AS DATE) <= @dateTo");
                    cmd.Parameters.AddWithValue("@dateTo", DateTime.Parse(txtDateTo.Text).Date);
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
            {
                query.Append(" AND assistance_type IN (" + values + ")");
            }
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
            {
                query.Append(" AND status IN (" + values + ")");
            }
        }

        private void AddFilterValue(
            StringBuilder values,
            SqlCommand cmd,
            ref int count,
            bool isChecked,
            string value,
            string prefix)
        {
            if (isChecked)
            {
                string paramName = "@" + prefix + count;

                if (count > 0)
                {
                    values.Append(", ");
                }

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
            if (Session["username"] == null)
            {
                lblMessage.Text = "Please login to view your transactions.";
                return;
            }

            ShowingMyTransactions = true;
            LoadTransactions(true);
        }

        protected void gvTransactions_RowCommand(
            object sender,
            System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ApproveApplication")
            {
                if (!IsAdmin())
                {
                    lblMessage.Text = "Only admins can approve applications.";
                    return;
                }

                int applicationId = Convert.ToInt32(e.CommandArgument);

                string connStr = ConfigurationManager
                    .ConnectionStrings["BarangayDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                        UPDATE assistance_applications
                        SET status = 'Approved',
                            date_updated = GETDATE()
                        WHERE application_id = @application_id
                          AND status = 'Pending'";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@application_id", applicationId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblMessage.Text = "Application approved successfully.";
                LoadTransactions(ShowingMyTransactions);
            }
        }
    }
}