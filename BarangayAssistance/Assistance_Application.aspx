<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Assistance_Application.aspx.cs" Inherits="BarangayAssistance.Assistance_Application"  UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AssistSys - Assistance Application</title>

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 1.5rem 1rem;
        }

        .wrap { max-width: 700px; margin: 0 auto; }

        .card {
            background: #fff;
            border: 1px solid #dde1e7;
            border-radius: 10px;
            overflow: hidden;
        }

        .hdr {
            background: #1f3b57;
            padding: 1.25rem 1.5rem;
            text-align: center;
        }

        .hdr .sub {
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: #9fc2e3;
            margin-bottom: 4px;
        }

        .hdr h1 {
            font-size: 20px;
            color: #fff;
            margin-bottom: 3px;
        }

        .hdr p {
            font-size: 12px;
            color: #d7e6f5;
        }

        .body { padding: 1.5rem; }

        .sec {
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            color: #888;
            margin-bottom: 0.9rem;
        }

        .row2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        /* ✅ FIX */
        .full-width {
            grid-column: span 2;
        }

        .f {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-bottom: 1rem;
        }

        .f label {
            font-size: 12px;
            font-weight: bold;
            color: #555;
        }

        .f label span {
            color: #c0392b;
        }

        .f input,
        .f select,
        .f textarea {
            width: 100%;
            padding: 10px 11px;
            font-size: 13px;
            background: #f8f9fa;
            border: 1px solid #dde1e7;
            border-radius: 6px;
        }

        .f textarea {
            min-height: 110px;
        }

        .divider {
            height: 1px;
            background: #eee;
            margin: 1.1rem 0;
        }

        .consent {
            display: flex;
            gap: 10px;
            padding: 12px;
            background: #f8f9fa;
            border: 1px solid #dde1e7;
            border-radius: 6px;
        }

        .msg-success {
            background: #eaf3de;
            border: 1px solid #97c459;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 1rem;
        }

        .msg-error {
            background: #fcebeb;
            border: 1px solid #f09595;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 1rem;
        }

        .footer {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            padding: 1rem;
            background: #f8f9fa;
        }

        .btn {
            padding: 9px 18px;
            border-radius: 6px;
            border: 1px solid #ccc;
            cursor: pointer;
        }

        .btn-primary {
            background: #1f3b57;
            color: #fff;
            border-color: #1f3b57;
        }

        @media (max-width: 560px) {
            .row2 { grid-template-columns: 1fr; }
            .full-width { grid-column: span 1; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

<div class="wrap">
<div class="card">

    <div class="hdr">
        <div class="sub">Barangay Assistance System</div>
        <h1>Assistance Application Form</h1>
        <p>Submit your request for review and processing</p>
    </div>

    <div class="body">

        <asp:Label ID="lblSuccess" runat="server" CssClass="msg-success" Visible="false" />
        <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />

        <div class="sec">Applicant Information</div>

        <div class="row2">
            <!-- ✅ FIXED FIELD -->
            <div class="f full-width">
                <label>Beneficiary Type <span>*</span></label>
                <asp:DropDownList ID="ddlBeneficiaryType" runat="server">
                    <asp:ListItem Value="">Select type</asp:ListItem>
                    <asp:ListItem Value="Senior Citizen">Senior Citizen</asp:ListItem>
                    <asp:ListItem Value="PWD">PWD</asp:ListItem>
                    <asp:ListItem Value="Solo Parent">Solo Parent</asp:ListItem>
                    <asp:ListItem Value="Indigent">Indigent</asp:ListItem>
                    <asp:ListItem Value="Displaced Worker">Displaced Worker</asp:ListItem>
                    <asp:ListItem Value="Calamity Victim">Calamity Victim</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="divider"></div>

        <div class="sec">Application Details</div>

        <div class="row2">
            <div class="f">
                <label>Assistance Type <span>*</span></label>
                <asp:DropDownList ID="ddlAssistanceType" runat="server">
                    <asp:ListItem Value="">Select assistance</asp:ListItem>
                    <asp:ListItem>Medical</asp:ListItem>
                    <asp:ListItem>Financial</asp:ListItem>
                    <asp:ListItem>Burial</asp:ListItem>
                    <asp:ListItem>Educational</asp:ListItem>
                    <asp:ListItem>Food</asp:ListItem>
                    <asp:ListItem>Emergency</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="f">
                <label>Preferred Date <span>*</span></label>
                <asp:TextBox ID="txtPreferredDate" runat="server" TextMode="Date" />
            </div>
        </div>

        <div class="row2">
            <div class="f">
                <label>Estimated Amount</label>
                <asp:TextBox ID="txtRequestedAmount" runat="server" TextMode="Number" />
            </div>

            <div class="f">
                <label>Urgency <span>*</span></label>
                <asp:DropDownList ID="ddlUrgency" runat="server">
                    <asp:ListItem Value="">Select urgency</asp:ListItem>
                    <asp:ListItem>Low</asp:ListItem>
                    <asp:ListItem>Moderate</asp:ListItem>
                    <asp:ListItem>High</asp:ListItem>
                    <asp:ListItem>Critical</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="f">
            <label>Reason <span>*</span></label>
            <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" />
        </div>

        <div class="f">
            <label>Additional Notes</label>
            <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" />
        </div>

        <div class="divider"></div>

        <label class="consent">
            <asp:CheckBox ID="chkDeclaration" runat="server" />
            <span>I confirm the information is correct.</span>
        </label>

    </div>

    <div class="footer">
        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
    </div>

</div>
</div>

</form>
</body>
</html>