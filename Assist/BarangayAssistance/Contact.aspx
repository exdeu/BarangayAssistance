<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="BarangayAssistance.Contact" %>
<%@ Register Src="~/Sidebar.ascx" TagPrefix="uc" TagName="Sidebar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Contact Us - AssistSys</title>
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

        .wrapper { display: flex; min-height: 100vh; }

        .main { flex: 1; padding: 30px; overflow-x: auto; }

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

        /* ── About Us Banner ── */
        .about-banner {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            border-radius: 20px;
            padding: 40px 35px;
            color: white;
            display: flex;
            align-items: center;
            gap: 30px;
            margin-top: 20px;
            box-shadow: 0 10px 30px rgba(26,54,78,0.3);
            animation: fadeInUp 0.7s ease-out;
            position: relative;
            overflow: hidden;
        }

        .about-banner::after {
            content: '🏥';
            position: absolute;
            right: 35px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 7rem;
            opacity: 0.07;
        }

        .about-banner-icon {
            width: 75px;
            height: 75px;
            background: rgba(255,255,255,0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            flex-shrink: 0;
            border: 3px solid rgba(255,255,255,0.25);
        }

        .about-banner-text h2 {
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .about-banner-text p {
            opacity: 0.88;
            font-size: 0.95rem;
            line-height: 1.7;
            max-width: 650px;
        }

        /* ── Feature Cards ── */
        .about-features {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-top: 5px;
        }

        .about-feature-card {
            background: linear-gradient(135deg, #f5f7fa, #e9edf2);
            border: 1px solid rgba(52,152,219,0.12);
            border-radius: 16px;
            padding: 22px 18px;
            text-align: center;
            transition: all 0.3s ease;
        }

        .about-feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            border-color: rgba(52,152,219,0.3);
        }

        .about-feature-card .feat-icon {
            font-size: 2rem;
            margin-bottom: 12px;
            display: block;
        }

        .about-feature-card h4 {
            font-size: 0.88rem;
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .about-feature-card p {
            font-size: 0.83rem;
            color: #5d6d7e;
            line-height: 1.5;
        }

        /* ── Mission / Vision ── */
        .mv-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-top: 5px;
        }

        .mv-card {
            border-radius: 16px;
            padding: 25px 22px;
            border: 1px solid rgba(52,152,219,0.12);
            transition: all 0.3s ease;
        }

        .mv-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .mv-card.mission {
            background: linear-gradient(135deg, #eef4fb, #dbeafe);
            border-color: rgba(52,152,219,0.2);
        }

        .mv-card.vision {
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            border-color: rgba(46,204,113,0.2);
        }

        .mv-card .mv-icon { font-size: 2rem; margin-bottom: 12px; display: block; }

        .mv-card h4 {
            font-size: 1rem;
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .mv-card p {
            font-size: 0.9rem;
            color: #4a5568;
            line-height: 1.7;
        }

        /* ── Contact Cards ── */
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

        /* ── FAQ ── */
        .faq-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .faq-tab {
            padding: 9px 20px;
            border-radius: 50px;
            border: 2px solid #e1e8ed;
            background: white;
            color: #5d6d7e;
            font-size: 0.88rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.25s ease;
            font-family: inherit;
        }

        .faq-tab:hover { border-color: #3498db; color: #3498db; }

        .faq-tab.active {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(26,54,78,0.25);
        }

        .faq-group { display: none; }
        .faq-group.active { display: block; }

        .faq-item {
            border: 1px solid #e8eef3;
            border-radius: 14px;
            margin-bottom: 12px;
            overflow: hidden;
            transition: box-shadow 0.3s ease;
        }

        .faq-item:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.07); }

        .faq-question {
            width: 100%;
            background: #f8fafc;
            border: none;
            padding: 16px 20px;
            text-align: left;
            font-size: 0.97rem;
            font-weight: 600;
            color: #1a364e;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background 0.2s ease;
            font-family: inherit;
        }

        .faq-question:hover { background: #eef4fb; }
        .faq-question.open { background: linear-gradient(135deg, #1a364e, #2471a3); color: white; }

        .faq-arrow {
            font-size: 0.8rem;
            transition: transform 0.3s ease;
            flex-shrink: 0;
            margin-left: 12px;
        }

        .faq-question.open .faq-arrow { transform: rotate(180deg); }

        .faq-answer {
            display: none;
            padding: 16px 20px;
            font-size: 0.92rem;
            color: #4a5568;
            line-height: 1.75;
            background: white;
            border-top: 1px solid #e8eef3;
        }

        .faq-answer ul { margin: 8px 0 0 18px; }
        .faq-answer ul li { margin-bottom: 5px; }
        .faq-answer a { color: #3498db; text-decoration: none; font-weight: 600; }
        .faq-answer a:hover { text-decoration: underline; }

        /* ── Responsive ── */
        @media (max-width: 1100px) {
            .filters { grid-template-columns: repeat(2, 1fr); }
            .about-features { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 900px) {
            .filters { grid-template-columns: 1fr; }
            .about-features { grid-template-columns: 1fr; }
            .mv-grid { grid-template-columns: 1fr; }
            .main { padding: 15px; }
            .navbar { flex-direction: column; gap: 10px; }
            .topbar { flex-direction: column; align-items: flex-start; gap: 10px; }
            .topbar h3 { font-size: 1rem; }
            .about-banner { flex-direction: column; text-align: center; }
        }
    </style>

    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("collapsed");
        }

        function switchTab(tabId) {
            document.querySelectorAll('.faq-tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.faq-group').forEach(g => g.classList.remove('active'));
            document.querySelector('[data-tab="' + tabId + '"]').classList.add('active');
            document.getElementById(tabId).classList.add('active');
        }

        function toggleFaq(btn) {
            var answer = btn.nextElementSibling;
            var isOpen = btn.classList.contains('open');
            btn.closest('.faq-group').querySelectorAll('.faq-question').forEach(function (q) {
                q.classList.remove('open');
                q.nextElementSibling.style.display = 'none';
            });
            if (!isOpen) {
                btn.classList.add('open');
                answer.style.display = 'block';
            }
        }
    </script>
</head>

<body>
<form id="form1" runat="server">

    <!-- ═══════════════════════════════════════════
         PUBLIC (not logged in)
    ════════════════════════════════════════════ -->
    <asp:Panel ID="pnlPublicNav" runat="server" Visible="false">
        <div class="navbar">
            <div class="public-logo">🏥 AssistSys</div>
            <div class="public-nav-links">
                <a href="index.aspx">Home</a>
                <a href="Login.aspx">Login</a>
                <a href="Register.aspx">Register</a>
                <a href="Transactions.aspx">Transactions</a>
                <a href="Contact.aspx">About Us</a>
                <a href="Feedback.aspx">Feedback</a>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlPublicContact" runat="server" Visible="false">
        <div class="main" style="padding:40px 5%;">

            <!-- About Us Banner -->
            <div class="about-banner">
                <div class="about-banner-icon">🏥</div>
                <div class="about-banner-text">
                    <h2>About AssistSys</h2>
                    <p>The Barangay Assistance System is a digital platform that helps barangay officials manage assistance programs efficiently. It simplifies application processing, record management, and communication between the barangay office and residents.</p>
                </div>
            </div>

            <!-- What the system does -->
            <div class="section">
                <div class="section-title">⚙️ What AssistSys Does</div>
                <div class="about-features">
                    <div class="about-feature-card">
                        <span class="feat-icon">📋</span>
                        <h4>Application Processing</h4>
                        <p>Simplifies how residents apply for barangay assistance programs online — anytime, anywhere.</p>
                    </div>
                    <div class="about-feature-card">
                        <span class="feat-icon">🗂️</span>
                        <h4>Record Management</h4>
                        <p>Organizes and maintains accurate beneficiary records for the barangay office in one secure place.</p>
                    </div>
                    <div class="about-feature-card">
                        <span class="feat-icon">🔔</span>
                        <h4>Real-Time Updates</h4>
                        <p>Keeps residents informed about their application status through instant notifications.</p>
                    </div>
                    <div class="about-feature-card">
                        <span class="feat-icon">🤝</span>
                        <h4>Better Communication</h4>
                        <p>Bridges the gap between barangay officials and residents for faster, more organized public service.</p>
                    </div>
                </div>
            </div>

            <!-- Mission & Vision -->
            <div class="section">
                <div class="section-title">🎯 Mission &amp; Vision</div>
                <div class="mv-grid">
                    <div class="mv-card mission">
                        <span class="mv-icon">🎯</span>
                        <h4>Our Mission</h4>
                        <p>To provide a transparent, accurate, and accessible digital platform that enables the barangay to deliver faster and more organized assistance to every resident in need.</p>
                    </div>
                    <div class="mv-card vision">
                        <span class="mv-icon">🌟</span>
                        <h4>Our Vision</h4>
                        <p>A community where every resident has equal and easy access to barangay assistance programs through the power of technology and good governance.</p>
                    </div>
                </div>
            </div>

            <!-- Contact Cards -->
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

            <!-- FAQ -->
            <div class="section" style="margin-top:25px;">
                <div class="section-title">❓ Frequently Asked Questions</div>
                <div class="faq-tabs">
                    <button type="button" class="faq-tab active" data-tab="faq-registration" onclick="switchTab('faq-registration')">📝 Registration</button>
                    <button type="button" class="faq-tab" data-tab="faq-application" onclick="switchTab('faq-application')">📋 Application</button>
                    <button type="button" class="faq-tab" data-tab="faq-services" onclick="switchTab('faq-services')">🏥 Services</button>
                </div>

                <div id="faq-registration" class="faq-group active">
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">Who is eligible to register in AssistSys? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Any resident of Barangay Canbanua may register. You must be an official resident with a valid barangay ID or proof of residency. Minors may be registered by a parent or legal guardian.</div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">What documents do I need to register? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Please prepare: <ul><li>Valid government-issued ID (e.g., PhilSys, UMID, Voter's ID)</li><li>Proof of residency (barangay certificate or utility bill)</li><li>Birth certificate (for age verification)</li><li>Active email address for account verification</li></ul></div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">How long does the registration approval take? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Registration is reviewed within <strong>1–3 business days</strong>. You will receive an email or SMS notification once approved or if additional documents are needed.</div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">Can I register on behalf of a family member? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Yes. A parent or legal guardian may register on behalf of a minor or a person with disability. Bring the beneficiary's documents, your valid ID, and a signed authorization letter.</div>
                    </div>
                </div>

                <div id="faq-application" class="faq-group">
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">How do I apply for barangay assistance? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Log in, go to <strong>My Applications</strong>, and click <strong>New Application</strong>. Fill in the details, select the assistance type, and submit. A reference number will be provided for tracking.</div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">What types of assistance can I apply for? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer"><ul><li>Medical / hospitalization assistance</li><li>Educational scholarship assistance</li><li>Livelihood and financial assistance</li><li>Burial and bereavement assistance</li><li>Disaster relief assistance</li></ul></div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">How can I track the status of my application? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Go to <strong>My Applications</strong>. Each application shows its status: <em>Pending</em>, <em>Under Review</em>, <em>Approved</em>, or <em>Rejected</em>. You will also be notified when the status changes.</div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">Can I submit multiple applications at the same time? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">One active application per assistance type at a time. Different types can be applied for simultaneously. Once resolved, you may re-apply for the same type.</div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">What happens if my application is rejected? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">You will be notified with a reason. You may re-apply after addressing the concern, or visit the barangay office for a personal appeal with additional supporting documents.</div>
                    </div>
                </div>

                <div id="faq-services" class="faq-group">
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">What services does AssistSys provide? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer"><ul><li>Register as a beneficiary online</li><li>Apply for various types of barangay assistance</li><li>Track application status in real time</li><li>Receive notifications for updates and announcements</li><li>View transaction history and assistance records</li></ul></div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">Is AssistSys free to use? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Yes. AssistSys is completely free for all Barangay Canbanua residents. There are no fees for registration, application submission, or any other use of the platform.</div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">Is my personal information safe in AssistSys? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Yes. AssistSys complies with the <strong>Data Privacy Act of 2012 (RA 10173)</strong>. Your information is stored securely and only accessible to authorized barangay personnel. It will never be shared with third parties without your consent.</div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">Can I use AssistSys on my mobile phone? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Yes. AssistSys is fully responsive and works on smartphones, tablets, and desktops. Open your browser and visit the AssistSys website — no app download required.</div>
                    </div>
                    <div class="faq-item">
                        <button type="button" class="faq-question" onclick="toggleFaq(this)">How do I report a problem or give feedback? <span class="faq-arrow">▼</span></button>
                        <div class="faq-answer">Contact us via phone, email, or Facebook using the details above. For urgent technical issues, call the barangay office directly. All feedback is welcome and helps improve the system.</div>
                    </div>
                </div>
            </div>

        </div>
    </asp:Panel>

    <!-- ═══════════════════════════════════════════
         LOGGED IN (dashboard layout)
    ════════════════════════════════════════════ -->
    <asp:Panel ID="pnlDashboardLayout" runat="server">
        <div class="wrapper">

            <uc:Sidebar ID="Sidebar" runat="server" />

            <div class="main">

                <div class="topbar">
                    <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                    <h3>📬 About Us &amp; Contact</h3>
                    <div></div>
                </div>

                <!-- About Us Banner -->
                <div class="about-banner">
                    <div class="about-banner-icon">🏥</div>
                    <div class="about-banner-text">
                        <h2>About AssistSys</h2>
                        <p>The Barangay Assistance System is a digital platform that helps barangay officials manage assistance programs efficiently. It simplifies application processing, record management, and communication between the barangay office and residents.</p>
                    </div>
                </div>

                <!-- What the system does -->
                <div class="section">
                    <div class="section-title">⚙️ What AssistSys Does</div>
                    <div class="about-features">
                        <div class="about-feature-card">
                            <span class="feat-icon">📋</span>
                            <h4>Application Processing</h4>
                            <p>Simplifies how residents apply for barangay assistance programs online — anytime, anywhere.</p>
                        </div>
                        <div class="about-feature-card">
                            <span class="feat-icon">🗂️</span>
                            <h4>Record Management</h4>
                            <p>Organizes and maintains accurate beneficiary records for the barangay office in one secure place.</p>
                        </div>
                        <div class="about-feature-card">
                            <span class="feat-icon">🔔</span>
                            <h4>Real-Time Updates</h4>
                            <p>Keeps residents informed about their application status through instant notifications.</p>
                        </div>
                        <div class="about-feature-card">
                            <span class="feat-icon">🤝</span>
                            <h4>Better Communication</h4>
                            <p>Bridges the gap between barangay officials and residents for faster, more organized public service.</p>
                        </div>
                    </div>
                </div>

                <!-- Mission & Vision -->
                <div class="section">
                    <div class="section-title">🎯 Mission &amp; Vision</div>
                    <div class="mv-grid">
                        <div class="mv-card mission">
                            <span class="mv-icon">🎯</span>
                            <h4>Our Mission</h4>
                            <p>To provide a transparent, accurate, and accessible digital platform that enables the barangay to deliver faster and more organized assistance to every resident in need.</p>
                        </div>
                        <div class="mv-card vision">
                            <span class="mv-icon">🌟</span>
                            <h4>Our Vision</h4>
                            <p>A community where every resident has equal and easy access to barangay assistance programs through the power of technology and good governance.</p>
                        </div>
                    </div>
                </div>

                <!-- Contact Cards -->
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

                <!-- FAQ -->
                <div class="section" style="margin-top:25px;">
                    <div class="section-title">❓ Frequently Asked Questions</div>
                    <div class="faq-tabs">
                        <button type="button" class="faq-tab active" data-tab="faq-reg2" onclick="switchTab('faq-reg2')">📝 Registration</button>
                        <button type="button" class="faq-tab" data-tab="faq-app2" onclick="switchTab('faq-app2')">📋 Application</button>
                        <button type="button" class="faq-tab" data-tab="faq-svc2" onclick="switchTab('faq-svc2')">🏥 Services</button>
                    </div>

                    <div id="faq-reg2" class="faq-group active">
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">Who is eligible to register in AssistSys? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Any resident of Barangay Canbanua may register. You must be an official resident with a valid barangay ID or proof of residency. Minors may be registered by a parent or legal guardian.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">What documents do I need to register? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Please prepare: <ul><li>Valid government-issued ID (e.g., PhilSys, UMID, Voter's ID)</li><li>Proof of residency (barangay certificate or utility bill)</li><li>Birth certificate (for age verification)</li><li>Active email address for account verification</li></ul></div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">How long does the registration approval take? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Registration is reviewed within <strong>1–3 business days</strong>. You will receive an email notification once approved or if additional documents are needed.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">Can I register on behalf of a family member? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Yes. A parent or legal guardian may register on behalf of a minor or a person with disability. Bring the beneficiary's documents, your valid ID, and a signed authorization letter.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">What if I forgot my username or password? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Use the <strong>Forgot Password</strong> link on the Login page. If you also forgot your username, visit the barangay office with a valid ID for assistance.</div>
                        </div>
                    </div>

                    <div id="faq-app2" class="faq-group">
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">How do I apply for barangay assistance? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Log in, go to <strong>My Applications</strong>, and click <strong>New Application</strong>. Fill in the details, select the assistance type, and submit. A reference number will be provided for tracking.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">What types of assistance can I apply for? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer"><ul><li>Medical / hospitalization assistance</li><li>Educational scholarship assistance</li><li>Livelihood and financial assistance</li><li>Burial and bereavement assistance</li><li>Disaster relief assistance</li></ul></div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">How can I track the status of my application? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Go to <strong>My Applications</strong>. Each application shows its status: <em>Pending</em>, <em>Under Review</em>, <em>Approved</em>, or <em>Rejected</em>. You will also be notified when the status changes.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">Can I submit multiple applications at the same time? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">One active application per assistance type at a time. Different types can be applied for simultaneously. Once resolved, you may re-apply for the same type.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">What happens if my application is rejected? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">You will be notified with a reason. You may re-apply after addressing the concern, or visit the barangay office for a personal appeal with additional supporting documents.</div>
                        </div>
                    </div>

                    <div id="faq-svc2" class="faq-group">
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">What services does AssistSys provide? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer"><ul><li>Register as a beneficiary online</li><li>Apply for various types of barangay assistance</li><li>Track application status in real time</li><li>Receive notifications for updates and announcements</li><li>View transaction history and assistance records</li></ul></div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">Is AssistSys free to use? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Yes. AssistSys is completely free for all Barangay Canbanua residents. There are no fees for registration, application submission, or any other use of the platform.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">Is my personal information safe in AssistSys? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Yes. AssistSys complies with the <strong>Data Privacy Act of 2012 (RA 10173)</strong>. Your information is stored securely and only accessible to authorized barangay personnel. It will never be shared with third parties without your consent.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">Can I use AssistSys on my mobile phone? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Yes. AssistSys is fully responsive and works on smartphones, tablets, and desktops. Open your browser and visit the AssistSys website — no app download required.</div>
                        </div>
                        <div class="faq-item">
                            <button type="button" class="faq-question" onclick="toggleFaq(this)">How do I report a problem or give feedback? <span class="faq-arrow">▼</span></button>
                            <div class="faq-answer">Contact us via phone, email, or Facebook using the details above. For urgent technical issues, call the barangay office directly. All feedback is welcome and helps improve the system.</div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </asp:Panel>

</form>
</body>
</html>