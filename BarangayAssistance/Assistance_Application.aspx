<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Assistance_Application.aspx.cs" Inherits="BarangayAssistance.Assistance_Application" UnobtrusiveValidationMode="None" %>
<%@ Register Src="~/InactivityTimeout.ascx" TagPrefix="uc" TagName="InactivityTimeout" %>
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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(145deg, #f5f7fa 0%, #e9edf2 100%);
            padding: 2rem 1rem;
            min-height: 100vh;
            position: relative;
            display: flex;
            align-items: stretch;
            justify-content: center;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(52,152,219,0.03)" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L0,320Z"></path></svg>') repeat-x bottom;
            pointer-events: none;
            z-index: 0;
        }

        form {
            width: 100%;
            position: relative;
            z-index: 1;
            display: flex;
        }

        .wrap {
            max-width: 720px;
            width: 100%;
            min-height: calc(100vh - 4rem);
            margin: 0 auto;
            display: flex;
            animation: slideUp 0.6s ease-out;
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

        .card {
            width: 100%;
            min-height: 100%;
            display: flex;
            flex-direction: column;
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid rgba(52, 152, 219, 0.2);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08), 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .hdr {
            background: linear-gradient(135deg, #1a364e, #152c40);
            padding: 1.75rem 1.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hdr::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.05) 0%, transparent 70%);
            transform: rotate(30deg);
        }

        .hdr .sub {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: #8ab3cf;
            margin-bottom: 6px;
            position: relative;
            z-index: 1;
        }

        .hdr h1 {
            font-size: 1.8rem;
            color: #ffffff;
            margin-bottom: 6px;
            font-weight: 700;
            letter-spacing: -0.5px;
            position: relative;
            z-index: 1;
        }

        .hdr p {
            font-size: 0.85rem;
            color: #c8dcee;
            position: relative;
            z-index: 1;
        }

        .body {
            padding: 2rem;
            flex: 1;
        }

        .sec {
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: #1a364e;
            margin-bottom: 1.2rem;
            position: relative;
            padding-bottom: 8px;
        }

        .sec::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 3px;
            background: linear-gradient(90deg, #3498db, #5dade2);
            border-radius: 2px;
        }

        .row2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
        }

        .f {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 1.2rem;
        }

        .f label {
            font-size: 0.85rem;
            font-weight: 700;
            color: #2c3e4e;
        }

        .f label span {
            color: #e74c3c;
            margin-left: 3px;
        }

        .f input[type=text],
        .f input[type=number],
        .f input[type=date],
        .f select,
        .f textarea {
            font-size: 0.9rem;
            color: #2c3e4e;
            background: #f8f9fa;
            border: 2px solid #e1e8ed;
            border-radius: 12px;
            padding: 12px 14px;
            outline: none;
            width: 100%;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .f textarea {
            min-height: 140px;
            resize: vertical;
        }

        .f input:focus,
        .f select:focus,
        .f textarea:focus {
            border-color: #3498db;
            background: white;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .f input:hover,
        .f select:hover,
        .f textarea:hover {
            border-color: #b0c4de;
        }

        .f select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='10' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%235d6d7e' stroke-width='2' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            padding-right: 38px;
        }

        .divider {
            height: 1px;
            background: linear-gradient(90deg, transparent, #dde1e7, transparent);
            margin: 1.5rem 0;
        }

        .consent {
            display: flex;
            gap: 12px;
            align-items: flex-start;
            padding: 14px;
            background: #f8f9fa;
            border: 2px solid #e1e8ed;
            border-radius: 12px;
            margin-bottom: 1.2rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .consent:hover {
            border-color: #3498db;
            background: white;
        }

        .consent input[type=checkbox] {
            width: 18px;
            height: 18px;
            margin-top: 2px;
            flex-shrink: 0;
            accent-color: #3498db;
            cursor: pointer;
        }

        .consent span {
            font-size: 0.85rem;
            color: #5d6d7e;
            line-height: 1.5;
        }

        .msg-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            border: 1px solid #28a745;
            color: #155724;
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            margin-bottom: 1.2rem;
            display: block;
            font-weight: 600;
        }

        .msg-error {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            border: 1px solid #dc3545;
            color: #721c24;
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            margin-bottom: 1.2rem;
            display: block;
            font-weight: 600;
        }

        .footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding: 1.2rem 2rem;
            border-top: 1px solid #e1e8ed;
            background: #f8f9fa;
        }

        .btn {
            font-size: 0.85rem;
            font-weight: 700;
            padding: 10px 22px;
            border-radius: 12px;
            cursor: pointer;
            border: 2px solid #dde1e7;
            background: white;
            color: #5d6d7e;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .btn:hover {
            background: #f0f0f0;
            transform: translateY(-2px);
        }

        .btn-primary {
            background: linear-gradient(135deg, #1a364e, #152c40);
            color: white;
            border-color: #1a364e;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #152c40, #0f2333);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .val-error {
            font-size: 11px;
            color: #e74c3c;
            margin-top: 4px;
            font-weight: 600;
        }

        ::-webkit-input-placeholder {
            color: #bdc3c7;
            font-size: 0.85rem;
        }

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

        @media (max-width: 640px) {
            body {
                padding: 1rem;
            }

            .wrap {
                max-width: 100%;
                min-height: calc(100vh - 2rem);
            }

            .body {
                padding: 1.5rem;
            }

            .row2 {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .footer {
                padding: 1rem 1.5rem;
                flex-wrap: wrap;
                justify-content: center;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .hdr h1 {
                font-size: 1.4rem;
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
      <uc:InactivityTimeout ID="InactivityTimeout1" runat="server" />
</form>
</body>
</html>