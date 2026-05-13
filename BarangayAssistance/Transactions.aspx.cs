using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

namespace BarangayAssistance
{
    public partial class Transactions : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["BarangayDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bool isLoggedIn = Session["role"] != null;

                pnlPublicNav.Visible = !isLoggedIn;
                pnlSidebar.Visible = isLoggedIn;
                pnlTopbar.Visible = isLoggedIn;
                pnlTimeout.Visible = isLoggedIn;

                lblWelcome.Text = isLoggedIn
                    ? (Session["FullName"] == null ? Session["role"].ToString() : Session["FullName"].ToString())
                    : "Public Viewer";

                LoadTransactions();
            }
        }

        private void LoadTransactions(string search = "", string status = "", string assistanceType = "")
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
                StringBuilder query = new StringBuilder(@"
                    SELECT
                        aa.application_id,
                        aa.beneficiary_id,
                        b.username,
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
                        aa.date_updated
                    FROM assistance_applications aa
                    INNER JOIN beneficiaries b
                        ON aa.beneficiary_id = b.beneficiary_id
                    WHERE 1 = 1
                ");

                if (IsBeneficiary())
                {
                    query.Append(" AND aa.beneficiary_id = @beneficiary_id");
                }

                if (!string.IsNullOrWhiteSpace(search))
                {
                    query.Append(@"
                        AND
                        (
                            aa.full_name LIKE @search OR
                            b.username LIKE @search OR
                            aa.beneficiary_type LIKE @search OR
                            aa.contact_number LIKE @search OR
                            aa.assistance_type LIKE @search OR
                            aa.urgency_level LIKE @search OR
                            aa.status LIKE @search OR
                            aa.reason_for_application LIKE @search
                        )");
                }

                if (!string.IsNullOrWhiteSpace(status))
                {
                    query.Append(" AND aa.status = @status");
                }

                if (!string.IsNullOrWhiteSpace(assistanceType))
                {
                    query.Append(" AND aa.assistance_type = @assistance_type");
                }

                query.Append(" ORDER BY aa.date_submitted DESC");

                using (SqlCommand cmd = new SqlCommand(query.ToString(), con))
                {
                    if (IsBeneficiary())
                    {
                        if (Session["beneficiary_id"] == null)
                        {
                            lblMessage.Text = "⚠️ Beneficiary session was not found.";
                            return;
                        }

                        cmd.Parameters.Add("@beneficiary_id", SqlDbType.Int).Value =
                            Convert.ToInt32(Session["beneficiary_id"]);
                    }

                    if (!string.IsNullOrWhiteSpace(search))
                    {
                        cmd.Parameters.Add("@search", SqlDbType.NVarChar, 150).Value = "%" + search + "%";
                    }

                    if (!string.IsNullOrWhiteSpace(status))
                    {
                        cmd.Parameters.Add("@status", SqlDbType.NVarChar, 30).Value = status;
                    }

                    if (!string.IsNullOrWhiteSpace(assistanceType))
                    {
                        cmd.Parameters.Add("@assistance_type", SqlDbType.NVarChar, 50).Value = assistanceType;
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvTransactions.DataSource = dt;
                    gvTransactions.DataBind();

                    lblMessage.Text = dt.Rows.Count + " transaction record(s) found.";
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadTransactions(
                txtSearch.Text.Trim(),
                ddlStatus.SelectedValue,
                ddlAssistanceType.SelectedValue);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedIndex = 0;
            ddlAssistanceType.SelectedIndex = 0;

            LoadTransactions();
        }

        protected void gvTransactions_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (!IsAdmin())
            {
                lblMessage.Text = "⚠️ Only admins are allowed to approve or reject applications.";
                return;
            }

            if (e.CommandName == "ApproveApplication" || e.CommandName == "RejectApplication")
            {
                if (e.CommandArgument == null ||
                    !int.TryParse(e.CommandArgument.ToString(), out int applicationId) ||
                    applicationId <= 0)
                {
                    lblMessage.Text = "⚠️ Invalid application selected.";
                    return;
                }

                string newStatus = e.CommandName == "ApproveApplication" ? "Approved" : "Rejected";

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    con.Open();

                    string updateQuery = @"
                        UPDATE assistance_applications
                        SET status = @status,
                            date_updated = GETDATE()
                        WHERE application_id = @application_id
                          AND status = 'Pending'";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.Add("@status", SqlDbType.NVarChar, 30).Value = newStatus;
                        cmd.Parameters.Add("@application_id", SqlDbType.Int).Value = applicationId;

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected == 0)
                        {
                            lblMessage.Text = "⚠️ Application was not found or already processed.";
                            LoadTransactions(txtSearch.Text.Trim(), ddlStatus.SelectedValue, ddlAssistanceType.SelectedValue);
                            return;
                        }
                    }

                    string getBeneficiaryQuery = @"
                        SELECT beneficiary_id, assistance_type
                        FROM assistance_applications
                        WHERE application_id = @application_id";

                    int beneficiaryId = 0;
                    string selectedAssistanceType = "";

                    using (SqlCommand getCmd = new SqlCommand(getBeneficiaryQuery, con))
                    {
                        getCmd.Parameters.Add("@application_id", SqlDbType.Int).Value = applicationId;

                        using (SqlDataReader reader = getCmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                beneficiaryId = Convert.ToInt32(reader["beneficiary_id"]);
                                selectedAssistanceType = reader["assistance_type"].ToString();
                            }
                        }
                    }

                    if (beneficiaryId > 0)
                    {
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
                                'Assistance',
                                0,
                                GETDATE()
                            )";

                        using (SqlCommand notifCmd = new SqlCommand(notifQuery, con))
                        {
                            notifCmd.Parameters.Add("@beneficiary_id", SqlDbType.Int).Value = beneficiaryId;
                            notifCmd.Parameters.Add("@title", SqlDbType.NVarChar, 100).Value =
                                "Application " + newStatus;

                            notifCmd.Parameters.Add("@message", SqlDbType.NVarChar, 500).Value =
                                "Your " + selectedAssistanceType + " assistance application has been " + newStatus.ToLower() + ".";

                            notifCmd.ExecuteNonQuery();
                        }
                    }
                }

                lblMessage.Text = "✅ Application " + newStatus.ToLower() + " successfully.";

                LoadTransactions(
                    txtSearch.Text.Trim(),
                    ddlStatus.SelectedValue,
                    ddlAssistanceType.SelectedValue);
            }
        }

        public bool IsPublicView()
        {
            return Session["role"] == null;
        }

        public bool IsAdmin()
        {
            return Session["role"] != null &&
                   Session["role"].ToString().Equals("Admin", StringComparison.OrdinalIgnoreCase);
        }

        public bool IsBeneficiary()
        {
            return Session["role"] != null &&
                   Session["role"].ToString().Equals("Beneficiary", StringComparison.OrdinalIgnoreCase);
        }

        public string GetStatusClass(object statusValue)
        {
            string status = statusValue == null ? "" : statusValue.ToString();

            if (status.Equals("Approved", StringComparison.OrdinalIgnoreCase))
            {
                return "status-approved";
            }

            if (status.Equals("Rejected", StringComparison.OrdinalIgnoreCase))
            {
                return "status-rejected";
            }

            if (status.Equals("Released", StringComparison.OrdinalIgnoreCase))
            {
                return "status-released";
            }

            return "status-pending";
        }

        public DataTable GetApplicationDocuments(object usernameValue, object applicationIdValue)
        {
            DataTable dt = new DataTable();

            dt.Columns.Add("FileName", typeof(string));
            dt.Columns.Add("FileUrl", typeof(string));

            if (usernameValue == null ||
                applicationIdValue == null ||
                string.IsNullOrWhiteSpace(usernameValue.ToString()) ||
                string.IsNullOrWhiteSpace(applicationIdValue.ToString()))
            {
                return dt;
            }

            string username = SanitizeFolderName(usernameValue.ToString());
            string applicationId = SanitizeFolderName(applicationIdValue.ToString());

            string applicationFolder = Server.MapPath("~/Records/" + username + "/" + applicationId + "/");

            if (!Directory.Exists(applicationFolder))
            {
                return dt;
            }

            string[] allowedExtensions =
            {
                ".jpg", ".jpeg", ".png", ".webp", ".gif", ".bmp", ".pdf", ".doc", ".docx"
            };

            foreach (string filePath in Directory.GetFiles(applicationFolder))
            {
                string extension = Path.GetExtension(filePath).ToLower();

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
                    continue;
                }

                string fileName = Path.GetFileName(filePath);

                string fileUrl = ResolveUrl("~/Records/"
                    + HttpUtility.UrlPathEncode(username)
                    + "/"
                    + HttpUtility.UrlPathEncode(applicationId)
                    + "/"
                    + HttpUtility.UrlPathEncode(fileName));

                dt.Rows.Add(fileName, fileUrl);
            }

            return dt;
        }

        public int GetApplicationDocumentCount(object usernameValue, object applicationIdValue)
        {
            return GetApplicationDocuments(usernameValue, applicationIdValue).Rows.Count;
        }

        private string SanitizeFolderName(string folderName)
        {
            if (string.IsNullOrWhiteSpace(folderName))
            {
                return "";
            }

            foreach (char invalidChar in Path.GetInvalidFileNameChars())
            {
                folderName = folderName.Replace(invalidChar.ToString(), "");
            }

            return folderName.Trim();
        }
    }
}