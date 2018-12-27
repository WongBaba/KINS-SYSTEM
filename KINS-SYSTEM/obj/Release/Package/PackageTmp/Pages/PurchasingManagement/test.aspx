<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="KINS_SYSTEM.Pages.PurchasingManagement.test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
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
        var Cp_data = new Object();
        $(function () {
            initAddDelFunction();
            initPageData();
            //表单验证
            var ef = $('#form1').easyform();
            ef.is_submit = false;
            $("#no").click(function () {
                closeFrame();
            });
            $("#yes").click(function () {
                ef.success = function (ef) {
                    if (checkSelect().length > 0) {
                        alert(checkSelect());
                        return;
                    }
                    $("#yes").attr("disabled", "true");
                    addNew();
                }
                ef.submit(false);
            });
            $("#Pc_typeId,#Pc_manufacturerId").change(function () {
                getComponent();
            });
            $("#Pc_Method").change(function () {
                if ($(this).val().indexOf("月结") >= 0)
                    $(".monthPay").show();
                else $(".monthPay").hide();
            });
        });
        //对采购方式、供应商、零件类型添加验证，不能为空
        function checkSelect() {
            var errStr = "";
            if ($("#Pc_Method").val() == "")
                errStr += "采购方式不能为空\n";
            if ($("#Pc_manufacturerId").val() == "")
                errStr += "供应商不能为空\n";
            for (var i = 0; i < $(".Pc_typeId").size() ; i++) {
                if ($(".Pc_typeId").eq(i).val() == "") {
                    errStr += "零件类型不能为空\n"
                    break;
                }
            }
            if ($(".num").size()<1)
                errStr += "请至少填写一条记录\n"
            return errStr;
        }

        //初始化页面供应商和零件类型下拉框数据
        function initPageData() {
            var d = new Date();
            $("#Pc_date").val(d.getFullYear() + '-' + (d.getMonth() + 1 < 10 ? '0' : '') + (d.getMonth() + 1) + '-' + (d.getDate() < 10 ? '0' : '') + d.getDate());
            $("#Pc_operator").val("<%=Session["xm"]%>");
            getCo_ComType();
        }
        //根据已选择的供应商和零件类型，获取相应的零件数据
        function getComponent() {
            var data = new Object();
            data.Cp_manufacturerId = $("#Pc_manufacturerId").val();
            data.Cp_typeId = $("#Pc_typeId").val();
            $.post("PurchasingGetComponent.ashx", { data: JSON.stringify(data) },
                function (data) {
                    Cp_data = jQuery.parseJSON(data);
                    var htmlData = "";
                    for (var i = 0; i < Cp_data.Table.length; i++) {
                        htmlData += "<li Cp_num='" + i + "' title='规格:" +
                            Cp_data.Table[i].Cp_parameter + "&#10;库存数量:" + Cp_data.Table[i].Cp_inventory +
                            "&#10;库存单价:" + Cp_data.Table[i].Cp_price + "'>" + (i + 1) + "、&nbsp;&nbsp;&nbsp;&nbsp;" + Cp_data.Table[i].Cp_parameter + "</li>";
                    }
                    $(".componentData ul").html(htmlData);
                    $(".componentData li").click(function () {
                        var num = $(this).attr("Cp_num");
                        $("#Pc_manufacturerId").val(Cp_data.Table[num].Cp_manufacturerId);
                        $("#Pc_typeId").val(Cp_data.Table[num].Cp_typeId);
                        if ($(".num").size() > 10) {
                            alert("无法继续添加，一次最多填写11条记录");
                            return;
                        } else
                            $(".add").trigger("click");
                        $(".num:last").parent().find(".Pc_parameter").val(Cp_data.Table[num].Cp_parameter);
                    });
                });
        }

        //初始化页面公司和零件类型数据
        function getCo_ComType() {
            $.post("../ComponentManagement/Init_Co_ComType.ashx", null,
                function (data) {
                    var pageData = jQuery.parseJSON(data);
                    var htmlData = "<option value=''></option>";
                    for (var i = 0; i < pageData.Table.length; i++) {
                        htmlData += "<option value='" + pageData.Table[i].Co_id + "'>" + pageData.Table[i].Co_abbreviation + "</option>";
                    }
                    $("#Pc_manufacturerId").html(htmlData);
                    htmlData = "<option value=''></option>";
                    for (var i = 0; i < pageData.Table1.length; i++) {
                        htmlData += "<option value='" + pageData.Table1[i].Tp_id + "'>" + pageData.Table1[i].Tp_name + "</option>";
                    }
                    $("#Pc_typeId").html(htmlData);
                }
            );
        }
        //新增加采购数据（包括库存和财务数据）
        function addNew() {
            var num=$(".num").size();
            var data = new Object();
            data.Pc_Method = $("#Pc_Method").val();
            data.Pc_date = $("#Pc_date").val();
            data.Pc_manufacturerId = $("#Pc_manufacturerId").val();
            data.A_Pc_typeId = new Array();
            data.A_Pc_parameter = new Array();
            data.A_Pc_unitPrice = new Array();
            data.A_Pc_quantity = new Array();
            data.A_Pc_purpose = new Array();
            data.A_Pc_remarks = new Array();
            for (var i = 0; i < num; i++) {
                data.A_Pc_typeId.push($(".Pc_typeId").eq(i).val())
                data.A_Pc_parameter.push($(".Pc_parameter").eq(i).val())
                data.A_Pc_unitPrice.push($(".Pc_unitPrice").eq(i).val())
                data.A_Pc_quantity.push($(".Pc_quantity").eq(i).val())
                data.A_Pc_purpose.push($(".Pc_purpose").eq(i).val())
                data.A_Pc_remarks.push($(".Pc_remarks").eq(i).val())
            }
            $.post("PurchasingAddnew.ashx", { data: JSON.stringify(data) },
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
        function initAddDelFunction() {
            $(".add").click(function () {
                $(this).attr("class", "num");
                $(this).siblings("td").eq(0).html("<select class='Pc_typeId'>" + $("#Pc_typeId").html() + "</select>");
                $(this).siblings("td").find(".Pc_typeId").val($("#Pc_typeId").val());
                $(this).siblings("td").eq(1).html("<input class='Pc_parameter' type='text' data-easyform='length:1 140;' data-message='规格不能为空，限140字' data-easytip='disappear:none;class:KINS;disappear:other;' />");
                $(this).siblings("td").eq(2).html("<input class='Pc_quantity' type='text' data-easyform='float:10 3' data-message='数量不能为空，只限数字' data-easytip='disappear:none;class:KINS;disappear:other;' />");
                $(this).siblings("td").eq(3).html("<input class='Pc_unitPrice' type='text' data-easyform='float:10 3' data-message='单价不能为空，只限数字，最多三位小数' data-easytip='disappear:none;class:KINS;disappear:other;' />");
                $(this).siblings("td").eq(6).attr("class", "Pc_totalPrice");
                $(this).siblings("td").eq(4).html("<input class='Pc_purpose' type='text' data-easyform='length:0 100;null;' data-message='最多100位中文、英文、数字、下划线、中文标点符号' data-easytip='disappear:none;class:KINS;disappear:other;' />");
                $(this).siblings("td").eq(5).html("<input class='Pc_remarks' type='text' data-easyform='length:0 100;null;' data-message='最多100位中文、英文、数字、下划线、中文标点符号' data-easytip='disappear:none;class:KINS;disappear:other;' />");
                $(this).parent().next("tr").html("<td class='add'>+</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>");
                $(this).siblings("td:last").addClass("del");
                $(this).siblings("td:last").html("-");
                $(".Pc_unitPrice,.Pc_quantity").off('change').change(function () {
                    $(this).parent().siblings(".Pc_totalPrice").html(($(this).parent().parent().find(".Pc_unitPrice").val() * $(this).parent().parent().find(".Pc_quantity").val()).toFixed(2) + "元");
                });
                reloadTable();
                initAddDelFunction();
            });
            $(".del").unbind();
            $(".del").click(function () {
                $(this).parent().remove();
                $(".comTable tbody").append("<tr></tr>");
                reloadTable();
            });
        }
        function reloadTable() {
            for (var i = 0; i < $(".num").size() ;) {
                $(".num").eq(i).html(++i);
            }
            if ($(".num").size() > 10)
                $(".add").parent().hide();
            else $(".add").parent().show();
        }
    </script>
    <style>
        .Pc_typeId {
            margin:0;
            width:100%;
            font-size:8pt;
        }
        .container {
            float: right;
            width: 848px;
            padding: 10px;
        }

        .componentData {
            width: 300px;
            float: left;
            border-right: 1px solid #dee5f3;
            box-sizing: border-box;
            height: 500px;
            padding: 10px;
        }

            .componentData ul {
                margin: 0;
                width: 100%;
                border: 1px solid #dee5f3;
                box-sizing: border-box;
                background-color: #efefef;
                height: 480px;
                overflow: auto;
            }

                .componentData ul li {
                    font-size: 10pt;
                    cursor: pointer;
                    padding-left: 5px;
                    text-align: left;
                    margin-top: 5px;
                }

                    .componentData ul li:hover {
                        background-color: #ccc;
                    }

        .top {
            height: 30px;
            width: 100%;
        }


        .main {
            width: 100%;
            height: 450px;
        }
        .comTable {
            overflow:hidden;
            height:400px;
            box-sizing:border-box;
        }

            .comTable thead, tbody, tr, td {
            box-sizing:border-box;
            }
            .comTable tbody {
                height:360px;
                overflow:hidden;
            }
        .comTable input {
            width:100%;
            height:100%;
            margin:0px;text-align:left;
        }
        .top ul {
            height:40px;
            width:100%;
        }
        .top li {
            float:left;
            margin-left:10px;
            width:auto;
        }
        .Pc_totalPrice {
            color:red;
        }
    </style>
    <script>
    </script>
</head>
<body>
    <div id="form1" style="width: 1150px; height: 530px; background-color: white; border: 1px solid #ccc; margin: 0 auto; -moz-box-shadow: 0px 0px 10px #000;">
        <div class="containerTitle">新增采购</div>
        <div class="componentData">
            <ul>
            </ul>
        </div>
        <div class="container">
            <div class="top">
                <ul>
                    <li>采购方式
                        <select id="Pc_Method">
                            <option value=""></option>
                            <option value="入库+入账">入库+入账</option>
                            <option value="入库+月结入账">入库+月结入账</option>
                            <option value="只入库">只入库</option>
                            <option value="只入账">只入账</option>
                            <option value="只月结入账">只月结入账</option>
                        </select>
                    </li>
                    <li>零件供应商
                        <select id="Pc_manufacturerId"></select>
                    </li>
                    <li>零件类型
                        <select id="Pc_typeId"></select>
                    </li>
                    <li>采购日期
                        <input id="Pc_date" type="date" data-easyform="date;" data-message="日期不能为空" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </li>
                </ul>
            </div>
            <div class="main">
                <table class="comTable">
                    <thead>
                        <tr>
                            <th style="width: 5%;">序号</th>
                            <th style="width: 10%">零件类型</th>
                            <th style="width: 20%">规格</th>
                            <th style="width: 10%">数量</th>
                            <th style="width: 10%">单价</th>
                            <th style="width: 15%;">采购原因/用途</th>
                            <th style="width: 10%;">备注</th>
                            <th style="width: 10%">金额</th>
                            <th style="width: 5%;">删除</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr><td class="add">+</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                        <tr></tr>
                    </tbody>
                </table>
                <div class="submitButton">
                <input type="button" value="确定" id="yes" />
                &nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="取消" id="no" />
            </div>
            </div>
            <ul style="display:none;">
                <li>
                    <div class="name non-null">采购方式</div>
                    <div class="value">
                        <select class="Pc_Method">
                            <option value=""></option>
                            <option value="入库+入账">入库+入账</option>
                            <option value="入库+月结入账">入库+月结入账</option>
                            <option value="只入库">只入库</option>
                            <option value="只入账">只入账</option>
                            <option value="只月结入账">只月结入账</option>
                        </select>
                    </div>
                </li>
                <li style="display: none;" class="monthPay">
                    <div class="name non-null">月结日期</div>
                    <div class="value">
                        <input id="Pc_payableDate" type="date" data-easyform="date;" data-message="日期不能为空" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">采购日期</div>
                    <div class="value">
                        <input id="Pc_date1" type="date" data-easyform="date;" data-message="日期不能为空" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">零件供应商</div>
                    <div class="value">
                        <select id="Pc_manufacturerId1"></select>
                    </div>
                </li>
                <li>
                    <div class="name non-null">零件类型</div>
                    <div class="value">
                        <select id="Pc_typeId1"></select>
                    </div>
                </li>
                <li>
                    <div class="name non-null">零件规格</div>
                    <div class="value">
                        <input id="Pc_parameter" type="text" data-easyform="length:1 140;" data-message="规格不能为空，限140字" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">采购单价</div>
                    <div class="value">
                        <input id="Pc_unitPrice" type="text" data-easyform="float:10 3" data-message="单价不能为空，只限数字，最多三位小数" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">采购数量</div>
                    <div class="value">
                        <input style="width: 30%;" id="Pc_quantity" type="text" data-easyform="float:10 3" data-message="金额不能为空，只限数字" data-easytip="disappear:none;class:KINS;disappear:other;" />
                        <select id="Pc_unit" style="width: 30%; margin-left: 10px;">
                            <option value="个" selected="selected">个</option>
                            <option value="千克">千克</option>
                            <option value="米">米</option>
                            <option value="件">件</option>
                        </select>
                    </div>
                </li>
                <li>
                    <div class="name">总价</div>
                    <div class="value">
                        <input id="Pc_totalPrice" type="text" value="0元" disabled="disabled" style="border: 0px; background-color: white" />
                    </div>
                </li>
                <li>
                    <div class="name">采购用途</div>
                    <div class="value">
                        <input id="Pc_purpose" type="text" data-easyform="length:0 100;null;" data-message="最多100位中文、英文、数字、下划线、中文标点符号" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name non-null">经办人</div>
                    <div class="value">
                        <input id="Pc_operator" type="text" data-easyform="length:0 19;null;" data-message="最多19位中文、英文、数字、下划线、中文标点符号" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>
                <li>
                    <div class="name">备注</div>
                    <div class="value">
                        <input id="Pc_remarks" type="text" data-easyform="length:0 100;null;" data-message="最多100位中文、英文、数字、下划线、中文标点符号" data-easytip="disappear:none;class:KINS;disappear:other;" />
                    </div>
                </li>

                <a class="non-null">标注为必填项</a>
            </ul>

            
        </div>
    </div>
</body>
</html>


