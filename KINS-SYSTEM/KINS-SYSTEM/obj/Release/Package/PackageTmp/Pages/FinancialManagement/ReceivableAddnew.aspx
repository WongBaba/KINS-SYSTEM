<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReceivableAddnew.aspx.cs" Inherits="KINS_SYSTEM.Pages.FinancialManagement.IncomeAddnew" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/easyform.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <script src="../../JS/commJavascript.js"></script>
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/easyform.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>新增进账</title>
    <link href="../../PageCSS/ComponentManagement/AddComponent.css" rel="stylesheet" />
    <script>
        $(function () {
            initPageData();
            //表单验证
            var ef = $('#form1').easyform();
            ef.is_submit = false;
            $("#no").click(function () {
                closeFrame();
            });
            $("#yes").click(function () {
                ef.success = function (ef) {$("#yes").attr("disabled", "true"); addNew() }
                ef.submit(false);
            });
        });

        function initPageData() {
            var d = new Date();
            $("#Ic_payDate").val(d.getFullYear() + '-' + (d.getMonth() + 1 < 10 ? '0' : '') + (d.getMonth() + 1) + '-' + (d.getDate() < 10 ? '0' : '') + d.getDate());
            $("#Ic_operator").val("<%=Session["xm"]%>");
        }
        function addNew() {
            var data = new Object();
            data.Ic_payDate = $("#Ic_payDate").val();
            data.Ic_payer = $("#Ic_payer").val();
            data.Ic_money = $("#Ic_money").val();
            data.Ic_content = $("#Ic_content").val();
            data.Ic_remarks = $("#Ic_remarks").val();
            data.Ic_operator = $("#Ic_operator").val();
            data.Ic_state = "待进账";
            $.post("ReceivableAddnew.ashx", { data: JSON.stringify(data) },
               function (data) {
                   pageData = jQuery.parseJSON(data);
                   if (data == "0")
                       alert("操作失败，请刷新重试或联系管理员");
                   closeFrame();
               }
           );
        }

        function closeFrame() {
            window.parent.hideBlackScreen();
            window.parent.getPageData();
        }
    </script>
</head>
<body>
    <div id="form1" style="width: 500px; height: 530px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
        <div class="containerTitle">新增待进账信息</div>
        <div class="container">
            <ul>
                <li>
                    <div class="name non-null">收款日期</div>
                    <div class="value">
                        <input id="Ic_payDate" type="date" data-easyform="" data-message="时间不能为空" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">付款方</div>
                    <div class="value">
                        <input id="Ic_payer" type="text" data-easyform="length:1 19;char-chinese;" data-message="长度限制1-19字" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">待收款金额</div>
                    <div class="value">
                        <input id="Ic_money" type="text" data-easyform="float:10 3" data-message="金额不能为空，只限数字" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">收款内容</div>
                    <div class="value">
                        <input id="Ic_content" type="text" data-easyform="length:0 100;null;" data-message="最多100位中文、英文、数字、下划线、中文标点符号" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">经办人</div>
                    <div class="value">
                        <input id="Ic_operator" type="text" data-easyform="length:0 19;null;char-chinese;" data-message="最多19位中文、英文、数字、下划线、中文标点符号" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">备注</div>
                    <div class="value">
                        <input id="Ic_remarks" type="text" data-easyform="length:0 100;null;" data-message="最多100位中文、英文、数字、下划线、中文标点符号" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
            
        <a class="non-null">标注为必填项</a>
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
