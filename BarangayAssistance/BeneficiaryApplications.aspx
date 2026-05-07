<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BeneficiaryApplications.aspx.cs" Inherits="BarangayAssistance.BeneficiaryApplications" %>
<%@ Register Src="~/Sidebar.ascx" TagPrefix="uc" TagName="Sidebar" %>

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
            animation: pageFadeIn 0.55s ease-out;
        }

        html {
            scroll-behavior: smooth;
        }

        ::-webkit-scrollbar { width: 10px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #3498db, #1a364e);
            border-radius: 5px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #2980b9, #152c40);
        }

        @keyframes pageFadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-18px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(24px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-18px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes scaleFadeIn {
            from {
                opacity: 0;
                transform: scale(0.97);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes softPulse {
            0% {
                box-shadow: 0 0 0 rgba(52,152,219,0);
            }
            50% {
                box-shadow: 0 0 0 4px rgba(52,152,219,0.08);
            }
            100% {
                box-shadow: 0 0 0 rgba(52,152,219,0);
            }
        }

        .wrapper {
            display: flex;
            min-height: 100vh;
            animation: fadeInLeft 0.55s ease-out;
        }

        .main {
            flex: 1;
            padding: 30px;
            overflow-x: auto;
            animation: fadeInUp 0.65s ease-out;
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
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .topbar:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
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
            transform: translateY(-2px) scale(1.04);
            box-shadow: 0 6px 18px rgba(0,0,0,0.2);
        }

        .menu-btn:active {
            transform: scale(0.96);
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
            animation: scaleFadeIn 0.7s ease-out 0.15s backwards;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .section:hover {
            transform: translateY(-3px);
            box-shadow: 0 14px 34px rgba(0,0,0,0.09);
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 3px solid transparent;
            border-image: linear-gradient(90deg, #3498db, #5dade2) 1;
            animation: fadeInLeft 0.6s ease-out 0.25s backwards;
        }

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 25px;
            animation: fadeInUp 0.6s ease-out 0.3s backwards;
        }

        .search-box {
            padding: 12px 16px;
            border: 2px solid #e1e8ed;
            border-radius: 50px;
            min-width: 280px;
            font-family: inherit;
            outline: none;
            background: white;
            transition: all 0.3s ease;
            color: #2c3e4e;
        }

        .search-box:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.1);
            transform: translateY(-1px);
            animation: softPulse 1.2s ease-in-out;
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
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            font-family: inherit;
        }

        .btn:hover {
            transform: translateY(-2px) scale(1.03);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        .btn:active {
            transform: scale(0.96);
        }

        .btn-outline {
            background: white;
            color: #1a364e;
            border: 2px solid #1a364e;
        }

        .btn-outline:hover {
            background: #f5f7fa;
        }

        .grid-container {
            overflow-x: auto;
            animation: fadeInUp 0.7s ease-out 0.4s backwards;
        }

        .gridview {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
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
            letter-spacing: 0.5px;
        }

        .gridview th:first-child {
            border-radius: 10px 0 0 10px;
        }

        .gridview th:last-child {
            border-radius: 0 10px 10px 0;
        }

        .gridview td {
            padding: 12px;
            border-bottom: 1px solid rgba(52, 152, 219, 0.08);
            font-size: 0.9rem;
            color: #2c3e4e;
            transition: background 0.25s ease, transform 0.25s ease;
        }

        .gridview tr {
            animation: fadeInUp 0.45s ease-out backwards;
        }

        .gridview tr:nth-child(1) { animation-delay: 0.05s; }
        .gridview tr:nth-child(2) { animation-delay: 0.1s; }
        .gridview tr:nth-child(3) { animation-delay: 0.15s; }
        .gridview tr:nth-child(4) { animation-delay: 0.2s; }
        .gridview tr:nth-child(5) { animation-delay: 0.25s; }
        .gridview tr:nth-child(6) { animation-delay: 0.3s; }
        .gridview tr:nth-child(7) { animation-delay: 0.35s; }
        .gridview tr:nth-child(8) { animation-delay: 0.4s; }

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
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .status-active {
            background: #d1e7dd;
            color: #0f5132;
        }

        .status-inactive {
            background: #fff3cd;
            color: #856404;
        }

        .status-active:hover,
        .status-inactive:hover {
            transform: scale(1.06);
            box-shadow: 0 4px 10px rgba(0,0,0,0.12);
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
            transition: all 0.3s ease;
        }

        .btn-activate:hover {
            transform: translateY(-1px) scale(1.04);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .btn-activate:active {
            transform: scale(0.95);
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
            transition: all 0.3s ease;
            margin-right: 6px;
        }

        .btn-details:hover {
            transform: translateY(-1px) scale(1.04);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .btn-details:active {
            transform: scale(0.95);
        }

        .application-details-panel {
            display: none;
            margin-top: 12px;
            padding: 15px;
            background: #f8fafd;
            border: 1px solid rgba(52, 152, 219, 0.18);
            border-left: 5px solid #3498db;
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.04);
            animation: detailsSlideDown 0.35s ease-out;
            transform-origin: top;
        }

        @keyframes detailsSlideDown {
            from {
                opacity: 0;
                transform: translateY(-8px) scaleY(0.96);
            }
            to {
                opacity: 1;
                transform: translateY(0) scaleY(1);
            }
        }

        .application-details-title {
            font-weight: 700;
            color: #1a364e;
            margin-bottom: 12px;
            font-size: 0.95rem;
            animation: fadeInLeft 0.35s ease-out;
        }

        .application-list {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            animation: fadeInUp 0.4s ease-out 0.1s backwards;
        }

        .application-list th {
            background: linear-gradient(135deg, #eef4fb, #dcecf8);
            color: #1a364e;
            padding: 10px;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            text-align: left;
            border-bottom: 1px solid rgba(52, 152, 219, 0.18);
        }

        .application-list td {
            padding: 10px;
            font-size: 0.84rem;
            border-bottom: 1px solid rgba(52, 152, 219, 0.08);
            color: #2c3e4e;
            vertical-align: top;
            transition: background 0.25s ease;
        }

        .application-list tr:nth-child(even) td {
            background: #fafcfe;
        }

        .application-list tr:hover td {
            background: #eef4fb;
        }

        .application-status {
            padding: 4px 10px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-block;
            background: #fff3cd;
            color: #856404;
            transition: transform 0.25s ease;
        }

        .application-status:hover {
            transform: scale(1.06);
        }

        .application-empty {
            padding: 14px;
            background: white;
            border-radius: 10px;
            color: #8899aa;
            font-weight: 600;
            text-align: center;
            border: 1px dashed #c8d8e8;
            animation: fadeInUp 0.35s ease-out;
        }

        .message {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #1a364e;
            font-size: 0.9rem;
            animation: fadeInUp 0.45s ease-out;
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

            .topbar h3 {
                font-size: 1rem;
            }
        }
    </style>

    <script>
        function toggleSidebar() {
            document.getElementById("sidebar").classList.toggle("collapsed");
        }

        function toggleApplicationDetails(panelId, buttonId) {
            var panel = document.getElementById(panelId);
            var button = document.getElementById(buttonId);

            if (!panel) {
                return false;
            }

            if (panel.style.display === "none" || panel.style.display === "") {
                panel.style.display = "block";

                if (button) {
                    button.value = "▲ Hide Applications";
                }
            } else {
                panel.style.display = "none";

                if (button) {
                    button.value = "▼ View Applications";
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
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box"
                        placeholder="Search name, username, contact, type..." />

                    <asp:Button ID="btnSearch" runat="server"
                        Text="🔍 Search" CssClass="btn"
                        OnClick="btnSearch_Click" />

                    <asp:Button ID="btnClear" runat="server"
                        Text="✖ Clear" CssClass="btn btn-outline"
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
                                        value="▼ View Applications"
                                        class="btn-details"
                                        onclick='return toggleApplicationDetails("appDetails_<%# Eval("beneficiary_id") %>", "btnDetails_<%# Eval("beneficiary_id") %>");' />

                                    <asp:Button ID="btnActivate" runat="server"
                                        Text="✔ Activate"
                                        CssClass="btn-activate"
                                        CommandName="ActivateBeneficiary"
                                        CommandArgument='<%# Eval("beneficiary_id") %>'
                                        Visible='<%# Eval("status").ToString() != "Active" %>' />

                                    <div id='appDetails_<%# Eval("beneficiary_id") %>' class="application-details-panel">
                                        <div class="application-details-title">
                                            Assistance Application List
                                        </div>

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

</form>
</body>
</html>