using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Configuration;

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

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter username and password.";
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Check admins table
                string adminQuery = @"SELECT admin_id, full_name 
                                      FROM admins 
                                      WHERE username = @username 
                                      AND password_hash = @password 
                                      AND status = 'Active'";

                using (SqlCommand cmd = new SqlCommand(adminQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    cmd.Parameters.AddWithValue("@password", password);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows)
                    {
                        reader.Read();
                        Session["UserID"] = reader["admin_id"].ToString();
                        Session["FullName"] = reader["full_name"].ToString();
                        Session["role"] = "Admin";
                        reader.Close();
                        Response.Redirect("Dashboard.aspx");
                        return;
                    }
                    reader.Close();
                }

                // Check beneficiaries table
                string userQuery = @"SELECT beneficiary_id, first_name, last_name 
                                     FROM beneficiaries 
                                     WHERE username = @username 
                                     AND password_hash = @password 
                                     AND status = 'Active'";

                using (SqlCommand cmd2 = new SqlCommand(userQuery, conn))
                {
                    cmd2.Parameters.AddWithValue("@username", username);
                    cmd2.Parameters.AddWithValue("@password", password);

                    SqlDataReader reader2 = cmd2.ExecuteReader();

                    if (reader2.HasRows)
                    {
                        reader2.Read();
                        Session["UserID"] = reader2["beneficiary_id"].ToString();
                        Session["beneficiary_id"] = reader2["beneficiary_id"].ToString();
                        Session["FullName"] = reader2["first_name"].ToString()
                                                  + " " + reader2["last_name"].ToString();
                        Session["role"] = "Beneficiary";
                        reader2.Close();
                        Response.Redirect("Dashboard.aspx");
                        return;
                    }
                    reader2.Close();
                }
            }

            lblMessage.Text = "Invalid username or password.";
        }
    }
}