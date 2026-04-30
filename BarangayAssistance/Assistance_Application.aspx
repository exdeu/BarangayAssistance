<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Assistance_Application.aspx.cs" Inherits="BarangayAssistance.Assistance_Application"  UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AssistSys - Assistance Application</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            padding: 1.5rem 1rem;
        }

        .wrap {
            max-width: 700px;
            margin: 0 auto;
        }

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

        .body {
            padding: 1.5rem;
        }

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
            margin-left: 2px;
        }

        .f input[type=text],
        .f input[type=number],
        .f input[type=date],
        .f select,
        .f textarea {
            width: 100%;
            padding: 10px 11px;
            font-size: 13px;
            color: #222;
            background: #f8f9fa;
            border: 1px solid #dde1e7;
            border-radius: 6px;
            outline: none;
            transition: border-color 0.15s;
            font-family: Arial, sans-serif;
        }

        .f input:focus,
        .f select:focus,
        .f textarea:focus {
            border-color: #1f3b57;
            box-shadow: 0 0 0 3px rgba(31,59,87,0.10);
        }

        .f textarea {
            min-height: 110px;
            resize: vertical;
        }

        .f select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23888' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 11px center;
            padding-right: 30px;
        }

        .divider {
            height: 1px;
            background: #eee;
            margin: 1.1rem 0;
        }

        .consent {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            padding: 12px;
            background: #f8f9fa;
            border: 1px solid #dde1e7;
            border-radius: 6px;
            margin-bottom: 1rem;
            cursor: pointer;
        }

        .consent input[type=checkbox] {
            margin-top: 2px;
            accent-color: #1f3b57;
        }

        .consent span {
            font-size: 12px;
            color: #555;
            line-height: 1.6;
        }

        .msg-success {
            background: #eaf3de;
            border: 1px solid #97c459;
            color: #27500a;
            padding: 10px 14px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 1rem;
            display: block;
        }

        .msg-error {
            background: #fcebeb;
            border: 1px solid #f09595;
            color: #791f1f;
            padding: 10px 14px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 1rem;
            display: block;
        }

        .footer {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            padding: 1rem 1.5rem;
            border-top: 1px solid #eee;
            background: #f8f9fa;
        }

        .btn {
            font-size: 13px;
            font-weight: bold;
            padding: 9px 18px;
            border-radius: 6px;
            cursor: pointer;
            border: 1px solid #ccc;
            background: #fff;
            color: #555;
        }

        .btn:hover {
            background: #f0f0f0;
        }

        .btn-primary {
            background: #1f3b57;
            color: #fff;
            border-color: #1f3b57;
        }

        .btn-primary:hover {
            background: #163047;
        }

        .val-error {
            font-size: 11px;
            color: #c0392b;
            margin-top: 2px;
        }

        @media (max-width: 560px) {
            .row2 {
                grid-template-columns: 1fr;
            }
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
                        <div class="f">
                            <label>Full Name <span>*</span></label>
                            <asp:TextBox ID="txtFullName" runat="server" placeholder="Enter full name" />
                            <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                                ControlToValidate="txtFullName"
                                ErrorMessage="Full name is required."
                                CssClass="val-error" Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>Reference Number</label>
                            <asp:TextBox ID="txtReferenceNo" runat="server" placeholder="Optional reference number" />
                        </div>
                    </div>

                    <div class="row2">
                        <div class="f">
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
                            <asp:RequiredFieldValidator ID="rfvBeneficiaryType" runat="server"
                                ControlToValidate="ddlBeneficiaryType"
                                InitialValue=""
                                ErrorMessage="Please select a beneficiary type."
                                CssClass="val-error" Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>Contact Number <span>*</span></label>
                            <asp:TextBox ID="txtContactNumber" runat="server" placeholder="09XXXXXXXXX" />
                            <asp:RequiredFieldValidator ID="rfvContactNumber" runat="server"
                                ControlToValidate="txtContactNumber"
                                ErrorMessage="Contact number is required."
                                CssClass="val-error" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div class="sec">Application Details</div>

                    <div class="row2">
                        <div class="f">
                            <label>Assistance Type <span>*</span></label>
                            <asp:DropDownList ID="ddlAssistanceType" runat="server">
                                <asp:ListItem Value="">Select assistance</asp:ListItem>
                                <asp:ListItem Value="Medical">Medical Assistance</asp:ListItem>
                                <asp:ListItem Value="Financial">Financial Assistance</asp:ListItem>
                                <asp:ListItem Value="Burial">Burial Assistance</asp:ListItem>
                                <asp:ListItem Value="Educational">Educational Assistance</asp:ListItem>
                                <asp:ListItem Value="Food">Food Assistance</asp:ListItem>
                                <asp:ListItem Value="Emergency">Emergency Assistance</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvAssistanceType" runat="server"
                                ControlToValidate="ddlAssistanceType"
                                InitialValue=""
                                ErrorMessage="Please select an assistance type."
                                CssClass="val-error" Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>Preferred Date <span>*</span></label>
                            <asp:TextBox ID="txtPreferredDate" runat="server" TextMode="Date" />
                            <asp:RequiredFieldValidator ID="rfvPreferredDate" runat="server"
                                ControlToValidate="txtPreferredDate"
                                ErrorMessage="Preferred date is required."
                                CssClass="val-error" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="row2">
                        <div class="f">
                            <label>Estimated Amount Requested</label>
                            <asp:TextBox ID="txtRequestedAmount" runat="server" TextMode="Number" placeholder="0.00" />
                        </div>

                        <div class="f">
                            <label>Urgency Level <span>*</span></label>
                            <asp:DropDownList ID="ddlUrgency" runat="server">
                                <asp:ListItem Value="">Select urgency</asp:ListItem>
                                <asp:ListItem Value="Low">Low</asp:ListItem>
                                <asp:ListItem Value="Moderate">Moderate</asp:ListItem>
                                <asp:ListItem Value="High">High</asp:ListItem>
                                <asp:ListItem Value="Critical">Critical</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvUrgency" runat="server"
                                ControlToValidate="ddlUrgency"
                                InitialValue=""
                                ErrorMessage="Please select urgency level."
                                CssClass="val-error" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="f">
                        <label>Reason for Application <span>*</span></label>
                        <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" placeholder="State the reason for your request" />
                        <asp:RequiredFieldValidator ID="rfvReason" runat="server"
                            ControlToValidate="txtReason"
                            ErrorMessage="Reason is required."
                            CssClass="val-error" Display="Dynamic" />
                    </div>

                    <div class="f">
                        <label>Additional Notes</label>
                        <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" placeholder="Add extra information if needed" />
                    </div>

                    <div class="divider"></div>

                    <label class="consent">
                        <asp:CheckBox ID="chkDeclaration" runat="server" />
                        <span>I certify that the information in this application is true and correct, and I understand that it will be subject to verification and approval.</span>
                    </label>

                    <asp:CustomValidator ID="cvDeclaration" runat="server"
                        OnServerValidate="cvDeclaration_ServerValidate"
                        ErrorMessage="You must agree to the declaration before submitting."
                        CssClass="val-error" Display="Dynamic" />
                </div>
                    <div class="footer">
                        <asp:Button ID="btnBack" runat="server" 
                            Text="← Back to Dashboard" 
                            CssClass="btn"
                            CausesValidation="false"
                            OnClick="btnBack_Click" />
                        <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn"
                            CausesValidation="false" OnClick="btnClear_Click" />
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit Application" CssClass="btn btn-primary"
                            OnClick="btnSubmit_Click" />
                    </div>
            </div>
        </div>
    </form>
</body>
</html>