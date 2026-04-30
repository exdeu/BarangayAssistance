<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="BarangayAssistance.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>AssistSys Dashboard</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e9edf2 100%);
            color: #2c3e4e;
            line-height: 1.6;
        }

        html {
            scroll-behavior: smooth;
        }

        ::-webkit-scrollbar { width: 10px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #3498db, #1a364e);
            border-radius: 5px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #2980b9, #152c40);
        }

        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 240px;
            background: linear-gradient(180deg, #1a364e 0%, #152c40 100%);
            color: white;
            transition: width 0.3s ease;
            overflow: hidden;
            box-shadow: 4px 0 20px rgba(0,0,0,0.15);
            display: flex;
            flex-direction: column;
            position: sticky;
            top: 0;
            height: 100vh;
        }

        .sidebar.collapsed {
            width: 70px;
        }

        .logo {
            padding: 25px 20px;
            font-size: 1.4rem;
            font-weight: 700;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #fff, #a8c8e8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            white-space: nowrap;
        }

        .sidebar.collapsed .logo span {
            display: none;
        }

        .nav-links {
            padding: 15px 0;
            flex: 1;
        }

        .nav-links a {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #ecf0f1;
            text-decoration: none;
            padding: 14px 20px;
            font-size: 0.95rem;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
            white-space: nowrap;
        }

        .nav-links a .icon {
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .nav-links a:hover {
            background: rgba(52, 152, 219, 0.2);
            color: #5dade2;
            padding-left: 28px;
        }

        .nav-links a::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: #3498db;
            transform: scaleY(0);
            transition: transform 0.3s ease;
            border-radius: 0 3px 3px 0;
        }

        .nav-links a:hover::before {
            transform: scaleY(1);
        }

        /* FIXED: only hide text, not icons */
        .sidebar.collapsed .nav-links a span:not(.icon) {
            display: none;
        }

        .sidebar.collapsed .nav-links a {
            justify-content: center;
            padding: 14px;
        }

        /* Main */
        .main {
            flex: 1;
            padding: 30px;
            overflow-x: auto;
        }

        /* Topbar */
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

        .menu-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.2);
        }

        .topbar h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a364e;
        }

        .welcome-text {
            font-size: 0.95rem;
            font-weight: 600;
            color: #5d6d7e;
        }

        /* Stat cards */
        .cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 25px 20px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.07);
            border: 1px solid rgba(52, 152, 219, 0.1);
            transition: all 0.3s ease;
            animation: fadeInUp 0.7s ease-out backwards;
        }

        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.3s; }
        .card:nth-child(4) { animation-delay: 0.4s; }

        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
            border-color: rgba(52, 152, 219, 0.3);
        }

        .card h4 {
            margin: 0 0 10px 0;
            color: #5d6d7e;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card p {
            margin: 0;
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, #1a364e, #3498db);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Section */
        .section {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.07);
            border: 1px solid rgba(52, 152, 219, 0.1);
            margin-top: 20px;
            animation: fadeInUp 0.7s ease-out 0.5s backwards;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 3px solid transparent;
            border-image: linear-gradient(90deg, #3498db, #5dade2) 1;
        }

        /* GridView */
        .grid-container {
            overflow-x: auto;
        }

        .gridview {
            width: 100%;
            min-width: 800px;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .gridview th {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            padding: 14px 12px;
            text-align: left;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .gridview th:first-child {
            border-radius: 10px 0 0 10px;
        }

        .gridview th:last-child {
            border-radius: 0 10px 10px 0;
        }

        .gridview td {
            padding: 12px;
            border-bottom: 1px solid rgba(52, 152, 219, 0.08);
            font-size: 0.9rem;
            color: #2c3e4e;
        }

        .gridview tr:nth-child(even) td {
            background-color: #f8fafd;
        }

        .gridview tr:hover td {
            background-color: #eef4fb;
            transition: background 0.2s ease;
        }

        /* Responsive */
        @media (max-width: 1100px) {
            .cards {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .main {
                padding: 15px;
            }

            .cards {
                grid-template-columns: 1fr;
            }

            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .topbar h3 {
                font-size: 1rem;
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

        <!-- Sidebar -->
        <div class="sidebar collapsed" id="sidebar">
            <div class="logo">
                🏥 <span>AssistSys</span>
            </div>

            <div class="nav-links">

                <asp:Panel ID="navAdmin" runat="server">
                    <a href="Dashboard.aspx">
                        <span class="icon">🏠</span>
                        <span>Dashboard</span>
                    </a>
                    <a href="Transactions.aspx">
                        <span class="icon">💳</span>
                        <span>Transactions</span>
                    </a>
                </asp:Panel>

               <asp:Panel ID="navUser" runat="server" Visible="false">
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
                    <a href="Notifications.aspx">
                        <span class="icon">🔔</span>
                        <span>Notifications</span>
                    </a>
                   <a href="Profile.aspx">
                        <span class="icon">👤</span>
                        <span>Profile</span>
                    </a>
                </asp:Panel>

                <a href="Logout.aspx">
                    <span class="icon">🚪</span>
                    <span>Logout</span>
                </a>

            </div>
        </div>

        <!-- Main Content -->
        <div class="main">

            <!-- Topbar -->
            <div class="topbar">
                <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                <h3>Dashboard</h3>
                <asp:Label ID="lblWelcome" runat="server" CssClass="welcome-text"></asp:Label>
            </div>

            <!-- Admin Panel -->
            <asp:Panel ID="pnlAdmin" runat="server">

                <div class="cards">
                    <div class="card">
                        <h4>Total Applications</h4>
                        <p><asp:Label ID="lblTotalApps" runat="server" Text="0" /></p>
                    </div>
                    <div class="card">
                        <h4>Pending Applications</h4>
                        <p><asp:Label ID="lblPending" runat="server" Text="0" /></p>
                    </div>
                    <div class="card">
                        <h4>Approved Applications</h4>
                        <p><asp:Label ID="lblApproved" runat="server" Text="0" /></p>
                    </div>
                    <div class="card">
                        <h4>Total Released</h4>
                        <p><asp:Label ID="lblFunds" runat="server" Text="₱0" /></p>
                    </div>
                </div>

                <div class="section">
                    <div class="section-title">📋 All Transactions</div>
                    <div class="grid-container">
                        <asp:GridView ID="gvAdminTransactions" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="gridview"
                            GridLines="None"
                            EmptyDataText="No transactions found.">
                            <Columns>
                                <asp:BoundField DataField="ApplicationID" HeaderText="Application ID" />
                                <asp:BoundField DataField="FullName" HeaderText="Beneficiary Name" />
                                <asp:BoundField DataField="AssistanceType" HeaderText="Assistance Type" />
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                                <asp:BoundField DataField="ApprovedAmount" HeaderText="Amount" />
                                <asp:BoundField DataField="DateApplied" HeaderText="Date Applied" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

            </asp:Panel>

            <!-- User Panel -->
            <asp:Panel ID="pnlUser" runat="server" Visible="false">

                <div class="cards">
                    <div class="card">
                        <h4>My Applications</h4>
                        <p><asp:Label ID="lblUserApps" runat="server" Text="0" /></p>
                    </div>
                    <div class="card">
                        <h4>Pending</h4>
                        <p><asp:Label ID="lblUserPending" runat="server" Text="0" /></p>
                    </div>
                    <div class="card">
                        <h4>Approved</h4>
                        <p><asp:Label ID="lblUserApproved" runat="server" Text="0" /></p>
                    </div>
                    <div class="card">
                        <h4>Total Received</h4>
                        <p><asp:Label ID="lblUserFunds" runat="server" Text="₱0" /></p>
                    </div>
                </div>

                <div class="section">
                    <div class="section-title">💳 My Transactions</div>
                    <div class="grid-container">
                        <asp:GridView ID="gvUserTransactions" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="gridview"
                            GridLines="None"
                            EmptyDataText="No transactions found.">
                            <Columns>
                                <asp:BoundField DataField="ApplicationID" HeaderText="Application ID" />
                                <asp:BoundField DataField="AssistanceType" HeaderText="Assistance Type" />
                                <asp:BoundField DataField="Status" HeaderText="Status" />
                                <asp:BoundField DataField="ApprovedAmount" HeaderText="Amount" />
                                <asp:BoundField DataField="DateApplied" HeaderText="Date Applied" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

            </asp:Panel>

        </div>
    </div>

</form>
</body>
</html>