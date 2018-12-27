<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductManagement.aspx.cs" Inherits="KINS_SYSTEM.Pages.ProductManagement.ProductManagement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="../../JS/jquery-1.6.js"></script>
    <script src="../../JS/commJavascript.js"></script>
    <title>添加新零件</title>
    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />

    <link href="../../PageCSS/ComponentManagement/ComponentManagement.css" rel="stylesheet" />
    <script>
        var comData;
        var require = new Object();//数据要求
        require.order = "0";//数据要求类型
        require.require = "";// 数据要求字符
        var starCom = 1; //当前200条数据的第一条数据的排名
        $(function () {
            initPage();
            initPageData();
            getPdData();
            initFunction();
        });

        //初始化页面各控件的事件
        function initFunction() {
            $("#delCo").click(function () {
                delCo();
            });
            $("#delType").click(function () {
                delType();
            });
            $("#addType").click(function () {
                addType();
            });
            $("#addCo").click(function () {
                addCo();
            });
            $("#delCom").click(function () {
                delCom();
            });
            $("#addCom").click(function () {
                addCom();
            });

            $("#checkAll").click(function () {
                $("tbody input[type=checkbox]").trigger("click");
            });

            //显示全部零件数据
            $("#comShowAll").click(function () {
                require.order = 0;
                regetPdData();
            });

            //更换每页显示数量
            $(".tablePage select").change(function () {
                $("#pageNum").val(1);
                starCom = 1;
                getPdData();
            });

            //上一页操作
            $("#pre").click(function () {
                if ($("#pageNum").val() == "1")
                    return;
                $("#pageNum").val(parseInt($("#pageNum").val()) - 1);
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 < starCom) {
                    //往回跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getPdData();
                    return;
                }
                setPdData();
            });

            //下一页操作
            $("#next").click(function () {
                if ($("#pageNum").val() == $("#pageSum").text())
                    return;
                $("#pageNum").val(parseInt($("#pageNum").val()) + 1);
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 > starCom + 199) {
                    //往下跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getPdData();
                    return;
                }
                setPdData();
            });

            //跳页操作
            $("#submitPage").click(function () {
                //跳页如果跳出了有效区间，则重置数据
                if (parseInt($("#pageNum").val()) < 1 || parseInt($("#pageNum").val()) > parseInt($("#pageSum").text())) {
                    starCom = 1;
                    $("#pageNum").val(1);
                    getPdData();
                    return;
                }
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 < starCom) {
                    //往回跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getPdData();
                    return;
                }
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 > starCom + 199) {
                    //往下跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    alert(starCom);
                    getPdData();
                    return;
                }
                setPdData();
            })
        }

        //弹出添加零件窗口及进行确认
        function addCom() {
            var co_name = "";
            var pd_type = "";

            if ($("#comCompany li").length == "0") {
                alert("需要先添加产品生产商才能添加零件");
                return;
            }
            $("#comCompany li").each(function () {
                co_name += ";" + $(this).find("input").attr("data-Co_id") + ";" + $(this).text();
            });

            if ($("#comType li").length == "0") {
                alert("需要先添加产品类型才能添加零件");
                return;
            }
            $("#comType li").each(function () {
                pd_type += ";" + $(this).find("input").attr("data-Tp_id") + ";" + $(this).text();
            });
            showBlackScreen();
            $(".blackFrame").attr("src", "AddProduct.aspx?co_name=" + co_name.substring(1) + "&pd_type=" + pd_type.substring(1));
        }

        //弹出添加公司类型窗口及进行确认
        function addCo() {
            showBlackScreen();
            $(".blackFrame").attr("src", "../ComponentManagement/AddCompany.aspx");
        }

        //弹出添加产品类型窗口及进行确认
        function addType() {
            showBlackScreen();
            $(".blackFrame").attr("src", "AddProductType.aspx");
        }

        //弹出删除产品类型窗口及进行确认
        function delType() {
            if ($("#comType input:[type='checkbox']:checked").length == "0")
                return;
            var delData = "";
            $("#comType input:[type='checkbox']:checked").each(function () {
                delData += "," + $(this).attr("data-Tp_id");
            });
            delData = delData.substring(1);
            showBlackScreen();
            $(".blackFrame").attr("src", "../ComponentManagement/DelComponentType.aspx?delData=" + delData);
        }

        //弹出删除公司窗口及进行确认
        function delCo() {
            if ($("#comCompany input:[type='checkbox']:checked").length == "0")
                return;
            var delData = "";
            $("#comCompany input:[type='checkbox']:checked").each(function () {
                delData += "," + $(this).attr("data-Co_id");
            });
            delData = delData.substring(1);
            showBlackScreen();
            $(".blackFrame").attr("src", "../ComponentManagement/DelCompany.aspx?delData=" + delData);
        }

        //弹出删除产品窗口及进行确认
        function delCom() {
            if ($(".comTable tbody input[type='checkbox']:checked").length == "0")
                return;
            var delData = "";
            $(".comTable tbody input[type='checkbox']:checked").each(function () {
                delData += "," + $(this).attr("data-Pd_id");
            });
            delData = delData.substring(1);
            showBlackScreen();
            $(".blackFrame").attr("src", "DelProduct.aspx?delData=" + delData);
        }

        //初始化页面布局
        function initPage() {
            $("#iframeContainer").css("height", $(window).height() - 20);
        }

        //重新获取产品信息
        function regetPdData() {
            $("#pageNum").val(1);
            starCom = 1;
            getPdData();
        }

        //初始化页面公司和产品类型数据
        function initPageData() {
            $.post("Init_Co_PdType.ashx", null,
                function (data) {
                    pageData = jQuery.parseJSON(data);
                    $("#comType ul").html(pageData.pd);
                    $("#comCompany ul").html(pageData.co);

                    $("#comType li").click(function () {
                        $("#pageNum").val(1);
                        starCom = 1;
                        require.order = 1;
                        require.require = $(this).find("input").attr("data-Tp_id");
                        getPdData();
                    });
                    $("#comCompany li").click(function () {
                        $("#pageNum").val(1);
                        starCom = 1;
                        require.order = 2;
                        require.require = $(this).find("input").attr("data-Co_id");
                        getPdData();
                    });
                }
            );
        }

        //从数据库获取200条数据
        function getPdData() {
            var data = new Object();
            //order=0 为全部查询，order=1 为
            data.order = require.order;
            data.require = require.require;
            data.starCom = starCom;

            $.post("GetProduct.ashx", { data: JSON.stringify(data) },
                function (data) {
                    comData = jQuery.parseJSON(data);
                    setPdData();
                }
            );
        }

        //根据每页条数和当前页码显示零件信息表
        function setPdData() {
            $(".comTable tbody").html("暂时没有数据");
            var tableData = "";
            $("#dataSum").html(comData[comData.length - 1].Pd_name);
            $("#pageSum").html(parseInt(parseInt(parseInt(comData[comData.length - 1].Pd_name) + parseInt($(".tablePage select").val()) - 1) / parseInt($(".tablePage select").val())));
            for (var i = (parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 - starCom ; i < parseInt($("#pageNum").val()) * parseInt($(".tablePage select").val()) + 1 - starCom ; i++) {
                if (i == comData.length - 1)
                    break;
                tableData += "<tr>";
                tableData += "<td><input data-Pd_id='" + comData[i].Pd_id + "' type='checkbox' /></td>";
                tableData += "<td title='" + comData[i].Pd_id + "'>" + comData[i].Pd_id + "</td>";
                tableData += "<td title='" + comData[i].Pd_name + "'>" + comData[i].Pd_name + "</td>";
                tableData += "<td title='" + comData[i].Tp_name + "'>" + comData[i].Tp_name + "</td>";
                tableData += "<td title='" + comData[i].Pd_parameter + "'>" + comData[i].Pd_parameter + "</td>";
                tableData += "<td title='" + comData[i].Pd_price + "'>" + comData[i].Pd_price + "</td>";
                tableData += "<td title='" + comData[i].Pd_inventory + "'>" + comData[i].Pd_inventory + "</td>";
                tableData += "<td class='linked'>编辑</td>";
                tableData += "<td class='linked SKU' data-id='" + comData[i].Pd_id + "'  title='" + comData[i].Pd_SKU + "'>" + comData[i].Pd_SKU + "</td>";
                tableData += "<td title='" + comData[i].Co_abbreviation + "'>" + comData[i].Co_abbreviation + "</td>";
                tableData += "<td title='" + comData[i].Pd_remarks + "'>" + comData[i].Pd_remarks + "</td>";
                tableData += "</tr>";
            }
            $(".comTable tbody").html(tableData);


            //为刚插入的数据添加点击事件，点击SKU数量弹出SKU信息
            $(".SKU").click(function () {
                if ($(this).html() == "null")
                    return;
                showBlackScreen();
                $(".blackFrame").attr("src", "ProductSKU.aspx?data-id=" + $(this).attr("data-id"));
            });
        }
    </script>
</head>
<body>
    <div id="iframeContainer">
        <div class="blackScreen">
            <a class="closeBlack">&#xe6b7;</a>
        </div>
        <iframe class="blackFrame" src="" scrolling="no"></iframe>
        <div id="leftContainer">
            <div id="comType" class="borderShadow">
                <span class="containerTitle">产品分类<a id="addType">&nbsp;+ 新建&nbsp;&nbsp;</a><a id="delType">&nbsp;- 删除&nbsp;&nbsp;</a></span>
                <ul style="overflow-y: auto; max-height: 80%">
                    <li></li>
                </ul>
            </div>
            <div id="comCompany" class="borderShadow">
                <span class="containerTitle">产品采购商<a id="addCo">&nbsp;+ 新添&nbsp;&nbsp;</a><a id="delCo">&nbsp;- 删除&nbsp;&nbsp;</a></span>
                <ul>
                    <li></li>
                </ul>
            </div>
        </div>
        <div id="rightContainer">
            <span class="containerTitle">产品信息<a id="addCom">&nbsp;+ 新建&nbsp;&nbsp;</a><a id="delCom">&nbsp;- 删除&nbsp;&nbsp;</a><a id="comShowAll">&nbsp;&nbsp;显示全部&nbsp;&nbsp;</a></span>
            <div style="overflow-y: scroll; width: 100%; max-height: 80%;">
                <table class="comTable">
                    <thead>
                        <tr>
                            <th style="width: 5%;">
                                <input id="checkAll" type="checkbox" /></th>
                            <th style="width: 10%">产品型号</th>
                            <th style="width: 10%">产品名</th>
                            <th style="width: 10%">类目</th>
                            <th style="width: 15%">产品属性</th>
                            <th style="width: 10%">产品价格</th>
                            <th style="width: 5%">库存</th>
                            <th style="width: 5%">操作</th>
                            <th style="width: 5%">SKU</th>
                            <th style="width: 10%;">生产厂商</th>
                            <th>备注说明</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div class="tablePage">
                <div style="margin-right: 30px; margin-top: 10px; height: 50px; display: block">
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
        </div>
    </div>
</body>
</html>
