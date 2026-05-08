using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace BarangayAssistance
{
    public partial class Feedback : System.Web.UI.Page
    {
        string connStr = ConfigurationManager
            .ConnectionStrings["BarangayDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string role = Session["role"] == null ? "" : Session["role"].ToString();

                bool isAdmin = role == "Admin";

                pnlAdmin.Visible = isAdmin;
                pnlLoggedIn.Visible = !isAdmin && role != "";
                pnlLoggedOut.Visible = !isAdmin && role == "";
                pnlInactivityTimeout.Visible = false;

                if (isAdmin)
                {
                    pnlInactivityTimeout.Visible = true;
                    LoadSubmissions();
                }
                else
                {
                    // LOAD PUBLIC RESOLVED COMPLAINTS
                    LoadPublicSubmissions();

                    // LOAD USER SUBMISSIONS IF LOGGED IN
                    if (role != "")
                    {
                        pnlInactivityTimeout.Visible = true;
                        LoadUserSubmissions();
                    }
                }
            }
        }
        private void LoadUserSubmissions()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT *
            FROM complaints_feedback
            ORDER BY date_submitted DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);

                DataTable dt = new DataTable();

                da.Fill(dt);

                rptUserSubmissions.DataSource = dt;
                rptUserSubmissions.DataBind();

                pnlUserNoSubmissions.Visible = (dt.Rows.Count == 0);
            }
        }
        public string GetStatusBadgeClass(string status)
        {
            switch (status)
            {
                case "Resolved": return "badge-resolved";
                case "Rejected": return "badge-rejected";
                case "Under Review": return "badge-review";
                default: return "badge-pending";
            }
        }

        private void LoadSubmissions()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT *
                    FROM complaints_feedback
                    ORDER BY date_submitted DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptSubmissions.DataSource = dt;
                rptSubmissions.DataBind();

                pnlNoSubmissions.Visible = (dt.Rows.Count == 0);
            }
        }
        // ADD THIS METHOD BELOW LoadSubmissions()

        private void LoadPublicSubmissions()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT *
            FROM complaints_feedback
            WHERE status = 'Resolved'
              AND admin_response IS NOT NULL
              AND admin_response <> ''
            ORDER BY date_resolved DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);

                DataTable dt = new DataTable();

                da.Fill(dt);

                rptPublicSubmissions.DataSource = dt;
                rptPublicSubmissions.DataBind();

                pnlPublicNoSubmissions.Visible = (dt.Rows.Count == 0);
            }
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int rating = GetLoggedInRating();

            SubmitFeedback(
                ddlType.SelectedValue,
                ddlCategory.SelectedValue,
                txtSubject.Text,
                txtDetails.Text,
                rating,
                lblSuccess,
                lblError,
                false
            );
        }

        protected void btnPublicSubmit_Click(object sender, EventArgs e)
        {
            int rating = GetPublicRating();

            SubmitFeedback(
                ddlPublicType.SelectedValue,
                ddlPublicCategory.SelectedValue,
                txtPublicSubject.Text,
                txtPublicDetails.Text,
                rating,
                lblPublicSuccess,
                lblPublicError,
                false
            );
        }

        private void SubmitFeedback(
            string type,
            string category,
            string subject,
            string details,
            int rating,
            System.Web.UI.WebControls.Label successLabel,
            System.Web.UI.WebControls.Label errorLabel,
            bool reloadSubmissions)
        {
            if (type == "" ||
                category == "" ||
                string.IsNullOrWhiteSpace(subject) ||
                string.IsNullOrWhiteSpace(details))
            {
                errorLabel.Text = "⚠️ Please fill in all fields.";
                errorLabel.Visible = true;
                successLabel.Visible = false;
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    string insertFeedbackQuery = @"
                        INSERT INTO complaints_feedback
                        (type, category, subject, details, rating, status, date_submitted)
                        VALUES
                        (@type, @category, @subject, @details, @rating, 'Pending', GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertFeedbackQuery, con, tran))
                    {
                        cmd.Parameters.AddWithValue("@type", type);
                        cmd.Parameters.AddWithValue("@category", category);
                        cmd.Parameters.AddWithValue("@subject", subject.Trim());
                        cmd.Parameters.AddWithValue("@details", details.Trim());
                        cmd.Parameters.AddWithValue("@rating", rating);

                        cmd.ExecuteNonQuery();
                    }

                    string insertNotificationQuery = @"
                        INSERT INTO notifications
                        (beneficiary_id, title, message, type, is_read, date_created, date_read)
                        VALUES
                        (@beneficiary_id, @title, @message, @type, 0, GETDATE(), NULL)";

                    using (SqlCommand notifCmd = new SqlCommand(insertNotificationQuery, con, tran))
                    {
                        object beneficiaryId = DBNull.Value;

                        if (Session["beneficiary_id"] != null &&
                            int.TryParse(Session["beneficiary_id"].ToString(), out int parsedBeneficiaryId))
                        {
                            beneficiaryId = parsedBeneficiaryId;
                        }

                        notifCmd.Parameters.AddWithValue("@beneficiary_id", beneficiaryId);
                        notifCmd.Parameters.AddWithValue("@title", "New Feedback Submitted");
                        notifCmd.Parameters.AddWithValue(
                            "@message",
                            $"A new {type.ToLower()} was submitted under {category}: {subject.Trim()}"
                        );
                        notifCmd.Parameters.AddWithValue("@type", "Admin");

                        notifCmd.ExecuteNonQuery();
                    }

                    tran.Commit();
                }
                catch
                {
                    tran.Rollback();
                    throw;
                }
            }

            successLabel.Text = "✅ Submission successful!";
            successLabel.Visible = true;
            errorLabel.Visible = false;

            // UPDATE THIS PART INSIDE SubmitFeedback()

            if (reloadSubmissions)
            {
                ResetLoggedInForm();
                LoadSubmissions();
            }
            else
            {
                if (Session["role"] == null || Session["role"].ToString() == "")
                {
                    ResetPublicForm();

                    // ADD THIS
                    LoadPublicSubmissions();
                }
                else
                {
                    ResetLoggedInForm();
                }
            }
        }
        private int GetLoggedInRating()
        {
            if (rbStar5.Checked) return 5;
            if (rbStar4.Checked) return 4;
            if (rbStar3.Checked) return 3;
            if (rbStar2.Checked) return 2;
            if (rbStar1.Checked) return 1;

            return 0;
        }

        private int GetPublicRating()
        {
            if (rbPublicStar5.Checked) return 5;
            if (rbPublicStar4.Checked) return 4;
            if (rbPublicStar3.Checked) return 3;
            if (rbPublicStar2.Checked) return 2;
            if (rbPublicStar1.Checked) return 1;

            return 0;
        }

        private void ResetLoggedInForm()
        {
            ddlType.SelectedIndex = 0;
            ddlCategory.SelectedIndex = 0;
            txtSubject.Text = "";
            txtDetails.Text = "";

            rbStar1.Checked = false;
            rbStar2.Checked = false;
            rbStar3.Checked = false;
            rbStar4.Checked = false;
            rbStar5.Checked = false;
        }

        private void ResetPublicForm()
        {
            ddlPublicType.SelectedIndex = 0;
            ddlPublicCategory.SelectedIndex = 0;
            txtPublicSubject.Text = "";
            txtPublicDetails.Text = "";

            rbPublicStar1.Checked = false;
            rbPublicStar2.Checked = false;
            rbPublicStar3.Checked = false;
            rbPublicStar4.Checked = false;
            rbPublicStar5.Checked = false;
        }

        protected void rptSubmissions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (Session["role"] == null || Session["role"].ToString() != "Admin")
            {
                lblAdminError.Text = "⚠️ You are not authorized to reply.";
                lblAdminError.Visible = true;
                lblAdminSuccess.Visible = false;
                return;
            }

            if (e.CommandName == "Reply")
            {
                int complaintId = Convert.ToInt32(e.CommandArgument);

                TextBox txtReply = (TextBox)e.Item.FindControl("txtReply");

                if (txtReply == null)
                {
                    lblAdminError.Text = "⚠️ Reply textbox not found.";
                    lblAdminError.Visible = true;
                    lblAdminSuccess.Visible = false;
                    return;
                }

                string replyText = txtReply.Text.Trim();

                if (string.IsNullOrWhiteSpace(replyText))
                {
                    lblAdminError.Text = "⚠️ Reply cannot be empty.";
                    lblAdminError.Visible = true;
                    lblAdminSuccess.Visible = false;
                    return;
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"
                        UPDATE complaints_feedback
                        SET admin_response = @reply,
                            admin_reply = @reply,
                            status = 'Resolved',
                            date_resolved = GETDATE()
                        WHERE complaint_id = @id";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@reply", replyText);
                        cmd.Parameters.AddWithValue("@id", complaintId);

                        con.Open();

                        int rows = cmd.ExecuteNonQuery();

                        if (rows > 0)
                        {
                            lblAdminSuccess.Text = "✅ Response sent successfully!";
                            lblAdminSuccess.Visible = true;
                            lblAdminError.Visible = false;
                        }
                        else
                        {
                            lblAdminError.Text = "⚠️ No record updated.";
                            lblAdminError.Visible = true;
                            lblAdminSuccess.Visible = false;
                        }
                    }
                }

                LoadSubmissions();
            }
        }
    }
}