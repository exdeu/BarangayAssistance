<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VerifyOtp.ascx.cs" Inherits="BarangayAssistance.VerifyOtp" %>

<style>
    .otp-overlay {
        position: fixed;
        inset: 0;
        background: rgba(15, 35, 51, 0.62);
        backdrop-filter: blur(7px);
        -webkit-backdrop-filter: blur(7px);
        z-index: 99999;
        display: none;
        align-items: center;
        justify-content: center;
        padding: 1rem;
        animation: otpFadeIn 0.3s ease;
    }

    .otp-box {
        width: 100%;
        max-width: 430px;
        background: rgba(255, 255, 255, 0.98);
        border-radius: 26px;
        overflow: hidden;
        box-shadow: 0 28px 70px rgba(0, 0, 0, 0.28);
        border: 1px solid rgba(255, 255, 255, 0.55);
        animation: otpPopupIn 0.38s ease;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .otp-header {
        position: relative;
        background: linear-gradient(135deg, #1a364e, #152c40);
        padding: 2.3rem 2rem 2rem;
        text-align: center;
        color: white;
        overflow: hidden;
    }

    .otp-header::before {
        content: '';
        position: absolute;
        top: -70px;
        right: -70px;
        width: 190px;
        height: 190px;
        background: rgba(255, 255, 255, 0.08);
        border-radius: 50%;
    }

    .otp-header::after {
        content: '';
        position: absolute;
        bottom: -90px;
        left: -80px;
        width: 210px;
        height: 210px;
        background: rgba(52, 152, 219, 0.22);
        border-radius: 50%;
    }

    .otp-icon {
        width: 72px;
        height: 72px;
        margin: 0 auto 1rem;
        border-radius: 22px;
        background: rgba(255, 255, 255, 0.13);
        border: 1px solid rgba(255, 255, 255, 0.18);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2rem;
        position: relative;
        z-index: 1;
        box-shadow: inset 0 0 20px rgba(255, 255, 255, 0.08);
    }

    .otp-header h2 {
        font-size: 1.65rem;
        margin-bottom: 8px;
        position: relative;
        z-index: 1;
        letter-spacing: -0.4px;
    }

    .otp-header p {
        color: #c8dcee;
        font-size: 0.9rem;
        position: relative;
        z-index: 1;
    }

    .otp-body {
        padding: 2rem;
    }

    .otp-message {
        color: #5d6d7e;
        text-align: center;
        line-height: 1.6;
        margin-bottom: 1.4rem;
        font-size: 0.93rem;
    }

    .otp-input-wrap {
        position: relative;
        margin-bottom: 1rem;
    }

    .otp-input-label {
        display: block;
        color: #1a364e;
        font-size: 0.8rem;
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        margin-bottom: 8px;
    }

    .otp-input {
        width: 100%;
        padding: 15px 16px;
        border: 2px solid #dde1e7;
        border-radius: 16px;
        text-align: center;
        font-size: 1.45rem;
        letter-spacing: 7px;
        outline: none;
        transition: all 0.3s ease;
        background: #f8f9fa;
        color: #1a364e;
        font-weight: 800;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .otp-input:focus {
        border-color: #3498db;
        background: white;
        box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.12);
    }

    .otp-btn {
        width: 100%;
        padding: 14px;
        border: none;
        border-radius: 16px;
        background: linear-gradient(135deg, #1a364e, #2980b9);
        color: white;
        font-weight: 800;
        cursor: pointer;
        font-size: 0.95rem;
        transition: all 0.3s ease;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        box-shadow: 0 8px 20px rgba(26, 54, 78, 0.22);
    }

    .otp-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 26px rgba(26, 54, 78, 0.28);
    }

    .otp-btn:active {
        transform: scale(0.98);
    }

    .otp-error {
        display: block;
        background: linear-gradient(135deg, #f8d7da, #f5c6cb);
        color: #721c24;
        border: 1px solid #dc3545;
        padding: 12px 14px;
        border-radius: 14px;
        margin-bottom: 1rem;
        font-size: 0.85rem;
        font-weight: 700;
        text-align: left;
    }

    .otp-note {
        margin-top: 1rem;
        padding: 12px 14px;
        border-radius: 14px;
        background: #eef4fb;
        color: #5d6d7e;
        font-size: 0.82rem;
        line-height: 1.5;
        text-align: center;
        border: 1px solid rgba(52, 152, 219, 0.14);
    }

    @keyframes otpPopupIn {
        from {
            opacity: 0;
            transform: scale(0.92) translateY(24px);
        }

        to {
            opacity: 1;
            transform: scale(1) translateY(0);
        }
    }

    @keyframes otpFadeIn {
        from {
            opacity: 0;
        }

        to {
            opacity: 1;
        }
    }

    @media (max-width: 480px) {
        .otp-box {
            border-radius: 22px;
        }

        .otp-header {
            padding: 2rem 1.5rem 1.7rem;
        }

        .otp-body {
            padding: 1.5rem;
        }

        .otp-input {
            font-size: 1.25rem;
            letter-spacing: 5px;
        }
    }
</style>

<div id="otpOverlay" class="otp-overlay" runat="server">
    <div class="otp-box">

        <div class="otp-header">
            <div class="otp-icon">✉️</div>
            <h2 style="color: white">Email Verification</h2>
            <p>Barangay Assistance System</p>
        </div>

        <div class="otp-body">

            <asp:Label ID="lblOtpError"
                runat="server"
                CssClass="otp-error"
                Visible="false" />

            <div class="otp-message">
                We sent a six-digit verification code to your email. Enter it below to continue.
            </div>

            <div class="otp-input-wrap">
                <label class="otp-input-label">Verification Code</label>

                <asp:TextBox ID="txtOtp"
                    runat="server"
                    CssClass="otp-input"
                    MaxLength="6"
                    placeholder="000000" />
            </div>

            <asp:Button ID="btnVerifyOtp"
                runat="server"
                Text="Verify OTP"
                CssClass="otp-btn"
                CausesValidation="false"
                OnClick="btnVerifyOtp_Click" />

            <div class="otp-note">
                This code will expire shortly. Please check your inbox or spam folder.
            </div>

        </div>

    </div>
</div>