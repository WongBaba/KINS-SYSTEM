<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OutlayManagement.aspx.cs" Inherits="KINS_SYSTEM.Pages.FinancialManagement.Outlay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
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

            //点击新增按钮
            $("#Ol_addNew").click(function () {
                outlayAddnew();
            });

            //点击删除按钮
            $("#Ol_delete").click(function () {
                outlayDelete();
            });

            //导出到Excel文档
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
        //点击新增出账信息弹出窗口
        function outlayAddnew() {
            showBlackScreen();
            $(".blackFrame").attr("src", "OutlayAddnew.aspx");
        }

        //弹出删除窗口及进行确认
        function outlayDelete() {
            if ($(".comTable tbody input[type='checkbox']:checked").length == "0")
                return;
            else if ($(".comTable tbody input[type='checkbox']:checked").length > "10") {
                alert("单次删除不能超过10个");
                return;
            }
            var data = "";
            $(".comTable tbody input[type='checkbox']:checked").each(function () {
                data += "," + $(this).attr("data_id");
            });
            data = data.substring(1);
            showBlackScreen();
            $(".blackFrame").attr("src", "OutlayDelete.aspx?Ol_id=" + data);
        }

        //获取页面数据
        function getPageData() {
            var data = new Object();
            data.starCom = starCom;
            data.Ol_payDate = $("#Ol_payDate").val();
            data.Ol_payee = $("#Ol_payee").val();
            data.Ol_payMethod = $("#Ol_payMethod").val();
            data.Ol_content = $("#Ol_content").val().replace(" ", "") + "";
            data.Ol_operator = $("#Ol_operator").val().replace(" ", "") + "";
            data.Ol_remarks = $("#Ol_remarks").val();
            data.Ol_state="出账";
            $.post("OutlayGetData.ashx", { data: JSON.stringify(data) },
               function (data) {
                   pageData = jQuery.parseJSON(data);
                   setPageData();
               }
           );
        }
        //插入数据至页面
        function setPageData() {
            $(".comTable tbody").html("暂时没有数据");
            $("#dataSum").html(pageData[pageData.length - 1].Ol_id);
            $("#pageSum").html(parseInt(parseInt(parseInt(pageData[pageData.length - 1].Ol_id) + parseInt($(".tablePage select").val()) - 1) / parseInt($(".tablePage select").val())));
            var maxi = parseInt($("#pageNum").val()) * parseInt($(".tablePage select").val()) + 1 - starCom;
            if (pageData.length - 2 < maxi)
                maxi = pageData.length - 2;
            var tb = "";
            for (var i = (parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 - starCom ; i < maxi ; i++) {
                tb += "<tr>";
                tb += "<td><input data_id='" + pageData[i].Ol_id + "' type='checkbox' /></td>";
                tb += "<td>" + toDate(pageData[i].Ol_payDate) + "</td>";
                tb += "<td>" + pageData[i].Ol_payee + "</td>";
                tb += "<td>" + pageData[i].Ol_money + "</td>";
                tb += "<td>" + pageData[i].Ol_payMethod + "</td>";
                tb += "<td title='" + pageData[i].Ol_content.replace(/\|/g, "&#10;") + "'>" + pageData[i].Ol_content + "</td>";
                tb += "<td>" + pageData[i].Ol_operator + "</td>";
                tb += "<td>" + toDateTime(pageData[i].Ol_editDate) + "</td>";
                tb += "<td title='" + pageData[i].Ol_remarks + "'>" + pageData[i].Ol_remarks + "</td>";
                tb += "<td class='linked edit' name='" + i + "'>编辑</td>";
                tb += "</tr>";
            }
            $(".comTable tbody").html(tb);

            //点击编辑按钮事件
            $(".edit").click(function () {
                var data = JSON.stringify(pageData[$(this).attr("name")]);
                showBlackScreen();
                $(".blackFrame").attr("src", "OutlayEdit.aspx?data=" + safeUrlValue(data));
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
        //URL传值时，需要将特殊字符先转码
        function safeUrlValue(data) {
            data = data.replace(/\%/g, "%25");
            data = data.replace(/\#/g, "");
            data = data.replace(/\&/g, "%26");
            data = data.replace(/\\/g, "%5C");
            data = data.replace(/\=/g, "%3D");
            data = data.replace(/\?/g, "%3F");
            data = data.replace(/\./g, "%2E");
            return data;
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
                        <span>支出日期:</span>
                        <input type="date" id="Ol_payDate" />
                    </li>
                    <li>
                        <span>收款方:</span>
                        <input type="text" id="Ol_payee" />
                    </li>
                    <li>
                        <span>付款方式:</span>
                        <select id="Ol_payMethod">
                            <option value="">请选择------------------</option>
                            <option value="现金">现金</option>
                            <option value="支付宝转账">支付宝转账</option>
                            <option value="微信转账">微信转账</option>
                            <option value="银行卡转账">银行卡转账</option>
                            <option value="支票">支票</option>
                            <option value="其他">其他</option>
                        </select>
                    </li>
                    <li>
                        <span>付款内容:</span>
                        <input type="text" id="Ol_content" />
                    </li>
                    <li>
                        <span>经办人:</span>
                        <input type="text" id="Ol_operator" />
                    </li>
                    <li>
                        <span>备注:</span>
                        <input type="text" id="Ol_remarks" />
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
            <span class="containerTitle">出账信息<a id="Ol_addNew">&nbsp;+ 新增&nbsp;&nbsp;</a><a id="Ol_delete">&nbsp;- 删除&nbsp;&nbsp;</a><a id="export">&nbsp; 导出为Excel&nbsp;&nbsp;</a></span>
            <table class="comTable">
                <thead>
                    <tr>
                        <th style="width: 5%;">
                            <input id="checkAll" type="checkbox" /></th>
                        <th style="width: 10%">支出日期</th>
                        <th style="width: 10%">收款方</th>
                        <th style="width: 10%;">付款金额</th>
                        <th style="width: 10%">付款方式</th>
                        <th style="width: 10%">付款内容</th>
                        <th style="width: 10%">经办人</th>
                        <th style="width: 15%">操作时间</th>
                        <th style="width: 15%">备注</th>
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
