using System;
using System.Configuration;
using System.Data.SqlClient;
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
                        cmd.Parameters.AddWithValue("@preferred_date", DateTime.Parse(txtPreferredDate.Text));
                        cmd.Parameters.AddWithValue("@urgency_level", ddlUrgency.SelectedValue);
                        cmd.Parameters.AddWithValue("@reason", txtReason.Text.Trim());

                        if (string.IsNullOrWhiteSpace(txtNotes.Text))
                            cmd.Parameters.AddWithValue("@notes", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@notes", txtNotes.Text.Trim());

                        if (string.IsNullOrWhiteSpace(txtRequestedAmount.Text))
                            cmd.Parameters.AddWithValue("@estimated_amount", DBNull.Value);
                        else
                            cmd.Parameters.AddWithValue("@estimated_amount", decimal.Parse(
                                txtRequestedAmount.Text,
                                System.Globalization.CultureInfo.InvariantCulture
                            ));

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
                            "📄 New Assistance Application");

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