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
            // Redirect to login if not logged in as Beneficiary
            if (!IsPostBack)
            {
                if (Session["role"] == null || Session["role"].ToString() != "Beneficiary")
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
{
    // Guard: check session
    if (Session["beneficiary_id"] == null || Session["role"]?.ToString() != "Beneficiary")
    {
        lblError.Text = "❌ Session expired. Please log in again.";
        lblError.Visible = true;
        return;
    }

    if (Page.IsValid)
    {
        try
        {
            int beneficiaryId = Convert.ToInt32(Session["beneficiary_id"].ToString());
            string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = @"
                    INSERT INTO assistance_applications 
                    (
                        beneficiary_id, full_name, beneficiary_type,
                        contact_number, assistance_type, preferred_date,
                        estimated_amount_requested, urgency_level,
                        reason_for_application, additional_notes,
                        status, date_submitted
                    )
                    VALUES 
                    (
                        @beneficiary_id, @full_name, @beneficiary_type,
                        @contact_number, @assistance_type, @preferred_date,
                        @estimated_amount, @urgency_level,
                        @reason, @notes,
                        'Pending', GETDATE()
                    )";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@beneficiary_id", beneficiaryId);
                    cmd.Parameters.AddWithValue("@full_name", txtFullName.Text.Trim());
                    cmd.Parameters.AddWithValue("@beneficiary_type", ddlBeneficiaryType.SelectedValue);
                    cmd.Parameters.AddWithValue("@contact_number", txtContactNumber.Text.Trim());
                    cmd.Parameters.AddWithValue("@assistance_type", ddlAssistanceType.SelectedValue);
                    cmd.Parameters.AddWithValue("@preferred_date", DateTime.Parse(txtPreferredDate.Text));
                    cmd.Parameters.AddWithValue("@urgency_level", ddlUrgency.SelectedValue);
                    cmd.Parameters.AddWithValue("@reason", txtReason.Text.Trim());
                    cmd.Parameters.AddWithValue("@notes", string.IsNullOrEmpty(txtNotes.Text) ? (object)DBNull.Value : txtNotes.Text.Trim());

                    if (!string.IsNullOrEmpty(txtRequestedAmount.Text))
                        cmd.Parameters.AddWithValue("@estimated_amount", decimal.Parse(txtRequestedAmount.Text, System.Globalization.CultureInfo.InvariantCulture));
                    else
                        cmd.Parameters.AddWithValue("@estimated_amount", DBNull.Value);

                    cmd.ExecuteNonQuery();
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
            txtFullName.Text = "";
            txtReferenceNo.Text = "";
            txtContactNumber.Text = "";
            txtPreferredDate.Text = "";
            txtRequestedAmount.Text = "";
            txtReason.Text = "";
            txtNotes.Text = "";
            ddlBeneficiaryType.SelectedIndex = 0;
            ddlAssistanceType.SelectedIndex = 0;
            ddlUrgency.SelectedIndex = 0;
            chkDeclaration.Checked = false;
        }
    }
}