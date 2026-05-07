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
                // Check passwords match
                if (txtPassword.Text.Trim() != txtConfirmPassword.Text.Trim())
                {
                    lblError.Text = "❌ Passwords do not match.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                // Check sex selected
                if (!rbMale.Checked && !rbFemale.Checked)
                {
                    lblError.Text = "❌ Please select your sex.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                string connectionString = ConfigurationManager
                    .ConnectionStrings["BarangayDB"].ConnectionString;

                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();

                        // Check if username already exists
                        // Check if username already exists in beneficiaries or admins
                    string checkQuery = @"
                            SELECT 
                                (
                                    SELECT COUNT(*) 
                                    FROM beneficiaries 
                                    WHERE username = @username
                                )
                                +
                                (
                                    SELECT COUNT(*) 
                                    FROM admins 
                                    WHERE username = @username
                                )";

                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@username", txtUsername.Text.Trim());

                        int count = (int)checkCmd.ExecuteScalar();

                        if (count > 0)
                        {
                            lblError.Text = "❌ Username already exists. Please choose another.";
                            lblError.Visible = true;
                            lblSuccess.Visible = false;
                            return;
                        }
                    }

                        // Insert new beneficiary
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
                                government_id_presented,
                                date_registered,
                                status
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
                                @government_id_presented,
                                GETDATE(),
                                'Inactive'
                            )";

                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            string sex = rbMale.Checked ? "Male" : "Female";

                            cmd.Parameters.AddWithValue("@username", txtUsername.Text.Trim());
                            cmd.Parameters.AddWithValue("@password_hash", txtPassword.Text.Trim());
                            cmd.Parameters.AddWithValue("@last_name", txtLastName.Text.Trim());
                            cmd.Parameters.AddWithValue("@first_name", txtFirstName.Text.Trim());
                            cmd.Parameters.AddWithValue("@middle_name", txtMiddleName.Text.Trim());
                            cmd.Parameters.AddWithValue("@date_of_birth", DateTime.Parse(txtDateOfBirth.Text));
                            cmd.Parameters.AddWithValue("@age",
                                string.IsNullOrWhiteSpace(txtAge.Text)
                                ? (object)DBNull.Value
                                : int.Parse(txtAge.Text));
                            cmd.Parameters.AddWithValue("@sex", sex);
                            cmd.Parameters.AddWithValue("@contact_number", txtContact.Text.Trim());
                            cmd.Parameters.AddWithValue("@civil_status", ddlCivilStatus.SelectedValue);
                            cmd.Parameters.AddWithValue("@purok_street", txtPurok.Text.Trim());
                            cmd.Parameters.AddWithValue("@household_members",
                                int.Parse(txtHouseholdSize.Text));
                            cmd.Parameters.AddWithValue("@monthly_income",
                                string.IsNullOrWhiteSpace(txtIncome.Text)
                                ? (object)DBNull.Value
                                : decimal.Parse(txtIncome.Text));
                            cmd.Parameters.AddWithValue("@beneficiary_type",
                                ddlBeneficiaryType.SelectedValue);
                            cmd.Parameters.AddWithValue("@government_id_presented",
                                ddlGovID.SelectedValue);

                            cmd.ExecuteNonQuery();
                        }
                        // Insert notification for admin
                        string notifQuery = @"
                            INSERT INTO notifications
                            (
                                beneficiary_id,
                                title,
                                message,
                                type,
                                is_read,
                                date_created
                            )
                            VALUES
                            (
                                NULL,
                                @title,
                                @message,
                                'Registration',
                                0,
                                GETDATE()
                            )";
                        using (SqlCommand notifCmd = new SqlCommand(notifQuery, con))
                        {
                            notifCmd.Parameters.AddWithValue(
                                "@title",
                                "New Beneficiary Registration");

                            notifCmd.Parameters.AddWithValue(
                                "@message",
                                txtFirstName.Text.Trim() + " "
                                + txtLastName.Text.Trim()
                                + " has submitted a new beneficiary registration request.");
                            notifCmd.ExecuteNonQuery();
                        }
                    }

                    // Success — redirect to login after 2 seconds
                    lblSuccess.Text = "✅ Registration successful! Redirecting to login...";
                    lblSuccess.Visible = true;
                    lblError.Visible = false;
                    ClearFields();

                    // Redirect to login page
                    Response.AddHeader("REFRESH", "2;URL=Login.aspx");
                }
                catch (Exception ex)
                {
                    lblError.Text = "❌ Registration failed: " + ex.Message;
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                }
            }
            else
            {
                lblError.Text = "⚠️ Please complete all required fields correctly.";
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