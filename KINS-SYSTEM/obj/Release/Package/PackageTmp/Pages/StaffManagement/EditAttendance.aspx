<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditAttendance.aspx.cs" Inherits="KINS_SYSTEM.Pages.StaffManagement.EditAttendance" %>

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
                ef.success = function (ef) {$("#yes").attr("disabled", "true"); editAtt(); }
                ef.submit(false);
            });
        });

        function editAtt() {
            var data = new Object();
            data.Emp_id = $("#Emp_id").val();
            data.Emp_name = $("#Emp_name").val();
            data.O_checkDate = $("#O_checkDate").val();
            data.O_onDuty1 = $("#O_onDuty1").val();
            data.O_onDuty2 = $("#O_onDuty2").val();
            data.O_onDuty3 = $("#O_onDuty3").val();
            data.O_offDuty1 =$("#O_offDuty1").val();
            data.O_offDuty2 =$("#O_offDuty2").val();
            data.O_offDuty3 =$("#O_offDuty3").val();
            $.post("EditAttendance.ashx", { data: JSON.stringify(data) },
               function (data) {
                   if (data == "0")
                       alert("操作失败，请刷新重试或联系管理员");
                   closeFrame();
               }
           );
        }

        function initPageData(data) {
            $("#Emp_id").val(data.Emp_id);
            $("#Emp_name").val(data.Emp_name);
            $("#O_checkDate").val(toDate(data.O_checkDate));
            $("#O_onDuty1").val(toTime(data.O_onDuty1).replace("无", ""));
            $("#O_onDuty2").val(toTime(data.O_onDuty2).replace("无", ""));
            $("#O_onDuty3").val(toTime(data.O_onDuty3).replace("无", ""));
            $("#O_offDuty1").val(toTime(data.O_offDuty1).replace("无", ""));
            $("#O_offDuty2").val(toTime(data.O_offDuty2).replace("无", ""));
            $("#O_offDuty3").val(toTime(data.O_offDuty3).replace("无", ""));
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
                return (d.getHours()<10 ? '0' : '') + d.getHours() + ":" + (d.getMinutes() < 10 ? '0' : '') + d.getMinutes() + ":" + (d.getSeconds() < 10 ? '0' : '') + d.getSeconds();
            } catch (err) {
                return "无";
            }
        }
        //将标准时区时间返回YYYY-MM-DD
        function toDate(str) {
            try {
                str.replace(/Date\([\d+]+\)/, function (a) { eval('d = new ' + a) });
                return d.getFullYear() + '-' + (d.getMonth() + 1 < 10 ? '0' : '') + (d.getMonth() + 1) + '-' + (d.getDate() < 10 ? '0' : '') + d.getDate();
            } catch (err) {
                return "无";
            }
        }
    </script>
</head>
<body>
    <div id="form1" style="width: 500px; height: 530px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
        <div class="containerTitle">考勤信息</div>
        <div class="container" style="overflow:auto;height:340px;">
            <ul>
                <li>
                    <div class="name non-null">工号</div>
                    <div class="value">
                        <input id="Emp_id" type="text" readonly="readonly" data-easyform="length:1 8;char-chinese;" data-message="工号限制1-8位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">姓名</div>
                    <div class="value">
                        <input id="Emp_name" type="text" readonly="readonly" data-easyform="length:1 8;char-chinese;" data-message="名字限制1-8位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">考勤日期</div>
                    <div class="value">
                        <input id="O_checkDate" type="text" readonly="readonly" data-easyform="date;char-chinese;" data-message="名字限制1-8位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name">早班上班</div>
                    <div class="value">
                        <input id="O_onDuty1" type="text" data-easyform="time;null;" data-message="时间格式 hh-mm-ss" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name">早班下班</div>
                    <div class="value">
                        <input id="O_offDuty1" type="text" data-easyform="time;null;" data-message="时间格式 hh-mm-ss" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name">中班上班</div>
                    <div class="value">
                        <input id="O_onDuty2" type="text" data-easyform="time;null;" data-message="时间格式 hh-mm-ss" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name">中班下班</div>
                    <div class="value">
                        <input id="O_offDuty2" type="text" data-easyform="time;null;" data-message="时间格式 hh-mm-ss" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name">晚班上班</div>
                    <div class="value">
                        <input id="O_onDuty3" type="text" data-easyform="time;null;" data-message="时间格式 hh-mm-ss" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name">晚班下班</div>
                    <div class="value">
                        <input id="O_offDuty3" type="text" data-easyform="time;null;" data-message="时间格式 hh-mm-ss" data-easytip="disappear:none;class:KINS;disappear:other;" />
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
