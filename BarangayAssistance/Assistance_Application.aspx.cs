using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BarangayAssistance
{
    public partial class Assistance_Application : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["role"] == null ||
                    Session["role"].ToString() != "Beneficiary" ||
                    Session["beneficiary_id"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Session["beneficiary_id"] == null ||
                Session["role"] == null ||
                Session["role"].ToString() != "Beneficiary")
            {
                lblError.Text = "❌ Session expired. Please log in again.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (!Page.IsValid)
            {
                lblError.Text = "⚠️ Please complete all required fields correctly.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (ddlAssistanceType.SelectedIndex == 0 || string.IsNullOrWhiteSpace(ddlAssistanceType.SelectedValue))
            {
                lblError.Text = "⚠️ Please select an assistance type.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (ddlUrgency.SelectedIndex == 0 || string.IsNullOrWhiteSpace(ddlUrgency.SelectedValue))
            {
                lblError.Text = "⚠️ Please select an urgency level.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (string.IsNullOrWhiteSpace(txtPreferredDate.Text))
            {
                lblError.Text = "⚠️ Please select your preferred date.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (!DateTime.TryParse(txtPreferredDate.Text, out DateTime preferredDate))
            {
                lblError.Text = "⚠️ Please enter a valid preferred date.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (preferredDate.Date < DateTime.Today)
            {
                lblError.Text = "⚠️ Preferred date cannot be in the past.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            string reason = txtReason.Text.Trim();
            string notes = txtNotes.Text.Trim();

            if (string.IsNullOrWhiteSpace(reason))
            {
                lblError.Text = "⚠️ Please enter your reason for application.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (reason.Length < 10)
            {
                lblError.Text = "⚠️ Reason must be at least 10 characters long.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (reason.Length > 1000)
            {
                lblError.Text = "⚠️ Reason must not exceed 1000 characters.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (!Regex.IsMatch(reason, @"^[a-zA-Z0-9\s.,!?()\-'/ñÑ]+$"))
            {
                lblError.Text = "⚠️ Reason contains invalid characters.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (!string.IsNullOrWhiteSpace(notes))
            {
                if (notes.Length > 1000)
                {
                    lblError.Text = "⚠️ Additional notes must not exceed 1000 characters.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (!Regex.IsMatch(notes, @"^[a-zA-Z0-9\s.,!?()\-'/ñÑ]+$"))
                {
                    lblError.Text = "⚠️ Additional notes contain invalid characters.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }
            }

            object requestedAmountValue = DBNull.Value;

            if (!string.IsNullOrWhiteSpace(txtRequestedAmount.Text))
            {
                if (!decimal.TryParse(
                    txtRequestedAmount.Text.Trim(),
                    NumberStyles.Number,
                    CultureInfo.InvariantCulture,
                    out decimal requestedAmount))
                {
                    lblError.Text = "⚠️ Please enter a valid requested amount.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (requestedAmount <= 0)
                {
                    lblError.Text = "⚠️ Requested amount must be greater than zero.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                if (requestedAmount > 100000)
                {
                    lblError.Text = "⚠️ Requested amount is too high. Please enter a reasonable amount.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                    return;
                }

                requestedAmountValue = requestedAmount;
            }

            try
            {
                int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"]);
                string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string fullName = "";
                    string contactNumber = "";
                    string beneficiaryType = "";

                    string beneficiaryQuery = @"
                        SELECT
                            (first_name + ' ' + last_name) AS full_name,
                            contact_number,
                            beneficiary_type
                        FROM beneficiaries
                        WHERE beneficiary_id = @beneficiary_id";

                    using (SqlCommand getBeneficiaryCmd = new SqlCommand(beneficiaryQuery, conn))
                    {
                        getBeneficiaryCmd.Parameters.AddWithValue("@beneficiary_id", beneficiaryId);

                        using (SqlDataReader reader = getBeneficiaryCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                fullName = reader["full_name"].ToString();
                                contactNumber = reader["contact_number"].ToString();
                                beneficiaryType = reader["beneficiary_type"].ToString();
                            }
                            else
                            {
                                lblError.Text = "❌ Beneficiary profile was not found.";
                                lblError.Visible = true;
                                lblSuccess.Visible = false;
                                return;
                            }
                        }
                    }

                    string insertQuery = @"
                        INSERT INTO assistance_applications
                        (
                            beneficiary_id,
                            full_name,
                            beneficiary_type,
                            contact_number,
                            assistance_type,
                            preferred_date,
                            estimated_amount_requested,
                            urgency_level,
                            reason_for_application,
                            additional_notes,
                            status,
                            date_submitted
                        )
                        VALUES
                        (
                            @beneficiary_id,
                            @full_name,
                            @beneficiary_type,
                            @contact_number,
                            @assistance_type,
                            @preferred_date,
                            @estimated_amount,
                            @urgency_level,
                            @reason,
                            @notes,
                            'Pending',
                            GETDATE()
                        )";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@beneficiary_id", beneficiaryId);
                        cmd.Parameters.AddWithValue("@full_name", fullName);
                        cmd.Parameters.AddWithValue("@beneficiary_type", beneficiaryType);
                        cmd.Parameters.AddWithValue("@contact_number", contactNumber);
                        cmd.Parameters.AddWithValue("@assistance_type", ddlAssistanceType.SelectedValue);
                        cmd.Parameters.AddWithValue("@preferred_date", preferredDate);
                        cmd.Parameters.AddWithValue("@urgency_level", ddlUrgency.SelectedValue);
                        cmd.Parameters.AddWithValue("@reason", reason);
                        cmd.Parameters.AddWithValue("@notes", string.IsNullOrWhiteSpace(notes) ? (object)DBNull.Value : notes);
                        cmd.Parameters.AddWithValue("@estimated_amount", requestedAmountValue);

                        cmd.ExecuteNonQuery();
                    }

                    // Insert admin notification for new assistance application
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
                            'Assistance',
                            0,
                            GETDATE()
                        )";
                    using (SqlCommand notifCmd = new SqlCommand(notifQuery, conn))
                    {
                        notifCmd.Parameters.AddWithValue(
                            "@title",
                            "New Assistance Application");

                        notifCmd.Parameters.AddWithValue(
                            "@message",
                            fullName + " submitted a new "
                            + ddlAssistanceType.SelectedValue
                            + " assistance application with "
                            + ddlUrgency.SelectedValue
                            + " urgency level.");

                        notifCmd.ExecuteNonQuery();
                    }
                }

                lblSuccess.Text = "✅ Application submitted successfully! It is now pending for review.";
                lblSuccess.Visible = true;
                lblError.Visible = false;

                ClearFields();
            }
            catch (Exception ex)
            {
                lblError.Text = "❌ Error: " + ex.Message;
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

        protected void cvDeclaration_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkDeclaration.Checked;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Dashboard.aspx");
        }

        private void ClearFields()
        {
            txtPreferredDate.Text = "";
            txtRequestedAmount.Text = "";
            txtReason.Text = "";
            txtNotes.Text = "";
            ddlAssistanceType.SelectedIndex = 0;
            ddlUrgency.SelectedIndex = 0;
            chkDeclaration.Checked = false;
        }
    }
}