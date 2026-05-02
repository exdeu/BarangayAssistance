using System;
using System.Configuration;
using System.Data.SqlClient;

namespace BarangayAssistance
{
    public partial class Sidebar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null)
                return;

            string role = Session["role"].ToString();

            navAdmin.Visible = role == "Admin";
            navBeneficiary.Visible = role == "Beneficiary";

            LoadNotificationCount();
        }

        private void LoadNotificationCount()
        {
            if (Session["role"] == null)
                return;

            string connStr = ConfigurationManager
                .ConnectionStrings["BarangayDB"]
                .ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string query = "";

                if (Session["role"].ToString() == "Admin")
                {
                    query = @"
                        SELECT COUNT(*)
                        FROM notifications
                        WHERE type IN ('Admin','Registration','Assistance')
                        AND is_read = 0";
                }
                else
                {
                    query = @"
                        SELECT COUNT(*)
                        FROM notifications
                        WHERE beneficiary_id = @beneficiary_id
                        AND is_read = 0";
                }

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (Session["role"].ToString() == "Beneficiary")
                    {
                        cmd.Parameters.AddWithValue(
                            "@beneficiary_id",
                            Convert.ToInt32(Session["beneficiary_id"]));
                    }

                    int count = Convert.ToInt32(cmd.ExecuteScalar());

                    if (count > 0)
                    {
                        if(Session["role"].ToString() == "Admin")
                        {
                            admin_notif.Text = count.ToString();
                            admin_notif.Visible = true;
                        }
                        else
                        {
                            bene_notif.Text = count.ToString();
                            bene_notif.Visible = true;
                        }
                    }


                }
            }
        }
    }
}