<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FinancialReports.aspx.cs" Inherits="KINS_SYSTEM.Pages.FinancialManagement.FinancialReports" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=GB2312" />
    <title>财务概况</title>
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/commJavascript.js"></script>
    <script src="../../JS/jquery.table2excel.js"></script>
    <script src="../../JS/amCharts/amcharts.js"></script>
    <script src="../../JS/amCharts/pie.js"></script>
    <script src="../../JS/amCharts/serial.js"></script>
    <script src="../../JS/easyform.js"></script>

    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <link href="../../CSS/iconfont.css" rel="stylesheet" />
    <link href="../../JS/amCharts/style.css" rel="stylesheet" />
    <link href="../../CSS/easyform.css" rel="stylesheet" />
    <style>
        .mainContainer {
            width: 100%;
            overflow-x: hidden;
            overflow-y: auto;
        }

        .container {
            width: 100%;
            background-color: white;
            margin-bottom: 10px;
            /**/
        }

        .Fr_today {
            height: 250px;
        }

        .Fr_data {
            height: 150px;
            width: 100%;
        }

        .Fr_history {
            width: 100%;
            height: 800px;
        }

        .Fr_historyData {
            height: 500px;
        }

        .Fr_date {
            float: right;
            margin-right: 30px;
        }

        .Fr_data ul {
            box-sizing: border-box;
            float: right;
            width: 60%;
            height: 202px;
            border-left: 1px solid #e6e6e6;
        }

        .Fr_data li {
            box-sizing: border-box;
            float: left;
            width: 130px;
            height: 100px;
            float: left;
            width: 25%;
            border: 0px;
            border-bottom: 1px solid #e6e6e6;
            border-right: 1px solid #e6e6e6;
            cursor: pointer;
        }

            .Fr_data li:hover {
                box-shadow: 5px 5px 15px #f2f2f2, -5px -5px 15px #f2f2f2;
                color: rgb(250,143,35);
            }

        .fund_title {
            color: #6f6f6f;
            display: block;
            width: 100%;
            margin-left: 20px;
            text-align: left;
            margin-top: 10px;
        }

        .fund_data {
            display: inline-block;
            font-size: 20pt;
            margin-left: 20px;
            height: 70px;
            line-height: 70px;
            vertical-align: middle;
        }

        .Fr_historyData {
            width: 100%;
            height: 400px;
        }
        .Fr_choice {
            margin-right:20px;
            height:20px;
            width:70px;
        }
    </style>
    <script>
        var frData = new Object();
        $(function () {
            initPageData();
            $(".Fr_choice").change(function () {
                var select = $(this).val();
                if (select == "进账") {
                    setHistory(getCharts(frData.Table));
                } else if (select == "出账") {
                    setHistory(getCharts(frData.Table1));
                }
            });
            $(".searchDate").click(function () {
                var ef = $('.containerTitle').easyform();
                ef.success = function (ef) {$("#yes").attr("disabled", "true"); setPageData() }
                ef.submit(false);
            })
        });
        function initPageData() {
            var data = new Object();
            var now = new Date();
            //起始时间默认为上一个月的1号
            $(".startDate").val((now.getMonth() < 1 ? (now.getFullYear() - 1) + '-12' : now.getFullYear() + "-" + (now.getMonth() < 10 ? '0' : '') + (now.getMonth())) + '-01');
            $(".endDate").val(now.getFullYear() + "-" + (now.getMonth() + 1 < 10 ? '0' : '') + (now.getMonth() + 1) + '-' + (now.getDate() < 10 ? '0' : '') + now.getDate());
            setPageData();
        }
        function setPageData() {
            var data = new Object();
            data.endDate = $(".endDate").val();
            data.startDate = $(".startDate").val();
            $.post("FinancialReportsGetData.ashx", { data: JSON.stringify(data) }, function (datas) {
                //返回数据共4个表，Table是期间每天的进账金额，Table1是期间每天的出账金额，Table2是总待进账金额，Table3是总待出账金额,Table4是总库存金额
                frData = $.parseJSON(datas);
                $("#receivableFunds").text(parseFloat("0" + frData.Table2[0].money) + "元");
                $("#payableFunds").text(parseFloat("0" + frData.Table3[0].money) + "元");
                $("#Td_inventoryFunds").text(parseFloat("0" + frData.Table4[0].money).toFixed(2) + "元");
                //获取今天和昨天的日期
                var td_date = "/Date(" + Date.parse(new Date(data.endDate + " 0:0:0")) + "+0800)/";
                var yd_date = addDay(td_date, -1);
                //设置今天和昨天的进账金额
                var td_money = 0;
                var yd_money = 0;
                var Ic_countMoney = 0;
                var Ol_countMoney = 0;
                for (var i = 0; i < frData.Table.length; i++) {
                    Ic_countMoney += parseFloat(frData.Table[i].money);
                    if (frData.Table[i].frDate == yd_date) {
                        yd_money = frData.Table[i].money;
                    }
                    if (frData.Table[i].frDate == td_date) {
                        td_money = frData.Table[i].money;
                    }
                }
                $("#Td_incomeFunds").text(td_money + "元");
                $("#Yd_incomeFunds").text(yd_money + "元");
                //设置今天和昨天的出账金额
                td_money = 0;
                yd_money = 0;
                for (var i = 0; i < frData.Table1.length; i++) {
                    Ol_countMoney += frData.Table1[i].money;
                    if (frData.Table1[i].frDate == yd_date) {
                        yd_money = frData.Table1[i].money;
                    }
                    if (frData.Table1[i].frDate == td_date) {
                        td_money = frData.Table1[i].money;
                    }
                }
                $("#Td_outlayFunds").text(td_money + "元");
                $("#Yd_outlayFunds").text(yd_money + "元");
                //设置可用资金
                $("#availableFunds").text((Ic_countMoney - Ol_countMoney).toFixed(2) + "元");
                //默认显示进账曲线图
                setHistory(getCharts(frData.Table));
            });
        }

        function getCharts(table) {
            var chartData = new Array();
            var lineDate = table[0].frDate;
            for (var i = 0; toDate(lineDate) <= $(".endDate").val() ; lineDate = addDay(lineDate, 1)) {
                var historyData = new Object();
                historyData.date = toDate(lineDate);
                historyData.money = 0;
                if (i < table.length)
                    if (lineDate == table[i].frDate) {
                        historyData.money = table[i++].money;
                    }
                chartData.push(historyData);
            }
            return chartData;
        }

        function setHistory(chartData) {
            var chart;
            var graph;
            chart = new AmCharts.AmSerialChart();

            chart.dataProvider = chartData;
            chart.marginLeft = 10;
            chart.categoryField = "date";
            chart.dataDateFormat = "YYYY-MM-DD";

            // listen for "dataUpdated" event (fired when chart is inited) and call zoomChart method when it happens
            chart.addListener("dataUpdated", zoomChart);

            // AXES
            // category
            var categoryAxis = chart.categoryAxis;
            categoryAxis.parseDates = true; // as our data is date-based, we set parseDates to true
            categoryAxis.minPeriod = "DD"; // our data is yearly, so we set minPeriod to YYYY
            categoryAxis.dashLength = 3;
            categoryAxis.minorGridEnabled = true;
            categoryAxis.minorGridAlpha = 0.1;

            // value
            var valueAxis = new AmCharts.ValueAxis();
            valueAxis.axisAlpha = 0;
            valueAxis.inside = true;
            valueAxis.dashLength = 3;
            chart.addValueAxis(valueAxis);

            // GRAPH
            graph = new AmCharts.AmGraph();
            graph.type = "smoothedLine"; // this line makes the graph smoothed line.
            graph.lineColor = "#d1655d";
            graph.negativeLineColor = "#637bb6"; // this line makes the graph to change color when it drops below 0
            graph.bullet = "round";
            graph.bulletSize = 8;
            graph.bulletBorderColor = "#FFFFFF";
            graph.bulletBorderAlpha = 1;
            graph.bulletBorderThickness = 2;
            graph.lineThickness = 2;
            graph.valueField = "money";
            graph.balloonText = "[[category]]<br><b><span style='font-size:14px;'>[[value]]</span></b>";
            chart.addGraph(graph);

            // CURSOR
            var chartCursor = new AmCharts.ChartCursor();
            chartCursor.cursorAlpha = 0;
            chartCursor.cursorPosition = "mouse";
            chartCursor.categoryBalloonDateFormat = "YYYY-MM-DD";
            chart.addChartCursor(chartCursor);

            // SCROLLBAR
            var chartScrollbar = new AmCharts.ChartScrollbar();
            chart.addChartScrollbar(chartScrollbar);

            chart.creditsPosition = "bottom-right";

            // WRITE
            chart.write("chartdiv");
        }

        function zoomChart() {
            // different zoom methods can be used - zoomToIndexes, zoomToDates, zoomToCategoryValues
            chart.zoomToDates(new Date(2018 - 02 - 28, 0), new Date(2018 - 03 - 01, 0));
        }

        function toDate(str) {
            try {
                str.replace(/Date\([\d+]+\)/, function (a) { eval('d = new ' + a) });
                return d.getFullYear() + '-' + (d.getMonth() + 1 < 10 ? '0' : '') + (d.getMonth() + 1) + '-' + (d.getDate() < 10 ? '0' : '') + d.getDate();
            } catch (err) {
                return "1900-01-01";
            }
        }
        //  /Date(1422193380000+0800)/字符串添加天数
        function addDay(str, num) {
            var date = parseFloat(str.replace("00000+", "(").split("(")[1]);
            date += 864 * num;
            return "/Date(" + date + "00000+0800)/";
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="mainContainer">
            <div class="container Fr_today  borderShadow">
                <div class="containerTitle">今日财务实况<a>&nbsp;财务结算&nbsp;</a></div>
                <div class="Fr_data">
                    <ul>
                        <li class="fund">
                            <span class="fund_title">可用资金<a class="KinsFont" title="公司账户现金">&nbsp;&#xe6a3;</a></span>
                            <span class="fund_data" id="availableFunds">-</span>
                        </li>
                        <li class="fund">
                            <span class="fund_title">库存资金<a class="KinsFont" title="仓库库存价值">&nbsp;&#xe6a3;</a></span>
                            <span class="fund_data" id="Td_inventoryFunds">-</span>
                        </li>
                        <li class="fund">
                            <span class="fund_title">今日进账<a class="KinsFont" title="今天公司账户所有进账">&nbsp;&#xe6a3;</a></span>
                            <span class="fund_data" id="Td_incomeFunds">-</span>
                        </li>
                        <li class="fund">
                            <span class="fund_title">今日出账<a class="KinsFont" title="今天公司账户所有支出">&nbsp;&#xe6a3;</a></span>
                            <span class="fund_data" id="Td_outlayFunds">-</span>
                        </li>
                        <li class="fund">
                            <span class="fund_title">待进账资金<a class="KinsFont" title="公司待收资金">&nbsp;&#xe6a3;</a></span>
                            <span class="fund_data" id="receivableFunds">-</span>
                        </li>
                        <li class="fund">
                            <span class="fund_title">待出账资金<a class="KinsFont" title="公司待支出资金">&nbsp;&#xe6a3;</a></span>
                            <span class="fund_data" id="payableFunds">-</span>
                        </li>
                        <li class="fund">
                            <span class="fund_title">昨日进账<a class="KinsFont" title="昨天公司账户所有进账">&nbsp;&#xe6a3;</a></span>
                            <span class="fund_data" id="Yd_incomeFunds">-</span>
                        </li>
                        <li class="fund">
                            <span class="fund_title">昨日出账<a class="KinsFont" title="昨天公司账户所有支出">&nbsp;&#xe6a3;</a></span>
                            <span class="fund_data" id="Yd_outlayFunds">-</span>
                        </li>
                    </ul>
                    <div id="chartdivs" style="width: 40%; height: 200px; padding-top: 20px;"></div>
                </div>
            </div>
            <div class="container Fr_history  borderShadow">
                <div class="containerTitle">
                    历史财务数据
                    <div class="Fr_date">
                        <select class="Fr_choice">
                            <option value="进账">进账</option>
                            <option value="出账">出账</option>
                        </select>
                        <input class="startDate" type="date" data-easyform="" data-message="时间不能为空" data-easytip="disappear:none;class:KINS;disappear:other;" />~
                        <input class="endDate" type="date" data-easyform="" data-message="时间不能为空" data-easytip="disappear:none;class:KINS;disappear:other;" />
                        <input type="button" class="searchDate" value="搜索" />
                    </div>
                </div>
                <div class="Fr_historyData" id="chartdiv"></div>
            </div>
        </div>
    </form>
</body>
</html>
