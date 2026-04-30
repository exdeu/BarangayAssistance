<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="BarangayAssistance.Notifications" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Notifications - AssistSys</title>
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
        .main { flex: 1; padding: 30px; overflow-y: auto; }

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
            animation: fadeInUp 0.7s ease-out;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 3px solid transparent;
            border-image: linear-gradient(90deg, #3498db, #5dade2) 1;
        }

        .section-header h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a364e;
        }

        .section-header p {
            font-size: 0.85rem;
            color: #5d6d7e;
            margin-top: 4px;
        }

        /* Mark all button */
        .btn-mark-all {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            font-family: inherit;
            white-space: nowrap;
        }

        .btn-mark-all:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.2);
        }

        /* Notification cards */
        .notification-list { margin-top: 5px; }

        .notification-card {
            background: linear-gradient(135deg, #f5f7fa, #e9edf2);
            border-left: 5px solid #95a5a6;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .notification-card::before {
            content: '🔔';
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 3rem;
            opacity: 0.06;
        }

        .notification-card.unread {
            background: linear-gradient(135deg, #eef4fb, #dbeafe);
            border-left-color: #3498db;
            box-shadow: 0 5px 15px rgba(52,152,219,0.15);
        }

        .notification-card:hover {
            transform: translateX(5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .notif-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 8px;
            flex-wrap: wrap;
        }

        .notif-header h4 {
            color: #1a364e;
            font-size: 1rem;
            font-weight: 700;
            margin: 0;
        }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 50px;
            font-size: 0.72rem;
            font-weight: 700;
        }

        .badge-unread {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }

        .badge-read {
            background: #e9ecef;
            color: #6c757d;
        }

        .notif-message {
            color: #5d6d7e;
            font-size: 0.9rem;
            line-height: 1.6;
            margin-bottom: 10px;
        }

        .notif-meta {
            font-size: 0.78rem;
            color: #95a5a6;
            margin-bottom: 12px;
        }

        .notif-meta span { margin-right: 15px; }

        /* Mark read button */
        .btn-read {
            background: white;
            color: #1a364e;
            border: 2px solid #1a364e;
            padding: 6px 16px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .btn-read:hover {
            background: #1a364e;
            color: white;
            transform: translateY(-1px);
        }

        /* Empty state */
        .empty-box {
            background: linear-gradient(135deg, #f5f7fa, #e9edf2);
            border: 2px dashed rgba(52,152,219,0.3);
            padding: 50px 25px;
            border-radius: 20px;
            text-align: center;
            color: #5d6d7e;
            margin-top: 15px;
        }

        .empty-box .empty-icon {
            font-size: 4rem;
            margin-bottom: 15px;
            opacity: 0.4;
        }

        .empty-box p {
            font-size: 1rem;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .main { padding: 15px; }
            .section-header { flex-direction: column; align-items: flex-start; gap: 10px; }
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

    <div class="wrapper">

        <!-- Sidebar -->
        <div class="sidebar collapsed" id="sidebar">
            <div class="logo">🏥 <span>AssistSys</span></div>
            <div class="nav-links">

                <asp:Panel ID="navAdmin" runat="server">
                    
                    <a href="Dashboard.aspx">
                        <span class="icon">📊</span>
                        <span>Dashboard</span>
                    </a>
                    <a href="Transactions.aspx">
                        <span class="icon">💳</span>
                        <span>Transactions</span>
                    </a>
                    <a href="Notifications.aspx">
                        <span class="icon">🔔</span>
                        <span>Notifications</span>
                    </a>
                </asp:Panel>

                <asp:Panel ID="navUser" runat="server" Visible="false">
                   
                    <a href="Dashboard.aspx">
                        <span class="icon">📊</span><span>Dashboard</span>
                    </a>
                    <a href="Assistance_Application.aspx">
                        <span class="icon">📄</span><span>Apply</span>
                    </a>
                    <a href="Transactions.aspx">
                        <span class="icon">💳</span><span>My Transactions</span>
                    </a>
                    <a href="Notifications.aspx" class="active">
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

        <!-- Main Content -->
        <div class="main">

            <div class="topbar">
                <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                <h3>🔔 Notifications</h3>
                <asp:Label ID="lblWelcome" runat="server"></asp:Label>
            </div>

            <%-- Admin Notifications --%>
            <asp:Panel ID="pnlAdminNotifications" runat="server" Visible="false">
                <div class="section">
                    <div class="section-header">
                        <div>
                            <h3>🔔 Admin Notifications</h3>
                            <p>System alerts, new applications, and beneficiary updates.</p>
                        </div>
                        <asp:Button ID="btnAdminMarkAllRead" runat="server"
                            Text="✔ Mark All as Read"
                            CssClass="btn-mark-all"
                            OnClick="btnAdminMarkAllRead_Click" />
                    </div>

                    <div class="notification-list">
                        <asp:Repeater ID="rptAdminNotifications" runat="server">
                            <ItemTemplate>
                                <div class='<%# Convert.ToBoolean(Eval("is_read")) ? "notification-card" : "notification-card unread" %>'>
                                    <div class="notif-header">
                                        <h4><%# Eval("title") %></h4>
                                        <span class='<%# Convert.ToBoolean(Eval("is_read")) ? "badge badge-read" : "badge badge-unread" %>'>
                                            <%# Convert.ToBoolean(Eval("is_read")) ? "Read" : "Unread" %>
                                        </span>
                                    </div>
                                    <div class="notif-message"><%# Eval("message") %></div>
                                    <div class="notif-meta">
                                        <span>📌 <%# Eval("type") %></span>
                                        <span>🕐 <%# Eval("date_created", "{0:MMM dd, yyyy hh:mm tt}") %></span>
                                    </div>
                                    <asp:Button ID="btnAdminMarkRead" runat="server"
                                        Text="✔ Mark as Read"
                                        CssClass="btn-read"
                                        CommandArgument='<%# Eval("notification_id") %>'
                                        Visible='<%# !Convert.ToBoolean(Eval("is_read")) %>'
                                        OnClick="btnAdminMarkRead_Click" />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlNoAdminNotifications" runat="server" Visible="false">
                            <div class="empty-box">
                                <div class="empty-icon">🔔</div>
                                <p>No admin notifications found.</p>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </asp:Panel>

            <%-- Beneficiary Notifications --%>
            <asp:Panel ID="pnlBeneficiaryNotifications" runat="server" Visible="false">
                <div class="section">
                    <div class="section-header">
                        <div>
                            <h3>🔔 My Notifications</h3>
                            <p>Updates about your assistance applications.</p>
                        </div>
                        <asp:Button ID="btnUserMarkAllRead" runat="server"
                            Text="✔ Mark All as Read"
                            CssClass="btn-mark-all"
                            OnClick="btnUserMarkAllRead_Click" />
                    </div>

                    <div class="notification-list">
                        <asp:Repeater ID="rptUserNotifications" runat="server">
                            <ItemTemplate>
                                <div class='<%# Convert.ToBoolean(Eval("is_read")) ? "notification-card" : "notification-card unread" %>'>
                                    <div class="notif-header">
                                        <h4><%# Eval("title") %></h4>
                                        <span class='<%# Convert.ToBoolean(Eval("is_read")) ? "badge badge-read" : "badge badge-unread" %>'>
                                            <%# Convert.ToBoolean(Eval("is_read")) ? "Read" : "Unread" %>
                                        </span>
                                    </div>
                                    <div class="notif-message"><%# Eval("message") %></div>
                                    <div class="notif-meta">
                                        <span>📌 <%# Eval("type") %></span>
                                        <span>🕐 <%# Eval("date_created", "{0:MMM dd, yyyy hh:mm tt}") %></span>
                                    </div>
                                    <asp:Button ID="btnUserMarkRead" runat="server"
                                        Text="✔ Mark as Read"
                                        CssClass="btn-read"
                                        CommandArgument='<%# Eval("notification_id") %>'
                                        Visible='<%# !Convert.ToBoolean(Eval("is_read")) %>'
                                        OnClick="btnUserMarkRead_Click" />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlNoUserNotifications" runat="server" Visible="false">
                            <div class="empty-box">
                                <div class="empty-icon">🔔</div>
                                <p>No notifications yet. We'll notify you when your application is updated.</p>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </asp:Panel>

        </div>
    </div>

</form>
</body>
</html>