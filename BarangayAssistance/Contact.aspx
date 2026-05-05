<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="BarangayAssistance.Contact" %>
<%@ Register Src="~/Sidebar.ascx" TagPrefix="uc" TagName="Sidebar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Contact Us - AssistSys</title>
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

        html { scroll-behavior: smooth; }

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

        .public-nav-links a:hover { color: #5dade2; }

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
            text-align: center;
        }

        .filter-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 32px rgba(0,0,0,0.09);
            border-color: rgba(52, 152, 219, 0.3);
        }

        .filter-box h4 {
            margin-bottom: 10px;
            color: #5d6d7e;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
        }

        .filter-box .icon {
            font-size: 2rem;
            margin-bottom: 12px;
            display: block;
        }

        .filter-box .card-value {
            font-size: 1rem;
            font-weight: 600;
            color: #1a364e;
        }

        .filter-box .card-sub {
            font-size: 0.85rem;
            color: #5d6d7e;
            margin-top: 4px;
        }

        @media (max-width: 1100px) {
            .filters { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 900px) {
            .filters { grid-template-columns: 1fr; }
            .main { padding: 15px; }
            .navbar { flex-direction: column; gap: 10px; }
            .topbar { flex-direction: column; align-items: flex-start; gap: 10px; }
            .topbar h3 { font-size: 1rem; }
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

    <!-- Public Navbar (not logged in) -->
    <asp:Panel ID="pnlPublicNav" runat="server" Visible="false">
        <div class="navbar">
            <div class="public-logo">🏥 AssistSys</div>
            <div class="public-nav-links">
                <a href="index.aspx">Home</a>
                <a href="Login.aspx">Login</a>
                <a href="Register.aspx">Register</a>
                <a href="Transactions.aspx">Transactions</a>
                <a href="Contact.aspx">Contact Us</a>
            </div>
        </div>
    </asp:Panel>

    <!-- Public Contact (not logged in) -->
    <asp:Panel ID="pnlPublicContact" runat="server" Visible="false">
        <div class="main" style="padding:40px 5%;">
            <div class="section">
                <div class="section-title">📬 Contact Information</div>
                <div class="filters">
                    <div class="filter-box">
                        <span class="icon">📍</span>
                        <h4>Address</h4>
                        <div class="card-value">Canbanua Barangay Hall, Main Street</div>
                        <div class="card-sub">Cebu City, Philippines</div>
                    </div>
                    <div class="filter-box">
                        <span class="icon">📞</span>
                        <h4>Phone</h4>
                        <div class="card-value">099299287815</div>
                        <div class="card-sub">Mon–Fri, 8AM – 5PM</div>
                    </div>
                    <div class="filter-box">
                        <span class="icon">📧</span>
                        <h4>Email</h4>
                        <div class="card-value">barangay@assistsys.gov</div>
                        <div class="card-sub">We reply within 1–2 business days</div>
                    </div>
                    <div class="filter-box">
                        <span class="icon">🕐</span>
                        <h4>Office Hours</h4>
                        <div class="card-value">Mon–Fri, 8AM – 5PM</div>
                        <div class="card-sub">Closed on weekends & holidays</div>
                    </div>
                    <div class="filter-box">
                        <span class="icon">🚨</span>
                        <h4>Emergency Hotline</h4>
                        <div class="card-value">099299287815</div>
                        <div class="card-sub">Available 24/7</div>
                    </div>
                    <div class="filter-box">
                        <span class="icon">📘</span>
                        <h4>Facebook Page</h4>
                        <div class="card-value">fb.com/BarangayAssistSys</div>
                        <div class="card-sub">Message us anytime</div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <!-- Dashboard Layout (logged in) -->
    <asp:Panel ID="pnlDashboardLayout" runat="server">
        <div class="wrapper">

            <uc:Sidebar ID="Sidebar" runat="server" />

            <div class="main">

                <div class="topbar">
                    <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                    <h3>📬 Contact Us</h3>
                    <div></div>
                </div>

                <div class="section">
                    <div class="section-title">📬 Contact Information</div>
                    <div class="filters">
                        <div class="filter-box">
                            <span class="icon">📍</span>
                            <h4>Address</h4>
                            <div class="card-value">Canbanua Barangay Hall, Main Street</div>
                            <div class="card-sub">Cebu City, Philippines</div>
                        </div>
                        <div class="filter-box">
                            <span class="icon">📞</span>
                            <h4>Phone</h4>
                            <div class="card-value">(032) 123-4567</div>
                            <div class="card-sub">Mon–Fri, 8AM – 5PM</div>
                        </div>
                        <div class="filter-box">
                            <span class="icon">📧</span>
                            <h4>Email</h4>
                            <div class="card-value">barangay@assistsys.gov</div>
                            <div class="card-sub">We reply within 1–2 business days</div>
                        </div>
                        <div class="filter-box">
                            <span class="icon">🕐</span>
                            <h4>Office Hours</h4>
                            <div class="card-value">Mon–Fri, 8AM – 5PM</div>
                            <div class="card-sub">Closed on weekends & holidays</div>
                        </div>
                        <div class="filter-box">
                            <span class="icon">🚨</span>
                            <h4>Emergency Hotline</h4>
                            <div class="card-value">(032) 911-0000</div>
                            <div class="card-sub">Available 24/7</div>
                        </div>
                        <div class="filter-box">
                            <span class="icon">📘</span>
                            <h4>Facebook Page</h4>
                            <div class="card-value">fb.com/BarangayAssistSys</div>
                            <div class="card-sub">Message us anytime</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>

</form>
</body>
</html>