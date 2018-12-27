<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditPassword.aspx.cs" Inherits="KINS_SYSTEM.Pages.StaffManagement.EditPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link href="../../CSS/commPage.css" rel="stylesheet" />
    <script src="../../JS/commJavascript.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>删除出账信息</title>
    <link href="../../PageCSS/ComponentManagement/DelComponent.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 400px; height:280px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
            <div class="containerTitle">修改登录密码：</div>
            旧密码：&nbsp;&nbsp; 
            <asp:TextBox ID="old_ps" runat="server" OnTextChanged="old_ps_TextChanged"></asp:TextBox>
            <br />
            新密码：&nbsp;&nbsp; 
            <asp:TextBox ID="new_ps" runat="server" OnTextChanged="TextBox2_TextChanged"></asp:TextBox>
            <br />
            再次输入：<asp:TextBox ID="again_ps" runat="server" OnTextChanged="again_ps_TextChanged"></asp:TextBox>
            <br />
            <asp:Button ID="yes" runat="server" Text="确定" OnClick="yes_Click" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="no" runat="server" Text="取消" OnClick="no_Click" />

        </div>
    </form>
</body>
</html>
