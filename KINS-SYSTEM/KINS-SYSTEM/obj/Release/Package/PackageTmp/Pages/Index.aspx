<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="KINS_SYSTEM.Pages.Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link id="link" rel="Shortcut Icon" href="../Image/企业云.png"" type="image/x-icon" />
    <title>金视照明</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="../JS/jquery-2.0.0.js"></script>
    <script src="../JS/jquery-ui-1.8.20.js"></script>
    <script src="../PageJavaScript/Index.js"></script>
    <link href="../PageCSS/Index.css" rel="stylesheet" />
    <link href="../CSS/commPage.css" rel="stylesheet" />
    <link href="../CSS/scollBar.css" rel="stylesheet" />
    <script type="text/ecmascript">
        //设置系统index标签
        document.addEventListener("visibilitychange", function () {
            if (document.hidden) {
                document.getElementById("link").href = "../Image/企业hidden.png";
            } else {
                document.getElementById("link").href = "../Image/企业show.png";
            }
        }, false);
        $().ready(function () {
            $("title").html("<%=Session["company"]%>".replace("中山市", "").replace("有限公司", ""));
            $("#menu_top a").html("<%=Session["company"]%>".replace("中山市", "").replace("有限公司", ""));
            $("#main").attr("src", "<%=Session["indexUrl"]%>");
            initFrame();
            initPage();
            setInterval(function () { var now = (new Date()).toLocaleString(); $('#current-time').text(now); }, 1000);
            if ("<%=Session["yhm"]%>".length > 0)
                $("#myName").text("<%=Session["xm"]%>");
            $("#menu").accordion();
            $("#exit").click(function () {
                window.location.href = "Exit.aspx";
            });
            $("#editPassword").click(function () {
                main.window.showBlackScreen();
                $("#main").contents().find(".blackFrame").attr("src", "../../Pages/StaffManagement/EditPassword.aspx");
            });
            $("#index").click(function () {
                $("#main").attr("src", "<%=Session["indexUrl"]%>");
            });
            $("#lockIndex").click(function () {
                var data = $("#main").attr("src");
                $("#index").unbind();
                $("#index").click(function () {
                    $("#main").attr("src", data);
                });
                $.post("lockIndex.ashx", { data: JSON.stringify(data) },
               function (data) {
                   if (data == "1") {
                       alert("设置首页成功");
                   }
               });
            })
        });

        //根据url链接信息决定主内容Iframe里的链接
        function initFrame() {
            var urls = getUrlParam("frame_url");
            if (urls != null) {
                $("#main").attr("src", urls);
            }
        }
        //获取链接URL中的参数值
        function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
            var r = window.location.search.substr(1).match(reg);
            if (r != null) return decodeURI(r[2]); return null;
        }
    </script>
    <style>
        div {
            overflow:hidden;
        }
    </style>
</head>
<body>
    <div id="mainPanel">
        <div id="top">
            <div id="current-time" style="float: left; margin-left: 11%; color: #333"></div>
            <ul class="userMenu">
                <li style="width:20px;font-family:'KINS_pageIcon' !important" id="lockIndex">&#xe6c0;</li>
                <li>消息</li>
                <li id="attendance">考勤</li>
            </ul>
            <div id="user">
                <span id="editPassword">修改密码</span>
                <span id="exit">退出</span>
                <span id="myName">请登录</span>
                <span>
                    <img src="../Image/bg2.JPG" /></span>
            </div>
        </div>
        <iframe src="ProductManagement/ProductManagement.aspx" id="main" name="main"></iframe>
        <div id="menuContainer">
            <div id="menu_top">
                <img style="width:50px;height:50px;" src="../Image/企业show.png" /><a></a>
            </div>
            <div id="dropdown_menu">
                <dl>
                    <dt class="menu_closed" id="index"><i>&#xe6da;</i><a>首页</a></dt>
                </dl>
                <%--<dl>
                    <dt class="menu_closed" id="d2"><i>&#xe6e9;</i><a>客户关系管理</a></dt>
                    <dd data-url="CustomerManagement/CustomerListSync.aspx"><a>客户列表同步</a></dd>
                    <dd data-url="CustomerManagement/CustomerInfoSync.aspx"><a>客户信息同步</a></dd>
                </dl>

                <dl>
                    <dt class="menu_closed" id="d3"><i>&#xe744;</i><a>订单处理</a></dt>
                    <dd data-url="OrderManagement/ImportOrder.aspx"><a>订单导入</a></dd>
                    <dd data-url="OrderManagement/QueryOrder.aspx"><a>订单查询</a></dd>
                    <dd><a>审单</a></dd>
                    <dd><a>反审</a></dd>
                    <dd><a>验货</a></dd>
                    <dd><a>称重</a></dd>
                </dl>--%>
                <dl>
                    <dt class="menu_closed" id="d4"><i>&#xe6f6;</i><a>库存管理</a></dt>
                    <dd data-url="ComponentManagement/ComponentManagement.aspx"><a>零配件管理</a></dd>
                    <dd data-url="ProductManagement/ProductManagement.aspx"><a>产品管理</a></dd>
                    <%--<dd><a>入库单</a></dd>
                    <dd><a>出库单</a></dd>
                    <dd><a>调拨单</a></dd>
                    <dd><a>盘点单</a></dd>
                    <dd><a>仓库管理</a></dd>--%>
                </dl>
                <dl>
                    <dt class="menu_closed" id="d5"><i>&#xe698;</i><a>采购管理</a></dt>
                    <dd  data-url="PurchasingManagement/PurchasingManagement.aspx"><a>采购</a></dd>
                    <%--<dd><a>采购退货单</a></dd>
                    <dd><a>库存监控</a></dd>
                    <dd><a>供应商信息</a></dd>
                    <dd><a>商品</a></dd>
                    <dd><a>库存成本</a></dd>--%>
                </dl>
                <dl>
                    <dt class="menu_closed" id="d6"><i>&#xe726;</i><a>人事管理</a></dt>
                    <dd data-url="StaffManagement/OnOffJob.aspx"><a>员工管理</a></dd>
                    <dd data-url="StaffManagement/AttendanceManagement.aspx"><a>考勤管理</a></dd>
                </dl>
                <dl>
                    <dt class="menu_closed" id="d7"><i>&#xe70c;</i><a>财务管理</a></dt>
                    <dd data-url="FinancialManagement/FinancialReports.aspx"><a>财务概况</a></dd>
                    <dd data-url="FinancialManagement/IncomeManagement.aspx"><a>进账</a></dd>
                    <dd data-url="FinancialManagement/OutlayManagement.aspx"><a>出账</a></dd>
                    <dd data-url="FinancialManagement/ReceivableManagement.aspx"><a>待进账</a></dd>
                    <dd data-url="FinancialManagement/PayableManagement.aspx"><a>待出账</a></dd>
                </dl>
                <%--<dl>
                    <dt class="menu_closed" id="d8"><i>&#xe6f6;</i><a>视频中心</a></dt>
                    <dd data-url="OperationCourse/ClassCenter.html"><a>淘宝运营视频</a></dd>
                </dl>--%>
            </div>
        </div>
    </div>
</body>
</html>
