using System;
using System.Configuration;

namespace BarangayAssistance
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] != null)
            {
                pnlDashboardLayout.Visible = true;
                pnlPublicNav.Visible = false;
                pnlPublicContact.Visible = false;
            }
            else
            {
                pnlPublicNav.Visible = true;
                pnlPublicContact.Visible = true;
                pnlDashboardLayout.Visible = false;
            }
        }
    }
}