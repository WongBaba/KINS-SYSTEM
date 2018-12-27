<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditStaff.aspx.cs" Inherits="KINS_SYSTEM.Pages.StaffManagement.EditStaff" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/easyform.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <script src="../../JS/commJavascript.js"></script>
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/easyform.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>添加零件</title>
    <link href="../../PageCSS/ComponentManagement/AddComponent.css" rel="stylesheet" />
    <script>
        $(function () {
            initPageData(jQuery.parseJSON(getUrlParam('data')));

            //表单验证
            var ef = $('#form1').easyform();
            ef.is_submit = false;
            $("#no").click(function () {
                closeFrame();
            });
            $("#yes").click(function () {
                ef.success = function (ef) {$("#yes").attr("disabled", "true"); onJob(); }
                ef.submit(false);
            });
        });

        function onJob() {
            var data = new Object();
            data.Emp_id = $("#Emp_id").val();
            data.Emp_name = $("#Emp_name").val();
            data.Emp_deptId = $("#Emp_deptId").val();
            data.Emp_positionId = $("#Emp_positionId").val();
            data.Emp_sex = $("#Emp_sex").val();
            data.Emp_birthday = $("#Emp_birthday").val();
            data.Emp_idcard = $("#Emp_idcard").val();
            data.Emp_address = $("#Emp_address").val();
            data.Emp_nowAddress = $("#Emp_nowAddress").val();
            data.Emp_phone = $("#Emp_phone").val();
            $.post("EditStaff.ashx", { data: JSON.stringify(data) },
               function (data) {
                   pageData = jQuery.parseJSON(data);
                   if (data == "0")
                       alert("操作失败，请刷新重试或联系管理员");
                   closeFrame();
               }
           );
        }

        function initPageData(data) {
            $("#Emp_id").val(data.Emp_id);
            $("#Emp_name").val(data.Emp_name);
            $("#Emp_deptId").val(data.Emp_deptId);
            $("#Emp_positionId").val(data.Emp_positionId);
            $("#Emp_sex").val(data.Emp_sex);
            $("#Emp_birthday").val(toDate(data.Emp_birthday));
            $("#Emp_idcard").val(data.Emp_idcard);
            $("#Emp_address").val(data.Emp_address);
            $("#Emp_nowAddress").val(data.Emp_nowAddress);
            $("#Emp_phone").val(data.Emp_phone);
        }

        function closeFrame() {
            window.parent.hideBlackScreen();
            window.parent.getPageData();
        }

        //将标准时区时间返回YYYY-MM-DD HH-MM-SS
        function toDateTime(str) {
            return toDate(str) + " " + toTime(str);
        }

        //将标准时区时间返回HH-MM-SS
        function toTime(str) {
            try {
                str.replace(/Date\([\d+]+\)/, function (a) { eval('d = new ' + a) });
                return (d.getHours() < 10 ? '0' : '') + d.getHours() + ":" + (d.getMinutes() < 10 ? '0' : '') + d.getMinutes() + ":" + (d.getSeconds() < 10 ? '0' : '') + d.getSeconds();
            } catch (err) {
                var now = new Date();
                return "无";
            }
        }
        //将标准时区时间返回YYYY-MM-DD
        function toDate(str) {
            try {
                str.replace(/Date\([\d+]+\)/, function (a) { eval('d = new ' + a) });
                return d.getFullYear() + '-' + (d.getMonth() + 1 < 10 ? '0' : '') + (d.getMonth() + 1) + '-' + (d.getDate() < 10 ? '0' : '') + d.getDate();
            } catch (err) {
                return "获取数据错误";
            }
        }
    </script>
</head>
<body>
    <div id="form1" style="width: 500px; height: 530px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
        <div class="containerTitle">员工入职</div>
        <div class="container">
            <ul>
                <li>
                    <div class="name non-null">工号</div>
                    <div class="value">
                        <input id="Emp_id" type="text" data-easyform="length:1 8;char-chinese;" data-message="工号限制1-8位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">姓名</div>
                    <div class="value">
                        <input id="Emp_name" type="text" data-easyform="length:1 8;char-chinese;" data-message="名字限制1-8位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">部门</div>
                    <div class="value">
                        <select id="Emp_deptId">
                            <option value="1">生产部</option>
                            <option value="2">仓储部</option>
                            <option value="3">发货部</option>
                            <option value="4">客服部</option>
                            <option value="5">运营部</option>
                            <option value="6">财务部</option>
                            <option value="7">采购部</option>
                            <option value="8">管理部</option>
                        </select>
                    </div>
                </li>
                <li>
                    <div class="name">职位</div>
                    <div class="value">
                        <select id="Emp_positionId">
                            <option value="1">员工</option>
                            <option value="2">组长</option>
                            <option value="3">总管</option>
                            <option value="4">经理</option>
                            <option value="5">总经理</option>
                        </select>
                    </div>
                </li>
                <li>
                    <div class="name">性别</div>
                    <div class="value">
                        <select id="Emp_sex">
                            <option value="男">男</option>
                            <option value="女">女</option>
                        </select>
                    </div>
                </li>
                <li>
                    <div class="name name non-null">出生日期</div>
                    <div class="value">
                        <input id="Emp_birthday" type="text" data-easyform="date;" data-message="日期格式 yyyy-mm-dd" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name non-null">身份证号码</div>
                    <div class="value">
                        <input id="Emp_idcard" type="text" data-easyform="length:18 18;char-normal;" data-message="身份证位数18位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name non-null">家庭住址</div>
                    <div class="value">
                        <input id="Emp_address" type="text" data-easyform="length:1 50;char-chinese;" data-message="家庭住址限制1-50位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name non-null">现居地址</div>
                    <div class="value">
                        <input id="Emp_nowAddress" type="text" data-easyform="length:1 50;char-chinese;" data-message="现住住址限制1-50位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name non-null">联系电话</div>
                    <div class="value">
                        <input id="Emp_phone" type="text" data-easyform="length:7 11;char-chinese;" data-message="联系电话限制7-11位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
            </ul>
        </div>
        <div class="submitButton">
            <input type="button" value="确定" id="yes" />
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" value="取消" id="no" />
        </div>
    </div>
</body>
</html>
