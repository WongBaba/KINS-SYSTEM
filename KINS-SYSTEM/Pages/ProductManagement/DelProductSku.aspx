<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DelProductSku.aspx.cs" Inherits="KINS_SYSTEM.Pages.ProductManagement.DelProductSku" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <script src="../../JS/commJavascript.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>删除SKU</title>
    <link href="../../PageCSS/ComponentManagement/DelCompany.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 400px; height: 175px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
            <div class="containerTitle">提示：</div>
            <p>确定删除?</p>
            <asp:Button ID="yes" runat="server" Text="确定" OnClick="yes_Click" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="no" runat="server" Text="取消" OnClick="no_Click" />

        </div>
    </form>
</body>
</html>
