using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace BarangayAssistance
{
    public partial class Notifications : System.Web.UI.Page
    {
        string connStr = ConfigurationManager
            .ConnectionStrings["BarangayDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string role = Session["role"]?.ToString();

                if (role == "Admin")
                {

                    pnlAdminNotifications.Visible = true;
                    pnlBeneficiaryNotifications.Visible = false;
                    LoadAdminNotifications();
                }
                else if (role == "Beneficiary")
                {
  
                    pnlAdminNotifications.Visible = false;
                    pnlBeneficiaryNotifications.Visible = true;
                    LoadUserNotifications();
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        private void LoadAdminNotifications()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT *
                    FROM notifications
                    WHERE type IN ('Admin', 'Registration', 'Assistance')
                    ORDER BY is_read ASC, date_created DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAdminNotifications.DataSource = dt;
                rptAdminNotifications.DataBind();

                pnlNoAdminNotifications.Visible = (dt.Rows.Count == 0);
            }
        }

        protected void btnAdminMarkAllRead_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE notifications
                    SET is_read = 1,
                        date_read = GETDATE()
                    WHERE type IN ('Admin', 'Registration', 'Assistance')";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadAdminNotifications();
        }

        protected void btnAdminMarkRead_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(
                ((System.Web.UI.WebControls.Button)sender).CommandArgument);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE notifications
                    SET is_read = 1,
                        date_read = GETDATE()
                    WHERE notification_id = @id";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadAdminNotifications();
        }

        private void LoadUserNotifications()
        {
            if (Session["beneficiary_id"] == null) return;

            int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT *
                    FROM notifications
                    WHERE beneficiary_id = @id
                    ORDER BY is_read ASC, date_created DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", beneficiaryId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptUserNotifications.DataSource = dt;
                rptUserNotifications.DataBind();

                pnlNoUserNotifications.Visible = (dt.Rows.Count == 0);
            }
        }

        protected void btnUserMarkAllRead_Click(object sender, EventArgs e)
        {
            if (Session["beneficiary_id"] == null) return;

            int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE notifications
                    SET is_read = 1,
                        date_read = GETDATE()
                    WHERE beneficiary_id = @id";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", beneficiaryId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadUserNotifications();
        }

        protected void btnUserMarkRead_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(
                ((System.Web.UI.WebControls.Button)sender).CommandArgument);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE notifications
                    SET is_read = 1,
                        date_read = GETDATE()
                    WHERE notification_id = @id";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadUserNotifications();
        }
        protected void btnAdminDelete_Click(object sender, EventArgs e)
        {
            int id = Convert.ToInt32(
                ((System.Web.UI.WebControls.Button)sender).CommandArgument);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            DELETE FROM notifications
            WHERE notification_id = @id
            AND type IN ('Admin', 'Registration', 'Assistance')";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadAdminNotifications();
        }

        protected void btnUserDelete_Click(object sender, EventArgs e)
        {
            if (Session["beneficiary_id"] == null) return;

            int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);
            int id = Convert.ToInt32(
                ((System.Web.UI.WebControls.Button)sender).CommandArgument);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            DELETE FROM notifications
            WHERE notification_id = @id
            AND beneficiary_id = @beneficiary_id";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.Parameters.AddWithValue("@beneficiary_id", beneficiaryId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadUserNotifications();
        }
    }
}