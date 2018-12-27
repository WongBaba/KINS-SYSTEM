<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddProductSku.aspx.cs" Inherits="KINS_SYSTEM.Pages.ProductManagement.AddSku" %>

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
            var skuId = getUrlParam('data-id');
            $("#SKU_id").val(skuId + "-");
            $("#SKU_inventory").val(0);

            //表单验证
            var ef = $('#form1').easyform();
            ef.is_submit = false;
            $("#no").click(function () {
                closeFrame();
            });
            $("#yes").click(function () {
                ef.success = function (ef) {$("#yes").attr("disabled", "true"); addProduct() }
                ef.submit(false);
            });
        });

        function addProduct() {
            var data = new Object();
            data.SKU_id = $("#SKU_id").val();
            data.SKU_name = $("#SKU_name").val();
            data.SKU_pdId = getUrlParam('data-id');
            data.SKU_inventory = $("#SKU_inventory").val();
            data.SKU_price = $("#SKU_price").val();
            data.SKU_parameter = $("#SKU_parameter").val();
            data.SKU_remarks = $("#SKU_remarks").val();
            $.post("AddProductSku.ashx", { data: JSON.stringify(data) },
                function (data) {
                    if (data == "2") {
                        closeFrame();
                        window.parent.getSkuData();
                        window.parent.getProduct();
                    } else if (data == "0") {
                        alert("新添失败，请刷新网页重试或联系管理员");
                    } else {
                        alert("添加失败，该产品已存在不能重复添加");
                        closeFrame();
                    }
                });
        }

        function closeFrame() {
            window.parent.hideBlackScreen();
            window.parent.getSkuData();
        }
    </script>
</head>
<body>
    <div id="form1" style="width: 500px; height: 380px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
        <div class="containerTitle">添加产品</div>
        <div class="container" style="height:250px;overflow:auto">
            <ul>
                <li>
                    <div class="name non-null">SKU型号</div>
                    <div class="value">
                        <input id="SKU_id" type="text" data-easyform="length:1 25;char-chinese;" data-message="限制字符1-50位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">SKU名</div>
                    <div class="value">
                        <input id="SKU_name" type="text" data-easyform="length:1 50;char-chinese;" data-message="限制字符1-50位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">SKU价格</div>
                    <div class="value">
                        <input id="SKU_price" type="text" data-easyform="length:1 25;float:10 2;" data-message="可精确至小数点后两位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">SKU库存</div>
                    <div class="value">
                        <input id="SKU_inventory" type="text" data-easyform="length:1 25;uint:0 100000000000;" data-message="库存必须为正整数" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">SKU参数</div>
                    <div class="value">
                        <textarea style="resize:none;margin-left:20px;" id="SKU_parameter" data-easyform="length:1 400;char-chinese;null;" data-message="SKU参数限制1-400字符" data-easytip="disappear:none;class:KINS;disappear:other;"></textarea>
                    </div>
                </li>
                <li>
                    <div class="name">说明备注</div>
                    <div class="value">
                        <input id="SKU_remarks" type="text" data-easyform="length:1 50;null;" data-message="限制字符1000" data-easytip="disappear:none;class:KINS;disappear:other;" />
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
