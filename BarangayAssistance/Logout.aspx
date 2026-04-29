<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="BarangayAssistance.Logout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Logging Out...</title>

    <style>
        body {
            margin:0;
            font-family:Arial, sans-serif;
            background:#f4f6f9;
            display:flex;
            justify-content:center;
            align-items:center;
            height:100vh;
        }

        .box {
            background:white;
            padding:30px 40px;
            border-radius:10px;
            box-shadow:0 8px 24px rgba(0,0,0,0.1);
            text-align:center;
        }

        .box h3 {
            margin-bottom:10px;
            color:#1f3b57;
        }

        .box p {
            font-size:14px;
            color:#555;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <div class="box">
        <h3>Logging out...</h3>
        <p>Please wait while we securely log you out.</p>
    </div>

</form>
</body>
</html>