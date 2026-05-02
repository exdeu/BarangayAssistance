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
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
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
        }

        .gridview tr:nth-child(even) td {
            background-color: #f8fafd;
        }

        .gridview tr:hover td {
            background-color: #eef4fb;
            transition: background 0.2s ease;
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
            transition: all 0.3s ease;
        }

        .btn-activate:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
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

            .topbar h3 {
                font-size: 1rem;
            }
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
                                    <asp:Button ID="btnActivate" runat="server"
                                        Text="✔ Activate"
                                        CssClass="btn-activate"
                                        CommandName="ActivateBeneficiary"
                                        CommandArgument='<%# Eval("beneficiary_id") %>'
                                        Visible='<%# Eval("status").ToString() != "Active" %>' />
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