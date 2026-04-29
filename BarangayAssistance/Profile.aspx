<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="BarangayAssistance.Profile" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Profile - AssistSys</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            color: #222;
        }

        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 230px;
            background-color: #1f3b57;
            color: white;
            transition: 0.3s;
            overflow: hidden;
        }

        .sidebar.collapsed {
            width: 70px;
        }

        .logo {
            padding: 20px;
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar.collapsed .logo span {
            display: none;
        }

        .nav-links {
            padding: 10px 0;
        }

        .nav-links a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 14px 20px;
            font-size: 14px;
        }

        .nav-links a:hover,
        .nav-links a.active {
            background-color: #2f557a;
        }

        .sidebar.collapsed .nav-links a span {
            display: none;
        }

        .main {
            flex: 1;
            padding: 20px;
        }

        .topbar {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .menu-btn {
            font-size: 20px;
            cursor: pointer;
            background: #1f3b57;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
        }

        .profile-card {
            background: #fff;
            border: 1px solid #dde1e7;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 8px 24px rgba(31, 59, 87, 0.12);
        }

        .profile-header {
            background: linear-gradient(135deg, #1f3b57, #2f557a);
            padding: 28px;
            color: white;
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .avatar {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: #ffffff;
            color: #1f3b57;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            font-weight: bold;
            border: 4px solid rgba(255,255,255,0.35);
        }

        .profile-header h2 {
            font-size: 24px;
            margin-bottom: 6px;
        }

        .profile-header p {
            font-size: 13px;
            color: #d7e6f5;
        }

        .content {
            padding: 26px;
        }

        .message {
            color: #791f1f;
            background: #fcebeb;
            border: 1px solid #f09595;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 18px;
            display: block;
        }

        .section-title {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #888;
            font-weight: bold;
            margin-bottom: 14px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 14px;
        }

        .info-box {
            background: #f8f9fa;
            border: 1px solid #dde1e7;
            border-radius: 10px;
            padding: 14px;
        }

        .info-box .label {
            font-size: 12px;
            font-weight: bold;
            color: #666;
            margin-bottom: 6px;
        }

        .info-box .value {
            font-size: 15px;
            color: #1f3b57;
            font-weight: bold;
            min-height: 20px;
        }

        .full {
            grid-column: span 2;
        }

        @media (max-width: 650px) {
            .wrapper {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .sidebar.collapsed {
                width: 100%;
            }

            .grid {
                grid-template-columns: 1fr;
            }

            .full {
                grid-column: span 1;
            }
        }
    </style>

    <script>
        function toggleSidebar() {
            var sidebar = document.getElementById("sidebar");
            sidebar.classList.toggle("collapsed");
        }
    </script>
</head>

<body>
<form id="form1" runat="server">

    <div class="wrapper">

        <div class="sidebar" id="sidebar">
            <div class="logo">
                🏥 <span>AssistSys</span>
            </div>

            <div class="nav-links">
                <a href="Dashboard.aspx">
                    <span class="icon">🏠</span>
                    <span>Dashboard</span>
                </a>
                <a href="Assistance_Application.aspx">
                    <span class="icon">📄</span>
                    <span>Apply</span>
                </a>
                <a href="Transactions.aspx">
                    <span class="icon">💳</span>
                    <span>My Transactions</span>
                </a>
                <a href="Profile.aspx" class="active">👤 <span>Profile</span></a>
                <a href="Notifications.aspx">
                    <span class="icon">🔔</span>
                    <span>Notifications</span>
                </a>
            </div>
            
                <a href="Logout.aspx">
                    <span class="icon">🚪</span>
                    <span>Logout</span>
                </a>
        </div>

        <div class="main">

            <div class="topbar">
                <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                <h3>User Profile</h3>
            </div>

            <div class="profile-card">

                <div class="profile-header">
                    <div class="avatar">👤</div>
                    <div>
                        <h2>My Profile</h2>
                        <p>Beneficiary information registered in AssistSys</p>
                    </div>
                </div>

                <div class="content">
                    <asp:Label ID="lblMessage" runat="server" CssClass="message" />

                    <div class="section-title">Account Information</div>

                    <div class="grid">
                        <div class="info-box">
                            <div class="label">Username</div>
                            <div class="value"><asp:Label ID="lblUsername" runat="server" /></div>
                        </div>

                        <div class="info-box">
                            <div class="label">Beneficiary Type</div>
                            <div class="value"><asp:Label ID="lblBeneficiaryType" runat="server" /></div>
                        </div>

                        <div class="info-box full">
                            <div class="label">Full Name</div>
                            <div class="value"><asp:Label ID="lblFullName" runat="server" /></div>
                        </div>
                    </div>

                    <br />

                    <div class="section-title">Personal Details</div>

                    <div class="grid">
                        <div class="info-box">
                            <div class="label">Date of Birth</div>
                            <div class="value"><asp:Label ID="lblDOB" runat="server" /></div>
                        </div>

                        <div class="info-box">
                            <div class="label">Age</div>
                            <div class="value"><asp:Label ID="lblAge" runat="server" /></div>
                        </div>

                        <div class="info-box">
                            <div class="label">Sex</div>
                            <div class="value"><asp:Label ID="lblSex" runat="server" /></div>
                        </div>

                        <div class="info-box">
                            <div class="label">Civil Status</div>
                            <div class="value"><asp:Label ID="lblCivilStatus" runat="server" /></div>
                        </div>

                        <div class="info-box">
                            <div class="label">Contact Number</div>
                            <div class="value"><asp:Label ID="lblContact" runat="server" /></div>
                        </div>

                        <div class="info-box">
                            <div class="label">Government ID</div>
                            <div class="value"><asp:Label ID="lblGovID" runat="server" /></div>
                        </div>
                    </div>

                    <br />

                    <div class="section-title">Household Information</div>

                    <div class="grid">
                        <div class="info-box full">
                            <div class="label">Purok / Street</div>
                            <div class="value"><asp:Label ID="lblPurok" runat="server" /></div>
                        </div>

                        <div class="info-box">
                            <div class="label">Household Members</div>
                            <div class="value"><asp:Label ID="lblHousehold" runat="server" /></div>
                        </div>

                        <div class="info-box">
                            <div class="label">Monthly Income</div>
                            <div class="value"><asp:Label ID="lblIncome" runat="server" /></div>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>

</form>
</body>
</html>