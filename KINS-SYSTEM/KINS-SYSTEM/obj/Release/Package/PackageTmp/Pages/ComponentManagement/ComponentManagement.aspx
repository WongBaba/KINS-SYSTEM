<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ComponentManagement.aspx.cs" Inherits="KINS_SYSTEM.Pages.ProductManagement.AddNewComponent" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
            getComData();
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
                regetComData();
            })

            //更换每页显示数量
            $(".tablePage select").change(function () {
                $("#pageNum").val(1);
                starCom = 1;
                getComData();
            });

            //上一页操作
            $("#pre").click(function () {
                if ($("#pageNum").val() == "1")
                    return;
                $("#pageNum").val(parseInt($("#pageNum").val()) - 1);
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 < starCom) {
                    //往回跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getComData();
                    return;
                }
                setComData();
            });

            //下一页操作
            $("#next").click(function () {
                if ($("#pageNum").val() == $("#pageSum").text())
                    return;
                $("#pageNum").val(parseInt($("#pageNum").val()) + 1);
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 > starCom + 199) {
                    //往下跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getComData();
                    return;
                }
                setComData();
            });

            //跳页操作
            $("#submitPage").click(function () {
                //跳页如果跳出了有效区间，则重置数据
                if (parseInt($("#pageNum").val()) < 1 || parseInt($("#pageNum").val()) > parseInt($("#pageSum").text())) {
                    starCom = 1;
                    $("#pageNum").val(1);
                    getComData();
                    return;
                }
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 < starCom) {
                    //往回跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    getComData();
                    return;
                }
                if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 > starCom + 199) {
                    //往下跳
                    starCom = parseInt((parseInt($("#pageNum").val() - 1) * parseInt($(".tablePage select").val()) + 200) / 200 - 1) * 200 + 1;
                    alert(starCom);
                    getComData();
                    return;
                }
                //if ((parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 > (starCom + 200 - 1)) {
                //    starCom = (parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1;
                //    getComData();
                //    return;
                //}
                setComData();
            })

        });

        //弹出添加零件窗口及进行确认
        function addCom() {
            var co_name = "";
            var cp_type = "";

            if ($("#comCompany li").length == "0") {
                alert("需要先添加零件生产商才能添加零件");
                return;
            }
            $("#comCompany li").each(function () {
                co_name += ";" + $(this).find("input").attr("data-Co_id") + ";" + $(this).text();
            });

            if ($("#comType li").length == "0") {
                alert("需要先添加零件类型才能添加零件");
                return;
            }
            $("#comType li").each(function () {
                cp_type += ";" + $(this).find("input").attr("data-Tp_id") + ";" + $(this).text();
            });
            showBlackScreen();
            $(".blackFrame").attr("src", "AddComponent.aspx?co_name=" + co_name.substring(1)+"&cp_type="+cp_type.substring(1));
        }

        //弹出添加公司类型窗口及进行确认
        function addCo() {
            showBlackScreen();
            $(".blackFrame").attr("src", "AddCompany.aspx");
        }

        //弹出添加零件类型窗口及进行确认
        function addType() {
            showBlackScreen();
            $(".blackFrame").attr("src", "AddComponentType.aspx");
        }

        //弹出删除零件类型窗口及进行确认
        function delType() {
            if ($("#comType input:[type='checkbox']:checked").length == "0")
                return;
            var delData = "";
            $("#comType input:[type='checkbox']:checked").each(function () {
                delData += "," + $(this).attr("data-Tp_id");
            });
            delData = delData.substring(1);
            showBlackScreen();
            $(".blackFrame").attr("src", "DelComponentType.aspx?delData=" + delData);
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
            $(".blackFrame").attr("src", "DelCompany.aspx?delData=" + delData);
        }

        //弹出删除零件窗口及进行确认
        function delCom() {
            if ($(".comTable tbody input:[type='checkbox']:checked").length == "0")
                return;
            var delData = "";
            $(".comTable tbody input:[type='checkbox']:checked").each(function () {
                delData += "," + $(this).attr("data-Com_id");
            });
            delData = delData.substring(1);
            showBlackScreen();
            $(".blackFrame").attr("src", "DelComponent.aspx?delData=" + delData);
        }

        //初始化页面布局
        function initPage() {
            $("#iframeContainer").css("height", $(window).height() - 20);
        }

        function regetComData() {
            $("#pageNum").val(1);
            starCom = 1;
            getComData();
        }

        //初始化页面公司和零件类型数据
        function initPageData() {
            $.post("Init_Co_ComType.ashx", null,
                function (data) {
                    //返回数据是dataset类型 Table是公司数据，Table1是零件类型数据
                    pageData = jQuery.parseJSON(data);
                    var htmlData = "";
                    for (var i = 0; i < pageData.Table.length; i++)
                    {
                        htmlData += "<li><input type='checkbox'  data-Co_id='" + pageData.Table[i].Co_id + "' title='地址："+pageData.Table[i].Co_address+"'/>" + pageData.Table[i].Co_abbreviation + "</li>";
                    }
                    $("#comCompany ul").html(htmlData);
                    htmlData = "";
                    for (var i = 0; i < pageData.Table1.length; i++) {
                        htmlData += "<li><input type='checkbox'  data-Tp_id='" + pageData.Table1[i].Tp_id + "'/>" + pageData.Table1[i].Tp_name + "</li>";
                    }
                    $("#comType ul").html(htmlData);

                    $("#comType li").click(function () {
                        $("#pageNum").val(1);
                        starCom = 1;
                        require.order = 1;
                        require.require = $(this).find("input").attr("data-Tp_id");
                        getComData();
                    });
                    $("#comCompany li").click(function () {
                        $("#pageNum").val(1);
                        starCom = 1;
                        require.order = 2;
                        require.require = $(this).find("input").attr("data-Co_id");
                        getComData();
                    });
                }
            );
        }

        //从数据库获取200条数据
        function getComData() {
            var data = new Object();
            //order=0 为全部查询，order=1 为
            data.order = require.order;
            data.require = require.require;
            data.starCom = starCom;

            $.post("Init_Component.ashx", { data: JSON.stringify(data) },
                function (data) {
                    comData = jQuery.parseJSON(data);
                    setComData();
                }
            );
        }

        //根据每页条数和当前页码显示零件信息表
        function setComData() {
            $(".comTable tbody").html("暂时没有数据");
            var tableData = "";
            $("#dataSum").html(comData[comData.length - 1].Cp_parameter);
            $("#pageSum").html(parseInt(parseInt(parseInt(comData[comData.length - 1].Cp_parameter) + parseInt($(".tablePage select").val()) - 1) / parseInt($(".tablePage select").val())));
            for (var i = (parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 - starCom ; i < parseInt($("#pageNum").val()) * parseInt($(".tablePage select").val()) + 1 - starCom ; i++) {
                if (i == comData.length - 1)
                    break;
                tableData += "<tr>";
                tableData += "<td><input data-Com_id='" + comData[i].Cp_id + "' type='checkbox' /></td>";
                tableData += "<td>" + comData[i].Tp_name + "</td>";
                tableData += "<td>" + comData[i].Cp_parameter + "</td>";
                tableData += "<td>" + comData[i].Co_abbreviation + "</td>";
                tableData += "<td>" + comData[i].Cp_price + "元/" + comData[i].Cp_unit + "</td>";
                tableData += "<td>" + comData[i].Cp_inventory + comData[i].Cp_unit + "</td>";
                tableData += "<td>" + (comData[i].Cp_inventory * comData[i].Cp_price).toFixed(2) + "元</td>";
                tableData += "<td>" + comData[i].Cp_useProductType + "</td>";
                tableData += "<td>" + comData[i].Cp_remarks + "</td>";
                tableData += "<td class='edit linked' name='" + i + "'>编辑</td>";
                tableData += "</tr>";
            }
            $(".comTable tbody").html(tableData);
            $(".edit").click(function () {
                var co_name = "";
                var cp_type = "";
                $("#comCompany li").each(function () {
                    co_name += ";" + $(this).find("input").attr("data-Co_id") + ";" + $(this).text();
                });
                $("#comType li").each(function () {
                    cp_type += ";" + $(this).find("input").attr("data-Tp_id") + ";" + $(this).text();
                });
                showBlackScreen();
                $(".blackFrame").attr("src", "EditComponent.aspx?data=" + JSON.stringify(comData[$(this).attr("name")])+"&co_name=" + co_name.substring(1) + "&cp_type=" + cp_type.substring(1));
            })
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
                <span class="containerTitle">零件分类<a id="addType">&nbsp;+ 新建&nbsp;&nbsp;</a><a id="delType">&nbsp;- 删除&nbsp;&nbsp;</a></span>
                <ul style="overflow-y: auto; max-height: 80%"><li></li>
                </ul>
            </div>
            <div id="comCompany" class="borderShadow">
                <span class="containerTitle">零件采购商<a id="addCo">&nbsp;+ 新添&nbsp;&nbsp;</a><a id="delCo">&nbsp;- 删除&nbsp;&nbsp;</a></span>
                <ul><li></li></ul>
            </div>
        </div>
        <div id="rightContainer">
            <span class="containerTitle">零件信息<a id="addCom">&nbsp;+ 新建&nbsp;&nbsp;</a><a id="delCom">&nbsp;- 删除&nbsp;&nbsp;</a><a id="comShowAll">&nbsp;&nbsp;显示全部&nbsp;&nbsp;</a></span>
            <div style="overflow-y: scroll; width: 100%; max-height: 80%;">
                <table class="comTable">
                    <thead>
                        <tr>
                            <th style="width: 5%;">
                                <input id="checkAll" type="checkbox" /></th>
                            <th style="width: 10%">零件类型</th>
                            <th style="width: 15%">零件规格</th>
                            <th style="width: 10%">生产厂商</th>
                            <th style="width: 10%">配件价格</th>
                            <th style="width: 10%">仓库数量</th>
                            <th style="width: 10%">库存总价</th>
                            <th style="width: 10%">可应用产品</th>
                            <th>备注说明</th>
                            <th style="width: 5%;">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div class="tablePage">
                <div style="margin-right: 30px;margin-top:10px; height: 50px; display: block">
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
