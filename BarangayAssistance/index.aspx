<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="BarangayAssistance.index" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Barangay Assistance System | Community Support Portal</title>
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

        /* Smooth scroll behavior */
        html {
            scroll-behavior: smooth;
        }

        /* Navbar - modern glass morphism effect */
        .navbar {
            background: rgba(26, 54, 78, 0.95);
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
            transition: all 0.3s ease;
        }

        .navbar .logo {
            font-size: 1.6rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #fff, #a8c8e8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .navbar .nav-links a {
            color: #ecf0f1;
            text-decoration: none;
            margin-left: 2rem;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
            padding-bottom: 5px;
        }

        .navbar .nav-links a:hover {
            color: #5dade2;
            transform: translateY(-2px);
        }

        .navbar .nav-links a::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 50%;
            background: linear-gradient(90deg, #5dade2, #3498db);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .navbar .nav-links a:hover::after {
            width: 80%;
        }

        /* Hero section - enhanced gradient overlay */
        .hero {
            background: linear-gradient(145deg, rgba(26, 54, 78, 0.92), rgba(31, 59, 87, 0.88)), 
                        url('https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1400&q=80') center/cover no-repeat fixed;
            color: white;
            text-align: center;
            padding: 120px 20px;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.05)" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') repeat-x bottom;
            pointer-events: none;
        }

        .hero h1 {
            font-size: 3.8rem;
            margin-bottom: 1rem;
            font-weight: 800;
            letter-spacing: -1px;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.3);
            animation: fadeInUp 0.8s ease-out;
        }

        .hero p {
            font-size: 1.2rem;
            max-width: 750px;
            margin: 0 auto 2rem auto;
            line-height: 1.8;
            opacity: 0.95;
            animation: fadeInUp 0.8s ease-out 0.2s backwards;
        }

        .hero .btn {
            display: inline-block;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            text-decoration: none;
            padding: 14px 32px;
            border-radius: 50px;
            margin: 5px;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            animation: fadeInUp 0.8s ease-out 0.4s backwards;
        }

        .hero .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
            background: linear-gradient(135deg, #2980b9, #1f618d);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Section styling */
        .section {
            padding: 80px 5%;
            max-width: 1400px;
            margin: 0 auto;
        }

        .section-title {
            text-align: center;
            font-size: 2.5rem;
            margin-bottom: 3rem;
            color: #1a364e;
            font-weight: 700;
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -12px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #3498db, #5dade2);
            border-radius: 2px;
        }

        /* Cards - modern hover effects */
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }

        .card {
            background: white;
            padding: 35px 25px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid rgba(52, 152, 219, 0.1);
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
            border-color: rgba(52, 152, 219, 0.3);
        }

        .card h3 {
            margin-top: 0;
            color: #1a364e;
            font-size: 1.5rem;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .card p {
            line-height: 1.7;
            color: #5d6d7e;
        }

        /* Add icon before card titles */
        .card:first-child h3::before {
            content: "🏥 ";
            font-size: 1.8rem;
            display: block;
            margin-bottom: 10px;
        }

        .card:nth-child(2) h3::before {
            content: "💰 ";
            font-size: 1.8rem;
            display: block;
            margin-bottom: 10px;
        }

        .card:nth-child(3) h3::before {
            content: "⚰️ ";
            font-size: 1.8rem;
            display: block;
            margin-bottom: 10px;
        }

        /* About box */
        .about-box {
            background: linear-gradient(135deg, #ffffff, #f8f9fa);
            padding: 40px;
            border-radius: 20px;
            line-height: 1.9;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border-left: 5px solid #3498db;
            font-size: 1.05rem;
            color: #2c3e4e;
            transition: all 0.3s ease;
        }

        .about-box:hover {
            transform: translateX(5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.12);
        }

        /* Announcements */
        .announcements {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
        }

        .announcement-card {
            background: white;
            padding: 25px;
            border-left: 5px solid #3498db;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .announcement-card::before {
            content: "📢";
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 2rem;
            opacity: 0.1;
        }

        .announcement-card:hover {
            transform: translateX(8px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.12);
            border-left-color: #5dade2;
        }

        .announcement-card h4 {
            margin-top: 0;
            color: #1a364e;
            font-size: 1.2rem;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .announcement-card p {
            color: #5d6d7e;
            line-height: 1.6;
        }

        /* Footer */
        .footer {
            background: linear-gradient(135deg, #1a364e, #152c40);
            color: #bdc3c7;
            text-align: center;
            padding: 30px;
            margin-top: 60px;
        }

        .footer p {
            margin: 0;
            font-size: 0.9rem;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                gap: 15px;
                padding: 1rem;
            }

            .navbar .nav-links a {
                margin: 0 0.8rem;
                font-size: 0.9rem;
            }

            .hero {
                padding: 80px 20px;
            }

            .hero h1 {
                font-size: 2.2rem;
            }

            .hero p {
                font-size: 1rem;
            }

            .section {
                padding: 50px 20px;
            }

            .section-title {
                font-size: 1.8rem;
            }

            .cards, .announcements {
                gap: 20px;
            }

            .card, .about-box, .announcement-card {
                padding: 20px;
            }
        }

        /* Add smooth fade-in for sections */
        .section {
            opacity: 0;
            animation: fadeIn 0.8s ease-out forwards;
        }

        .section:nth-child(2) {
            animation-delay: 0.2s;
        }

        .section:nth-child(3) {
            animation-delay: 0.4s;
        }

        .section:nth-child(4) {
            animation-delay: 0.6s;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 10px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #3498db, #1a364e);
            border-radius: 5px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #2980b9, #152c40);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="navbar">
            <div class="logo">🏥 AssistSys</div>
            <div class="nav-links">
                <a href="index.aspx">Home</a>
                <a href="Login.aspx">Login</a>
                <a href="Register.aspx">Register</a>
                <a href="Transactions.aspx">Transactions</a>
                  <a href="Contact.aspx">Contact Us</a>
                <a href="Feedback.aspx">Feedback</a>
            </div>
        </div>

        <div class="hero">
            <h1>Barangay Assistance System</h1>
            <p>
                A simple and efficient platform for managing barangay assistance applications,
                beneficiary records, and transaction monitoring in one secure system.
            </p>
        </div>

        <div class="section">
            <h2 class="section-title">Our Services</h2>
            <div class="cards">
                <div class="card">
                    <h3>Medical Assistance</h3>
                    <p>Support for beneficiaries needing hospital, medicine, or other medical-related assistance.</p>
                </div>

                <div class="card">
                    <h3>Financial Assistance</h3>
                    <p>Direct financial aid for qualified residents facing urgent needs and emergencies.</p>
                </div>

                <div class="card">
                    <h3>Burial and Other Support</h3>
                    <p>Special assistance programs for burial needs and other barangay-approved concerns.</p>
                </div>
            </div>
        </div>

        <div class="section">
            <h2 class="section-title">About the System</h2>
            <div class="about-box">
                The Barangay Assistance System is designed to help administrators and beneficiaries
                manage assistance programs more efficiently. It allows faster application processing,
                better record tracking, and easier communication between the barangay office and residents.
                This system aims to improve transparency, accessibility, and service delivery in the community.
            </div>
        </div>

        <div class="section">
            <h2 class="section-title">Latest Announcements</h2>
            <div class="announcements">
                <div class="announcement-card">
                    <h4>Application Schedule</h4>
                    <p>Applications for this month's assistance program are open from May 1 to May 15.</p>
                </div>

                <div class="announcement-card">
                    <h4>Claiming of Approved Assistance</h4>
                    <p>Approved beneficiaries may visit the barangay hall from Monday to Friday, 8:00 AM to 4:00 PM.</p>
                </div>
            </div>
        </div>

        <div class="footer">
            <p>&copy; 2026 Barangay Assistance System. All rights reserved.</p>
        </div>

    </form>
</body>
</html>