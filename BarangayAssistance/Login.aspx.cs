using System;
using System.Data.SqlClient;
using System.Configuration;

namespace BarangayAssistance
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            string connStr = ConfigurationManager
                .ConnectionStrings["BarangayDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    conn.Open();

                    string adminQuery = @"
                        SELECT username
                        FROM admins
                        WHERE username = @username
                        AND password_hash = @password
                        AND status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(adminQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@username", username);
                        cmd.Parameters.AddWithValue("@password", password);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["username"] = reader["username"].ToString();
                                Session["role"] = "Admin";

                                Response.Redirect("Dashboard.aspx");
                                return;
                            }
                        }
                    }

                    string userQuery = @"
                        SELECT beneficiary_id, username
                        FROM beneficiaries
                        WHERE username = @username
                        AND password_hash = @password
                        AND status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(userQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@username", username);
                        cmd.Parameters.AddWithValue("@password", password);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["beneficiary_id"] = reader["beneficiary_id"].ToString();
                                Session["username"] = reader["username"].ToString();
                                Session["role"] = "Beneficiary";

                                Response.Redirect("Dashboard.aspx");
                                return;
                            }
                        }
                    }

                    lblMessage.Text = "Invalid username or password.";
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                }
            }
        }
    }
}