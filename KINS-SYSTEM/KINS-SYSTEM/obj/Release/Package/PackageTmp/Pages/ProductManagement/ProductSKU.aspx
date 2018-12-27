<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductSKU.aspx.cs" Inherits="KINS_SYSTEM.Pages.ProductManagement.ProductSKU" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/iconfont.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/commJavascript.js"></script>
    <title></title>
    <script>
        var skuId = getUrlParam('data-id');//该SKU所属产品的id
        var skuData;//该产品的所有SKU数据
        $(function () {
            getSkuData();

            //全选勾选框
            $("#checkAll").click(function () {
                $("tbody input[type=checkbox]").trigger("click");
            });

            $("#addSku").click(function () {
                addSku();
            });

            $("#delSku").click(function () {
                delSku();
            });

            //弹出添加SKU窗口及进行确认
            function addSku() {
                showBlackScreen();
                $(".blackFrame").attr("src", "AddProductSku.aspx?data-id=" + skuId);
            }

            //弹出删除SKU窗口及进行确认
            function delSku() {
                if ($(".comTable tbody input[type='checkbox']:checked").length == "0")
                    return;
                var delData = "";
                $(".comTable tbody input[type='checkbox']:checked").each(function () {
                    delData += "," + $(this).attr("data-Pd_id");
                });
                delData = delData.substring(1);
                showBlackScreen();
                $(".blackFrame").attr("src", "DelProductSku.aspx?delData=" + delData+"&skuId="+skuId);
            }
        })

        //获取SKU数据库数据
        function getSkuData() {
            $.post("GetSkuData.ashx", { data: JSON.stringify(skuId) },
                function (data) {
                    skuData = jQuery.parseJSON(data);
                    setSkuData();
                });
        }
        //将SKU数据插入到页面中
        function setSkuData() {
            $("tbody").html("<tr><td colspan='7'>暂时没有数据</td></tr>");
            var tableData = "";
            for (var i = 0; i < skuData.length; i++) {
                tableData += "<tr>";
                tableData += "<td><input data-Pd_id='" + skuData[i].SKU_id + "' type='checkbox' /></td>";
                tableData += "<td title='" + skuData[i].SKU_id + "'>" + skuData[i].SKU_id + "</td>";
                tableData += "<td title='" + skuData[i].SKU_name + "'>" + skuData[i].SKU_name + "</td>";
                tableData += "<td title='" + skuData[i].SKU_parameter + "'>" + skuData[i].SKU_parameter + "</td>";
                tableData += "<td title='" + skuData[i].SKU_price + "'>" + skuData[i].SKU_price + "</td>";
                tableData += "<td title='" + skuData[i].SKU_inventory + "'>" + skuData[i].SKU_inventory + "</td>";
                tableData += "<td class='linked'>编辑</td>";
                tableData += "<td title='" + skuData[i].SKU_remarks + "'>" + skuData[i].SKU_remarks + "</td>";
                tableData += "</tr>";
            }
            if ($("tbody").html() != "")
                $("tbody").html(tableData);
        }
        function getProduct() {
            window.parent.getPdData();
        }
    </script>
    <style>
        body {
            background-color: #fff;
        }
        tr {
            height:30px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 100%">
        <div class="blackScreen">
            <a class="closeBlack">&#xe6b7;</a>
        </div>
        <iframe class="blackFrame" src="" scrolling="no"></iframe>
            <div><span class="containerTitle">产品SKU<a id="addSku">&nbsp;+ 新建&nbsp;&nbsp;</a><a id="delSku">&nbsp;- 删除&nbsp;&nbsp;</a></span></div>
            <div id="skuList"  style="width: 100%; height: 350px; width: 100%; overflow: auto;">
                <table class="comTable">
                    <thead>
                        <tr>
                            <th style="width: 5%;">
                                <input id="checkAll" type="checkbox" /></th>
                            <th style="width: 10%">SKU型号</th>
                            <th style="width: 10%">SKU名</th>
                            <th style="width: 40%">参数</th>
                            <th style="width: 10%">价格</th>
                            <th style="width: 5%">库存</th>
                            <th style="width: 5%">操作</th>
                            <th style="width: 15%">备注</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
