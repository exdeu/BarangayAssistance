<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Transactions.aspx.cs" Inherits="BarangayAssistance.Transactions" %>
<%@ Register Src="~/Sidebar.ascx" TagPrefix="uc" TagName="Sidebar" %>
<%@ Register Src="~/InactivityTimeout.ascx" TagPrefix="uc" TagName="InactivityTimeout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Transactions - AssistSys</title>
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

        .navbar {
            background: rgba(26,54,78,0.95);
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
            color: white;
        }

        .public-nav-links a {
            color: #ecf0f1;
            text-decoration: none;
            margin-left: 2rem;
            font-size: 1rem;
            font-weight: 500;
        }

        .public-nav-links a:hover { color: #5dade2; }

        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        .public-wrapper {
            display: block;
            min-height: 100vh;
        }

        .main {
            flex: 1;
            padding: 30px;
            overflow-x: auto;
        }

        .public-main {
            padding: 40px 5%;
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
            border: 1px solid rgba(52,152,219,0.1);
            margin-top: 20px;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 3px solid #3498db;
        }

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }

        .search-box {
            padding: 12px 16px;
            border: 2px solid #e1e8ed;
            border-radius: 50px;
            min-width: 240px;
            font-family: inherit;
            outline: none;
            background: white;
            color: #2c3e4e;
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
            font-family: inherit;
        }

        .btn-outline {
            background: white;
            color: #1a364e;
            border: 2px solid #1a364e;
        }

        .grid-container { overflow-x: auto; }

        .gridview {
            width: 100%;
            border-collapse: collapse;
            min-width: 1200px;
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
        }

        .gridview td {
            padding: 12px;
            border-bottom: 1px solid rgba(52,152,219,0.08);
            font-size: 0.9rem;
            color: #2c3e4e;
            vertical-align: top;
        }

        .gridview tr:nth-child(even) td { background-color: #f8fafd; }
        .gridview tr:hover td { background-color: #eef4fb; }

        .status-pending,
        .status-approved,
        .status-rejected,
        .status-released {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.78rem;
            font-weight: 700;
            display: inline-block;
        }

        .status-pending { background: #fff3cd; color: #856404; }
        .status-approved { background: #d1e7dd; color: #0f5132; }
        .status-rejected { background: #f8d7da; color: #842029; }
        .status-released { background: #cff4fc; color: #055160; }

        .btn-details,
        .btn-approve,
        .btn-reject {
            color: white;
            border: none;
            padding: 7px 15px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            margin-right: 5px;
            margin-bottom: 6px;
            font-family: inherit;
        }

        .btn-details { background: linear-gradient(135deg, #6c757d, #495057); }
        .btn-approve { background: linear-gradient(135deg, #198754, #157347); }
        .btn-reject { background: linear-gradient(135deg, #dc3545, #bb2d3b); }

        .transaction-details-panel {
            display: none;
            margin-top: 12px;
            padding: 16px;
            background: #f8fafd;
            border: 1px solid rgba(52,152,219,0.18);
            border-left: 5px solid #3498db;
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
        }

        .details-title {
            font-weight: 800;
            color: #1a364e;
            margin-bottom: 12px;
            font-size: 0.95rem;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 12px;
            margin-bottom: 18px;
        }

        .detail-card {
            background: white;
            border: 1px solid #dcecf8;
            border-radius: 12px;
            padding: 12px;
            margin-bottom: 14px;
        }

        .detail-label {
            display: block;
            font-size: 0.72rem;
            font-weight: 800;
            color: #7f8c8d;
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .detail-value {
            font-size: 0.9rem;
            font-weight: 700;
            color: #1a364e;
            word-break: break-word;
        }

        .document-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .document-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: white;
            color: #1a364e;
            border: 1px solid #c8e4fb;
            border-radius: 12px;
            padding: 10px 12px;
            text-decoration: none;
            font-size: 0.84rem;
            font-weight: 700;
            word-break: break-word;
        }

        .document-link:hover { background: #eef4fb; }

        .document-empty {
            padding: 14px;
            background: white;
            border-radius: 10px;
            color: #8899aa;
            font-weight: 600;
            text-align: center;
            border: 1px dashed #c8d8e8;
        }

        .message {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #1a364e;
            font-size: 0.9rem;
        }

        @media (max-width: 900px) {
            .main,
            .public-main { padding: 15px; }

            .actions { flex-direction: column; }

            .search-box {
                width: 100%;
                min-width: 100%;
            }

            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .navbar {
                flex-direction: column;
                gap: 10px;
            }

            .public-nav-links {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 12px;
            }

            .public-nav-links a {
                margin-left: 0;
            }
        }
    </style>

    <script>
        function toggleSidebar() {
            var sidebar = document.getElementById("sidebar");

            if (sidebar) {
                sidebar.classList.toggle("collapsed");
            }
        }

        function toggleTransactionDetails(panelId, buttonId) {
            var panel = document.getElementById(panelId);
            var button = document.getElementById(buttonId);

            if (!panel) {
                return false;
            }

            if (panel.style.display === "none" || panel.style.display === "") {
                panel.style.display = "block";

                if (button) {
                    button.value = "▲ Hide Details";
                }
            } else {
                panel.style.display = "none";

                if (button) {
                    button.value = "▼ View Details";
                }
            }

            return false;
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
                <a href="Transactions.aspx">Transactions</a>
                <a href="Contact.aspx">About Us</a>
                <a href="Feedback.aspx">Feedback</a>
            </div>
        </div>
    </asp:Panel>

    <div class='<%= IsPublicView() ? "public-wrapper" : "wrapper" %>'>

        <asp:Panel ID="pnlSidebar" runat="server" Visible="false">
            <uc:Sidebar ID="Sidebar" runat="server" />
        </asp:Panel>

        <div class='<%= IsPublicView() ? "public-main" : "main" %>'>

            <asp:Panel ID="pnlTopbar" runat="server" Visible="false">
                <div class="topbar">
                    <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                    <h3>📋 Assistance Transactions</h3>
                    <asp:Label ID="lblWelcome" runat="server"></asp:Label>
                </div>
            </asp:Panel>

            <div class="section">
                <div class="section-title">Transaction Records</div>

                <div class="actions">
                    <asp:TextBox ID="txtSearch" runat="server"
                        CssClass="search-box"
                        placeholder="Search name, assistance type, status..." />

                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="search-box">
                        <asp:ListItem Text="All Status" Value="" />
                        <asp:ListItem Text="Pending" Value="Pending" />
                        <asp:ListItem Text="Approved" Value="Approved" />
                        <asp:ListItem Text="Rejected" Value="Rejected" />
                        <asp:ListItem Text="Released" Value="Released" />
                    </asp:DropDownList>

                    <asp:DropDownList ID="ddlAssistanceType" runat="server" CssClass="search-box">
                        <asp:ListItem Text="All Assistance Types" Value="" />
                        <asp:ListItem Text="Medical" Value="Medical" />
                        <asp:ListItem Text="Financial" Value="Financial" />
                        <asp:ListItem Text="Burial" Value="Burial" />
                        <asp:ListItem Text="Educational" Value="Educational" />
                        <asp:ListItem Text="Food" Value="Food" />
                        <asp:ListItem Text="Emergency" Value="Emergency" />
                    </asp:DropDownList>

                    <asp:Button ID="btnSearch" runat="server"
                        Text="🔍 Search"
                        CssClass="btn"
                        OnClick="btnSearch_Click" />

                    <asp:Button ID="btnClear" runat="server"
                        Text="✖ Clear"
                        CssClass="btn btn-outline"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />
                </div>

                <div class="grid-container">
                    <asp:GridView ID="gvTransactions" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="gridview"
                        GridLines="None"
                        EmptyDataText="No transaction records found."
                        OnRowCommand="gvTransactions_RowCommand">

                        <Columns>
                            <asp:BoundField DataField="application_id" HeaderText="Application ID" />
                            <asp:BoundField DataField="full_name" HeaderText="Beneficiary" />
                            <asp:BoundField DataField="assistance_type" HeaderText="Assistance Type" />
                            <asp:BoundField DataField="preferred_date" HeaderText="Preferred Date" DataFormatString="{0:MMM dd, yyyy}" />
                            <asp:BoundField DataField="estimated_amount_requested" HeaderText="Amount" DataFormatString="₱{0:N2}" />
                            <asp:BoundField DataField="urgency_level" HeaderText="Urgency" />
                            <asp:BoundField DataField="date_submitted" HeaderText="Date Submitted" DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='<%# GetStatusClass(Eval("status")) %>'>
                                        <%# Eval("status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <input type="button"
                                        id='btnDetails_<%# Eval("application_id") %>'
                                        value="▼ View Details"
                                        class="btn-details"
                                        onclick='return toggleTransactionDetails("transactionDetails_<%# Eval("application_id") %>", "btnDetails_<%# Eval("application_id") %>");' />

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

                                    <div id='transactionDetails_<%# Eval("application_id") %>' class="transaction-details-panel">
                                        <div class="details-title">Application Details</div>

                                        <div class="details-grid">
                                            <div class="detail-card">
                                                <span class="detail-label">Application ID</span>
                                                <span class="detail-value"><%# Eval("application_id") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Beneficiary</span>
                                                <span class="detail-value"><%# Eval("full_name") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Username</span>
                                                <span class="detail-value"><%# Eval("username") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Beneficiary Type</span>
                                                <span class="detail-value"><%# Eval("beneficiary_type") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Contact Number</span>
                                                <span class="detail-value"><%# Eval("contact_number") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Assistance Type</span>
                                                <span class="detail-value"><%# Eval("assistance_type") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Preferred Date</span>
                                                <span class="detail-value"><%# Eval("preferred_date") == DBNull.Value ? "N/A" : Eval("preferred_date", "{0:MMM dd, yyyy}") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Amount Requested</span>
                                                <span class="detail-value"><%# Eval("estimated_amount_requested") == DBNull.Value ? "N/A" : Eval("estimated_amount_requested", "₱{0:N2}") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Urgency</span>
                                                <span class="detail-value"><%# Eval("urgency_level") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Status</span>
                                                <span class="detail-value"><%# Eval("status") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Date Submitted</span>
                                                <span class="detail-value"><%# Eval("date_submitted") == DBNull.Value ? "N/A" : Eval("date_submitted", "{0:MMM dd, yyyy hh:mm tt}") %></span>
                                            </div>

                                            <div class="detail-card">
                                                <span class="detail-label">Date Updated</span>
                                                <span class="detail-value"><%# Eval("date_updated") == DBNull.Value ? "N/A" : Eval("date_updated", "{0:MMM dd, yyyy hh:mm tt}") %></span>
                                            </div>
                                        </div>

                                        <div class="details-title">Reason for Application</div>
                                        <div class="detail-card">
                                            <%# Eval("reason_for_application") == DBNull.Value || string.IsNullOrWhiteSpace(Eval("reason_for_application").ToString()) ? "N/A" : Eval("reason_for_application") %>
                                        </div>

                                        <div class="details-title">Additional Notes</div>
                                        <div class="detail-card">
                                            <%# Eval("additional_notes") == DBNull.Value || string.IsNullOrWhiteSpace(Eval("additional_notes").ToString()) ? "N/A" : Eval("additional_notes") %>
                                        </div>

                                        <div class="details-title">Supporting Documents</div>

                                        <asp:Repeater ID="rptApplicationDocuments" runat="server"
                                            DataSource='<%# GetApplicationDocuments(Eval("username"), Eval("application_id")) %>'>
                                            <HeaderTemplate>
                                                <div class="document-list">
                                            </HeaderTemplate>

                                            <ItemTemplate>
                                                <a class="document-link" href='<%# Eval("FileUrl") %>' target="_blank">
                                                    📄 <%# Eval("FileName") %>
                                                </a>
                                            </ItemTemplate>

                                            <FooterTemplate>
                                                </div>
                                            </FooterTemplate>
                                        </asp:Repeater>

                                        <asp:Panel ID="pnlNoApplicationDocuments" runat="server"
                                            Visible='<%# GetApplicationDocumentCount(Eval("username"), Eval("application_id")) == 0 %>'>
                                            <div class="document-empty">
                                                No supporting documents uploaded for this application.
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="message" />
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlTimeout" runat="server" Visible="false">
        <uc:InactivityTimeout ID="InactivityTimeout1" runat="server" />
    </asp:Panel>

</form>
</body>
</html>