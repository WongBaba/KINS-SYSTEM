<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QueryOrder.aspx.cs" Inherits="KINS_SYSTEM.Pages.OrderManagement.QueryOrder" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/commJavascript.js"></script>

    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <link href="../../CSS/iconfont.css" rel="stylesheet" />
    <title></title>
    <script>
        var pageData;
        var starCom = 1;
        $(function () {
            initPage();
            initPageData();
            //提交搜索
            $("#searchOrderButton").click(function () {
                starCom = 1;
                $("#pageNum").val(1);
                getPageData();
            });
            //重置搜索框
            $("#resetOrderFiltersButton").click(function () {
                $("#queryList input[type=text]").val("");
            })

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
                //if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 > (starCom + 200 - 1)) {
                //    starCom = (parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1;
                //    getComData();
                //    return;
                //}
                setPageData();
            })
        });
        function initPage() {
            $("body,html").css("height", $(window).height() - 20);
            $("body,html").css("max-height", $(window).height() - 20);

            $("#orderList").css("height", $(window).height() - 180);
            $("#orderList").css("max-height", $(window).height() - 180);

        }
        function initPageData() {
            getPageData();
        }
        function getPageData() {
            var data = new Object();
            data.starCom = starCom;
            data.buyerUsername = $("#buyerUsername").val().replace(" ", "") + "";
            data.originalId = $("#originalId").val().replace(" ", "") + "";
            data.orderItemTitle = $("#orderItemTitle").val().replace(" ", "") + "";
            data.waybillNo = $("#waybillNo").val().replace(" ", "") + "";
            data.phone = $("#phone").val().replace(" ", "") + "";
            data.consigneeName = $("#consigneeName").val().replace(" ", "") + "";
            $.post("getOrderData.ashx", { data: JSON.stringify(data) },
               function (data) {
                   pageData = jQuery.parseJSON(data);
                   setPageData();
               }
           );
        }
        function setPageData() {
            $(".comTable tbody").html("暂时没有数据");
            $("#dataSum").html(pageData[pageData.length - 1].订单编号);
            $("#pageSum").html(parseInt(parseInt(parseInt(pageData[pageData.length - 1].订单编号) + parseInt($(".tablePage select").val()) - 1) / parseInt($(".tablePage select").val())));
            var maxi = parseInt($("#pageNum").val()) * parseInt($(".tablePage select").val()) + 1 - starCom;
            if (pageData.length - 2 < maxi)
                maxi = pageData.length - 2;
            var tb = ""
            for (var i = (parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 - starCom ; i < maxi ; i++) {
                tb += "<tr>";
                tb += "<td>" + pageData[i].买家会员名 + "</td>";
                tb += "<td>" + pageData[i].宝贝标题 + "</td>";
                tb += "<td>" + pageData[i].宝贝总数量 + "</td>";
                tb += "<td>" + pageData[i].买家实际支付金额 + "</td>";
                var city = pageData[i].收货地址.split(" ");
                tb += "<td>" + pageData[i].收货人姓名 + " " + pageData[i].联系手机 + city[0] + " " + city[1] + "</td>";
                tb += "<td>" + pageData[i].物流单号 + "</td>";
                tb += "<td>" + pageData[i].订单状态 + "</td>";
                tb += "<td>" + toDateTime(pageData[i].订单付款时间) + "</td>";
                tb += "</tr>";
            }
            $(".comTable tbody").html(tb);
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
            background-color: white;
        }

        #queryList {
            width: 98%;
            margin-left: 1%;
            margin-top: 1%;
            height: 120px;
            border: 1px solid #ccc;
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
            height: 80px;
        }

        #orderList {
            overflow-y: scroll;
            width: 100%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="queryList">
            <div id="inputList">
                <ul>
                    <li>
                        <span>订单状态:</span>
                        <select id="printStatus">
                            <option value=""></option>
                            <option value="notPrintWaybill">未打印快递单</option>
                            <option value="notPrintShippingList">未打印发货单</option>
                            <option value="printedWaybill">已打印快递单</option>
                            <option value="printedShippingList">已打印发货单</option>
                            <option value="printWaybillCount">快递单打印次数&gt;1</option>
                        </select>
                    </li>
                    <li>
                        <span>快捷选单:</span>
                        <select id="quick">
                            <option value=""></option>
                            <option value="2">发EMS的订单</option>
                            <option value="11">发平邮的订单</option>
                            <option value="3">有买家留言</option>
                            <option value="4">有卖家备注</option>
                            <option value="15">无留言无备注</option>
                            <option value="5">包邮订单</option>
                            <option value="6">部分发货</option>
                            <option value="17">在线支付订单</option>
                            <option value="7">货到付款订单</option>
                            <option value="8">合并订单</option>
                            <option value="9">已录入运单号</option>
                            <option value="10">未录入运单号</option>
                            <option value="12">镇乡村订单</option>
                            <option value="13">非镇乡村订单</option>
                            <option value="14">有发票信息</option>
                        </select>
                    </li>
                    <li>
                        <span>买家昵称:</span>
                        <input type="text" id="buyerUsername" />
                    </li>
                    <li>
                        <span>订单编号:</span>
                        <input type="text" id="originalId" />
                    </li>
                    <li>
                        <span>旗帜颜色:</span>
                        <select id="sellerFlag">
                            <option value=""></option>
                            <option value="GRAY">无旗帜</option>
                            <option value="RED">红</option>
                            <option value="YELLOW">黄</option>
                            <option value="GREEN">绿</option>
                            <option value="BLUE">蓝</option>
                            <option value="PURPLE">紫</option>
                        </select>
                    </li>
                    <li>
                        <span>商品名称:</span>
                        <input type="text" id="orderItemTitle" />
                    </li>
                    <li>
                        <span>运单号:</span>
                        <input type="text" id="waybillNo" />
                    </li>
                    <li>
                        <span>收货人:</span>
                        <input type="text" id="consigneeName" />
                    </li>
                    <li>
                        <span>手机电话:</span>
                        <input type="text" id="phone" />
                    </li>
                    <li>
                        <span>物流公司:</span>
                        <input type="text" id="logisticsCompanyId" />
                    </li>
                    <li>
                        <span>买家留言:</span>
                        <input type="text" id="buyerRemarks" />
                    </li>
                    <li>
                        <span>卖家备忘:</span>
                        <input type="text" id="sellerRemarks" />
                    </li>
                </ul>
                <div class="submitList">
                    <button id="searchOrderButton" type="button">
                        搜索
                    </button>
                    <button id="resetOrderFiltersButton" type="button">
                        重置
                    </button>
                </div>
            </div>
        </div>
        <div id="orderList">
            <table class="comTable">
                <thead>
                    <tr>
                        <th style="width: 10%">买家昵称</th>
                        <th style="width: 25%">商品名称</th>
                        <th style="width: 5%">数量</th>
                        <th style="width: 5%">实收款</th>
                        <th style="width: 25%">收货人信息</th>
                        <th style="width: 10%">快递单号</th>
                        <th style="width: 10%">交易状态</th>
                        <th style="width: 10%">下单时间</th>
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
