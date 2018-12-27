<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AttendanceManagement.aspx.cs" Inherits="KINS_SYSTEM.Pages.StaffManagement.AttendanceManagement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/commJavascript.js"></script>
    <script src="../../JS/jquery.table2excel.js"></script>

    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <link href="../../CSS/iconfont.css" rel="stylesheet" />

    <script>
        var pageData;
        var starCom = 1;
        $(function () {
            initPage();
            initPageData();
            //提交搜索
            $("#searchButton").click(function () {
                starCom = 1;
                $("#pageNum").val(1);
                getPageData();
            });
            //重置搜索框
            $("#resetFiltersButton").click(function () {
                $("#queryList input[type=text]").val("");
                $("#queryList select").val("");
            })

            //全部反选
            $("#checkAll").click(function () {
                $("tbody input[type=checkbox]").trigger("click");
            });

            //到出到Excel文档
            $("#export").click(function () {
                $(".comTable").table2excel({
                    // 不被导出的表格行的CSS class类
                    exclude: ".noExl",
                    // 导出的Excel文档的名称
                    name: "Excel Document Name",
                    // Excel文件的名称
                    filename: "myExcelTable"
                });
            });


            //更换每页显示数量
            $(".tablePage select").change(function () {
                $("#pageNum").val(1);
                starCom = 1;
                getPageData();
            });

            //上一页操作
            $("#pre").click(function () {
                if ($("#pageNum").val() == "1")
                    return;
                $("#pageNum").val(parseInt($("#pageNum").val()) - 1);
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 < starCom) {
                    //往回跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getPageData();
                    return;
                }
                setPageData();
            });

            //下一页操作
            $("#next").click(function () {
                if ($("#pageNum").val() == $("#pageSum").text())
                    return;
                $("#pageNum").val(parseInt($("#pageNum").val()) + 1);
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 > starCom + 199) {
                    //往下跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getPageData();
                    return;
                }
                setPageData();
            });

            //跳页操作
            $("#submitPage").click(function () {
                //跳页如果跳出了有效区间，则重置数据
                if (parseInt($("#pageNum").val()) < 1 || parseInt($("#pageNum").val()) > parseInt($("#pageSum").text())) {
                    starCom = 1;
                    $("#pageNum").val(1);
                    getPageData();
                    return;
                }
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 < starCom) {
                    //往回跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getPageData();
                    return;
                }
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 > starCom + 199) {
                    //往下跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getPageData();
                    return;
                }
                setPageData();
            })
        });
        function initPage() {
            $("body,html").css("height", $(window).height() - 20);
            $("body,html").css("max-height", $(window).height() - 20);

            $("#List").css("height", $(window).height() - 180);
            $("#List").css("max-height", $(window).height() - 180);
        }
        //初始化页面数据
        function initPageData() {
            getPageData();
        }

        function onJob() {
            showBlackScreen();
            $(".blackFrame").attr("src", "OnJob.aspx");
        }

        //弹出离职窗口及进行确认
        function offJob() {
            if ($(".comTable tbody input[type='checkbox']:checked").length == "0")
                return;
            var data = "";
            $(".comTable tbody input[type='checkbox']:checked").each(function () {
                data += "," + $(this).attr("data_id");
            });
            data = data.substring(1);
            showBlackScreen();
            $(".blackFrame").attr("src", "OffJob.aspx?Emp_id=" + data);
        }

        //获取页面数据
        function getPageData() {
            var data = new Object();
            data.starCom = starCom;
            data.Emp_state = $("#Emp_state").val();
            data.Emp_deptId = $("#Emp_deptId").val();
            data.Emp_positionId = $("#Emp_positionId").val();
            data.Emp_id = $("#Emp_id").val().replace(" ", "") + "";
            data.Emp_name = $("#Emp_name").val().replace(" ", "") + "";
            data.O_checkDate = $("#O_checkDate").val();
            $.post("GetAttendanceData.ashx", { data: JSON.stringify(data) },
               function (data) {
                   pageData = jQuery.parseJSON(data);
                   setPageData();
               }
           );
        }
        //插入数据至页面
        function setPageData() {
            var dept = ",生产部,仓储部,发货部,客服部,运营部,财务部,采购部".split(",");
            var position = ",员工,组长,主管,经理".split(",");
            var state = "离职,在职".split(",");
            $(".comTable tbody").html("暂时没有数据");
            $("#dataSum").html(pageData[pageData.length - 1].Emp_id);
            $("#pageSum").html(parseInt(parseInt(parseInt(pageData[pageData.length - 1].Emp_id) + parseInt($(".tablePage select").val()) - 1) / parseInt($(".tablePage select").val())));
            var maxi = parseInt($("#pageNum").val()) * parseInt($(".tablePage select").val()) + 1 - starCom;
            if (pageData.length - 2 < maxi)
                maxi = pageData.length - 2;
            var tb = ""
            for (var i = (parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 - starCom ; i < maxi ; i++) {
                tb += "<tr>";
                tb += "<td><input data_id='" + pageData[i].O_id + "' type='checkbox' /></td>";
                tb += "<td>" + toDate(pageData[i].O_checkDate) + "</td>";
                tb += "<td>" + pageData[i].Emp_id + "</td>";
                tb += "<td>" + pageData[i].Emp_name + "</td>";
                tb += "<td>" + toTime(pageData[i].O_onDuty1) + "</td>";
                tb += "<td>" + toTime(pageData[i].O_offDuty1) + "</td>";
                tb += "<td>" + toTime(pageData[i].O_onDuty2) + "</td>";
                tb += "<td>" + toTime(pageData[i].O_offDuty2) + "</td>";
                tb += "<td>" + toTime(pageData[i].O_onDuty3) + "</td>";
                tb += "<td>" + toTime(pageData[i].O_offDuty3) + "</td>";
                tb += "<td class='linked edit' name='" + i + "'>编辑</td>";
                tb += "</tr>";
            }
            $(".comTable tbody").html(tb);

            $(".edit").click(function () {
                var data = JSON.stringify(pageData[$(this).attr("name")]);
                showBlackScreen();
                $(".blackFrame").attr("src", "EditAttendance.aspx?data=" + data);
            });
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
    <style>
        body {
        }

        #queryList {
            background-color: white;
            width: 98%;
            margin-left: 1%;
            margin-top: 1%;
            height: 90px;
        }

            #queryList li {
                float: left;
                margin-left: 2%;
                width: 14.5%;
                height: 30px;
                margin-top: 10px;
            }

                #queryList li select, #queryList li input {
                    width: 60%;
                    float: right;
                }

                #queryList li span {
                    font-size: 10pt;
                    text-align: right;
                    width: 37%;
                    float: left;
                }

        .submitList {
            text-align: center;
            margin-right: 20px;
            margin-top: 10px;
            width: 100%;
            height: 20px;
        }

        #inputList {
            width: 100%;
            height: 40px;
            margin-top: 10px;
        }

        #List {
            overflow-y: scroll;
            width: 100%;
            margin-top: 10px;
            background-color: white;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="queryList">
            <div class="blackScreen">
                <a class="closeBlack">&#xe6b7;</a>
            </div>
            <iframe class="blackFrame" src="" scrolling="no"></iframe>
            <div id="inputList">
                <ul>
                    <li>
                        <span>工作状态:</span>
                        <select id="Emp_state">
                            <option value="">全部</option>
                            <option value="1">在职</option>
                            <option value="0">离职</option>
                        </select>
                    </li>
                    <li>
                        <span>部门:</span>
                        <select id="Emp_deptId">
                            <option value="">全部</option>
                            <option value="1">生产部</option>
                            <option value="2">仓储部</option>
                            <option value="3">发货部</option>
                            <option value="4">客服部</option>
                            <option value="5">运营部</option>
                            <option value="6">财务部</option>
                            <option value="7">采购部</option>
                        </select>
                    </li>
                    <li>
                        <span>职位:</span>
                        <select id="Emp_positionId">
                            <option value="">全部</option>
                            <option value="1">员工</option>
                            <option value="2">组长</option>
                            <option value="3">总管</option>
                            <option value="4">经理</option>
                            <option value="5">总经理</option>
                        </select>
                    </li>
                    <li>
                        <span>工号:</span>
                        <input type="text" id="Emp_id" />
                    </li>
                    <li>
                        <span>姓名:</span>
                        <input type="text" id="Emp_name" />
                    </li>
                    <li>
                        <span>考勤日期:</span>
                        <input type="date" id="O_checkDate" value=""/>
                    </li>
                </ul>
            </div>
            <div class="submitList">
                <button id="searchButton" type="button">
                    搜索
                </button>
                <button id="resetFiltersButton" type="button">
                    重置
                </button>
            </div>
        </div>
        <div id="List">
            <span class="containerTitle">考勤管理<a id="onJob">&nbsp;+ 入职&nbsp;&nbsp;</a><a id="export">&nbsp;- 导出为Excel&nbsp;&nbsp;</a></span>
            <table class="comTable">
                <thead>
                    <tr>
                        <th style="width: 5%;">
                            <input id="checkAll" type="checkbox" /></th>
                        <th style="width: 10%">日期</th>
                        <th style="width: 10%">工号</th>
                        <th style="width: 10%;">姓名</th>
                        <th style="width: 10%">早班上班</th>
                        <th style="width: 10%">早班下班</th>
                        <th style="width: 10%">中班上班</th>
                        <th style="width: 10%">中班下班</th>
                        <th style="width: 10%">晚班上班</th>
                        <th style="width: 10%">晚班下班</th>
                        <th style="width: 5%">操作</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
        <div class="tablePage" style="height: 30px; margin-top: 10px;">
            <div style="margin-right: 30px; height: 30px; display: block">
                <a>共</a><a id="dataSum" style="color: red"></a><a>条记录&nbsp;</a><a id="pageSum" style="color: red"></a><a>页&nbsp;&nbsp;每页显示</a>
                <select>
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                    <option value="200" selected="selected">200</option>
                </select>
                <input type="button" id="pre" value="<" />
                <input type="text" id="pageNum" value="1" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                <input type="button" id="submitPage" value="确定" />
                <input type="button" id="next" value=">" />
            </div>
        </div>
    </form>
</body>
</html>
