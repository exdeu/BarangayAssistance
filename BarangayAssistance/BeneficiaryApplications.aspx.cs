using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

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
                        cmd.Parameters.AddWithValue("@search", "%" + search.Trim() + "%");
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
            if (e.CommandName == "ActivateBeneficiary")
            {
                int beneficiaryId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    string updateQuery = @"
                        UPDATE beneficiaries
                        SET status = 'Active'
                        WHERE beneficiary_id = @beneficiary_id";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@beneficiary_id", beneficiaryId);
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
                            @beneficiary_id,
                            @title,
                            @message,
                            'Beneficiary',
                            0,
                            GETDATE()
                        )";

                    using (SqlCommand notifCmd = new SqlCommand(notifQuery, con))
                    {
                        notifCmd.Parameters.AddWithValue("@beneficiary_id", beneficiaryId);
                        notifCmd.Parameters.AddWithValue("@title", "✅ Account Activated");
                        notifCmd.Parameters.AddWithValue("@message", "Your beneficiary account has been activated. You can now log in and submit assistance applications.");
                        notifCmd.ExecuteNonQuery();
                    }
                }

                lblMessage.Text = "✅ Beneficiary account activated successfully.";
                LoadBeneficiaries(txtSearch.Text.Trim());
            }
        }
    }
}