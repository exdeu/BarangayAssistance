<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="BarangayAssistance.Register" UnobtrusiveValidationMode="None" %>
<%@ Register Src="~/VerifyOtp.ascx" TagPrefix="uc" TagName="VerifyOtp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AssistSys - Beneficiary Registration</title>

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
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(52,152,219,0.03)" fill-opacity="1" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,154.7C960,171,1056,181,1152,165.3C1248,149,1344,107,1392,85.3L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') repeat-x bottom;
            pointer-events: none;
            z-index: 0;
        }

        .wrap {
            max-width: 720px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
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
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid rgba(52, 152, 219, 0.2);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08), 0 5px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0,0,0,0.12);
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

        .hdr .brgy {
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: #8ab3cf;
            margin-bottom: 6px;
        }

        .hdr h1 {
            font-size: 1.8rem;
            color: #ffffff;
            margin-bottom: 6px;
            font-weight: 700;
            letter-spacing: -0.5px;
        }

        .hdr p {
            font-size: 0.85rem;
            color: #c8dcee;
        }

        .body {
            padding: 2rem;
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
        .f input[type=password],
        .f input[type=tel],
        .f input[type=number],
        .f input[type=date],
        .f input[type=email],
        .f input[type=file],
        .f select {
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

        .f input:focus,
        .f select:focus {
            border-color: #3498db;
            background: white;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.1);
        }

        .f input:hover,
        .f select:hover {
            border-color: #b0c4de;
        }

        .f select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='10' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%235d6d7e' stroke-width='2' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            padding-right: 38px;
        }

        .row2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
        }

        .radio-row {
            display: flex;
            gap: 12px;
            margin-top: 5px;
        }

        .ropt {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 11px 14px;
            border: 2px solid #e1e8ed;
            border-radius: 12px;
            background: #f8f9fa;
            cursor: pointer;
            font-size: 0.9rem;
            color: #2c3e4e;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .ropt:hover {
            border-color: #3498db;
            background: white;
        }

        .ropt input[type=radio] {
            width: 16px;
            height: 16px;
            accent-color: #3498db;
            cursor: pointer;
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
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn:hover {
            background: #f0f0f0;
            transform: translateY(-2px);
        }

        .btn-primary,
        .btn-home {
            background: linear-gradient(135deg, #1a364e, #152c40);
            color: white;
            border-color: #1a364e;
        }

        .btn-primary:hover,
        .btn-home:hover {
            background: linear-gradient(135deg, #152c40, #0f2333);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .val-error {
            font-size: 11px;
            color: #e74c3c;
            margin-top: 4px;
            font-weight: 600;
        }

        .hint {
            font-size: 11px;
            color: #7f8c8d;
            margin-top: 2px;
            line-height: 1.4;
        }

        .f input[readonly] {
            background: #eef4fb;
            color: #1a364e;
            cursor: not-allowed;
            border-color: #b0c4de;
        }

        .upload-group {
            margin-bottom: 1.2rem;
        }

        .upload-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 700;
            color: #2c3e4e;
            margin-bottom: 8px;
        }

        .upload-label span {
            color: #e74c3c;
            margin-left: 3px;
        }

        .upload-wrapper {
            position: relative;
            border: 2px dashed #3498db;
            border-radius: 16px;
            padding: 28px 20px;
            background: linear-gradient(135deg, #f8fbff, #eef6ff);
            text-align: center;
            transition: all 0.3s ease;
            overflow: hidden;
            cursor: pointer;
        }

        .upload-wrapper:hover {
            border-color: #1a364e;
            background: linear-gradient(135deg, #ffffff, #eef6ff);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.14);
        }

        .custom-file-upload {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
            z-index: 2;
        }

        .upload-info {
            pointer-events: none;
        }

        .upload-icon {
            width: 58px;
            height: 58px;
            margin: 0 auto 12px;
            border-radius: 18px;
            background: linear-gradient(135deg, #1a364e, #3498db);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 18px rgba(26, 54, 78, 0.25);
        }

        .upload-icon svg {
            width: 30px;
            height: 30px;
            display: block;
        }

        .upload-text {
            display: block;
            font-size: 0.95rem;
            font-weight: 800;
            color: #1a364e;
            margin-bottom: 5px;
        }

        .upload-note {
            display: block;
            font-size: 0.78rem;
            color: #6f7f8f;
            line-height: 1.4;
        }

        .selected-file {
            display: none;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
            padding: 10px 12px;
            border-radius: 12px;
            background: #eef7ff;
            border: 1px solid #c8e4fb;
            color: #1a364e;
            font-size: 0.82rem;
            font-weight: 700;
            word-break: break-word;
        }

        .selected-file.show {
            display: flex;
        }

        .selected-file-icon {
            width: 24px;
            height: 24px;
            border-radius: 8px;
            background: #1a364e;
            color: white;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 13px;
        }

        .otp-modal {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 99999;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }

        .otp-box {
            background: white;
            width: 380px;
            max-width: 100%;
            padding: 30px;
            border-radius: 18px;
            text-align: center;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
            animation: slideUp 0.35s ease-out;
        }

        .otp-box h2 {
            margin-bottom: 15px;
            color: #1a364e;
        }

        .otp-box p {
            margin-bottom: 20px;
            color: #5d6d7e;
        }

        .otp-input {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: 2px solid #dde1e7;
            margin-bottom: 20px;
            font-family: inherit;
            font-size: 0.95rem;
            outline: none;
            text-align: center;
            letter-spacing: 4px;
        }

        .otp-input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.1);
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
            .wrap {
                max-width: 100%;
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

            .hdr h1 {
                font-size: 1.4rem;
            }
        }

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
    </style>

    <script>
        function calculateAge(dateValue) {
            if (!dateValue) return;

            var today = new Date();
            var birthDate = new Date(dateValue);
            var age = today.getFullYear() - birthDate.getFullYear();
            var monthDiff = today.getMonth() - birthDate.getMonth();

            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }

            if (age < 0 || age > 120) {
                document.getElementById('<%= txtAge.ClientID %>').value = '';
                return;
            }

            document.getElementById('<%= txtAge.ClientID %>').value = age;
        }

        function showSelectedFileName(fileInput) {
            var fileNameBox = document.getElementById('selectedFileName');
            var fileNameText = document.getElementById('selectedFileText');

            if (fileInput.files && fileInput.files.length > 0) {
                fileNameText.innerText = fileInput.files[0].name;
                fileNameBox.classList.add('show');
            } else {
                fileNameText.innerText = '';
                fileNameBox.classList.remove('show');
            }
        }
    </script>
</head>

<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="wrap">
            <div class="card">
                <div class="hdr">
                    <div class="brgy">Barangay Assistance System</div>
                    <h1>Beneficiary Registration</h1>
                    <p>Create your account and complete your profile</p>
                </div>

                <div class="body">
                    <asp:Label ID="lblSuccess" runat="server" CssClass="msg-success" Visible="false" />
                    <asp:Label ID="lblError" runat="server" CssClass="msg-error" Visible="false" />

                    <div class="sec">Account Information</div>

                    <div class="row2">
                        <div class="f">
                            <label>Username <span>*</span></label>
                            <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter username" MaxLength="30" />
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                                ControlToValidate="txtUsername"
                                ErrorMessage="Username is required."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>Password <span>*</span></label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter password" MaxLength="50" />
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ControlToValidate="txtPassword"
                                ErrorMessage="Password is required."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="row2">
                        <div class="f">
                            <label>Confirm Password <span>*</span></label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm password" MaxLength="50" />
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                                ControlToValidate="txtConfirmPassword"
                                ErrorMessage="Confirm password is required."
                                CssClass="val-error"
                                Display="Dynamic" />
                            <asp:CompareValidator ID="cvPassword" runat="server"
                                ControlToValidate="txtConfirmPassword"
                                ControlToCompare="txtPassword"
                                ErrorMessage="Passwords do not match."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>Email Address <span>*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="example@email.com" MaxLength="150" />
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Email is required."
                                CssClass="val-error"
                                Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                ErrorMessage="Enter a valid email address."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div class="sec">Personal Information</div>

                    <div class="row2">
                        <div class="f">
                            <label>Last Name <span>*</span></label>
                            <asp:TextBox ID="txtLastName" runat="server" placeholder="Apelyido" MaxLength="50" />
                            <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
                                ControlToValidate="txtLastName"
                                ErrorMessage="Last name is required."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>First Name <span>*</span></label>
                            <asp:TextBox ID="txtFirstName" runat="server" placeholder="Pangalan" MaxLength="50" />
                            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
                                ControlToValidate="txtFirstName"
                                ErrorMessage="First name is required."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="row2">
                        <div class="f">
                            <label>Middle Name</label>
                            <asp:TextBox ID="txtMiddleName" runat="server" placeholder="Gitnang pangalan" MaxLength="50" />
                        </div>

                        <div class="f">
                            <label>Date of Birth <span>*</span></label>
                            <asp:TextBox ID="txtDateOfBirth" runat="server" TextMode="Date" onchange="calculateAge(this.value)" />
                            <asp:RequiredFieldValidator ID="rfvDOB" runat="server"
                                ControlToValidate="txtDateOfBirth"
                                ErrorMessage="Date of birth is required."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="row2">
                        <div class="f">
                            <label>Age</label>
                            <asp:TextBox ID="txtAge" runat="server" TextMode="Number" placeholder="Age" ReadOnly="true" />
                            <asp:RangeValidator ID="rvAge" runat="server"
                                ControlToValidate="txtAge"
                                MinimumValue="1"
                                MaximumValue="120"
                                Type="Integer"
                                ErrorMessage="Enter a valid age from 1 to 120."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>Sex <span>*</span></label>
                            <div class="radio-row">
                                <label class="ropt">
                                    <asp:RadioButton ID="rbMale" runat="server" GroupName="Sex" Text="Male" />
                                </label>

                                <label class="ropt">
                                    <asp:RadioButton ID="rbFemale" runat="server" GroupName="Sex" Text="Female" />
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="row2">
                        <div class="f">
                            <label>Contact Number</label>
                            <asp:TextBox ID="txtContact" runat="server" TextMode="Phone" placeholder="09XXXXXXXXX" MaxLength="13" />
                            <asp:RegularExpressionValidator ID="revContact" runat="server"
                                ControlToValidate="txtContact"
                                ValidationExpression="^(09|\+639)\d{9}$"
                                ErrorMessage="Enter a valid PH mobile number."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>Civil Status</label>
                            <asp:DropDownList ID="ddlCivilStatus" runat="server">
                                <asp:ListItem Value="">Select</asp:ListItem>
                                <asp:ListItem Value="Single">Single</asp:ListItem>
                                <asp:ListItem Value="Married">Married</asp:ListItem>
                                <asp:ListItem Value="Widowed">Widowed</asp:ListItem>
                                <asp:ListItem Value="Separated">Separated</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div class="sec">Address</div>

                    <div class="f">
                        <label>Purok / Street <span>*</span></label>
                        <asp:TextBox ID="txtPurok" runat="server" placeholder="Purok or street name" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvPurok" runat="server"
                            ControlToValidate="txtPurok"
                            ErrorMessage="Purok / Street is required."
                            CssClass="val-error"
                            Display="Dynamic" />
                    </div>

                    <div class="row2">
                        <div class="f">
                            <label>No. of Household Members <span>*</span></label>
                            <asp:TextBox ID="txtHouseholdSize" runat="server" TextMode="Number" placeholder="0" />
                            <asp:RequiredFieldValidator ID="rfvHousehold" runat="server"
                                ControlToValidate="txtHouseholdSize"
                                ErrorMessage="Required."
                                CssClass="val-error"
                                Display="Dynamic" />
                            <asp:RangeValidator ID="rvHousehold" runat="server"
                                ControlToValidate="txtHouseholdSize"
                                MinimumValue="1"
                                MaximumValue="50"
                                Type="Integer"
                                ErrorMessage="Enter 1 to 50."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>

                        <div class="f">
                            <label>Monthly Income</label>
                            <asp:TextBox ID="txtIncome" runat="server" placeholder="0.00" />
                            <asp:RegularExpressionValidator ID="revIncome" runat="server"
                                ControlToValidate="txtIncome"
                                ValidationExpression="^\d+(\.\d{1,2})?$"
                                ErrorMessage="Enter a valid amount."
                                CssClass="val-error"
                                Display="Dynamic" />
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div class="sec">Classification</div>

                    <div class="f">
                        <label>Beneficiary Type <span>*</span></label>
                        <asp:DropDownList ID="ddlBeneficiaryType" runat="server">
                            <asp:ListItem Value="">Select type</asp:ListItem>
                            <asp:ListItem Value="Senior Citizen">Senior Citizen</asp:ListItem>
                            <asp:ListItem Value="PWD">Person with Disability (PWD)</asp:ListItem>
                            <asp:ListItem Value="Solo Parent">Solo Parent</asp:ListItem>
                            <asp:ListItem Value="Indigent">Indigent Family</asp:ListItem>
                            <asp:ListItem Value="Displaced Worker">Displaced Worker</asp:ListItem>
                            <asp:ListItem Value="Calamity Victim">Calamity Victim</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvBenefType" runat="server"
                            ControlToValidate="ddlBeneficiaryType"
                            InitialValue=""
                            ErrorMessage="Please select a beneficiary type."
                            CssClass="val-error"
                            Display="Dynamic" />
                    </div>

                    <div class="f">
                        <label>Government ID Presented</label>
                        <asp:DropDownList ID="ddlGovID" runat="server">
                            <asp:ListItem Value="">Select ID</asp:ListItem>
                            <asp:ListItem Value="PhilSys">PhilSys / National ID</asp:ListItem>
                            <asp:ListItem Value="Barangay ID">Barangay ID</asp:ListItem>
                            <asp:ListItem Value="Voters ID">Voter's ID</asp:ListItem>
                            <asp:ListItem Value="Senior Citizen ID">Senior Citizen ID</asp:ListItem>
                            <asp:ListItem Value="PWD ID">PWD ID</asp:ListItem>
                            <asp:ListItem Value="Drivers License">Driver's License</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="upload-group">
                        <label class="upload-label">Upload Valid ID <span>*</span></label>

                        <div class="upload-wrapper">
                            <asp:FileUpload
                                ID="fuIdPicture"
                                runat="server"
                                CssClass="custom-file-upload"
                                onchange="showSelectedFileName(this)" />

                            <div class="upload-info">
                                <div class="upload-icon">
                                    <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                        <path d="M7 3.75h7.2L19 8.55v11.7H7V3.75Z" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round" />
                                        <path d="M14 3.75v5h5" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round" />
                                        <path d="M9.75 14.25l1.65-1.65 2.1 2.1 1.05-1.05 1.7 1.7" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" />
                                        <path d="M10.5 10.75h.01" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" />
                                    </svg>
                                </div>
                                <span class="upload-text">Choose your ID picture</span>
                                <small class="upload-note">Accepted file types: JPG, JPEG, PNG, WEBP. Maximum file size: 5 MB.</small>
                            </div>
                        </div>

                        <div id="selectedFileName" class="selected-file">
                            <span class="selected-file-icon">✓</span>
                            <span id="selectedFileText"></span>
                        </div>

                        <asp:RequiredFieldValidator
                            ID="rfvIdPicture"
                            runat="server"
                            ControlToValidate="fuIdPicture"
                            InitialValue=""
                            ErrorMessage="Valid ID picture is required."
                            CssClass="val-error"
                            Display="Dynamic" />
                    </div>

                    <div class="divider"></div>

                    <label class="consent">
                        <asp:CheckBox ID="chkConsent" runat="server" />
                        <span>I certify that all information provided is true and correct.</span>
                    </label>

                    <asp:CustomValidator ID="cvConsent" runat="server"
                        OnServerValidate="cvConsent_ServerValidate"
                        ErrorMessage="You must agree to the declaration before submitting."
                        CssClass="val-error"
                        Display="Dynamic" />
                </div>

                <div class="footer">
                    <asp:HyperLink ID="hlBackToHome" runat="server"
                        NavigateUrl="index.aspx"
                        CssClass="btn btn-home"
                        Text="Back to Home" />

                    <asp:Button ID="btnClear" runat="server"
                        Text="Clear"
                        CssClass="btn"
                        OnClick="btnClear_Click"
                        CausesValidation="false" />

                    <asp:Button ID="btnSubmit" runat="server"
                        Text="Register"
                        CssClass="btn btn-primary"
                        OnClick="btnSubmit_Click" />
                </div>
            </div>
        </div>

        <uc:VerifyOtp ID="VerifyOtpControl" runat="server" />
    </form>
</body>
</html>