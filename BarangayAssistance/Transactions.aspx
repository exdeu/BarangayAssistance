<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Transactions.aspx.cs" Inherits="BarangayAssistance.Transactions" %>
<%@ Register Src="~/Sidebar.ascx" TagPrefix="uc" TagName="Sidebar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Transactions - AssistSys</title>
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

        .public-nav-links a:hover {
            color: #5dade2;
        }

        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        .main {
            flex: 1;
            padding: 30px;
            overflow-x: auto;
        }

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

        .section {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.07);
            border: 1px solid rgba(52, 152, 219, 0.1);
            margin-top: 20px;
            animation: fadeInUp 0.7s ease-out 0.2s backwards;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
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

        .filters {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .filter-box {
            background: white;
            padding: 22px 20px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border: 1px solid rgba(52, 152, 219, 0.12);
            transition: all 0.3s ease;
        }

        .filter-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 32px rgba(0,0,0,0.09);
            border-color: rgba(52, 152, 219, 0.3);
        }

        .filter-box h4 {
            margin-bottom: 15px;
            color: #5d6d7e;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
        }

        .checkbox-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 8px 16px;
        }

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

        .date-row {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

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

        .btn-approve {
            background: linear-gradient(135deg, #198754, #157347);
            color: white;
            border: none;
            padding: 7px 15px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-right: 5px;
            font-family: inherit;
        }

        .btn-approve:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .btn-reject {
            background: linear-gradient(135deg, #dc3545, #b02a37);
            color: white;
            border: none;
            padding: 7px 15px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .btn-reject:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .message {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #1a364e;
            font-size: 0.9rem;
        }

        @media (max-width: 1100px) {
            .filters {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 900px) {
            .filters {
                grid-template-columns: 1fr;
            }

            .main {
                padding: 15px;
            }

            .navbar {
                flex-direction: column;
                gap: 10px;
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
            document.getElementById("sidebar").classList.toggle("collapsed");
        }
    </script>
</head>

<body>
<form id="form1" runat="server">

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
               <!-- PUBLIC DASHBOARD CARDS -->
<div class="cards" style="display:grid; grid-template-columns:repeat(4,1fr); gap:20px; margin-bottom:25px;">

    <div class="filter-box">
        <h4>Total Public Records</h4>
        <p style="font-size:2rem;font-weight:800;color:#1a364e;">
            <asp:Label ID="lblPublicTotal" runat="server" Text="0" />
        </p>
    </div>

    <div class="filter-box">
        <h4>Approved</h4>
        <p style="font-size:2rem;font-weight:800;color:#1a364e;">
            <asp:Label ID="lblPublicApproved" runat="server" Text="0" />
        </p>
    </div>

    <div class="filter-box">
        <h4>Released</h4>
        <p style="font-size:2rem;font-weight:800;color:#1a364e;">
            <asp:Label ID="lblPublicReleased" runat="server" Text="0" />
        </p>
    </div>

    <div class="filter-box">
        <h4>Total Amount</h4>
        <p style="font-size:2rem;font-weight:800;color:#1a364e;">
            <asp:Label ID="lblPublicAmount" runat="server" Text="₱0.00" />
        </p>
    </div>

</div>

<!-- NEW INSIGHT CARDS -->
<div class="cards" style="display:grid; grid-template-columns:repeat(4,1fr); gap:20px; margin-bottom:25px;">

    <div class="filter-box">
        <h4>Average Assistance</h4>
        <p style="font-size:1.8rem;font-weight:800;color:#2980b9;">
            <asp:Label ID="lblPublicAverage" runat="server" Text="₱0.00" />
        </p>
    </div>

    <div class="filter-box">
        <h4>Highest Assistance</h4>
        <p style="font-size:1.8rem;font-weight:800;color:#27ae60;">
            <asp:Label ID="lblPublicHighest" runat="server" Text="₱0.00" />
        </p>
    </div>

    <div class="filter-box">
        <h4>Medical Cases</h4>
        <p style="font-size:1.8rem;font-weight:800;color:#8e44ad;">
            <asp:Label ID="lblPublicMedical" runat="server" Text="0" />
        </p>
    </div>

    <div class="filter-box">
        <h4>Financial Cases</h4>
        <p style="font-size:1.8rem;font-weight:800;color:#e67e22;">
            <asp:Label ID="lblPublicFinancial" runat="server" Text="0" />
        </p>
    </div>

</div>

<!-- THIRD ROW -->
<div class="cards" style="display:grid; grid-template-columns:repeat(2,1fr); gap:20px; margin-bottom:25px;">

    <div class="filter-box">
        <h4>Last 7 Days Transactions</h4>
        <p style="font-size:1.8rem;font-weight:800;color:#c0392b;">
            <asp:Label ID="lblPublicRecent" runat="server" Text="0" />
        </p>
    </div>

    <div class="filter-box">
        <h4>Approval Rate</h4>
        <p style="font-size:1.8rem;font-weight:800;color:#16a085;">
            <asp:Label ID="lblPublicApprovalRate" runat="server" Text="0%" />
        </p>
    </div>

</div>
                <div class="filters">
                    <div class="filter-box">
                        <h4>Assistance Type</h4>
                        <div class="checkbox-grid">
                            <label class="checkbox-item"><asp:CheckBox ID="pubChkMedical" runat="server" />Medical</label>
                            <label class="checkbox-item"><asp:CheckBox ID="pubChkFinancial" runat="server" />Financial</label>
                            <label class="checkbox-item"><asp:CheckBox ID="pubChkBurial" runat="server" />Burial</label>
                            <label class="checkbox-item"><asp:CheckBox ID="pubChkEducational" runat="server" />Educational</label>
                            <label class="checkbox-item"><asp:CheckBox ID="pubChkFood" runat="server" />Food</label>
                            <label class="checkbox-item"><asp:CheckBox ID="pubChkEmergency" runat="server" />Emergency</label>
                        </div>
                    </div>

                    <div class="filter-box">
                        <h4>Status</h4>
                        <div class="checkbox-grid">
                            <label class="checkbox-item"><asp:CheckBox ID="pubChkApproved" runat="server" />Approved</label>
                            <label class="checkbox-item"><asp:CheckBox ID="pubChkReleased" runat="server" />Released</label>
                        </div>
                    </div>

                    <div class="filter-box">
                        <h4>Date Range</h4>
                        <div class="date-row">
                            <asp:TextBox ID="pubDateFrom" runat="server" TextMode="Date" />
                            <asp:TextBox ID="pubDateTo" runat="server" TextMode="Date" />
                        </div>
                    </div>
                </div>

                <div class="actions">
                    <asp:Button ID="btnPublicApplyFilter" runat="server"
                        Text="🔍 Apply Filter"
                        CssClass="btn"
                        OnClick="btnPublicApplyFilter_Click" />

                    <asp:Button ID="btnPublicClearFilter" runat="server"
                        Text="✖ Clear Filter"
                        CssClass="btn btn-outline"
                        OnClick="btnPublicClearFilter_Click" />
                </div>
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

    <asp:Panel ID="pnlDashboardLayout" runat="server">
        <div class="wrapper">

            <uc:Sidebar ID="Sidebar" runat="server" />

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
                                <asp:TextBox ID="txtDateTo" runat="server" TextMode="Date" />
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
                                <asp:BoundField DataField="application_id" HeaderText="ID" />
                                <asp:BoundField DataField="full_name" HeaderText="Name" />
                                <asp:BoundField DataField="assistance_type" HeaderText="Type" />
                                <asp:BoundField DataField="estimated_amount_requested" HeaderText="Amount" DataFormatString="{0:₱#,##0.00}" />
                                <asp:BoundField DataField="urgency_level" HeaderText="Urgency" />
                                <asp:BoundField DataField="date_submitted" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:BoundField DataField="status" HeaderText="Status" />

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