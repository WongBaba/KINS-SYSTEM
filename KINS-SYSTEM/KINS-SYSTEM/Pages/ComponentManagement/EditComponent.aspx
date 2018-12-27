<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditComponent.aspx.cs" Inherits="KINS_SYSTEM.Pages.ComponentManagement.EditComponent" %>

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
            initPage();
            initPageData();
            var url = window.location.href;


            //表单验证
            var ef = $('#form1').easyform();
            ef.is_submit = false;
            $("#no").click(function () {
                closeFrame();
            });
            $("#yes").click(function () {
                ef.success = function (ef) {$("#yes").attr("disabled", "true"); addCompany() }
                ef.submit(false);
            });
        });

        //初始化页面各控件
        function initPage() {
            $("#Cp_typeId").html(getSelect(getUrlParam('cp_type').split(';')));
            $("#Cp_manufacturerId").html(getSelect(getUrlParam('co_name').split(';')));
        }

        //初始化页面各控件数据
        function initPageData() {
            var data = jQuery.parseJSON(getUrlParam('data'));
            $("#Cp_name").val(data.Cp_name);
            $("#Cp_typeId").val(data.Cp_typeId);
            $("#Cp_manufacturerId").val(data.Cp_manufacturerId);
            $("#Cp_parameter").val(data.Cp_parameter);
            $("#Cp_price").val(data.Cp_price);
            $("#Cp_pictrue").val(data.Cp_pictrue);
            $("#Cp_remarks").val(data.Cp_remarks);
            $("#Cp_inventory").val(data.Cp_inventory);
        }

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


        function addCompany() {
            var data = new Object();
            data.Cp_typeId = $("#Cp_typeId").val();
            data.Cp_manufacturerId = $("#Cp_manufacturerId").val();
            data.Cp_parameter = $("#Cp_parameter").val();
            data.Cp_price = $("#Cp_price").val();
            data.Cp_unit = $("#Cp_unit").val();
            data.Cp_inventory = $("#Cp_inventory").val();
            data.Cp_remarks = $("#Cp_remarks").val();
            data.Cp_pictrue = $("#Cp_pictrue").val();
            data.Cp_id = jQuery.parseJSON(getUrlParam('data')).Cp_id;
            $.post("EditComponent.ashx", { data: JSON.stringify(data) },
                function (data) {
                    if (data == "2") {
                        closeFrame();
                    } else if (data == "0") {
                        alert("编辑失败，请刷新网页重试或联系管理员");
                        closeFrame();
                    } 
                });
        }

        function closeFrame() {
            window.parent.hideBlackScreen();
            window.parent.getComData();
        }
    </script>
</head>
<body>
    <div id="form1" style="width: 500px; height: 530px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
        <div class="containerTitle">编辑</div>
        <div class="container">
            <ul>
                <li>
                    <div class="name">零件类型</div>
                    <div class="value">
                        <select id="Cp_typeId"></select>
                    </div>
                </li>
                <li>
                    <div class="name">零件生产商</div>
                    <div class="value">
                        <select id="Cp_manufacturerId"></select>
                    </div>
                </li>
                <li>
                    <div class="name name non-null">零件参数</div>
                    <div class="value">
                        <input id="Cp_parameter" type="text" data-easyform="length:1 140;char-chinese;" data-message="零件参数必须为1-140位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">零件价格</div>
                    <div class="value">
                        <input id="Cp_price" type="text" data-easyform="float:10 3" data-message="价格格式错误" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">库存单位</div>
                    <div class="value">
                        <select id="Cp_unit">
                            <option value="个" selected="selected">个</option>
                            <option value="千克">千克</option>
                            <option value="米">米</option>
                            <option value="件">件</option>
                        </select>
                    </div>
                </li>
                <li>
                    <div class="name">零件库存</div>
                    <div class="value">
                        <input id="Cp_inventory" type="text" data-easyform="float:10 3;null;" data-message="库存格式错误" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">零件图片</div>
                    <div class="value">
                        <input id="Cp_pictrue" type="text" data-easyform="null;" data-message="图片格式错误" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">说明备注</div>
                    <div class="value">
                        <input id="Cp_remarks" type="text" data-easyform="length:1 50;null;" data-message="字数必须为1-50位" data-easytip="disappear:none;class:KINS;disappear:other;" />
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
