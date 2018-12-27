<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCompany.aspx.cs" Inherits="KINS_SYSTEM.Pages.ProductManagement.AddCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/easyform.css" rel="stylesheet" />

    <script src="../../JS/commJavascript.js"></script>
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/easyform.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>新增供应商</title>
    <link href="../../PageCSS/ComponentManagement/AddCompany.css" rel="stylesheet" />
    <script>
        $(function () {
            var ef = $('#form1').easyform();
            ef.is_submit = false;
            $("#no").click(function () {
                closeFrame();
            });
            $("#yes").click(function () {
                ef.success = function (ef) {$("#yes").attr("disabled", "true"); addCompany() }
                ef.submit(false);
            });
        })

        function addCompany() {
            var data = new Object();
            data.abbreviation = $("#abbreviation").val();
            data.name = $("#name").val();
            data.en_name = $("#en_name").val();
            data.address = $("#address").val();
            data.email = $("#email").val();
            data.phone = $("#phone").val();
            $.post("addCompany.ashx", { data: JSON.stringify(data) },
                function (data) {
                    if (data == "2") {
                        closeFrame();
                    } else if (data == "0") {
                        alert("新添失败，请刷新网页重试或联系管理员");
                    } else {
                        alert("添加失败，该公司已存在不能重复添加");
                        closeFrame();
                    }
                });
        }

        function closeFrame() {
            window.parent.hideBlackScreen();
            window.parent.initPageData();
        }
    </script>

</head>
<body>
    <div id="form1" style="width: 500px; height: 380px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
        <div class="containerTitle">添加合作公司</div>
        <div class="container">
            <ul>
                <li>
                    <div class="name non-null">公司简称</div>
                    <div class="value">
                        <input id="abbreviation" type="text" data-easyform="length:1 10;char-chinese;" data-message="简称必须为1-10位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">公司全称</div>
                    <div class="value">
                        <input id="name" type="text" data-easyform="length:1 25;null;char-chinese;" data-message="全称必须为1-25位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">公司英文名</div>
                    <div class="value">
                        <input id="en_name" type="text" data-easyform="length:0 100;null;char-normal;" data-message="英文名必须为1-100位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name name non-null">公司地址</div>
                    <div class="value">
                        <input id="address" type="text" data-easyform="length:1 100;char-chinese;" data-message="地址必须为1-100位" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">公司邮箱</div>
                    <div class="value">
                        <input id="email" type="text" data-easyform="length:4 16;null;email;" data-message="邮箱格式错误" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">公司联系电话</div>
                    <div class="value">
                        <input id="phone" type="text" data-easyform="length:4 16;null;mobile;" data-message="电话格式错误" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
            </ul>

        </div>
        <input type="button" value="确定" id="yes" />
        &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" value="取消" id="no" />
    </div>
</body>
</html>
