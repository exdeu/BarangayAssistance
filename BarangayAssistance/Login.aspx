<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="BarangayAssistance.Login" %>
<%@ Register Src="~/VerifyOtp.ascx" TagPrefix="uc" TagName="VerifyOtp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - AssistSys</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(145deg, rgba(26, 54, 78, 0.92), rgba(31, 59, 87, 0.88)),
                        url('https://images.unsplash.com/photo-1506744038136-46273834b3fb') center/cover no-repeat fixed;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        /* Animated background overlay */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.03)" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') repeat-x bottom;
            pointer-events: none;
            animation: wave 20s linear infinite;
        }

        @keyframes wave {
            0% {
                background-position: 0 bottom;
            }
            100% {
                background-position: 1440px bottom;
            }
        }

        .login-container {
            background: rgba(255, 255, 255, 0.98);
            padding: 40px 35px;
            width: 400px;
            max-width: 90%;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15), 0 5px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
            position: relative;
            z-index: 1;
            animation: slideUp 0.6s ease-out;
            backdrop-filter: blur(0px);
            border: 1px solid rgba(52, 152, 219, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .login-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-container h2 {
            margin-bottom: 25px;
            color: #1a364e;
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            position: relative;
            display: inline-block;
            padding-bottom: 10px;
        }

        .login-container h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #3498db, #5dade2);
            border-radius: 2px;
        }

        .input-group {
            text-align: left;
            margin-bottom: 20px;
        }

        .input-group label {
            font-size: 0.85rem;
            color: #5d6d7e;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
            margin-bottom: 8px;
        }

        .input-group input,
        .input-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 12px;
            font-size: 0.95rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f8f9fa;
            box-sizing: border-box;
        }

        .input-group input:focus,
        .input-group select:focus {
            outline: none;
            border-color: #3498db;
            background: white;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .input-group input:hover,
        .input-group select:hover {
            border-color: #b0c4de;
        }

        .btn {
            width: 100%;
            background: linear-gradient(135deg, #1a364e, #152c40);
            color: white;
            border: none;
            padding: 14px;
            margin-top: 15px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            font-family: inherit;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            background: linear-gradient(135deg, #152c40, #0f2333);
        }

        .btn:active {
            transform: translateY(0);
        }

        .extra-links {
            margin-top: 20px;
            font-size: 0.85rem;
        }

        .extra-links p {
            margin: 0;
        }

        .extra-links a {
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            display: inline-block;
        }

        .extra-links a::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -3px;
            left: 0;
            background: linear-gradient(90deg, #3498db, #5dade2);
            transition: width 0.3s ease;
        }

        .extra-links a:hover {
            color: #2980b9;
        }

        .extra-links a:hover::after {
            width: 100%;
        }

        .message {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #e74c3c;
            font-size: 0.85rem;
            padding: 10px;
            background: rgba(231, 76, 60, 0.1);
            border-radius: 10px;
            border-left: 3px solid #e74c3c;
            text-align: left;
        }

        /* Success message style (if needed) */
        .message[class*="success"] {
            color: #27ae60;
            background: rgba(39, 174, 96, 0.1);
            border-left-color: #27ae60;
        }

        /* Custom placeholder styling */
        ::-webkit-input-placeholder {
            color: #bdc3c7;
            font-size: 0.85rem;
        }

        ::-moz-placeholder {
            color: #bdc3c7;
            font-size: 0.85rem;
        }

        :-ms-input-placeholder {
            color: #bdc3c7;
            font-size: 0.85rem;
        }

        /* Decorative floating elements */
        .login-container::before {
            content: "🏥";
            position: absolute;
            top: -15px;
            left: -15px;
            font-size: 3rem;
            opacity: 0.1;
            transform: rotate(-15deg);
            pointer-events: none;
        }

        .login-container::after {
            content: "📋";
            position: absolute;
            bottom: -15px;
            right: -15px;
            font-size: 3rem;
            opacity: 0.1;
            transform: rotate(10deg);
            pointer-events: none;
        }

        /* Responsive design */
        @media (max-width: 480px) {
            .login-container {
                padding: 30px 25px;
                width: 90%;
            }

            .login-container h2 {
                font-size: 1.6rem;
            }

            .input-group input,
            .input-group select {
                padding: 10px 12px;
                font-size: 0.9rem;
            }

            .btn {
                padding: 12px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <div class="login-container">

        <h2>AssistSys Login</h2>

        <div class="input-group">
            <label>Username</label>
            <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter your username"></asp:TextBox>
        </div>

        <div class="input-group">
            <label>Password</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
        </div>

      

        <asp:Button ID="btnLogin" runat="server"
            Text="Login"
            CssClass="btn"
            OnClick="btnLogin_Click" />

        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>

        <div class="extra-links">
            <p><a href="index.aspx">← Back to Home</a></p>
        </div>

    </div>
    <uc:VerifyOtp ID="VerifyOtpControl"
    runat="server" />
</form>
</body>
</html>