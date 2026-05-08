using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Configuration;
using System.Text.RegularExpressions;

namespace BarangayAssistance
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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
                    string adminQuery = @"SELECT admin_id, full_name 
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

                            Response.Redirect("Dashboard.aspx");
                            return;
                        }

                        reader.Close();
                    }

                    // =========================
                    // CHECK BENEFICIARY ACCOUNT
                    // =========================
                    string userQuery = @"SELECT beneficiary_id, first_name, last_name, status
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

                            int beneficiaryId = Convert.ToInt32(reader2["beneficiary_id"]);

                            Session.Clear();

                            Session["UserID"] = beneficiaryId.ToString();
                            Session["beneficiary_id"] = beneficiaryId.ToString();
                            Session["FullName"] = reader2["first_name"].ToString()
                                                  + " " + reader2["last_name"].ToString();
                            Session["role"] = "Beneficiary";

                            reader2.Close();

                            // =========================
                            // LOAD BENEFICIARY NOTIFICATION COUNT
                            // =========================
                            string beneficiaryNotifQuery = @"
                            SELECT COUNT(*)
                            FROM notifications
                            WHERE beneficiary_id = @beneficiary_id
                            AND is_read = 0";

                            using (SqlCommand notifCmd = new SqlCommand(beneficiaryNotifQuery, conn))
                            {
                                notifCmd.Parameters.Add("@beneficiary_id", SqlDbType.Int).Value = beneficiaryId;

                                int notifCount = Convert.ToInt32(notifCmd.ExecuteScalar());

                                Session["NotificationCount"] = notifCount;
                            }

                            Response.Redirect("Dashboard.aspx");
                            return;
                        }

                        reader2.Close();
                    }
                }

                lblMessage.Text = "Invalid username or password.";
            }
            catch
            {
                lblMessage.Text = "Login failed. Please try again.";
            }
        }
    }
}