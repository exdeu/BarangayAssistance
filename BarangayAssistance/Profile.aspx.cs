using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.IO;


namespace BarangayAssistance
{
    public partial class Profile : Page
    {
        string connStr = ConfigurationManager
            .ConnectionStrings["BarangayDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect if not logged in as Beneficiary
            if (Session["role"] == null || Session["role"].ToString() != "Beneficiary")
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
            int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        username, first_name, last_name, middle_name,
                        date_of_birth, age, sex, civil_status,
                        contact_number, purok_street, household_members,
                        monthly_income, beneficiary_type, government_id_presented,
                        profile_picture
                    FROM beneficiaries
                    WHERE beneficiary_id = @id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", beneficiaryId);
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Header
                        lblFullName.Text = reader["first_name"] + " " + reader["last_name"];
                        lblBeneficiaryType.Text = reader["beneficiary_type"].ToString();
                        lblUsername.Text = "@" + reader["username"].ToString();

                        // Info grid
                        lblLastName.Text = reader["last_name"].ToString();
                        lblFirstName.Text = reader["first_name"].ToString();
                        lblMiddleName.Text = reader["middle_name"].ToString();
                        lblDOB.Text = Convert.ToDateTime(reader["date_of_birth"])
                                                .ToString("MMMM dd, yyyy");
                        lblAge.Text = reader["age"].ToString();
                        lblSex.Text = reader["sex"].ToString();
                        lblCivilStatus.Text = reader["civil_status"].ToString();
                        lblContact.Text = reader["contact_number"].ToString();
                        lblPurok.Text = reader["purok_street"].ToString();
                        lblHousehold.Text = reader["household_members"].ToString();
                        lblIncome.Text = reader["monthly_income"] == DBNull.Value  ? "₱0.00"  : "₱" + Convert.ToDecimal(reader["monthly_income"]).ToString("N2");
                        lblGovID.Text = reader["government_id_presented"].ToString();

                        // Pre-fill edit fields
                        txtContact.Text = reader["contact_number"].ToString();
                        txtPurok.Text = reader["purok_street"].ToString();
                        txtIncome.Text = txtIncome.Text = reader["monthly_income"] == DBNull.Value ? "" : reader["monthly_income"].ToString();
                        txtHousehold.Text = reader["household_members"].ToString();

                        string profilePicture = reader["profile_picture"] == DBNull.Value ? "" : reader["profile_picture"].ToString();

                        imgProfilePicture.ImageUrl = string.IsNullOrWhiteSpace(profilePicture) ? "~/Uploads/ProfilePictures/default.jpg": "~/" + profilePicture;
                    }
                }
            }
        }
        protected void btnUploadPicture_Click(object sender, EventArgs e)
        {
            if (Session["beneficiary_id"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!fuProfilePicture.HasFile)
            {
                lblError.Text = "⚠️ Please select an image file.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            try
            {
                int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);

                string extension = Path.GetExtension(fuProfilePicture.FileName).ToLower();
                int fileSize = fuProfilePicture.PostedFile.ContentLength;

                if (extension != ".jpg" && extension != ".jpeg" && extension != ".png")
                {
                    lblError.Text = "❌ Only JPG, JPEG, and PNG files are allowed.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (fileSize > 2 * 1024 * 1024)
                {
                    lblError.Text = "❌ File size must not exceed 2MB.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                string folderPath = Server.MapPath("~/Uploads/ProfilePictures/");

                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string fileName = "beneficiary_" + beneficiaryId + extension;
                string fullPath = Path.Combine(folderPath, fileName);
                string dbPath = "Uploads/ProfilePictures/" + fileName;

                fuProfilePicture.SaveAs(fullPath);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"
                UPDATE beneficiaries
                SET profile_picture = @profile_picture
                WHERE beneficiary_id = @id";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@profile_picture", dbPath);
                        cmd.Parameters.AddWithValue("@id", beneficiaryId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSuccess.Text = "✅ Profile picture uploaded successfully!";
                lblSuccess.Visible = true;
                lblError.Visible = false;

                LoadProfile();
            }
            catch (Exception ex)
            {
                lblError.Text = "❌ Error uploading profile picture: " + ex.Message;
                lblError.Visible = true;
                lblSuccess.Visible = false;
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string query = @"
                        UPDATE beneficiaries
                        SET contact_number    = @contact,
                            purok_street      = @purok,
                            monthly_income    = @income,
                            household_members = @household
                        WHERE beneficiary_id  = @id";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@contact", txtContact.Text.Trim());
                        cmd.Parameters.AddWithValue("@purok", txtPurok.Text.Trim());
                        cmd.Parameters.AddWithValue("@income",
                            string.IsNullOrWhiteSpace(txtIncome.Text)
                            ? (object)DBNull.Value
                            : decimal.Parse(txtIncome.Text));
                        cmd.Parameters.AddWithValue("@household",
                            string.IsNullOrWhiteSpace(txtHousehold.Text)
                            ? (object)DBNull.Value
                            : int.Parse(txtHousehold.Text));
                        cmd.Parameters.AddWithValue("@id", beneficiaryId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblSuccess.Text = "✅ Profile updated successfully!";
                lblSuccess.Visible = true;
                lblError.Visible = false;
                LoadProfile();
            }
            catch (Exception ex)
            {
                lblError.Text = "❌ Error updating profile: " + ex.Message;
                lblError.Visible = true;
                lblSuccess.Visible = false;
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);

            if (string.IsNullOrWhiteSpace(txtCurrentPassword.Text) ||
                string.IsNullOrWhiteSpace(txtNewPassword.Text) ||
                string.IsNullOrWhiteSpace(txtConfirmPassword.Text))
            {
                lblError.Text = "⚠️ Please fill in all password fields.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                lblError.Text = "❌ New passwords do not match.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    // Verify current password
                    string checkQuery = @"
                        SELECT COUNT(*) FROM beneficiaries
                        WHERE beneficiary_id = @id
                        AND   password_hash  = @current";

                    using (SqlCommand cmd = new SqlCommand(checkQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@id", beneficiaryId);
                        cmd.Parameters.AddWithValue("@current", txtCurrentPassword.Text.Trim());
                        con.Open();
                        int count = (int)cmd.ExecuteScalar();

                        if (count == 0)
                        {
                            lblError.Text = "❌ Current password is incorrect.";
                            lblError.Visible = true;
                            lblSuccess.Visible = false;
                            return;
                        }
                    }

                    // Update password
                    string updateQuery = @"
                        UPDATE beneficiaries
                        SET password_hash   = @newpass
                        WHERE beneficiary_id = @id";

                    using (SqlCommand cmd2 = new SqlCommand(updateQuery, con))
                    {
                        cmd2.Parameters.AddWithValue("@newpass", txtNewPassword.Text.Trim());
                        cmd2.Parameters.AddWithValue("@id", beneficiaryId);
                        cmd2.ExecuteNonQuery();
                    }
                }

                lblSuccess.Text = "✅ Password changed successfully!";
                lblSuccess.Visible = true;
                lblError.Visible = false;

                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";
            }
            catch (Exception ex)
            {
                lblError.Text = "❌ Error changing password: " + ex.Message;
                lblError.Visible = true;
                lblSuccess.Visible = false;
            }
        }
    }
}