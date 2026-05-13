using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;

namespace BarangayAssistance
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            VerifyOtpControl.OtpVerified += VerifyOtpControl_OtpVerified;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();
                string email = txtEmail.Text.Trim();

                if (!Regex.IsMatch(username, @"^[a-zA-Z0-9_]{5,20}$"))
                {
                    lblError.Text = "❌ Username must be 5–20 characters and contain only letters, numbers, or underscores.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (!Regex.IsMatch(password,
                    @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#_\-])[A-Za-z\d@$!%*?&.#_\-]{8,}$"))
                {
                    lblError.Text =
                        "❌ Password must be at least 8 characters and include uppercase, lowercase, number, and special character.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (txtPassword.Text.Trim() != txtConfirmPassword.Text.Trim())
                {
                    lblError.Text = "❌ Passwords do not match.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (string.IsNullOrWhiteSpace(email))
                {
                    lblError.Text = "❌ Email is required.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
                {
                    lblError.Text = "❌ Please enter a valid email address.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (!rbMale.Checked && !rbFemale.Checked)
                {
                    lblError.Text = "❌ Please select your sex.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (!ValidateIdPictureUpload())
                {
                    return;
                }

                string connectionString = ConfigurationManager
                    .ConnectionStrings["BarangayDB"].ConnectionString;

                try
                {
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        con.Open();

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
                            checkCmd.Parameters.AddWithValue("@username", username);

                            int count = (int)checkCmd.ExecuteScalar();

                            if (count > 0)
                            {
                                lblError.Text = "❌ Username already exists. Please choose another.";
                                lblError.Visible = true;
                                lblSuccess.Visible = false;
                                return;
                            }
                        }

                        string checkEmailQuery = @"
                            SELECT COUNT(*)
                            FROM beneficiaries
                            WHERE email = @email";

                        using (SqlCommand checkEmailCmd = new SqlCommand(checkEmailQuery, con))
                        {
                            checkEmailCmd.Parameters.AddWithValue("@email", email);

                            int emailCount = (int)checkEmailCmd.ExecuteScalar();

                            if (emailCount > 0)
                            {
                                lblError.Text = "❌ Email already exists. Please use another email.";
                                lblError.Visible = true;
                                lblSuccess.Visible = false;
                                return;
                            }
                        }
                    }

                    StoreRegistrationData();
                    SaveIdPictureToTemporaryFolder(username);

                    Random rnd = new Random();

                    string otp = rnd.Next(100000, 999999).ToString();

                    Session["EmailOtp"] = otp;
                    Session["EmailOtpExpiry"] = DateTime.Now.AddMinutes(5);

                    SendOtpEmail(email, otp);

                    VerifyOtpControl.Show();

                    lblSuccess.Text = "✅ OTP has been sent to your email.";
                    lblSuccess.Visible = true;
                    lblError.Visible = false;
                }
                catch (Exception ex)
                {
                    DeleteTemporaryIdPicture();
                    lblError.Text = "❌ Failed to send OTP: " + ex.Message;
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

        private void VerifyOtpControl_OtpVerified(object sender, EventArgs e)
        {
            try
            {
                RegisterBeneficiary();

                Session.Remove("EmailOtp");
                Session.Remove("EmailOtpExpiry");

                lblSuccess.Text = "✅ Registration successful!";
                lblSuccess.Visible = true;
                lblError.Visible = false;

                ClearFields();

                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                lblError.Text = "❌ Registration failed: " + ex.Message;
                lblError.Visible = true;
                lblSuccess.Visible = false;
            }
        }

        private bool ValidateIdPictureUpload()
        {
            if (!fuIdPicture.HasFile)
            {
                lblError.Text = "❌ Please upload a picture of your ID.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return false;
            }

            string extension = Path.GetExtension(fuIdPicture.FileName).ToLowerInvariant();
            string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp" };

            bool allowed = false;

            foreach (string allowedExtension in allowedExtensions)
            {
                if (extension == allowedExtension)
                {
                    allowed = true;
                    break;
                }
            }

            if (!allowed)
            {
                lblError.Text = "❌ Invalid ID picture format. Please upload JPG, JPEG, PNG, GIF, BMP, or WEBP.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return false;
            }

            int maxFileSize = 5 * 1024 * 1024;

            if (fuIdPicture.PostedFile.ContentLength > maxFileSize)
            {
                lblError.Text = "❌ ID picture must not exceed 5 MB.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return false;
            }

            return true;
        }

        private void SaveIdPictureToTemporaryFolder(string username)
        {
            DeleteTemporaryIdPicture();

            string extension = Path.GetExtension(fuIdPicture.FileName).ToLowerInvariant();
            string tempFolder = Server.MapPath("~/Records/_Temp");

            if (!Directory.Exists(tempFolder))
            {
                Directory.CreateDirectory(tempFolder);
            }

            string tempFileName = username + "_" + Guid.NewGuid().ToString("N") + extension;
            string tempFilePath = Path.Combine(tempFolder, tempFileName);

            fuIdPicture.SaveAs(tempFilePath);

            Session["reg_id_temp_path"] = tempFilePath;
            Session["reg_id_extension"] = extension;
        }

        private string SaveIdPictureToUserRecords()
        {
            if (Session["reg_id_temp_path"] == null || Session["reg_id_extension"] == null)
            {
                throw new Exception("ID picture was not found. Please upload your ID picture again.");
            }

            string tempFilePath = Session["reg_id_temp_path"].ToString();

            if (!File.Exists(tempFilePath))
            {
                throw new Exception("ID picture file is missing. Please upload your ID picture again.");
            }

            string username = Session["reg_username"].ToString();
            string extension = Session["reg_id_extension"].ToString();
            string recordsFolder = Server.MapPath("~/Records");
            string userFolder = Path.Combine(recordsFolder, username);

            if (!Directory.Exists(recordsFolder))
            {
                Directory.CreateDirectory(recordsFolder);
            }

            if (!Directory.Exists(userFolder))
            {
                Directory.CreateDirectory(userFolder);
            }

            string finalFileName = username + "_ID_Picture" + extension;
            string finalFilePath = Path.Combine(userFolder, finalFileName);

            if (File.Exists(finalFilePath))
            {
                File.Delete(finalFilePath);
            }

            File.Move(tempFilePath, finalFilePath);

            Session.Remove("reg_id_temp_path");
            Session.Remove("reg_id_extension");

            return "~/Records/" + username + "/" + finalFileName;
        }

        private void DeleteTemporaryIdPicture()
        {
            if (Session["reg_id_temp_path"] != null)
            {
                string tempFilePath = Session["reg_id_temp_path"].ToString();

                if (File.Exists(tempFilePath))
                {
                    File.Delete(tempFilePath);
                }
            }

            Session.Remove("reg_id_temp_path");
            Session.Remove("reg_id_extension");
        }

        private void RegisterBeneficiary()
        {
            SaveIdPictureToUserRecords();

            string connectionString = ConfigurationManager
                .ConnectionStrings["BarangayDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                string query = @"
                    INSERT INTO beneficiaries
                    (
                        username,
                        password_hash,
                        email,
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
                        @email,
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
                    cmd.Parameters.AddWithValue("@username", Session["reg_username"].ToString());
                    cmd.Parameters.AddWithValue("@password_hash", Session["reg_password"].ToString());
                    cmd.Parameters.AddWithValue("@email", Session["reg_email"].ToString());

                    cmd.Parameters.AddWithValue("@last_name", Session["reg_lastname"].ToString());
                    cmd.Parameters.AddWithValue("@first_name", Session["reg_firstname"].ToString());
                    cmd.Parameters.AddWithValue("@middle_name", Session["reg_middlename"].ToString());

                    cmd.Parameters.AddWithValue("@date_of_birth",
                        DateTime.Parse(Session["reg_dob"].ToString()));

                    cmd.Parameters.AddWithValue("@age",
                        string.IsNullOrWhiteSpace(Session["reg_age"].ToString())
                        ? (object)DBNull.Value
                        : int.Parse(Session["reg_age"].ToString()));

                    cmd.Parameters.AddWithValue("@sex", Session["reg_sex"].ToString());

                    cmd.Parameters.AddWithValue("@contact_number",
                        Session["reg_contact"].ToString());

                    cmd.Parameters.AddWithValue("@civil_status",
                        Session["reg_civil"].ToString());

                    cmd.Parameters.AddWithValue("@purok_street",
                        Session["reg_purok"].ToString());

                    cmd.Parameters.AddWithValue("@household_members",
                        int.Parse(Session["reg_household"].ToString()));

                    cmd.Parameters.AddWithValue("@monthly_income",
                        string.IsNullOrWhiteSpace(Session["reg_income"].ToString())
                        ? (object)DBNull.Value
                        : decimal.Parse(Session["reg_income"].ToString()));

                    cmd.Parameters.AddWithValue("@beneficiary_type",
                        Session["reg_beneficiary"].ToString());

                    cmd.Parameters.AddWithValue("@government_id_presented",
                        Session["reg_govid"].ToString());

                    cmd.ExecuteNonQuery();
                }

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
                        Session["reg_firstname"].ToString() + " "
                        + Session["reg_lastname"].ToString()
                        + " has submitted a new beneficiary registration request.");

                    notifCmd.ExecuteNonQuery();
                }
            }
        }

        private void StoreRegistrationData()
        {
            Session["reg_username"] = txtUsername.Text.Trim();
            Session["reg_password"] = txtPassword.Text.Trim();
            Session["reg_email"] = txtEmail.Text.Trim();

            Session["reg_lastname"] = txtLastName.Text.Trim();
            Session["reg_firstname"] = txtFirstName.Text.Trim();
            Session["reg_middlename"] = txtMiddleName.Text.Trim();

            Session["reg_dob"] = txtDateOfBirth.Text.Trim();
            Session["reg_age"] = txtAge.Text.Trim();

            Session["reg_sex"] = rbMale.Checked ? "Male" : "Female";

            Session["reg_contact"] = txtContact.Text.Trim();

            Session["reg_civil"] = ddlCivilStatus.SelectedValue;

            Session["reg_purok"] = txtPurok.Text.Trim();

            Session["reg_household"] = txtHouseholdSize.Text.Trim();

            Session["reg_income"] = txtIncome.Text.Trim();

            Session["reg_beneficiary"] = ddlBeneficiaryType.SelectedValue;

            Session["reg_govid"] = ddlGovID.SelectedValue;
        }

        private void SendOtpEmail(string recipientEmail, string otp)
        {
            string senderEmail = ConfigurationManager.AppSettings["SmtpEmail"];
            string senderPassword = ConfigurationManager.AppSettings["SmtpPassword"];

            MailMessage mail = new MailMessage();

            mail.From = new MailAddress(senderEmail, "Barangay Assistance System");

            mail.To.Add(recipientEmail);

            mail.Subject = "OTP Verification";

            mail.Body =
                "Your OTP code is: " + otp +
                "\n\nThis code will expire in 5 minutes.";

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);

            smtp.EnableSsl = true;
            smtp.UseDefaultCredentials = false;

            smtp.Credentials =
                new NetworkCredential(senderEmail, senderPassword);

            smtp.DeliveryMethod =
                SmtpDeliveryMethod.Network;

            smtp.Send(mail);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearFields();

            lblSuccess.Visible = false;
            lblError.Visible = false;

            Session.Remove("EmailOtp");
            Session.Remove("EmailOtpExpiry");
            DeleteTemporaryIdPicture();
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
            txtEmail.Text = "";

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