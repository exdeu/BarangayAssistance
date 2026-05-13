<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BeneficiaryApplications.aspx.cs" Inherits="BarangayAssistance.BeneficiaryApplications" %>
<%@ Register Src="~/Sidebar.ascx" TagPrefix="uc" TagName="Sidebar" %>
<%@ Register Src="~/InactivityTimeout.ascx" TagPrefix="uc" TagName="InactivityTimeout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Beneficiary Applications - AssistSys</title>
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

        .grid-container {
            overflow-x: auto;
        }

        .gridview {
            width: 100%;
            border-collapse: collapse;
            min-width: 1100px;
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
            border-bottom: 1px solid rgba(52, 152, 219, 0.08);
            font-size: 0.9rem;
            color: #2c3e4e;
            vertical-align: top;
        }

        .gridview tr:nth-child(even) td {
            background-color: #f8fafd;
        }

        .gridview tr:hover td {
            background-color: #eef4fb;
        }

        .status-active,
        .status-inactive {
            padding: 4px 12px;
            border-radius: 50px;
            font-size: 0.78rem;
            font-weight: 700;
            display: inline-block;
        }

        .status-active {
            background: #d1e7dd;
            color: #0f5132;
        }

        .status-inactive {
            background: #fff3cd;
            color: #856404;
        }

        .btn-activate {
            background: linear-gradient(135deg, #198754, #157347);
            color: white;
            border: none;
            padding: 7px 15px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            font-family: inherit;
        }

        .btn-details {
            background: linear-gradient(135deg, #6c757d, #495057);
            color: white;
            border: none;
            padding: 7px 15px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            font-family: inherit;
            margin-right: 6px;
            margin-bottom: 6px;
        }

        .details-panel {
            display: none;
            margin-top: 12px;
            padding: 18px;
            background: #f8fafd;
            border: 1px solid rgba(52, 152, 219, 0.18);
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

        .beneficiary-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 12px;
            margin-bottom: 20px;
        }

        .info-card {
            background: white;
            border: 1px solid #dcecf8;
            border-radius: 12px;
            padding: 12px;
        }

        .info-label {
            display: block;
            font-size: 0.72rem;
            font-weight: 800;
            color: #7f8c8d;
            text-transform: uppercase;
            margin-bottom: 4px;
        }

        .info-value {
            font-size: 0.9rem;
            font-weight: 700;
            color: #1a364e;
        }

        .document-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
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
        }

        .document-link:hover {
            background: #eef4fb;
        }

        .document-empty,
        .application-empty {
            padding: 14px;
            background: white;
            border-radius: 10px;
            color: #8899aa;
            font-weight: 600;
            text-align: center;
            border: 1px dashed #c8d8e8;
            margin-bottom: 15px;
        }

        .application-list {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        .application-list th {
            background: linear-gradient(135deg, #eef4fb, #dcecf8);
            color: #1a364e;
            padding: 10px;
            font-size: 0.78rem;
            text-transform: uppercase;
            text-align: left;
            border-bottom: 1px solid rgba(52, 152, 219, 0.18);
        }

        .application-list td {
            padding: 10px;
            font-size: 0.84rem;
            border-bottom: 1px solid rgba(52, 152, 219, 0.08);
            color: #2c3e4e;
            vertical-align: top;
        }

        .application-status {
            padding: 4px 10px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-block;
            background: #fff3cd;
            color: #856404;
        }

        .message {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #1a364e;
            font-size: 0.9rem;
        }

        @media (max-width: 900px) {
            .main {
                padding: 15px;
            }

            .actions {
                flex-direction: column;
            }

            .search-box {
                width: 100%;
                min-width: 100%;
            }

            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>

    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("collapsed");
        }

        function toggleBeneficiaryDetails(panelId, buttonId) {
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
    <div class="wrapper">
        <uc:Sidebar ID="Sidebar" runat="server" />

        <div class="main">
            <div class="topbar">
                <button type="button" class="menu-btn" onclick="toggleSidebar()">☰</button>
                <h3>👥 Beneficiary Accounts</h3>
                <asp:Label ID="lblWelcome" runat="server"></asp:Label>
            </div>

            <div class="section">
                <div class="section-title">Beneficiary Accounts</div>

                <div class="actions">
                    <asp:TextBox ID="txtSearch" runat="server"
                        CssClass="search-box"
                        placeholder="Search name, username, contact..." />

                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="search-box">
                        <asp:ListItem Text="All Status" Value="" />
                        <asp:ListItem Text="Active" Value="Active" />
                        <asp:ListItem Text="Inactive" Value="Inactive" />
                    </asp:DropDownList>

                    <asp:DropDownList ID="ddlBeneficiaryType" runat="server" CssClass="search-box">
                        <asp:ListItem Text="All Beneficiary Types" Value="" />
                        <asp:ListItem Text="Senior Citizen" Value="Senior Citizen" />
                        <asp:ListItem Text="PWD" Value="PWD" />
                        <asp:ListItem Text="Solo Parent" Value="Solo Parent" />
                        <asp:ListItem Text="Indigent Family" Value="Indigent" />
                        <asp:ListItem Text="Displaced Worker" Value="Displaced Worker" />
                        <asp:ListItem Text="Calamity Victim" Value="Calamity Victim" />
                    </asp:DropDownList>

                    <asp:DropDownList ID="ddlSex" runat="server" CssClass="search-box">
                        <asp:ListItem Text="All Sex" Value="" />
                        <asp:ListItem Text="Male" Value="Male" />
                        <asp:ListItem Text="Female" Value="Female" />
                    </asp:DropDownList>

                    <asp:DropDownList ID="ddlCivilStatus" runat="server" CssClass="search-box">
                        <asp:ListItem Text="All Civil Status" Value="" />
                        <asp:ListItem Text="Single" Value="Single" />
                        <asp:ListItem Text="Married" Value="Married" />
                        <asp:ListItem Text="Widowed" Value="Widowed" />
                        <asp:ListItem Text="Separated" Value="Separated" />
                    </asp:DropDownList>

                    <asp:Button ID="btnSearch" runat="server"
                        Text="🔍 Search"
                        CssClass="btn"
                        OnClick="btnSearch_Click" />

                    <asp:Button ID="btnClear" runat="server"
                        Text="✖ Clear"
                        CssClass="btn btn-outline"
                        OnClick="btnClear_Click" />
                </div>

                <div class="grid-container">
                    <asp:GridView ID="gvBeneficiaries" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="gridview"
                        GridLines="None"
                        EmptyDataText="No beneficiary records found."
                        OnRowCommand="gvBeneficiaries_RowCommand">

                        <Columns>
                            <asp:BoundField DataField="beneficiary_id" HeaderText="ID" />
                            <asp:BoundField DataField="username" HeaderText="Username" />
                            <asp:BoundField DataField="full_name" HeaderText="Full Name" />
                            <asp:BoundField DataField="contact_number" HeaderText="Contact" />
                            <asp:BoundField DataField="beneficiary_type" HeaderText="Type" />
                            <asp:BoundField DataField="purok_street" HeaderText="Address" />
                            <asp:BoundField DataField="date_registered" HeaderText="Date Registered" DataFormatString="{0:MMM dd, yyyy}" />

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='<%# Eval("status").ToString() == "Active" ? "status-active" : "status-inactive" %>'>
                                        <%# Eval("status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <input type="button"
                                        id='btnDetails_<%# Eval("beneficiary_id") %>'
                                        value="▼ View Details"
                                        class="btn-details"
                                        onclick='return toggleBeneficiaryDetails("beneficiaryDetails_<%# Eval("beneficiary_id") %>", "btnDetails_<%# Eval("beneficiary_id") %>");' />

                                    <asp:Button ID="btnActivate" runat="server"
                                        Text="✔ Activate"
                                        CssClass="btn-activate"
                                        CommandName="ActivateBeneficiary"
                                        CommandArgument='<%# Eval("beneficiary_id") %>'
                                        Visible='<%# Eval("status").ToString() != "Active" %>' />

                                    <div id='beneficiaryDetails_<%# Eval("beneficiary_id") %>' class="details-panel">
                                        <div class="details-title">Beneficiary Information</div>

                                        <div class="beneficiary-info-grid">
                                            <div class="info-card">
                                                <span class="info-label">Full Name</span>
                                                <span class="info-value"><%# Eval("full_name") %></span>
                                            </div>

                                            <div class="info-card">
                                                <span class="info-label">Email</span>
                                                <span class="info-value"><%# Eval("email") %></span>
                                            </div>

                                            <div class="info-card">
                                                <span class="info-label">Date of Birth</span>
                                                <span class="info-value"><%# Eval("date_of_birth", "{0:MMM dd, yyyy}") %></span>
                                            </div>

                                            <div class="info-card">
                                                <span class="info-label">Age</span>
                                                <span class="info-value"><%# Eval("age") %></span>
                                            </div>

                                            <div class="info-card">
                                                <span class="info-label">Sex</span>
                                                <span class="info-value"><%# Eval("sex") %></span>
                                            </div>

                                            <div class="info-card">
                                                <span class="info-label">Civil Status</span>
                                                <span class="info-value"><%# Eval("civil_status") %></span>
                                            </div>
                                            <div class="info-card">
                                                <span class="info-label">Monthly Income</span>
                                                <span class="info-value"><%# Eval("monthly_income") == DBNull.Value ? "N/A" : Eval("monthly_income", "{0:N2}") %></span>
                                            </div>
                                        </div>

                                        <div class="details-title">Uploaded Documents</div>

                                        <asp:Repeater ID="rptDocuments" runat="server"
                                            DataSource='<%# GetBeneficiaryDocuments(Eval("username")) %>'>
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

                                        <asp:Panel ID="pnlNoDocuments" runat="server"
                                            Visible='<%# GetBeneficiaryDocumentCount(Eval("username")) == 0 %>'>
                                            <div class="document-empty">
                                                No uploaded documents found for this beneficiary.
                                            </div>
                                        </asp:Panel>

                                        <div class="details-title">Assistance Application List</div>

                                        <asp:Repeater ID="rptApplications" runat="server"
                                            DataSource='<%# GetAssistanceApplications(Eval("beneficiary_id")) %>'>
                                            <HeaderTemplate>
                                                <table class="application-list">
                                                    <thead>
                                                        <tr>
                                                            <th>Application ID</th>
                                                            <th>Assistance Type</th>
                                                            <th>Preferred Date</th>
                                                            <th>Amount</th>
                                                            <th>Urgency</th>
                                                            <th>Reason</th>
                                                            <th>Notes</th>
                                                            <th>Status</th>
                                                            <th>Date Submitted</th>
                                                            <th>Date Updated</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                            </HeaderTemplate>

                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("application_id") %></td>
                                                    <td><%# Eval("assistance_type") %></td>
                                                    <td><%# Eval("preferred_date", "{0:MMM dd, yyyy}") %></td>
                                                    <td><%# Eval("estimated_amount_requested") == DBNull.Value ? "N/A" : Eval("estimated_amount_requested", "{0:N2}") %></td>
                                                    <td><%# Eval("urgency_level") %></td>
                                                    <td><%# Eval("reason_for_application") %></td>
                                                    <td><%# Eval("additional_notes") == DBNull.Value || string.IsNullOrWhiteSpace(Eval("additional_notes").ToString()) ? "N/A" : Eval("additional_notes") %></td>
                                                    <td>
                                                        <span class="application-status">
                                                            <%# Eval("status") %>
                                                        </span>
                                                    </td>
                                                    <td><%# Eval("date_submitted", "{0:MMM dd, yyyy hh:mm tt}") %></td>
                                                    <td><%# Eval("date_updated") == DBNull.Value ? "N/A" : Eval("date_updated", "{0:MMM dd, yyyy hh:mm tt}") %></td>
                                                </tr>
                                            </ItemTemplate>

                                            <FooterTemplate>
                                                    </tbody>
                                                </table>
                                            </FooterTemplate>
                                        </asp:Repeater>

                                        <asp:Panel ID="pnlNoApplications" runat="server"
                                            Visible='<%# GetAssistanceApplicationCount(Eval("beneficiary_id")) == 0 %>'>
                                            <div class="application-empty">
                                                No assistance applications found for this beneficiary.
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

    <uc:InactivityTimeout ID="InactivityTimeout1" runat="server" />
</form>
</body>
</html>