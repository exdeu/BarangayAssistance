using System;
using System.Configuration;
using System.Data.SqlClient;

namespace BarangayAssistance
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            string username = Session["username"].ToString();

            string connStr = ConfigurationManager
                .ConnectionStrings["BarangayDB"].ConnectionString;

            string query = @"
                SELECT 
                    username,
                    first_name,
                    middle_name,
                    last_name,
                    date_of_birth,
                    age,
                    sex,
                    contact_number,
                    civil_status,
                    purok_street,
                    household_members,
                    monthly_income,
                    beneficiary_type,
                    government_id_presented
                FROM beneficiaries
                WHERE username = @username";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@username", username);

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string middleName = reader["middle_name"] == DBNull.Value ? "" : reader["middle_name"].ToString();

                            lblUsername.Text = reader["username"].ToString();
                            lblFullName.Text = reader["first_name"] + " " +
                                               (string.IsNullOrWhiteSpace(middleName) ? "" : middleName + " ") +
                                               reader["last_name"];

                            lblDOB.Text = Convert.ToDateTime(reader["date_of_birth"]).ToString("yyyy-MM-dd");
                            lblAge.Text = reader["age"] == DBNull.Value ? "" : reader["age"].ToString();
                            lblSex.Text = reader["sex"].ToString();
                            lblContact.Text = reader["contact_number"].ToString();
                            lblCivilStatus.Text = reader["civil_status"].ToString();
                            lblPurok.Text = reader["purok_street"].ToString();
                            lblHousehold.Text = reader["household_members"].ToString();

                            lblIncome.Text = reader["monthly_income"] == DBNull.Value
                                ? "Not provided"
                                : "₱" + Convert.ToDecimal(reader["monthly_income"]).ToString("N2");

                            lblBeneficiaryType.Text = reader["beneficiary_type"].ToString();

                            lblGovID.Text = reader["government_id_presented"] == DBNull.Value
                                ? "Not provided"
                                : reader["government_id_presented"].ToString();
                        }
                        else
                        {
                            lblMessage.Text = "Profile not found.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
            }
        }

    }
}