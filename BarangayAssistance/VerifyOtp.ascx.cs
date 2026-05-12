using System;
using System.Text.RegularExpressions;

namespace BarangayAssistance
{
    public partial class VerifyOtp : System.Web.UI.UserControl
    {
        public event EventHandler OtpVerified;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public void Show()
        {
            otpOverlay.Style["display"] = "flex";
        }

        public void Hide()
        {
            otpOverlay.Style["display"] = "none";
        }

        protected void btnVerifyOtp_Click(object sender, EventArgs e)
        {
            lblOtpError.Visible = false;

            if (Session["EmailOtp"] == null ||
                Session["EmailOtpExpiry"] == null)
            {
                lblOtpError.Text = "❌ OTP session expired.";
                lblOtpError.Visible = true;
                return;
            }

            string enteredOtp = txtOtp.Text.Trim();

            if (string.IsNullOrWhiteSpace(enteredOtp))
            {
                lblOtpError.Text = "❌ Please enter OTP.";
                lblOtpError.Visible = true;
                return;
            }

            if (!Regex.IsMatch(enteredOtp, @"^\d{6}$"))
            {
                lblOtpError.Text = "❌ OTP must be exactly 6 digits.";
                lblOtpError.Visible = true;
                return;
            }

            if (DateTime.Now > Convert.ToDateTime(Session["EmailOtpExpiry"]))
            {
                lblOtpError.Text = "❌ OTP expired.";
                lblOtpError.Visible = true;
                return;
            }

            if (enteredOtp != Session["EmailOtp"].ToString())
            {
                lblOtpError.Text = "❌ Invalid OTP.";
                lblOtpError.Visible = true;
                return;
            }

            Hide();

            if (OtpVerified != null)
            {
                OtpVerified(this, EventArgs.Empty);
            }
        }
    }
}