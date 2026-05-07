<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Sidebar.ascx.cs" Inherits="BarangayAssistance.Sidebar" %>

<style>
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
.sidebar.collapsed .nav-links a span:not(.icon):not(.notif-badge) {
    display: none;
}

 .sidebar.collapsed .nav-links a {
     justify-content: center;
     padding: 14px;
 }
.notif-link {
    position: relative;
}

.notif-badge {
    background: #dc3545;
    color: white;
    padding: 2px 7px;
    border-radius: 50px;
    font-size: 11px;
    font-weight: bold;
    margin-left: auto;
    min-width: 18px;
    height: 18px;
    line-height: 14px;
    text-align: center;
}
.sidebar.collapsed .notif-link {
    position: relative;
}

.sidebar.collapsed .notif-badge {
    position: absolute;
    top: 8px;
    right: 6px;
    margin-left: 0;
    padding: 1px 5px;
    min-width: 16px;
    height: 16px;
    font-size: 10px;
    line-height: 14px;
}
</style>
<div class="sidebar collapsed" id="sidebar">

    <div class="logo">
        🏥 <span>AssistSys</span>
    </div>

    <div class="nav-links">

        <asp:Panel ID="navAdmin" runat="server" Visible="false">

           
            <div class="nav-links">
                <a href="Dashboard.aspx">
                    <span class="icon">📊</span>
                    <span>Dashboard</span>
                </a>

                <a href="BeneficiaryApplications.aspx">
                    <span class="icon">👥</span>
                    <span>Beneficiaries</span>
                </a>

                <a href="Transactions.aspx">
                    <span class="icon">💳</span>
                    <span>Transactions</span>
                </a>

                 <a href="Notifications.aspx" class="notif-link">
                    <span class="icon">🔔</span>
                    <span>Notifications</span>
                    <asp:Label ID="admin_notif"
                        runat="server"
                        Visible="false"
                        CssClass="notif-badge">
                    </asp:Label>
                </a>
                <a href="Feedback.aspx">
                    <span class="icon">💬</span>
                    <span>Feedback & Complaints</span>
                </a>
            </div>

        </asp:Panel>

        <asp:Panel ID="navBeneficiary" runat="server" Visible="false">
          <div class="nav-links">
            <a href="Dashboard.aspx">
                <span class="icon">📊</span>
                <span>Dashboard</span>
            </a>
              <a href="Profile.aspx">
                  <span class="icon">👤</span>
                  <span>Profile</span>
              </a>
            <a href="Assistance_Application.aspx">
                <span class="icon">📄</span>
                <span>Apply</span>
            </a>

            <a href="Transactions.aspx">
                <span class="icon">💳</span>
                <span>My Transactions</span>
            </a>

            <a href="Notifications.aspx" class="notif-link">
                <span class="icon">🔔</span>
                <span>Notifications</span>

                <asp:Label ID="bene_notif"
                    runat="server"
                    Visible="false"
                    CssClass="notif-badge">
                </asp:Label>
            </a>
              </div>
        </asp:Panel>

        <a href="Logout.aspx">
            <span class="icon">🚪</span>
            <span>Logout</span>
        </a>

    </div>
</div>