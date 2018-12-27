<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AttendanceManagement.aspx.cs" Inherits="KINS_SYSTEM.Pages.AttendanceManagement.AttendanceManagement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/commJavascript.js"></script>
    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <title></title>
    <script>
        $(function () {
            initPage();
            getAttData();
        });

        //初始化页面布局
        function initPage() {
            $("#iframeContainer").css("height", $(window).height() - 20);
        }


        //获取当前用户所选月份的考勤数据
        function getAttData() {
            var mydate = new Date();
            var data = new Object();
            data.year = mydate.getFullYear();
            data.month = mydate.getMonth() + 1;

            //获取当月的考勤数据
            $.post("GetAttendance.ashx", { data: JSON.stringify(data) },
                function (data) {
                    setAttendance(jQuery.parseJSON(data));
                }
            );
        }

        function setAttendance(data) {
            var mydate = new Date();
            var tableData = "";
            for (var i = 0; i < data.length - 1; i++) {
                tableData += "<tr>";
                tableData += "<td>" + toDate(data[i].O_checkDate) + "</td>";
                tableData += "<td>" + toTime(data[i].O_onDuty1) + "</td>";
                tableData += "<td>" + toTime(data[i].O_offDuty1) + "</td>";
                tableData += "<td>" + toTime(data[i].O_onDuty2) + "</td>";
                tableData += "<td>" + toTime(data[i].O_offDuty2) + "</td>";
                tableData += "<td>" + toTime(data[i].O_onDuty3) + "</td>";
                tableData += "<td>" + toTime(data[i].O_offDuty3) + "</td>";
                tableData += "<td>" + (data[i].workTime / 60.0).toFixed(2) + " 小时</td>";
                tableData += "<td>" + (data[i].exTime / 60.0).toFixed(2) + "小时</td>";
                tableData += "</tr>";
            }
            var arr = data[data.length - 1].O_id.split('@');
            $("#allTime").html((parseFloat(arr[0]) / 60).toFixed(2) + "<a>&nbsp;&nbsp;&nbsp;&nbsp;小时");
            $("#lostTime").html((parseFloat(arr[1]) / 60).toFixed(2) + "<a>&nbsp;&nbsp;&nbsp;&nbsp;小时");
            $("#exTime").html((parseFloat(arr[2]) / 60).toFixed(2) + "<a>&nbsp;&nbsp;&nbsp;&nbsp;小时");
            $("#exCash").html((parseFloat(arr[2]) / 60 * 12).toFixed(2) + "<a>&nbsp;&nbsp;&nbsp;&nbsp;元");
            $("#lostCash").html("-" + (parseFloat(arr[1]) / 60 * 12).toFixed(2) + "<a>&nbsp;&nbsp;&nbsp;&nbsp;元");
            $("tbody").html(tableData);
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
                return;
            }
        }
    </script>
    <style>
        body, html, div, ul, li {
            list-style: none;
            border: 0px;
            padding: 0px;
            font-family: 微软雅黑;
        }

        body {
            background-color: white;
        }

        #top {
            margin-top: 1%;
            height: 25%;
            width: 100%;
            background-color: white;
        }

            #top ul {
                height: 100%;
                width: 100%;
            }

            #top li {
                text-align: center;
                height: 100%;
                width: 18.8%;
                margin-left: 1%;
                float: left;
                background-color: blue;
                color: white;
            }

        h2 a {
            font-size: 11pt;
        }

        #bottom {
            height: 72%;
            margin-top: 1%;
            overflow-y:scroll;
        }

        .comTable {
            border-collapse: collapse;
            width: 100%;
            border: 1px solid #D8D8D8;
            margin-top: 10px;
        }

            .comTable thead {
                width: 100%;
                border: 1px solid #D8D8D8;
            }

            .comTable th {
                font-size: 11pt;
                font-weight: normal;
                height: 35px;
                border: 1px solid #D8D8D8;
                font-weight: 500;
            }

            .comTable tbody {
                height: 30px;
                width: 100%;
                background-color: #EFEFEF;
            }

            .comTable tr {
                height: 30px;
                width: 100%;
                border: 1px solid #D8D8D8;
            }

            .comTable td {
                height: 30px;
                border: 1px solid #D8D8D8;
                text-align: center;
                font-size: 9pt;
                font-weight: normal;
            }

            .comTable input {
                text-align: center;
            }
    </style>
</head>
<body>
    <div id="iframeContainer">
        <div id="top">
            <ul>
                <li style="background-color: #2E98E8">
                    <h5>加班工时</h5>
                    <h2 id="exTime">100<a>&nbsp;&nbsp;&nbsp;&nbsp;小时</a></h2>
                </li>
                <li style="background-color: #3BB6DC">
                    <h5>加班工资</h5>
                    <h2 id="exCash">1200<a>&nbsp;&nbsp;&nbsp;&nbsp;元</a></h2>
                </li>
                <li style="background-color: #1BC9C9">
                    <h5>总工时</h5>
                    <h2 id="allTime">2000<a>&nbsp;&nbsp;&nbsp;&nbsp;小时</a></h2>
                </li>
                <li style="background-color: #3BB6DC">
                    <h5>缺勤扣资</h5>
                    <h2 id="lostCash">144<a>&nbsp;&nbsp;&nbsp;&nbsp;元</a></h2>
                </li>
                <li style="background-color: #2E98E8">
                    <h5>缺勤工时</h5>
                    <h2 id="lostTime">12<a>&nbsp;&nbsp;&nbsp;&nbsp;小时</a></h2>
                </li>
            </ul>
        </div>
        <div id="bottom">
            <table class="comTable">
                <thead>
                    <tr>
                        <th style="width: 10%">日期</th>
                        <th style="width: 10%">早班上班</th>
                        <th style="width: 10%">早班下班</th>
                        <th style="width: 10%">中班上班</th>
                        <th style="width: 10%">中班下班</th>
                        <th style="width: 10%">晚班上班</th>
                        <th style="width: 10%">晚班下班</th>
                        <th style="width: 10%">工作时间</th>
                        <th style="width: 10%;">加班时间</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
