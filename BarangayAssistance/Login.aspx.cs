using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace BarangayAssistance
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            VerifyOtpControl.OtpVerified += VerifyOtpControl_OtpVerified;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            lblMessage.Text = "";

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                lblMessage.Text = "Please enter username and password.";
                return;
            }


            string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // =========================
                    // CHECK ADMIN ACCOUNT
                    // =========================
                    string adminQuery = @"
                        SELECT admin_id, full_name
                        FROM admins
                        WHERE username = @username
                          AND password_hash = @password
                          AND status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(adminQuery, conn))
                    {
                        cmd.Parameters.Add("@username", SqlDbType.VarChar, 50).Value = username;
                        cmd.Parameters.Add("@password", SqlDbType.VarChar, 255).Value = password;

                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            reader.Read();

                            Session.Clear();

                            Session["UserID"] = reader["admin_id"].ToString();
                            Session["FullName"] = reader["full_name"].ToString();
                            Session["role"] = "Admin";

                            reader.Close();

                            // =========================
                            // LOAD ADMIN NOTIFICATION COUNT
                            // =========================
                            string adminNotifQuery = @"
                                SELECT COUNT(*) 
                                FROM notifications
                                WHERE type = 'Admin'
                                AND is_read = 0";

                            using (SqlCommand notifCmd = new SqlCommand(adminNotifQuery, conn))
                            {
                                int notifCount = Convert.ToInt32(notifCmd.ExecuteScalar());
                                Session["NotificationCount"] = notifCount;
                            }

                            Response.Redirect("Dashboard.aspx", false);
                            Context.ApplicationInstance.CompleteRequest();
                            return;
                        }

                        reader.Close();
                    }

                    // =========================
                    // CHECK BENEFICIARY ACCOUNT
                    // =========================
                    string userQuery = @"
                        SELECT beneficiary_id,
                               first_name,
                               last_name,
                               status,
                               email
                        FROM beneficiaries
                        WHERE username = @username
                          AND password_hash = @password";

                    using (SqlCommand cmd2 = new SqlCommand(userQuery, conn))
                    {
                        cmd2.Parameters.Add("@username", SqlDbType.VarChar, 50).Value = username;
                        cmd2.Parameters.Add("@password", SqlDbType.VarChar, 255).Value = password;

                        SqlDataReader reader2 = cmd2.ExecuteReader();

                        if (reader2.HasRows)
                        {
                            reader2.Read();

                            string status = reader2["status"].ToString();

                            if (status != "Active")
                            {
                                reader2.Close();

                                lblMessage.Text = "Your account is inactive. Please contact the barangay office.";
                                return;
                            }

                            string beneficiaryEmail = reader2["email"].ToString();

                            if (string.IsNullOrWhiteSpace(beneficiaryEmail))
                            {
                                reader2.Close();

                                lblMessage.Text = "This account has no email for OTP verification.";
                                return;
                            }

                            string beneficiaryId = reader2["beneficiary_id"].ToString();

                            string fullName =
                                reader2["first_name"].ToString()
                                + " "
                                + reader2["last_name"].ToString();

                            reader2.Close();

                            StorePendingLogin(
                                beneficiaryId,
                                fullName,
                                beneficiaryEmail
                            );

                            SendLoginOtp(beneficiaryEmail);

                            return;
                        }

                        reader2.Close();
                    }
                }

                lblMessage.Text = "Invalid username or password.";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Login failed: " + ex.Message;
            }
        }

        private void StorePendingLogin(
            string beneficiaryId,
            string fullName,
            string email)
        {
            Session["PendingLoginBeneficiaryID"] = beneficiaryId;
            Session["PendingLoginFullName"] = fullName;
            Session["PendingLoginEmail"] = email;
        }

        private void SendLoginOtp(string email)
        {
            Random rnd = new Random();

            string otp = rnd.Next(100000, 999999).ToString();

            Session["EmailOtp"] = otp;
            Session["EmailOtpExpiry"] = DateTime.Now.AddMinutes(5);

            SendOtpEmail(email, otp);

            lblMessage.Text = "OTP has been sent to your email.";

            VerifyOtpControl.Show();
        }

        private void VerifyOtpControl_OtpVerified(object sender, EventArgs e)
        {
            if (Session["PendingLoginBeneficiaryID"] == null ||
                Session["PendingLoginFullName"] == null)
            {
                lblMessage.Text = "Login session expired. Please login again.";
                return;
            }

            string beneficiaryId =
                Session["PendingLoginBeneficiaryID"].ToString();

            string fullName =
                Session["PendingLoginFullName"].ToString();

            Session.Clear();

            Session["UserID"] = beneficiaryId;
            Session["beneficiary_id"] = beneficiaryId;
            Session["FullName"] = fullName;
            Session["role"] = "Beneficiary";

            LoadBeneficiaryNotificationCount(beneficiaryId);

            Response.Redirect("Dashboard.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void LoadBeneficiaryNotificationCount(string beneficiaryId)
        {
            string connStr =
                ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string beneficiaryNotifQuery = @"
                    SELECT COUNT(*)
                    FROM notifications
                    WHERE beneficiary_id = @beneficiary_id
                    AND is_read = 0";

                using (SqlCommand notifCmd =
                    new SqlCommand(beneficiaryNotifQuery, conn))
                {
                    notifCmd.Parameters.Add(
                        "@beneficiary_id",
                        SqlDbType.Int).Value = Convert.ToInt32(beneficiaryId);

                    int notifCount =
                        Convert.ToInt32(notifCmd.ExecuteScalar());

                    Session["NotificationCount"] = notifCount;
                }
            }
        }

        private void SendOtpEmail(string recipientEmail, string otp)
        {
            string senderEmail =
                ConfigurationManager.AppSettings["SmtpEmail"];

            string senderPassword =
                ConfigurationManager.AppSettings["SmtpPassword"];

            MailMessage mail = new MailMessage();

            mail.From = new MailAddress(
                senderEmail,
                "Barangay Assistance System");

            mail.To.Add(recipientEmail);

            mail.Subject = "Login OTP Verification";

            mail.Body =
                "Your login OTP code is: "
                + otp
                + "\n\nThis code will expire in 5 minutes.";

            SmtpClient smtp =
                new SmtpClient("smtp.gmail.com", 587);

            smtp.EnableSsl = true;
            smtp.UseDefaultCredentials = false;

            smtp.Credentials =
                new NetworkCredential(
                    senderEmail,
                    senderPassword);

            smtp.DeliveryMethod =
                SmtpDeliveryMethod.Network;

            smtp.Send(mail);
        }
    }
}