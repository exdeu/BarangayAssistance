<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Transactions.aspx.cs" Inherits="BarangayAssistance.Transactions" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Transactions - AssistSys</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e9edf2 100%);
            color: #2c3e4e;
        }

        ::-webkit-scrollbar { width: 10px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #3498db, #1a364e);
            border-radius: 5px;
        }

        /* Public navbar */
        .navbar {
            background: rgba(26,54,78,0.95);
            backdrop-filter: blur(10px);
            color: white;
            padding: 1rem 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .public-logo {
            font-size: 1.6rem;
            font-weight: 700;
            background: linear-gradient(135deg, #fff, #a8c8e8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .public-nav-links a {
            color: #ecf0f1;
            text-decoration: none;
            margin-left: 2rem;
            font-size: 1rem;
            font-weight: 500;
            transition: color 0.3s;
        }

        .public-nav-links a:hover { color: #5dade2; }

        /* Layout */
        .wrapper { display: flex; min-height: 100vh; }

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

        .sidebar.collapsed { width: 70px; }

        .logo {
            padding: 25px 20px;
            font-size: 1.4rem;
            font-weight: 700;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            background: linear-gradient(135deg, #fff, #a8c8e8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            white-space: nowrap;
        }

        .sidebar.collapsed .logo span { display: none; }

        .nav-links { padding: 15px 0; flex: 1; }

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

        .nav-links a .icon { font-size: 1.2rem; flex-shrink: 0; }

        .nav-links a:hover,
        .nav-links a.active {
            background: rgba(52,152,219,0.2);
            color: #5dade2;
            padding-left: 28px;
        }

        .nav-links a::before {
            content: '';
            position: absolute;
            left: 0; top: 0; bottom: 0;
            width: 3px;
            background: #3498db;
            transform: scaleY(0);
            transition: transform 0.3s ease;
            border-radius: 0 3px 3px 0;
        }

        .nav-links a:hover::before,
        .nav-links a.active::before { transform: scaleY(1); }

                /* FIXED: only hide text, not icons */
        .sidebar.collapsed .nav-links a span:not(.icon) {
            display: none;
        }
        .sidebar.collapsed .nav-links a { justify-content: center; padding: 14px; }

        /* Main */
        .main { flex: 1; padding: 30px; overflow-x: auto; }

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

        /* Section */
        .section {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.07);
            border: 1px solid rgba(52,152,219,0.1);
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid transparent;
            border-image: linear-gradient(90deg, #3498db, #5dade2) 1;
        }

        /* Filters */
        .filters {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .filter-box {
            background: linear-gradient(135deg, #f5f7fa, #e9edf2);
            border: 1px solid rgba(52,152,219,0.15);
            border-radius: 15px;
            padding: 20px;
            transition: all 0.3s ease;
        }

        .filter-box:hover {
            border-color: rgba(52,152,219,0.3);
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .filter-box h4 {
            margin-bottom: 15px;
            color: #1a364e;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
        }

        .checkbox-grid { display: flex; flex-wrap: wrap; gap: 8px 16px; }

        .checkbox-item {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
            color: #2c3e4e;
            gap: 6px;
            cursor: pointer;
        }

        .checkbox-item input[type=checkbox] {
            accent-color: #3498db;
            width: 15px;
            height: 15px;
        }

        .date-row { display: flex; flex-direction: column; gap: 10px; }

        .date-row input {
            padding: 10px 12px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 0.9rem;
            font-family: inherit;
            background: white;
            transition: all 0.3s ease;
            color: #2c3e4e;
        }

        .date-row input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.1);
        }

        /* Action buttons */
        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 25px;
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

        .btn-outline {
            background: white;
            color: #1a364e;
            border: 2px solid #1a364e;
        }

        .btn-outline:hover {
            background: #f5f7fa;
        }

        /* GridView */
        .grid-container { overflow-x: auto; margin-top: 10px; }

        .gridview {
            width: 100%;
            border-collapse: collapse;
            min-width: 700px;
        }

        .gridview th {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            padding: 14px 12px;
            text-align: left;
            font-size: 0.82rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .gridview th:first-child { border-radius: 10px 0 0 10px; }
        .gridview th:last-child  { border-radius: 0 10px 10px 0; }

        .gridview td {
            padding: 12px;
            border-bottom: 1px solid rgba(52,152,219,0.08);
            font-size: 0.9rem;
        }

        .gridview tr:nth-child(even) td { background: #f8fafd; }
        .gridview tr:hover td {
            background: #eef4fb;
            transition: background 0.2s ease;
        }

        /* Status badges */
        .badge {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.78rem;
            font-weight: 700;
            display: inline-block;
        }

        .badge-pending  { background: #fff3cd; color: #856404; }
        .badge-approved { background: #d1e7dd; color: #0f5132; }
        .badge-rejected { background: #f8d7da; color: #842029; }
        .badge-released { background: #cff4fc; color: #055160; }

        /* Approve/Reject buttons */
        .btn-approve {
            background: linear-gradient(135deg, #198754, #157347);
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-right: 5px;
            font-family: inherit;
        }

        .btn-approve:hover { transform: translateY(-1px); box-shadow: 0 4px 10px rgba(0,0,0,0.2); }

        .btn-reject {
            background: linear-gradient(135deg, #dc3545, #b02a37);
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .btn-reject:hover { transform: translateY(-1px); box-shadow: 0 4px 10px rgba(0,0,0,0.2); }

        /* Message */
        .message {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #1a364e;
            font-size: 0.9rem;
        }

        @media (max-width: 900px) {
            .filters { grid-template-columns: 1fr; }
            .main { padding: 15px; }
            .navbar { flex-direction: column; gap: 10px; }
        }
    </style>

    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("collapsed");
        }
    </script>
</head>

<body>
<form id="form1" runat="server">

    <%-- Public navbar (not logged in) --%>
    <asp:Panel ID="pnlPublicNav" runat="server" Visible="false">
        <div class="navbar">
            <div class="public-logo">🏥 AssistSys</div>
            <div class="public-nav-links">
                <a href="index.aspx">Home</a>
                <a href="Login.aspx">Login</a>
                <a href="Register.aspx">Register</a>
                <a accesskey="t" href="Transactions.aspx">Transactions</a>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlPublicTransactions" runat="server" Visible="false">
    <div class="main" style="padding:40px 5%;">
        <div class="section">
            <div class="section-title">🌐 Public Transactions Overview</div>

            <p style="margin-bottom:20px; color:#5d6d7e;">
                View approved and released assistance records. Login to manage or apply.
            </p>

            <div class="grid-container">
                <asp:GridView ID="gvPublicTransactions" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="gridview"
                    GridLines="None"
                    EmptyDataText="No public records available.">
                    <Columns>
                        <asp:BoundField DataField="full_name" HeaderText="Beneficiary" />
                        <asp:BoundField DataField="assistance_type" HeaderText="Type" />
                        <asp:BoundField DataField="estimated_amount_requested" HeaderText="Amount" DataFormatString="{0:₱#,##0.00}" />
                        <asp:BoundField DataField="date_submitted" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:BoundField DataField="status" HeaderText="Status" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Panel>


    <%-- Dashboard layout (logged in) --%>
    <asp:Panel ID="pnlDashboardLayout" runat="server">
        <div class="wrapper">

            <%-- Sidebar --%>
            <asp:Panel ID="pnlSidebar" runat="server">
                <div class="sidebar collapsed" id="sidebar">
                    <div class="logo">🏥 <span>AssistSys</span></div>
                    <div class="nav-links">

                        <asp:Panel ID="navAdmin" runat="server" Visible="false">
                            
                            <a href="Dashboard.aspx">
                                <span class="icon">📊</span><span>Dashboard</span>
                            </a>
                            <a href="Transactions.aspx" class="active">
                                <span class="icon">💳</span><span>Transactions</span>
                            </a>
                        </asp:Panel>

                        <asp:Panel ID="navBeneficiary" runat="server" Visible="false">
                            
                            <a href="Dashboard.aspx">
                                <span class="icon">📊</span><span>Dashboard</span>
                            </a>
                            <a href="Assistance_Application.aspx">
                                <span class="icon">📄</span><span>Apply</span>
                            </a>
                            <a href="Transactions.aspx" class="active">
                                <span class="icon">💳</span><span>My Transactions</span>
                            </a>
                            <a href="Notifications.aspx">
                                <span class="icon">🔔</span><span>Notifications</span>
                            </a>
                            <a href="Profile.aspx">
                             <span class="icon">👤</span>
                             <span>Profile</span>
                         </a>
                        </asp:Panel>

                        <a href="Logout.aspx">
                            <span class="icon">🚪</span><span>Logout</span>
                        </a>
                    </div>
                </div>
            </asp:Panel>

            <%-- Main content --%>
            <div class="main">

                <asp:Panel ID="pnlTopbar" runat="server">
                    <div class="topbar">
                        <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                        <h3>💳 Transactions</h3>
                        <div></div>
                    </div>
                </asp:Panel>

                <div class="section">
                    <div class="section-title">🔍 Filter Transactions</div>

                    <div class="filters">
                        <div class="filter-box">
                            <h4>Assistance Type</h4>
                            <div class="checkbox-grid">
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkMedical" runat="server" />Medical
                                </label>
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkFinancial" runat="server" />Financial
                                </label>
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkBurial" runat="server" />Burial
                                </label>
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkEducational" runat="server" />Educational
                                </label>
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkFood" runat="server" />Food
                                </label>
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkEmergency" runat="server" />Emergency
                                </label>
                            </div>
                        </div>

                        <div class="filter-box">
                            <h4>Status</h4>
                            <div class="checkbox-grid">
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkPending" runat="server" />Pending
                                </label>
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkApproved" runat="server" />Approved
                                </label>
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkRejected" runat="server" />Rejected
                                </label>
                                <label class="checkbox-item">
                                    <asp:CheckBox ID="chkReleased" runat="server" />Released
                                </label>
                            </div>
                        </div>

                        <div class="filter-box">
                            <h4>Date Range</h4>
                            <div class="date-row">
                                <asp:TextBox ID="txtDateFrom" runat="server" TextMode="Date" />
                                <asp:TextBox ID="txtDateTo"   runat="server" TextMode="Date" />
                            </div>
                        </div>
                    </div>

                    <div class="actions">
                        <asp:Button ID="btnApplyFilter" runat="server"
                            Text="🔍 Apply Filter" CssClass="btn"
                            OnClick="btnApplyFilter_Click" />
                        <asp:Button ID="btnClearFilter" runat="server"
                            Text="✖ Clear Filter" CssClass="btn btn-outline"
                            OnClick="btnClearFilter_Click" />
                        <asp:Button ID="btnMyTransactions" runat="server"
                            Text="👤 My Transactions" CssClass="btn"
                            Visible="false"
                            OnClick="btnMyTransactions_Click" />
                    </div>

                    <div class="grid-container">
                        <asp:GridView ID="gvTransactions" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="gridview"
                            GridLines="None"
                            EmptyDataText="No transactions found."
                            OnRowCommand="gvTransactions_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="application_id"             HeaderText="ID" />
                                <asp:BoundField DataField="full_name"                  HeaderText="Name" />
                                <asp:BoundField DataField="assistance_type"            HeaderText="Type" />
                                <asp:BoundField DataField="estimated_amount_requested" HeaderText="Amount" DataFormatString="{0:₱#,##0.00}" />
                                <asp:BoundField DataField="urgency_level"              HeaderText="Urgency" />
                                <asp:BoundField DataField="date_submitted"             HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:BoundField DataField="status"                     HeaderText="Status" />

                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <asp:Button ID="btnApprove" runat="server"
                                            Text="✔ Approve"
                                            CssClass="btn-approve"
                                            CommandName="ApproveApplication"
                                            CommandArgument='<%# Eval("application_id") %>'
                                            Visible='<%# IsAdmin() && Eval("status").ToString() == "Pending" %>' />
                                        <asp:Button ID="btnReject" runat="server"
                                            Text="✖ Reject"
                                            CssClass="btn-reject"
                                            CommandName="RejectApplication"
                                            CommandArgument='<%# Eval("application_id") %>'
                                            Visible='<%# IsAdmin() && Eval("status").ToString() == "Pending" %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <asp:Label ID="lblMessage" runat="server" CssClass="message" />
                </div>
            </div>
        </div>
    </asp:Panel>


</form>
</body>
</html>