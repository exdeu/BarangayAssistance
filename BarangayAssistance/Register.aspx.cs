using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace BarangayAssistance
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = @"
                            INSERT INTO beneficiaries
                            (
                                username,
                                password_hash,
                                last_name,
                                first_name,
                                middle_name,
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
                            )
                            VALUES
                            (
                                @username,
                                @password_hash,
                                @last_name,
                                @first_name,
                                @middle_name,
                                @date_of_birth,
                                @age,
                                @sex,
                                @contact_number,
                                @civil_status,
                                @purok_street,
                                @household_members,
                                @monthly_income,
                                @beneficiary_type,
                                @government_id_presented
                            )";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            string sex = rbMale.Checked ? "Male" : rbFemale.Checked ? "Female" : "";

                            cmd.Parameters.AddWithValue("@username", txtUsername.Text.Trim());
                            cmd.Parameters.AddWithValue("@password_hash", txtPassword.Text.Trim());

                            cmd.Parameters.AddWithValue("@last_name", txtLastName.Text.Trim());
                            cmd.Parameters.AddWithValue("@first_name", txtFirstName.Text.Trim());
                            cmd.Parameters.AddWithValue("@middle_name", txtMiddleName.Text.Trim());

                            cmd.Parameters.AddWithValue("@date_of_birth", DateTime.Parse(txtDateOfBirth.Text));
                            cmd.Parameters.AddWithValue("@age", string.IsNullOrWhiteSpace(txtAge.Text) ? (object)DBNull.Value : int.Parse(txtAge.Text));
                            cmd.Parameters.AddWithValue("@sex", sex);

                            cmd.Parameters.AddWithValue("@contact_number", txtContact.Text.Trim());
                            cmd.Parameters.AddWithValue("@civil_status", ddlCivilStatus.SelectedValue);

                            cmd.Parameters.AddWithValue("@purok_street", txtPurok.Text.Trim());
                            cmd.Parameters.AddWithValue("@household_members", int.Parse(txtHouseholdSize.Text));
                            cmd.Parameters.AddWithValue("@monthly_income", string.IsNullOrWhiteSpace(txtIncome.Text) ? (object)DBNull.Value : decimal.Parse(txtIncome.Text));

                            cmd.Parameters.AddWithValue("@beneficiary_type", ddlBeneficiaryType.SelectedValue);
                            cmd.Parameters.AddWithValue("@government_id_presented", ddlGovID.SelectedValue);

                            con.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    lblSuccess.Text = "Registration successful!";
                    lblSuccess.Visible = true;
                    lblError.Visible = false;

                    ClearFields();
                }
                catch (Exception ex)
                {
                    lblError.Text = "Registration failed: " + ex.Message;
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                }
            }
            else
            {
                lblError.Text = "Please complete all required fields correctly.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearFields();
            lblSuccess.Visible = false;
            lblError.Visible = false;
        }

        protected void cvConsent_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkConsent.Checked;
        }

        private void ClearFields()
        {
            txtUsername.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";

            txtLastName.Text = "";
            txtFirstName.Text = "";
            txtMiddleName.Text = "";
            txtDateOfBirth.Text = "";
            txtAge.Text = "";
            txtContact.Text = "";

            txtPurok.Text = "";
            txtHouseholdSize.Text = "";
            txtIncome.Text = "";

            ddlCivilStatus.SelectedIndex = 0;
            ddlBeneficiaryType.SelectedIndex = 0;
            ddlGovID.SelectedIndex = 0;

            rbMale.Checked = false;
            rbFemale.Checked = false;

            chkConsent.Checked = false;
        }
    }
}