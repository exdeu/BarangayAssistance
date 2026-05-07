using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;

namespace BarangayAssistance
{
    public partial class BeneficiaryApplications : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["role"] == null || Session["role"].ToString() != "Admin")
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                lblWelcome.Text = Session["FullName"] == null
                    ? "Administrator"
                    : Session["FullName"].ToString();

                LoadBeneficiaries();
            }
        }

        private void LoadBeneficiaries(
     string search = "",
     string status = "",
     string beneficiaryType = "",
     string sex = "",
     string civilStatus = "")
        {
            search = search.Trim();

            if (search.Length > 100)
            {
                lblMessage.Text = "⚠️ Search text must not exceed 100 characters.";
                return;
            }

            if (!string.IsNullOrWhiteSpace(search) &&
                !Regex.IsMatch(search, @"^[a-zA-Z0-9\s.,@_+\-'/ñÑ]+$"))
            {
                lblMessage.Text = "⚠️ Search contains invalid characters.";
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
            SELECT
                b.beneficiary_id,
                b.username,
                b.first_name + ' ' + b.last_name AS full_name,
                b.contact_number,
                b.beneficiary_type,
                b.purok_street,
                b.date_registered,
                b.status
            FROM beneficiaries b
            WHERE 1 = 1";

                // SEARCH
                if (!string.IsNullOrWhiteSpace(search))
                {
                    query += @"
                AND
                (
                    b.username LIKE @search OR
                    b.first_name LIKE @search OR
                    b.last_name LIKE @search OR
                    b.contact_number LIKE @search OR
                    b.purok_street LIKE @search OR
                    b.beneficiary_type LIKE @search
                )";
                }

                // STATUS FILTER
                if (!string.IsNullOrWhiteSpace(status))
                {
                    query += " AND b.status = @status";
                }

                // BENEFICIARY TYPE FILTER
                if (!string.IsNullOrWhiteSpace(beneficiaryType))
                {
                    query += " AND b.beneficiary_type = @beneficiaryType";
                }

                // SEX FILTER
                if (!string.IsNullOrWhiteSpace(sex))
                {
                    query += " AND b.sex = @sex";
                }

                // CIVIL STATUS FILTER
                if (!string.IsNullOrWhiteSpace(civilStatus))
                {
                    query += " AND b.civil_status = @civilStatus";
                }

                query += @"
            ORDER BY
                CASE WHEN b.status = 'Inactive' THEN 0 ELSE 1 END,
                b.date_registered DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrWhiteSpace(search))
                    {
                        cmd.Parameters.Add("@search", SqlDbType.NVarChar, 150)
                            .Value = "%" + search + "%";
                    }

                    if (!string.IsNullOrWhiteSpace(status))
                    {
                        cmd.Parameters.Add("@status", SqlDbType.NVarChar, 30)
                            .Value = status;
                    }

                    if (!string.IsNullOrWhiteSpace(beneficiaryType))
                    {
                        cmd.Parameters.Add("@beneficiaryType", SqlDbType.NVarChar, 50)
                            .Value = beneficiaryType;
                    }

                    if (!string.IsNullOrWhiteSpace(sex))
                    {
                        cmd.Parameters.Add("@sex", SqlDbType.NVarChar, 10)
                            .Value = sex;
                    }

                    if (!string.IsNullOrWhiteSpace(civilStatus))
                    {
                        cmd.Parameters.Add("@civilStatus", SqlDbType.NVarChar, 30)
                            .Value = civilStatus;
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvBeneficiaries.DataSource = dt;
                    gvBeneficiaries.DataBind();

                    lblMessage.Text = dt.Rows.Count + " beneficiary record(s) found.";
                }
            }
        }

        public DataTable GetAssistanceApplications(object beneficiaryIdValue)
        {
            DataTable dt = new DataTable();

            if (beneficiaryIdValue == null ||
                !int.TryParse(beneficiaryIdValue.ToString(), out int beneficiaryId) ||
                beneficiaryId <= 0)
            {
                return dt;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        aa.application_id,
                        aa.beneficiary_id,
                        aa.full_name,
                        aa.beneficiary_type,
                        aa.contact_number,
                        aa.assistance_type,
                        aa.preferred_date,
                        aa.estimated_amount_requested,
                        aa.urgency_level,
                        aa.reason_for_application,
                        aa.additional_notes,
                        aa.status,
                        aa.date_submitted,
                        aa.date_updated,
                        b.username,
                        b.first_name,
                        b.last_name,
                        b.contact_number AS beneficiary_contact
                    FROM assistance_applications aa
                    INNER JOIN beneficiaries b
                        ON aa.beneficiary_id = b.beneficiary_id
                    WHERE aa.beneficiary_id = @beneficiary_id
                    ORDER BY aa.date_submitted DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add("@beneficiary_id", SqlDbType.Int).Value = beneficiaryId;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            return dt;
        }

        public int GetAssistanceApplicationCount(object beneficiaryIdValue)
        {
            if (beneficiaryIdValue == null ||
                !int.TryParse(beneficiaryIdValue.ToString(), out int beneficiaryId) ||
                beneficiaryId <= 0)
            {
                return 0;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT COUNT(*)
                    FROM assistance_applications aa
                    INNER JOIN beneficiaries b
                        ON aa.beneficiary_id = b.beneficiary_id
                    WHERE b.beneficiary_id = @beneficiary_id";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.Add("@beneficiary_id", SqlDbType.Int).Value = beneficiaryId;

                    con.Open();

                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadBeneficiaries(
                txtSearch.Text.Trim(),
                ddlStatus.SelectedValue,
                ddlBeneficiaryType.SelectedValue,
                ddlSex.SelectedValue,
                ddlCivilStatus.SelectedValue);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";

            ddlStatus.SelectedIndex = 0;
            ddlBeneficiaryType.SelectedIndex = 0;
            ddlSex.SelectedIndex = 0;
            ddlCivilStatus.SelectedIndex = 0;

            LoadBeneficiaries();
        }

        protected void gvBeneficiaries_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (Session["role"] == null || Session["role"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (e.CommandName == "ActivateBeneficiary")
            {
                if (e.CommandArgument == null ||
                    !int.TryParse(e.CommandArgument.ToString(), out int beneficiaryId) ||
                    beneficiaryId <= 0)
                {
                    lblMessage.Text = "⚠️ Invalid beneficiary selected.";
                    return;
                }

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    string checkQuery = @"
                        SELECT COUNT(*)
                        FROM beneficiaries
                        WHERE beneficiary_id = @beneficiary_id
                          AND status = 'Inactive'";

                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.Add("@beneficiary_id", SqlDbType.Int).Value = beneficiaryId;

                        int existingInactive = (int)checkCmd.ExecuteScalar();

                        if (existingInactive == 0)
                        {
                            lblMessage.Text = "⚠️ Beneficiary was not found or is already active.";
                            LoadBeneficiaries(txtSearch.Text.Trim());
                            return;
                        }
                    }

                    string updateQuery = @"
                        UPDATE beneficiaries
                        SET status = 'Active'
                        WHERE beneficiary_id = @beneficiary_id
                          AND status = 'Inactive'";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.Add("@beneficiary_id", SqlDbType.Int).Value = beneficiaryId;

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected == 0)
                        {
                            lblMessage.Text = "⚠️ Beneficiary account could not be activated.";
                            LoadBeneficiaries(txtSearch.Text.Trim());
                            return;
                        }
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
                            @beneficiary_id,
                            @title,
                            @message,
                            'Beneficiary',
                            0,
                            GETDATE()
                        )";

                    using (SqlCommand notifCmd = new SqlCommand(notifQuery, con))
                    {
                        notifCmd.Parameters.Add("@beneficiary_id", SqlDbType.Int).Value = beneficiaryId;
                        notifCmd.Parameters.Add("@title", SqlDbType.NVarChar, 100).Value = "Account Activated";
                        notifCmd.Parameters.Add("@message", SqlDbType.NVarChar, 500).Value =
                            "Your beneficiary account has been activated. You can now log in and submit assistance applications.";

                        notifCmd.ExecuteNonQuery();
                    }
                }

                lblMessage.Text = "✅ Beneficiary account activated successfully.";

                LoadBeneficiaries(txtSearch.Text.Trim());
            }
        }
    }
}