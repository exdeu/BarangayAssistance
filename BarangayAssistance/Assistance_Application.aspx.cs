using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BarangayAssistance
{
    public partial class Assistance_Application : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                lblError.Text = "Please complete all required fields correctly.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            if (Session["username"] == null)
            {
                lblError.Text = "Session expired. Please login again.";
                lblError.Visible = true;
                lblSuccess.Visible = false;
                return;
            }

            string username = Session["username"].ToString();

            string connStr = System.Configuration.ConfigurationManager
                .ConnectionStrings["BarangayDB"].ConnectionString;

            string query = @"
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
                    additional_notes
                )
                SELECT
                    b.beneficiary_id,
                    b.first_name + ' ' + ISNULL(b.middle_name + ' ', '') + b.last_name,
                    @beneficiary_type,
                    b.contact_number,
                    @assistance_type,
                    @preferred_date,
                    @amount,
                    @urgency,
                    @reason,
                    @notes
                FROM beneficiaries b
                WHERE b.username = @username";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    cmd.Parameters.AddWithValue("@beneficiary_type", ddlBeneficiaryType.SelectedValue);
                    cmd.Parameters.AddWithValue("@assistance_type", ddlAssistanceType.SelectedValue);
                    cmd.Parameters.AddWithValue("@preferred_date", DateTime.Parse(txtPreferredDate.Text));

                    cmd.Parameters.AddWithValue("@amount",
                        string.IsNullOrWhiteSpace(txtRequestedAmount.Text)
                        ? (object)DBNull.Value
                        : Convert.ToDecimal(txtRequestedAmount.Text));

                    cmd.Parameters.AddWithValue("@urgency", ddlUrgency.SelectedValue);
                    cmd.Parameters.AddWithValue("@reason", txtReason.Text.Trim());

                    cmd.Parameters.AddWithValue("@notes",
                        string.IsNullOrWhiteSpace(txtNotes.Text)
                        ? (object)DBNull.Value
                        : txtNotes.Text.Trim());

                    conn.Open();

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        lblSuccess.Text = "Application submitted successfully.";
                        lblSuccess.Visible = true;
                        lblError.Visible = false;
                        ClearFields();
                    }
                    else
                    {
                        lblError.Text = "Application failed. Username was not found in beneficiaries table.";
                        lblError.Visible = true;
                        lblSuccess.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error: " + ex.Message;
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

        private void ClearFields()
        {
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