<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="KINS_SYSTEM.Pages.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="Shortcut Icon"  type="image/x-icon" />
    <title>请登录-管理系统</title>
    <link href="../PageCSS/Login.css" rel="stylesheet" />
    <script src="../JS/jquery-2.0.0.js"></script>
    <script>
        $(function () {
            var temp = window.parent.location.href;
            if(temp.substring(temp.length-10)!="Login.aspx")
                window.parent.location.href = 'Login.aspx';
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div id="main" style="margin-top: 200px; text-align: center;">
            <div id="registerInfo">
                <ul id="names">
                    <li>账号</li>
                    <li>密码</li>
                </ul>
                <ul id="values">
                    <li>
                        <div class="fieldHolder">
                            <asp:TextBox ID="yhm" class="textInput" runat="server"></asp:TextBox>
                        </div>
                    </li>
                    <li>
                        <div class="fieldHolder">
                            <asp:TextBox ID="mm" class="textInput" runat="server" TextMode="Password"></asp:TextBox>
                        </div>
                    </li>
                </ul>
            </div>
            <br/>
        </div>
        <asp:Button ID="submit" runat="server" Text="登录" OnClick="submit_Click" />
        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="打卡登陆" Style="margin-left:50px;" />
    </form>
</body>
</html>
