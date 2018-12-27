<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GetCustomerInfo.aspx.cs" Inherits="KINS_SYSTEM.Pages.CustomerManagement.GetCustomerInfo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script src="../../JS/jquery-1.6.js"></script>
    <script src="../../JS/commJavascript.js"></script>
    <title>
        
    </title>
    <script>
        $(function () {
            try {
                var info = new Object();
                var infoStr = getUrlParam("data");
                re = new RegExp("'", "g");
                infoStr = infoStr.replace(re, "''");
                info = $.parseJSON(infoStr);
            } catch (e) {
                alert("又有数据出现了URL限制的字符"+e);
            }
            $.post("CustomerInfoSync.ashx", { data: JSON.stringify(info) }, function (data) {
                //if (info.count > 20000) {
                //    run_sync(info.count);
                //    alert("出于安全考虑，每次同步限制200次");
                //    return;
                //}
                if (data == "null") {
                    run_sync(info.count);
                    alert("同步完成，所有用户数据全部是最新");
                }
                else if (data == "0")
                    alert("同步错误，请重试或联系管理员");
                else {
                    window.parent.run_sync(info.count);
                    window.location.href = "https://ecrm.taobao.com/p/customer/ecrmMemberDetail.htm?buyerId=" + data + "&count=" + info.count;
                }
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
