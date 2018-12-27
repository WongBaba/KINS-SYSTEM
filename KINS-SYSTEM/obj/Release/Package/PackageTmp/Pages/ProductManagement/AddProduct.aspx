<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddProduct.aspx.cs" Inherits="KINS_SYSTEM.Pages.ProductManagement.AddProduct" %>

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
            var url = window.location.href;
            $("#Pd_typeId").html(getSelect(getUrlParam('pd_type').split(';')));
            $("#Pd_manufacturerId").html(getSelect(getUrlParam('co_name').split(';')));


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

        //根据数组生成 select控件代码
        function getSelect(array) {
            var str = "";
            for (var i = 0; i < array.length; i += 2) {
                str += "<option value='" + array[i] + "'";
                if (i == 0)
                    str += "selected='selected'";
                str += ">" + array[i + 1] + "</option>";
            }
            return str;
        }


        function addProduct() {
            var data = new Object();
            data.Pd_id = $("#Pd_id").val();
            data.Pd_name = $("#Pd_name").val();
            data.Pd_typeId = $("#Pd_typeId").val();
            data.Pd_manufacturerId = $("#Pd_manufacturerId").val();
            data.Pd_parameter = $("#Pd_parameter").val();
            data.Pd_remarks = $("#Pd_remarks").val();
            $.post("AddProduct.ashx", { data: JSON.stringify(data) },
                function (data) {
                    if (data == "2") {
                        closeFrame();
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
            window.parent.getPdData();
        }
    </script>
</head>
<body>
    <div  id="form1" style="width: 500px; height: 530px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
        <div class="containerTitle">添加产品</div>
        <div class="container">
            <ul>
                <li>
                    <div class="name non-null">产品型号</div>
                    <div class="value">
                        <input id="Pd_id" type="text" data-easyform="length:1 25;char-chinese;" data-message="型号必须为1-25位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">产品名</div>
                    <div class="value">
                        <input id="Pd_name" type="text" data-easyform="length:1 25;char-chinese;" data-message="名称必须为1-25位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">产品类目</div>
                    <div class="value">
                        <select id="Pd_typeId"></select>
                    </div>
                </li>
                <li>
                    <div class="name">产品生产商</div>
                    <div class="value">
                        <select id="Pd_manufacturerId"></select>
                    </div>
                </li>
                <li>
                    <div class="name">产品参数</div>
                    <div class="value">
                        <input id="Pd_parameter" type="text" data-easyform="length:1 140;char-chinese;" data-message="零件参数必须为1-140位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">说明备注</div>
                    <div class="value">
                        <input id="Pd_remarks" type="text" data-easyform="length:1 50;null;" data-message="字数必须为1-50位" data-easytip="disappear:none;class:KINS;disappear:other;" />
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
