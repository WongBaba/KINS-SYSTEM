<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PermissionManagement.aspx.cs" Inherits="KINS_SYSTEM.Pages.PermissionManagement.PermissionManagement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/dtree.js"></script>
    <script src="../../JS/commJavascript.js"></script>

    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <link href="../../CSS/iconfont.css" rel="stylesheet" />
    <link href="../../PageCSS/ComponentManagement/AddComponent.css" rel="stylesheet" />
    <script>
        $(function () {
            initPage();
            $("#no").click(function () { closeFrame(); })
            $("#yes").click(function () { updatePermission()})
        });
        function initPage() {
            d = new dTree('d');
            d.add(0, -1, '');

            d.add(36, 0, 'permission', '#S07', '分配系统权限');
            d.add(1, 0, 'authority', 'ALL', '全部权限');

            d.add(10, 1, 'permission', '#I00', '系统首页');

            d.add(2, 1, 'authority', '1', '个人中心');
            d.add(11, 2, 'permission', '#A01', '个人考勤信息');
            d.add(12, 2, 'permission', '#A02', '上班打卡');

            d.add(3, 1, 'authority', '', '零配件管理');
            d.add(13, 3, 'permission', '#C01', '添加新合作供应商');
            d.add(14, 3, 'permission', '#C02', '添加新零配件');
            d.add(15, 3, 'permission', '#C03', '添加新零配件类型');
            d.add(16, 3, 'permission', '#C04', '查看零配件信息');
            d.add(17, 3, 'permission', '#C05', '删除合作供应商');
            d.add(18, 3, 'permission', '#C06', '删除零配件');
            d.add(19, 3, 'permission', '#C07', '删除零配件类型');
            d.add(20, 3, 'permission', '#C08', '编辑零配件信息');

            d.add(4, 1, 'authority', '1', '产品管理');
            d.add(21, 4, 'permission', '#P01', '添加新产品');
            d.add(22, 4, 'permission', '#P02', '添加新产品SKU');
            d.add(23, 4, 'permission', '#P03', '添加新产品类型');
            d.add(24, 4, 'permission', '#P04', '删除产品信息');
            d.add(25, 4, 'permission', '#P05', '删除产品SKU');
            d.add(26, 4, 'permission', '#P06', '查看产品信息');
            d.add(27, 4, 'permission', '#P07', '查看产品SKU信息');

            d.add(5, 1, 'authority', '1', '订单管理');
            d.add(28, 5, 'permission', '#O01', '导入订单至数据库');
            d.add(29, 5, 'permission', '#O02', '查看订单信息');

            d.add(6, 1, 'authority', '1', '员工管理');
            d.add(30, 6, 'permission', '#S01', '查看员工考勤');
            d.add(31, 6, 'permission', '#S02', '编辑员工考勤信息');
            d.add(32, 6, 'permission', '#S03', '编辑员工基本信息');
            d.add(33, 6, 'permission', '#S04', '员工离职');
            d.add(34, 6, 'permission', '#S05', '员工入职');
            d.add(35, 6, 'permission', '#S06', '查看员工基本信息');

            d.add(7, 1, 'authority', '1', '财务管理');
            d.add(37, 7, 'permission', '#F01', '查看财务概况');
            d.add(38, 7, 'permission', '#F02', '查看进账');
            d.add(39, 7, 'permission', '#F03', '新增进账记录');
            d.add(40, 7, 'permission', '#F04', '删除进账和待进账记录');
            d.add(41, 7, 'permission', '#F05', '编辑进账记录');
            d.add(42, 7, 'permission', '#F06', '查看出账');
            d.add(43, 7, 'permission', '#F07', '新增出账记录');
            d.add(44, 7, 'permission', '#F08', '删除出账和待出账记录');
            d.add(45, 7, 'permission', '#F09', '编辑出账记录');
            d.add(46, 7, 'permission', '#F10', '查看待进账');
            d.add(47, 7, 'permission', '#F11', '新增待进账记录');
            d.add(48, 7, 'permission', '#F12', '编辑待进账记录');
            d.add(49, 7, 'permission', '#F13', '待进账确认收款');
            d.add(50, 7, 'permission', '#F14', '查看待出账');
            d.add(51, 7, 'permission', '#F15', '新增待出账记录');
            d.add(52, 7, 'permission', '#F16', '编辑待出账记录');
            d.add(53, 7, 'permission', '#F17', '待出账确认支出');

            // dTree实例属性以此为：  节点ID，父类ID，chechbox的名称， chechbox的值，chechbox的显示名称，chechbox是否被选中--默认是不选，chechbox是否可用：默认是可用，节点链接：默认是虚链接

            document.getElementById("dtree").innerHTML = d;
            d.closeAll();
            getPermission();
        }
        function getPermission() {
            data = getUrlParam('data');
            $.post("GetPermission.ashx", { data: JSON.stringify(data) },
               function (data) {
                   if (data == "0")
                       alert("获取数据失败，请刷新重试或联系管理员");
                   setPermission(data);
               }
           );
        }

        function setPermission(data) {
            var perArr = data.split("#");
            for (var i = 1; i < perArr.length; i++)
                $("input[value=#" + perArr[i] + "]").attr("checked", true);
        }

        function updatePermission() {
            var data = new Object();
            data.id = getUrlParam('data');
            data.permissions = "";
            $("input[name='permission']:checked").each(function () {
                data.permissions += $(this).val();
            });
            $.post("SetPermission.ashx", { data: JSON.stringify(data) },
               function (data) {
                   if (data == "0")
                       alert("获取数据失败，请刷新重试或联系管理员");
                   closeFrame();
               }
           );
        }

        function closeFrame() {
            window.parent.hideBlackScreen();
            window.parent.getPageData();
        }
    </script>
    <style>
        a {
            color: black;
            font-family: 微软雅黑;
            text-decoration: none;
        }
        #dtree {
            text-align:left;
        }
    </style>
</head>

<body>
    <div style="width:500px;background-color:white;margin:auto;height:420px;">
    <span class="containerTitle">权限管理</span>
    <div style="max-height: 340px; overflow: auto;">
        <div id="dtree" style="margin-left: 100px;">
        </div>
    </div>
    <div class="submitButton" style="margin-bottom:10px;">
        <input type="button" value="确定" id="yes" />
        &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" value="取消" id="no" />
    </div>
        </div>
</body>
</html>
