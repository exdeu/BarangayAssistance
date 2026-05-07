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

        private void LoadBeneficiaries(string search = "")
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
                        beneficiary_id,
                        username,
                        first_name + ' ' + last_name AS full_name,
                        contact_number,
                        beneficiary_type,
                        purok_street,
                        date_registered,
                        status
                    FROM beneficiaries
                    WHERE 1 = 1";

                if (!string.IsNullOrWhiteSpace(search))
                {
                    query += @"
                        AND (
                            username LIKE @search OR
                            first_name LIKE @search OR
                            last_name LIKE @search OR
                            contact_number LIKE @search OR
                            beneficiary_type LIKE @search OR
                            purok_street LIKE @search OR
                            status LIKE @search
                        )";
                }

                query += " ORDER BY CASE WHEN status = 'Inactive' THEN 0 ELSE 1 END, date_registered DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (!string.IsNullOrWhiteSpace(search))
                    {
                        cmd.Parameters.Add("@search", SqlDbType.NVarChar, 150).Value = "%" + search + "%";
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

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadBeneficiaries(txtSearch.Text.Trim());
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
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
                        notifCmd.Parameters.Add("@title", SqlDbType.NVarChar, 100).Value = "✅ Account Activated";
                        notifCmd.Parameters.Add("@message", SqlDbType.NVarChar, 500).Value = "Your beneficiary account has been activated. You can now log in and submit assistance applications.";
                        notifCmd.ExecuteNonQuery();
                    }
                }

                lblMessage.Text = "✅ Beneficiary account activated successfully.";
                LoadBeneficiaries(txtSearch.Text.Trim());
            }
        }
    }
}