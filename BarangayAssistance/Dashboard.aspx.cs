using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace BarangayAssistance
{
    public partial class Dashboard : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                string role = Session["role"] != null ? Session["role"].ToString() : "";

                if (role == "Admin")
                {
                    ShowAdminDashboard();
                }
                else if (role == "Beneficiary")
                {
                    ShowBeneficiaryDashboard();
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void ShowAdminDashboard()
        {
            pnlAdmin.Visible = true;
            pnlUser.Visible = false;

            lblWelcome.Text = "Administrator";

            LoadAdminStats();
            LoadAdminTransactions();
        }

        private void ShowBeneficiaryDashboard()
        {
            pnlAdmin.Visible = false;
            pnlUser.Visible = true;

            lblWelcome.Text = "Beneficiary";

            if (Session["beneficiary_id"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);

            LoadBeneficiaryStats(beneficiaryId);
            LoadBeneficiaryTransactions(beneficiaryId);
        }

        private void LoadAdminStats()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                lblTotalApps.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications").ToString();

                lblPending.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications WHERE status = 'Pending'").ToString();

                lblApproved.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications WHERE status = 'Approved'").ToString();

                lblRejected.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications WHERE status = 'Rejected'").ToString();

                lblThisMonth.Text = GetScalarValue(con, @"
            SELECT COUNT(*) 
            FROM assistance_applications 
            WHERE MONTH(date_submitted) = MONTH(GETDATE())
            AND YEAR(date_submitted) = YEAR(GETDATE())").ToString();

                lblUrgent.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications WHERE urgency_level = 'High'").ToString();

                lblTopType.Text = Convert.ToString(GetScalarValue(con, @"
            SELECT TOP 1 assistance_type 
            FROM assistance_applications 
            GROUP BY assistance_type 
            ORDER BY COUNT(*) DESC"));

                object totalFunds = GetScalarValue(con,
                    "SELECT ISNULL(SUM(estimated_amount_requested), 0) FROM assistance_applications WHERE status = 'Approved'");

                lblFunds.Text = "₱" + Convert.ToDecimal(totalFunds).ToString("N2");
            }
        }

        private void LoadAdminTransactions()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        application_id AS ApplicationID,
                        full_name AS FullName,
                        assistance_type AS AssistanceType,
                        status AS Status,
                        estimated_amount_requested AS ApprovedAmount,
                        date_submitted AS DateApplied
                    FROM assistance_applications
                    ORDER BY date_submitted DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvAdminTransactions.DataSource = dt;
                    gvAdminTransactions.DataBind();
                }
            }
        }

        private void LoadBeneficiaryStats(int beneficiaryId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                lblUserApps.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications WHERE beneficiary_id = @BeneficiaryID",
                    beneficiaryId).ToString();

                lblUserPending.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications WHERE beneficiary_id = @BeneficiaryID AND status = 'Pending'",
                    beneficiaryId).ToString();

                lblUserApproved.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications WHERE beneficiary_id = @BeneficiaryID AND status = 'Approved'",
                    beneficiaryId).ToString();

                lblUserRejected.Text = GetScalarValue(con,
                    "SELECT COUNT(*) FROM assistance_applications WHERE beneficiary_id = @BeneficiaryID AND status = 'Rejected'",
                    beneficiaryId).ToString();

                lblLatestStatus.Text = Convert.ToString(GetScalarValue(con, @"
            SELECT TOP 1 status 
            FROM assistance_applications 
            WHERE beneficiary_id = @BeneficiaryID 
            ORDER BY date_submitted DESC", beneficiaryId));

                object lastDate = GetScalarValue(con, @"
            SELECT TOP 1 date_submitted 
            FROM assistance_applications 
            WHERE beneficiary_id = @BeneficiaryID 
            ORDER BY date_submitted DESC", beneficiaryId);

                lblLastApplied.Text = lastDate != null
                    ? Convert.ToDateTime(lastDate).ToString("MMM dd, yyyy")
                    : "-";

                lblUserTopType.Text = Convert.ToString(GetScalarValue(con, @"
            SELECT TOP 1 assistance_type 
            FROM assistance_applications 
            WHERE beneficiary_id = @BeneficiaryID
            GROUP BY assistance_type 
            ORDER BY COUNT(*) DESC", beneficiaryId));

                object totalReceived = GetScalarValue(con,
                    "SELECT ISNULL(SUM(estimated_amount_requested), 0) FROM assistance_applications WHERE beneficiary_id = @BeneficiaryID AND status = 'Approved'",
                    beneficiaryId);

                lblUserFunds.Text = "₱" + Convert.ToDecimal(totalReceived).ToString("N2");
            }
        }

        private void LoadBeneficiaryTransactions(int beneficiaryId)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        application_id AS ApplicationID,
                        assistance_type AS AssistanceType,
                        status AS Status,
                        estimated_amount_requested AS ApprovedAmount,
                        date_submitted AS DateApplied
                    FROM assistance_applications
                    WHERE beneficiary_id = @BeneficiaryID
                    ORDER BY date_submitted DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@BeneficiaryID", beneficiaryId);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvUserTransactions.DataSource = dt;
                        gvUserTransactions.DataBind();
                    }
                }
            }
        }

        private object GetScalarValue(SqlConnection con, string query, int? beneficiaryId = null)
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                if (beneficiaryId.HasValue)
                {
                    cmd.Parameters.AddWithValue("@BeneficiaryID", beneficiaryId.Value);
                }

                return cmd.ExecuteScalar();
            }
        }
    }
}