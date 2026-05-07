<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="BarangayAssistance.Feedback" %>
<%@ Register Src="~/Sidebar.ascx" TagPrefix="uc" TagName="Sidebar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Complaints & Feedback - AssistSys</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <style>
    <!-- ADD THIS INSIDE Feedback.aspx <style> TAG, preferably before @media -->

::-webkit-scrollbar { width: 10px; }

::-webkit-scrollbar-track { background: #f1f1f1; }

::-webkit-scrollbar-thumb {
    background: linear-gradient(135deg, #3498db, #1a364e);
    border-radius: 5px;
}

::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(135deg, #2980b9, #152c40);
}

@keyframes fadeInDown {
    from {
        opacity: 0;
        transform: translateY(-15px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(18px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.navbar {
    animation: fadeInDown 0.6s ease-out;
}

.topbar {
    animation: fadeInDown 0.6s ease-out;
}

.section {
    animation: fadeInUp 0.7s ease-out 0.2s backwards;
}


.public-main .section:first-child {
    animation-delay: 0.15s;
}

.public-main .section:nth-child(2) {
    animation-delay: 0.3s;
}

.menu-btn {
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.menu-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 18px rgba(0,0,0,0.2);
}

.btn-submit {
    transition: all 0.3s ease;
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 24px rgba(26,54,78,0.35);
}

.btn-reply {
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(26,54,78,0.2);
}

.btn-reply:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 18px rgba(26,54,78,0.3);
}

.submission-card {
    transition: all 0.3s ease;
    animation: fadeInUp 0.55s ease-out backwards;
}

.submission-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 28px rgba(0,0,0,0.08);
    border-left-color: #2980b9;
}

.admin-reply-box {
    animation: fadeInUp 0.4s ease-out backwards;
}

.admin-action-panel {
    animation: fadeInUp 0.4s ease-out backwards;
}

.msg-success,
.msg-error {
    animation: fadeInDown 0.45s ease-out;
}

.navbar .nav-links a {
    transition: all 0.3s ease;
}

.navbar .nav-links a:hover {
    transform: translateY(-2px);
}

select,
textarea,
input[type="text"] {
    transition: border-color 0.25s ease, box-shadow 0.25s ease, background 0.25s ease;
}

.empty-state {
    animation: fadeInUp 0.5s ease-out;
}
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #e9edf2 100%);
            color: #2c3e4e;
            line-height: 1.6;
        }

        html { scroll-behavior: smooth; }

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
        }

        .navbar .logo {
            font-size: 1.6rem;
            font-weight: 700;
            background: linear-gradient(135deg, #fff, #a8c8e8);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .navbar .nav-links a {
            color: #ecf0f1;
            text-decoration: none;
            margin-left: 2rem;
            font-size: 1rem;
            font-weight: 500;
            position: relative;
            padding-bottom: 5px;
            transition: all 0.3s ease;
        }

        .navbar .nav-links a:hover { color: #5dade2; }

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

        .navbar .nav-links a:hover::after { width: 80%; }

        .wrapper { display: flex; min-height: 100vh; }
        .main { flex: 1; padding: 30px; overflow-x: auto; }

        .public-main {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
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
        }

        .menu-btn {
            font-size: 1.2rem;
            cursor: pointer;
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            border: none;
            padding: 10px 14px;
            border-radius: 10px;
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

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .full { grid-column: 1 / -1; }

        .form-label {
            display: block;
            font-size: 0.82rem;
            font-weight: 700;
            color: #5d6d7e;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 7px;
        }

        .form-group { display: flex; flex-direction: column; }

        select,
        textarea,
        input[type="text"] {
            padding: 11px 14px;
            border-radius: 10px;
            border: 1.5px solid #e1e8ed;
            font-family: inherit;
            font-size: 0.95rem;
            color: #2c3e4e;
            background: #fafcfe;
            width: 100%;
            outline: none;
        }

        select:focus,
        textarea:focus,
        input[type="text"]:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.12);
            background: #fff;
        }

        textarea { resize: vertical; min-height: 110px; }

        .rating-wrapper {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .rating-label-text {
            font-size: 0.82rem;
            font-weight: 700;
            color: #5d6d7e;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .star-option { display: flex; align-items: center; gap: 5px; }

        .star-option input[type="radio"] {
            width: 15px;
            height: 15px;
            accent-color: #f39c12;
        }

        .star-option label {
            font-size: 1.25rem;
            cursor: pointer;
            color: #d5d8dc;
            line-height: 1;
        }

        .star-option input[type="radio"]:checked ~ label,
        .star-option:hover label { color: #f39c12; }

        .btn-submit {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            border: none;
            padding: 12px 32px;
            border-radius: 50px;
            font-size: 0.97rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            box-shadow: 0 6px 18px rgba(26,54,78,0.25);
        }

        .msg-success,
        .msg-error {
            display: block;
            padding: 12px 18px;
            border-radius: 12px;
            font-size: 0.92rem;
            font-weight: 600;
            margin-bottom: 18px;
        }

        .msg-success {
            background: #eafaf1;
            color: #1e8449;
            border: 1.5px solid #a9dfbf;
        }

        .msg-error {
            background: #fdedec;
            color: #c0392b;
            border: 1.5px solid #f1aaa5;
        }

        .submission-card {
            background: #fafcfe;
            border: 1px solid rgba(52, 152, 219, 0.13);
            border-left: 5px solid #3498db;
            border-radius: 16px;
            padding: 20px 22px;
            margin-bottom: 16px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.04);
        }

        .card-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 8px;
            gap: 10px;
            flex-wrap: wrap;
        }

        .card-subject {
            font-size: 1.02rem;
            font-weight: 700;
            color: #1a364e;
        }

        .card-meta { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }

        .badge {
            display: inline-block;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 50px;
            letter-spacing: 0.3px;
        }

        .badge-type { background: rgba(52,152,219,0.12); color: #2471a3; }
        .badge-pending { background: #fef9e7; color: #b7950b; }
        .badge-resolved { background: #eafaf1; color: #1e8449; }
        .badge-rejected { background: #fdedec; color: #c0392b; }
        .badge-review { background: #eaf2ff; color: #2e86c1; }

        .card-details {
            font-size: 0.93rem;
            color: #4a5568;
            margin-bottom: 10px;
            line-height: 1.7;
        }

        .card-footer {
            display: flex;
            gap: 20px;
            font-size: 0.82rem;
            color: #8899aa;
            flex-wrap: wrap;
        }

        .stars-display { color: #f39c12; letter-spacing: 2px; }

        .admin-reply-box {
            margin-top: 14px;
            background: linear-gradient(135deg, #eef4fb, #f0f7ff);
            border: 1px solid rgba(52,152,219,0.2);
            border-radius: 12px;
            padding: 14px 16px;
        }

        .admin-reply-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #2471a3;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }

        .admin-reply-text {
            font-size: 0.93rem;
            color: #34495e;
            line-height: 1.65;
        }

        .admin-action-panel {
            margin-top: 14px;
            background: #f8fafc;
            border: 1.5px dashed #adc8e5;
            border-radius: 12px;
            padding: 14px 16px;
        }

        .admin-action-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #5d6d7e;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .btn-reply {
            background: linear-gradient(135deg, #1a364e, #2980b9);
            color: white;
            border: none;
            padding: 9px 22px;
            border-radius: 50px;
            font-size: 0.88rem;
            font-weight: 700;
            font-family: inherit;
            cursor: pointer;
            margin-top: 8px;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #8899aa;
        }

        .empty-state .empty-icon {
            font-size: 3rem;
            margin-bottom: 12px;
            display: block;
        }

        .footer {
            background: linear-gradient(135deg, #1a364e, #152c40);
            color: #bdc3c7;
            text-align: center;
            padding: 30px;
            margin-top: 60px;
        }

        @media (max-width: 900px) {
            .form-grid { grid-template-columns: 1fr; }
            .main { padding: 15px; }
            .topbar { flex-direction: column; align-items: flex-start; gap: 10px; }
            .navbar { flex-direction: column; gap: 15px; padding: 1rem; }
            .navbar .nav-links a { margin: 0 0.8rem; font-size: 0.9rem; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <asp:Panel ID="pnlLoggedOut" runat="server" Visible="false">

        <div class="navbar">
            <div class="logo">🏥 AssistSys</div>
            <div class="nav-links">
                <a href="index.aspx">Home</a>
                <a href="Login.aspx">Login</a>
                <a href="Register.aspx">Register</a>
                <a href="Transactions.aspx">Transactions</a>
                <a href="Contact.aspx">About Us</a>
                <a href="Feedback.aspx">Feedback</a>
            </div>
        </div>

        <div class="public-main">

            <asp:Label ID="lblPublicError" runat="server" CssClass="msg-error" Visible="false" />
            <asp:Label ID="lblPublicSuccess" runat="server" CssClass="msg-success" Visible="false" />

            <div class="section">
                <div class="section-title">📢 Public Complaints &amp; Feedback</div>

                <div class="form-grid">

                    <div class="form-group">
                        <label class="form-label">Type</label>
                        <asp:DropDownList ID="ddlPublicType" runat="server">
                            <asp:ListItem Value="">— Select Type —</asp:ListItem>
                            <asp:ListItem>Complaint</asp:ListItem>
                            <asp:ListItem>Feedback</asp:ListItem>
                            <asp:ListItem>Suggestion</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Category</label>
                        <asp:DropDownList ID="ddlPublicCategory" runat="server">
                            <asp:ListItem Value="">— Select Category —</asp:ListItem>
                            <asp:ListItem>Service</asp:ListItem>
                            <asp:ListItem>Staff</asp:ListItem>
                            <asp:ListItem>System</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group full">
                        <label class="form-label">Subject</label>
                        <asp:TextBox ID="txtPublicSubject" runat="server" placeholder="Enter subject here" />
                    </div>

                    <div class="form-group full">
                        <label class="form-label">Details</label>
                        <asp:TextBox ID="txtPublicDetails" runat="server"
                            TextMode="MultiLine" Rows="4"
                            placeholder="Describe your concern or feedback in detail..." />
                    </div>

                    <div class="full">
                        <div class="rating-wrapper">
                            <span class="rating-label-text">Rating:</span>

                            <div class="star-option">
                                <asp:RadioButton ID="rbPublicStar5" runat="server" GroupName="publicRating" />
                                <label for="<%= rbPublicStar5.ClientID %>">★★★★★</label>
                            </div>

                            <div class="star-option">
                                <asp:RadioButton ID="rbPublicStar4" runat="server" GroupName="publicRating" />
                                <label for="<%= rbPublicStar4.ClientID %>">★★★★</label>
                            </div>

                            <div class="star-option">
                                <asp:RadioButton ID="rbPublicStar3" runat="server" GroupName="publicRating" />
                                <label for="<%= rbPublicStar3.ClientID %>">★★★</label>
                            </div>

                            <div class="star-option">
                                <asp:RadioButton ID="rbPublicStar2" runat="server" GroupName="publicRating" />
                                <label for="<%= rbPublicStar2.ClientID %>">★★</label>
                            </div>

                            <div class="star-option">
                                <asp:RadioButton ID="rbPublicStar1" runat="server" GroupName="publicRating" />
                                <label for="<%= rbPublicStar1.ClientID %>">★</label>
                            </div>
                        </div>
                    </div>

                   <div class="full">
    <asp:Button ID="btnPublicSubmit" runat="server" Text="📤 Submit Feedback"
        CssClass="btn-submit" OnClick="btnPublicSubmit_Click" />
</div>

</div> <!-- CLOSE form-grid -->
</div> <!-- CLOSE first section -->

<div class="section">
                    <div class="section">
    <div class="section-title">📋 Resolved Complaints & Feedback</div>

    <asp:Panel ID="pnlPublicNoSubmissions" runat="server" Visible="false">
        <div class="empty-state">
            <span class="empty-icon">📭</span>
            <p>No resolved feedback available.</p>
        </div>
    </asp:Panel>

    <asp:Repeater ID="rptPublicSubmissions" runat="server">
        <ItemTemplate>

            <div class="submission-card">

                <div class="card-header">
                    <div class="card-subject">
                        <%# Eval("subject") %>
                    </div>

                    <div class="card-meta">
                        <span class="badge badge-type">
                            <%# Eval("type") %>
                        </span>

                        <span class='badge <%# GetStatusBadgeClass(Eval("status")?.ToString()) %>'>
                            <%# Eval("status") %>
                        </span>
                    </div>
                </div>

                <div class="card-details">
                    <%# Eval("details") %>
                </div>

                <div class="card-footer">
                    <span>📂 <%# Eval("category") %></span>

                    <span class="stars-display">
                        <%# new string('★', Convert.ToInt32(Eval("rating") ?? 0)) %>
                    </span>

                    <span>🕐 <%# Eval("date_submitted") %></span>
                </div>

                <div class="admin-reply-box">
                    <div class="admin-reply-label">
                        💬 Admin Response
                    </div>

                    <div class="admin-reply-text">
                        <%# Eval("admin_response") %>
                    </div>
                </div>

            </div>

        </ItemTemplate>
    </asp:Repeater>
</div>

                </div>
            </div>

        </div>

        <div class="footer">
            <p>&copy; 2026 Barangay Assistance System. All rights reserved.</p>
        </div>

    </asp:Panel>

    <asp:Panel ID="pnlLoggedIn" runat="server" Visible="false">

        <div class="wrapper">

            <uc:Sidebar ID="Sidebar" runat="server" />

            <div class="main">

                <div class="topbar">
                    <button type="button" class="menu-btn" onclick="document.getElementById('sidebar').classList.toggle('collapsed')">☰</button>
                    <h3>📢 Complaints &amp; Feedback</h3>
                    <div></div>
                </div>

                <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />
                <asp:Label ID="lblSuccess" runat="server" CssClass="msg-success" Visible="false" />

                <div class="section">
                    <div class="section-title">✏️ Submit Complaint / Feedback</div>

                    <div class="form-grid">

                        <div class="form-group">
                            <label class="form-label">Type</label>
                            <asp:DropDownList ID="ddlType" runat="server">
                                <asp:ListItem Value="">— Select Type —</asp:ListItem>
                                <asp:ListItem>Complaint</asp:ListItem>
                                <asp:ListItem>Feedback</asp:ListItem>
                                <asp:ListItem>Suggestion</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server">
                                <asp:ListItem Value="">— Select Category —</asp:ListItem>
                                <asp:ListItem>Service</asp:ListItem>
                                <asp:ListItem>Staff</asp:ListItem>
                                <asp:ListItem>System</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group full">
                            <label class="form-label">Subject</label>
                            <asp:TextBox ID="txtSubject" runat="server" placeholder="Enter subject here" />
                        </div>

                        <div class="form-group full">
                            <label class="form-label">Details</label>
                            <asp:TextBox ID="txtDetails" runat="server"
                                TextMode="MultiLine" Rows="4"
                                placeholder="Describe your concern or feedback in detail..." />
                        </div>

                        <div class="full">
                            <div class="rating-wrapper">
                                <span class="rating-label-text">Rating:</span>

                                <div class="star-option">
                                    <asp:RadioButton ID="rbStar5" runat="server" GroupName="rating" />
                                    <label for="<%= rbStar5.ClientID %>">★★★★★</label>
                                </div>

                                <div class="star-option">
                                    <asp:RadioButton ID="rbStar4" runat="server" GroupName="rating" />
                                    <label for="<%= rbStar4.ClientID %>">★★★★</label>
                                </div>

                                <div class="star-option">
                                    <asp:RadioButton ID="rbStar3" runat="server" GroupName="rating" />
                                    <label for="<%= rbStar3.ClientID %>">★★★</label>
                                </div>

                                <div class="star-option">
                                    <asp:RadioButton ID="rbStar2" runat="server" GroupName="rating" />
                                    <label for="<%= rbStar2.ClientID %>">★★</label>
                                </div>

                                <div class="star-option">
                                    <asp:RadioButton ID="rbStar1" runat="server" GroupName="rating" />
                                    <label for="<%= rbStar1.ClientID %>">★</label>
                                </div>
                            </div>
                        </div>

                       <div class="full">
    <asp:Button ID="Button1" runat="server" Text="📤 Submit Feedback"
        CssClass="btn-submit" OnClick="btnPublicSubmit_Click" />
</div>

</div> <!-- CLOSE form-grid -->
</div> <!-- CLOSE first section -->

<div class="section">
                        <div class="section">
    <div class="section-title">📋 Complaints & Feedback List</div>

    <asp:Panel ID="pnlUserNoSubmissions" runat="server" Visible="false">
        <div class="empty-state">
            <span class="empty-icon">📭</span>
            <p>No complaints or feedback found.</p>
        </div>
    </asp:Panel>

    <asp:Repeater ID="rptUserSubmissions" runat="server">
        <ItemTemplate>

            <div class="submission-card">

                <div class="card-header">
                    <div class="card-subject">
                        <%# Eval("subject") %>
                    </div>

                    <div class="card-meta">
                        <span class="badge badge-type">
                            <%# Eval("type") %>
                        </span>

                        <span class='badge <%# GetStatusBadgeClass(Eval("status")?.ToString()) %>'>
                            <%# Eval("status") %>
                        </span>
                    </div>
                </div>

                <div class="card-details">
                    <%# Eval("details") %>
                </div>

                <div class="card-footer">
                    <span>📂 <%# Eval("category") %></span>

                    <span class="stars-display">
                        <%# new string('★', Convert.ToInt32(Eval("rating") ?? 0)) %>
                    </span>

                    <span>🕐 <%# Eval("date_submitted") %></span>
                </div>

                <asp:Panel runat="server"
                    Visible='<%# Eval("admin_response") != DBNull.Value && !string.IsNullOrEmpty(Eval("admin_response")?.ToString()) %>'>

                    <div class="admin-reply-box">
                        <div class="admin-reply-label">
                            💬 Admin Response
                        </div>

                        <div class="admin-reply-text">
                            <%# Eval("admin_response") %>
                        </div>
                    </div>

                </asp:Panel>

            </div>

        </ItemTemplate>
    </asp:Repeater>
</div>

                    </div>
                </div>

            </div>
        </div>

    </asp:Panel>

    <asp:Panel ID="pnlAdmin" runat="server" Visible="false">

        <div class="wrapper">

            <uc:Sidebar ID="SidebarAdmin" runat="server" />

            <div class="main">

                <div class="topbar">
                    <button type="button" class="menu-btn" onclick="document.getElementById('sidebar').classList.toggle('collapsed')">☰</button>
                    <h3>📋 Complaints &amp; Feedback Management</h3>
                    <div></div>
                </div>

                <asp:Label ID="lblAdminError" runat="server" CssClass="msg-error" Visible="false" />
                <asp:Label ID="lblAdminSuccess" runat="server" CssClass="msg-success" Visible="false" />

                <div class="section">
                    <div class="section-title">📋 Submission History</div>

                    <asp:Panel ID="pnlNoSubmissions" runat="server" Visible="false">
                        <div class="empty-state">
                            <span class="empty-icon">📭</span>
                            <p>No submissions found.</p>
                        </div>
                    </asp:Panel>

                    <asp:Repeater ID="rptSubmissions" runat="server" OnItemCommand="rptSubmissions_ItemCommand">
                        <ItemTemplate>
                            <div class="submission-card">

                                <div class="card-header">
                                    <div class="card-subject"><%# Eval("subject") %></div>
                                    <div class="card-meta">
                                        <span class="badge badge-type"><%# Eval("type") %></span>
                                        <span class='badge <%# GetStatusBadgeClass(Eval("status")?.ToString()) %>'>
                                            <%# Eval("status") %>
                                        </span>
                                    </div>
                                </div>

                                <div class="card-details"><%# Eval("details") %></div>

                                <div class="card-footer">
                                    <span>📂 <%# Eval("category") %></span>
                                    <span class="stars-display"><%# new string('★', Convert.ToInt32(Eval("rating") ?? 0)) %></span>
                                    <span>🕐 <%# Eval("date_submitted") %></span>
                                </div>

                                <asp:Panel runat="server"
                                    Visible='<%# Eval("admin_response") != DBNull.Value && !string.IsNullOrEmpty(Eval("admin_response")?.ToString()) %>'>
                                    <div class="admin-reply-box">
                                        <div class="admin-reply-label">💬 Admin Response</div>
                                        <div class="admin-reply-text"><%# Eval("admin_response") %></div>
                                    </div>
                                </asp:Panel>


                                <asp:Panel runat="server"
                                    Visible='<%# Eval("status").ToString() != "Resolved" %>'>
                                    <div class="admin-action-panel">
                                        <div class="admin-action-label">🛡️ Admin – Send Response</div>
                                        w
                                        <asp:TextBox ID="txtReply" runat="server"
                                            TextMode="MultiLine" Rows="2"
                                            placeholder="Type your response here..."
                                            style="border-radius:10px; border:1.5px solid #adc8e5; font-family:inherit;
                                                   font-size:0.93rem; padding:10px 13px; width:100%; resize:vertical; outline:none;" />

                                        <asp:Button ID="btnReply" runat="server"
                                            Text="Send Response"
                                            CommandName="Reply"
                                            CommandArgument='<%# Eval("complaint_id") %>'
                                            CssClass="btn-reply" />
                                    </div>
                                </asp:Panel>

                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                </div>

            </div>
        </div>

    </asp:Panel>

</form>
</body>
</html>