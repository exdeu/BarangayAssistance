<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="BarangayAssistance.Notifications" %>
<%@ Register Src="~/Sidebar.ascx"
    TagPrefix="uc"
    TagName="Sidebar" %>
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

        /* Header action buttons group */
        .header-actions {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

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

        .btn-delete-all {
            background: linear-gradient(135deg, #c0392b, #e74c3c);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(231,76,60,0.3);
            font-family: inherit;
            white-space: nowrap;
        }

        .btn-delete-all:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(231,76,60,0.4);
        }

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
            flex: 1;
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

        /* Action buttons row per card */
        .notif-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

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

        .btn-delete {
            background: white;
            color: #e74c3c;
            border: 2px solid #e74c3c;
            padding: 6px 16px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .btn-delete:hover {
            background: #e74c3c;
            color: white;
            transform: translateY(-1px);
        }

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

        /* ── Custom Modal ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            backdrop-filter: blur(4px);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.show { display: flex; }

        .modal-box {
            background: white;
            border-radius: 20px;
            padding: 35px 30px 28px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.2);
            text-align: center;
            animation: modalPop 0.3s ease-out;
        }

        @keyframes modalPop {
            from { opacity: 0; transform: scale(0.85); }
            to   { opacity: 1; transform: scale(1); }
        }

        .modal-icon { font-size: 3rem; margin-bottom: 15px; }

        .modal-box h4 {
            font-size: 1.2rem;
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 8px;
        }

        .modal-box p {
            font-size: 0.9rem;
            color: #5d6d7e;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .modal-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .modal-btn-cancel {
            background: #f0f3f6;
            color: #5d6d7e;
            border: none;
            padding: 10px 26px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            font-family: inherit;
            transition: all 0.2s ease;
        }

        .modal-btn-cancel:hover { background: #e2e8ed; }

        .modal-btn-confirm {
            background: linear-gradient(135deg, #c0392b, #e74c3c);
            color: white;
            border: none;
            padding: 10px 26px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 600;
            font-family: inherit;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(231,76,60,0.3);
        }

        .modal-btn-confirm:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(231,76,60,0.4);
        }

        @media (max-width: 768px) {
            .main { padding: 15px; }
            .section-header { flex-direction: column; align-items: flex-start; gap: 10px; }
            .header-actions { width: 100%; }
        }
    </style>

    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("collapsed");
        }

        var _pendingBtn = null;

        function showDeleteModal(btn, isAll) {
            _pendingBtn = btn;
            var title = document.getElementById("modalTitle");
            var msg = document.getElementById("modalMessage");
            if (isAll) {
                title.innerText = "Delete All Notifications";
                msg.innerText = "Are you sure you want to delete all notifications? This action cannot be undone.";
            } else {
                title.innerText = "Delete Notification";
                msg.innerText = "Are you sure you want to delete this notification?";
            }
            document.getElementById("deleteModal").classList.add("show");
            return false;
        }

        function closeModal() {
            document.getElementById("deleteModal").classList.remove("show");
            _pendingBtn = null;
        }

        function confirmDelete() {
            document.getElementById("deleteModal").classList.remove("show");
            if (_pendingBtn) {
                _pendingBtn.click();
                _pendingBtn = null;
            }
        }
    </script>
</head>

<body>
<form id="form1" runat="server">

    <!-- Custom Delete Confirmation Modal -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-box">
            <div class="modal-icon">🗑️</div>
            <h4 id="modalTitle">Delete Notification</h4>
            <p id="modalMessage">Are you sure you want to delete this notification?</p>
            <div class="modal-actions">
                <button type="button" class="modal-btn-cancel" onclick="closeModal()">Cancel</button>
                <button type="button" class="modal-btn-confirm" onclick="confirmDelete()">Yes, Delete</button>
            </div>
        </div>
    </div>

    <div class="wrapper">

        <uc:Sidebar ID="Sidebar" runat="server" />

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
                        <div class="header-actions">
                            <asp:Button ID="btnAdminMarkAllRead" runat="server"
                                Text="✔ Mark All as Read"
                                CssClass="btn-mark-all"
                                OnClick="btnAdminMarkAllRead_Click" />

                            <asp:Button ID="btnAdminDeleteAllReal" runat="server"
                                Text="🗑 Delete All"
                                CssClass="btn-delete-all"
                                OnClick="btnAdminDeleteAll_Click"
                                Style="display:none;" />
                            <button type="button" class="btn-delete-all"
                                onclick="showDeleteModal(document.getElementById('<%= btnAdminDeleteAllReal.ClientID %>'), true);">
                                🗑 Delete All
                            </button>
                        </div>
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
                                    <div class="notif-actions">
                                        <asp:Button ID="btnAdminMarkRead" runat="server"
                                            Text="✔ Mark as Read"
                                            CssClass="btn-read"
                                            CommandArgument='<%# Eval("notification_id") %>'
                                            Visible='<%# !Convert.ToBoolean(Eval("is_read")) %>'
                                            OnClick="btnAdminMarkRead_Click" />

                                        <asp:Button ID="btnAdminDeleteOne" runat="server"
                                            Text="🗑 Delete"
                                            CssClass="btn-delete"
                                            CommandArgument='<%# Eval("notification_id") %>'
                                            OnClick="btnAdminDeleteOne_Click"
                                            Style="display:none;" />
                                        <button type="button" class="btn-delete"
                                            onclick="showDeleteModal(this.previousElementSibling, false); return false;">
                                            🗑 Delete
                                        </button>
                                    </div>
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
                        <div class="header-actions">
                            <asp:Button ID="btnUserMarkAllRead" runat="server"
                                Text="✔ Mark All as Read"
                                CssClass="btn-mark-all"
                                OnClick="btnUserMarkAllRead_Click" />

                            <asp:Button ID="btnUserDeleteAllReal" runat="server"
                                Text="🗑 Delete All"
                                CssClass="btn-delete-all"
                                OnClick="btnUserDeleteAll_Click"
                                Style="display:none;" />
                            <button type="button" class="btn-delete-all"
                                onclick="showDeleteModal(document.getElementById('<%= btnUserDeleteAllReal.ClientID %>'), true);">
                                🗑 Delete All
                            </button>
                        </div>
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
                                    <div class="notif-actions">
                                        <asp:Button ID="btnUserMarkRead" runat="server"
                                            Text="✔ Mark as Read"
                                            CssClass="btn-read"
                                            CommandArgument='<%# Eval("notification_id") %>'
                                            Visible='<%# !Convert.ToBoolean(Eval("is_read")) %>'
                                            OnClick="btnUserMarkRead_Click" />

                                        <asp:Button ID="btnUserDeleteOne" runat="server"
                                            Text="🗑 Delete"
                                            CssClass="btn-delete"
                                            CommandArgument='<%# Eval("notification_id") %>'
                                            OnClick="btnUserDeleteOne_Click"
                                            Style="display:none;" />
                                        <button type="button" class="btn-delete"
                                            onclick="showDeleteModal(this.previousElementSibling, false); return false;">
                                            🗑 Delete
                                        </button>
                                    </div>
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