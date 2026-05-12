<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="BarangayAssistance.Profile" %>
<%@ Register Src="~/Sidebar.ascx"
    TagPrefix="uc"
    TagName="Sidebar" %>
<%@ Register Src="~/InactivityTimeout.ascx" TagPrefix="uc" TagName="InactivityTimeout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Profile - AssistSys</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e9edf2 100%);
            color: #2c3e4e;
            line-height: 1.6;
        }

        ::-webkit-scrollbar { width: 10px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #3498db, #1a364e);
            border-radius: 5px;
        }

        .wrapper { display: flex; min-height: 100vh; }

        .main { flex: 1; padding: 30px; overflow-y: auto; }

        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 30px;
            background: white;
            padding: 15px 25px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            animation: fadeInDown 0.6s ease-out;
        }

        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-15px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .menu-btn {
            font-size: 1.2rem;
            cursor: pointer;
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            border: none;
            padding: 10px 14px;
            border-radius: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .menu-btn:hover { transform: translateY(-2px); }

        .topbar h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a364e;
        }

        .profile-header {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            padding: 35px 30px;
            border-radius: 20px;
            margin-bottom: 25px;
            color: white;
            display: flex;
            align-items: center;
            gap: 25px;
            box-shadow: 0 10px 30px rgba(26,54,78,0.3);
            animation: fadeInUp 0.7s ease-out;
            position: relative;
            overflow: hidden;
        }

        .profile-header::after {
            content: '👤';
            position: absolute;
            right: 30px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 6rem;
            opacity: 0.08;
        }

        /* Clickable Avatar */
        .avatar {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            flex-shrink: 0;
            border: 3px solid rgba(255,255,255,0.3);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: border-color 0.3s ease;
        }

        .avatar:hover { border-color: rgba(255,255,255,0.8); }

        .avatar .camera-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: rgba(0,0,0,0.55);
            color: white;
            font-size: 10px;
            text-align: center;
            padding: 5px 0;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .avatar:hover .camera-overlay { opacity: 1; }

        .profile-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
        }

        .profile-info h2 {
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .profile-info p {
            opacity: 0.85;
            font-size: 0.95rem;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.07);
            border: 1px solid rgba(52,152,219,0.1);
            margin-bottom: 25px;
            animation: fadeInUp 0.7s ease-out 0.2s backwards;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 3px solid transparent;
            border-image: linear-gradient(90deg, #3498db, #5dade2) 1;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .info-item {
            background: linear-gradient(135deg, #f5f7fa, #e9edf2);
            padding: 15px 18px;
            border-radius: 12px;
            border: 1px solid rgba(52,152,219,0.1);
            transition: all 0.3s ease;
        }

        .info-item:hover {
            border-color: rgba(52,152,219,0.3);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .info-item .label {
            font-size: 0.75rem;
            font-weight: 700;
            color: #5d6d7e;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .info-item .value {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1a364e;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #5d6d7e;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input,
        .form-group select {
            padding: 11px 14px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            background: #f8f9fa;
            color: #2c3e4e;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #3498db;
            background: white;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.1);
        }

        .btn-row {
            display: flex;
            gap: 12px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .btn {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            font-family: inherit;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        .msg-success {
            background: #d1e7dd;
            border: 1px solid #a3cfbb;
            color: #0f5132;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 0.9rem;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .msg-error {
            background: #f8d7da;
            border: 1px solid #f1aeb5;
            color: #842029;
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 0.9rem;
            margin-bottom: 20px;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .main { padding: 15px; }
            .info-grid, .form-grid { grid-template-columns: 1fr; }
            .profile-header { flex-direction: column; text-align: center; }
        }
    </style>

    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("collapsed");
        }

        function triggerUpload() {
            document.getElementById('<%= fuProfilePicture.ClientID %>').click();
        }

        function autoUpload() {
            document.getElementById('<%= btnUploadPicture.ClientID %>').click();
        }
    </script>
</head>

<body>
<form id="form1" runat="server" enctype="multipart/form-data">

    <div class="wrapper">

        <!-- Sidebar -->
        <uc:Sidebar ID="Sidebar" runat="server" />

        <!-- Hidden upload controls (invisible but still work in code-behind) -->
        <asp:FileUpload ID="fuProfilePicture" runat="server"
            style="display:none;"
            onchange="autoUpload()" />
        <asp:Button ID="btnUploadPicture" runat="server"
            Text="Upload"
            style="display:none;"
            OnClick="btnUploadPicture_Click" />

        <!-- Main Content -->
        <div class="main">

            <div class="topbar">
                <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                <h3>👤 My Profile</h3>
                <div></div>
            </div>

            <!-- Profile Header with Clickable Avatar -->
            <div class="profile-header">
                <div class="avatar" onclick="triggerUpload()" title="Click to change profile picture">
                    <asp:Image ID="imgProfilePicture" runat="server" CssClass="profile-img" />
                    <div class="camera-overlay">📷 Change</div>
                </div>
                <div class="profile-info">
                    <h2><asp:Label ID="lblFullName" runat="server" Text="Loading..." /></h2>
                    <p>
                        <asp:Label ID="lblBeneficiaryType" runat="server" Text="" /> •
                        <asp:Label ID="lblUsername" runat="server" Text="" />
                    </p>
                </div>
            </div>

            <!-- Messages -->
            <asp:Label ID="lblSuccess" runat="server" CssClass="msg-success" Visible="false" />
            <asp:Label ID="lblError"   runat="server" CssClass="msg-error"   Visible="false" />

            <!-- Personal Information -->
            <div class="section">
                <div class="section-title">📋 Personal Information</div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="label">Last Name</div>
                        <div class="value"><asp:Label ID="lblLastName" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">First Name</div>
                        <div class="value"><asp:Label ID="lblFirstName" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Middle Name</div>
                        <div class="value"><asp:Label ID="lblMiddleName" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Date of Birth</div>
                        <div class="value"><asp:Label ID="lblDOB" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Age</div>
                        <div class="value"><asp:Label ID="lblAge" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Sex</div>
                        <div class="value"><asp:Label ID="lblSex" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Civil Status</div>
                        <div class="value"><asp:Label ID="lblCivilStatus" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Contact Number</div>
                        <div class="value"><asp:Label ID="lblContact" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Purok / Street</div>
                        <div class="value"><asp:Label ID="lblPurok" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Household Members</div>
                        <div class="value"><asp:Label ID="lblHousehold" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Monthly Income</div>
                        <div class="value"><asp:Label ID="lblIncome" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Government ID</div>
                        <div class="value"><asp:Label ID="lblGovID" runat="server" /></div>
                    </div>
                    <div class="info-item">
                        <div class="label">Email</div>
                        <div class="value"><asp:Label ID="lblEmail" runat="server" /></div>
                    </div>
                </div>
            </div>

            <!-- Edit Contact Info -->
            <div class="section">
                <div class="section-title">✏️ Update Contact Information</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Contact Number</label>
                        <asp:TextBox ID="txtContact" runat="server" placeholder="09XXXXXXXXX" />
                    </div>
                    <div class="form-group">
                        <label>Purok / Street</label>
                        <asp:TextBox ID="txtPurok" runat="server" placeholder="Purok or street name" />
                    </div>
                    <div class="form-group">
                        <label>Monthly Income</label>
                        <asp:TextBox ID="txtIncome" runat="server" placeholder="0.00" />
                    </div>
                    <div class="form-group">
                        <label>Household Members</label>
                        <asp:TextBox ID="txtHousehold" runat="server" placeholder="0" TextMode="Number" />
                    </div>
                </div>

                <div class="btn-row">
                    <asp:Button ID="btnUpdate" runat="server"
                        Text="💾 Save Changes"
                        CssClass="btn"
                        OnClick="btnUpdate_Click" />
                </div>
            </div>

            <!-- Change Password -->
            <div class="section">
                <div class="section-title">🔐 Change Password</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label>Current Password</label>
                        <asp:TextBox ID="txtCurrentPassword" runat="server"
                            TextMode="Password" placeholder="Enter current password" />
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server"
                            TextMode="Password" placeholder="Enter new password" />
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server"
                            TextMode="Password" placeholder="Confirm new password" />
                    </div>
                </div>

                <div class="btn-row">
                    <asp:Button ID="btnChangePassword" runat="server"
                        Text="🔐 Change Password"
                        CssClass="btn"
                        OnClick="btnChangePassword_Click" />
                </div>
            </div>

        </div>
    </div>
     <uc:InactivityTimeout ID="InactivityTimeout1" runat="server" />
</form>
</body>
</html>