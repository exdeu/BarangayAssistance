<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="BarangayAssistance.Dashboard" %>
<%@ Register Src="~/InactivityTimeout.ascx" TagPrefix="uc" TagName="InactivityTimeout" %>
<%@ Register Src="~/Sidebar.ascx"
    TagPrefix="uc"
    TagName="Sidebar" %>
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
        <uc:Sidebar ID="Sidebar" runat="server" />
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
                    <p><asp:Label ID="lblTotalApps" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Pending</h4>
                    <p><asp:Label ID="lblPending" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Approved</h4>
                    <p><asp:Label ID="lblApproved" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Total Released</h4>
                    <p><asp:Label ID="lblFunds" runat="server" /></p>
                </div>

                <!-- NEW CARDS -->
                <div class="card">
                    <h4>This Month</h4>
                    <p><asp:Label ID="lblThisMonth" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Rejected</h4>
                    <p><asp:Label ID="lblRejected" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>High Priority</h4>
                    <p><asp:Label ID="lblUrgent" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Top Assistance</h4>
                    <p><asp:Label ID="lblTopType" runat="server" /></p>
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
                    <p><asp:Label ID="lblUserApps" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Pending</h4>
                    <p><asp:Label ID="lblUserPending" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Approved</h4>
                    <p><asp:Label ID="lblUserApproved" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Total Received</h4>
                    <p><asp:Label ID="lblUserFunds" runat="server" /></p>
                </div>

                <!-- NEW CARDS -->
                <div class="card">
                    <h4>Rejected</h4>
                    <p><asp:Label ID="lblUserRejected" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Latest Status</h4>
                    <p><asp:Label ID="lblLatestStatus" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Last Applied</h4>
                    <p><asp:Label ID="lblLastApplied" runat="server" /></p>
                </div>
                <div class="card">
                    <h4>Most Requested</h4>
                    <p><asp:Label ID="lblUserTopType" runat="server" /></p>
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
                <!-- ADD THIS RIGHT BEFORE </div> OF .main -->

                <div style="margin-top:30px; text-align:center;">
    
                    <a href="Feedback.aspx"
                       style="
                        display:inline-block;
                        background:linear-gradient(135deg,#1a364e,#2980b9);
                        color:white;
                        text-decoration:none;
                        padding:14px 32px;
                        border-radius:50px;
                        font-size:1rem;
                        font-weight:700;
                        box-shadow:0 8px 24px rgba(26,54,78,0.25);
                        transition:all 0.3s ease;
                       "
                       onmouseover="this.style.transform='translateY(-3px)';this.style.boxShadow='0 12px 30px rgba(26,54,78,0.35)'"
                       onmouseout="this.style.transform='translateY(0px)';this.style.boxShadow='0 8px 24px rgba(26,54,78,0.25)'">

                        💬 Send Feedback / Complaints

                    </a>

                </div>
            </asp:Panel>

        </div>
    </div>
    <uc:InactivityTimeout ID="InactivityTimeout1" runat="server" />
</form>
</body>
</html>