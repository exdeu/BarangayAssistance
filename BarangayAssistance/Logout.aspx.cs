using System;

namespace BarangayAssistance
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔥 Destroy session
            Session.Clear();
            Session.Abandon();

            // 🔥 Optional: clear cache (prevents back button access)
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
            Response.Cache.SetNoStore();

            // 🔥 Redirect to login or home
            Response.Redirect("Login.aspx");
        }
    }
}