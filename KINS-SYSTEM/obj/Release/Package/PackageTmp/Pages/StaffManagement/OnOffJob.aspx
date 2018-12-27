<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OnOffJob.aspx.cs" Inherits="KINS_SYSTEM.Pages.StaffManagement.OnOffJob" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/commJavascript.js"></script>

    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/scollBar.css" rel="stylesheet" />
    <link href="../../CSS/iconfont.css" rel="stylesheet" />

    <script>
        var pageData;
        var starCom = 1;
        $(function () {
            initPage();
            initPageData();
            //提交搜索
            $("#searchButton").click(function () {
                starCom = 1;
                $("#pageNum").val(1);
                getPageData();
            });
            //重置搜索框
            $("#resetFiltersButton").click(function () {
                $("#queryList input[type=text]").val("");
                $("#queryList select").val("");
            })

            //全部反选
            $("#checkAll").click(function () {
                $("tbody input[type=checkbox]").trigger("click");
            });

            //新员工入职
            $("#onJob").click(function () {
                onJob();
            })

            //离职
            $("#offJob").click(function () {
                offJob();
            });


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
                setPageData();
            })
        });
        function initPage() {
            $("body,html").css("height", $(window).height() - 20);
            $("body,html").css("max-height", $(window).height() - 20);

            $("#List").css("height", $(window).height() - 180);
            $("#List").css("max-height", $(window).height() - 180);
        }
        //初始化页面数据
        function initPageData() {
            getPageData();
        }

        function onJob() {
            showBlackScreen();
            $(".blackFrame").attr("src", "OnJob.aspx");
        }

        //弹出离职窗口及进行确认
        function offJob() {
            if ($(".comTable tbody input[type='checkbox']:checked").length == "0")
                return;
            var data = "";
            $(".comTable tbody input[type='checkbox']:checked").each(function () {
                data += "," + $(this).attr("data_id");
            });
            data = data.substring(1);
            showBlackScreen();
            $(".blackFrame").attr("src", "OffJob.aspx?Emp_id=" + data);
        }

        //获取页面数据
        function getPageData() {
            var data = new Object();
            data.starCom = starCom;
            data.Emp_state = $("#Emp_state").val();
            data.Emp_deptId = $("#Emp_deptId").val();
            data.Emp_positionId = $("#Emp_positionId").val();
            data.Emp_id = $("#Emp_id").val().replace(" ", "") + "";
            data.Emp_name = $("#Emp_name").val().replace(" ", "") + "";
            data.Emp_phone = $("#Emp_phone").val().replace(" ", "") + "";
            $.post("GetStaffData.ashx", { data: JSON.stringify(data) },
               function (data) {
                   pageData = jQuery.parseJSON(data);
                   setPageData();
               }
           );
        }
        //插入数据至页面
        function setPageData() {
            var dept = ",生产部,仓储部,发货部,客服部,运营部,财务部,采购部,管理部".split(",");
            var position = ",员工,组长,主管,经理,总经理".split(",");
            var state = "离职,在职".split(",");
            $(".comTable tbody").html("暂时没有数据");
            $("#dataSum").html(pageData[pageData.length - 1].Emp_id);
            $("#pageSum").html(parseInt(parseInt(parseInt(pageData[pageData.length - 1].Emp_id) + parseInt($(".tablePage select").val()) - 1) / parseInt($(".tablePage select").val())));
            var maxi = parseInt($("#pageNum").val()) * parseInt($(".tablePage select").val()) + 1 - starCom;
            if (pageData.length - 2 < maxi)
                maxi = pageData.length - 2;
            var tb = ""
            for (var i = (parseInt($("#pageNum").val()) - 1) * parseInt($(".tablePage select").val()) + 1 - starCom ; i < maxi ; i++) {
                tb += "<tr>";
                tb += "<td><input data_id='" + pageData[i].Emp_id + "' type='checkbox' /></td>";
                tb += "<td>" + pageData[i].Emp_account + "</td>";
                tb += "<td>" + pageData[i].Emp_name + "</td>";
                tb += "<td>" + dept[pageData[i].Emp_deptId] + "</td>";
                tb += "<td>" + position[pageData[i].Emp_positionId] + "</td>";
                tb += "<td>" + state[pageData[i].Emp_state] + "</td>";
                tb += "<td>" + pageData[i].Emp_phone + "</td>";
                tb += "<td>" + pageData[i].Emp_idcard + "</td>";
                tb += "<td title='" + pageData[i].Emp_nowAddress + "'>" + pageData[i].Emp_nowAddress + "</td>";
                tb += "<td><a  class='linked edit' name='" + i + "'>编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;<a  class='linked permission' name='" + i + "'>访问权限</a></td>";
                tb += "</tr>";
            }
            $(".comTable tbody").html(tb);


            $(".edit").click(function () {
                var data = JSON.stringify(pageData[$(this).attr("name")]);
                showBlackScreen();
                $(".blackFrame").attr("src", "EditStaff.aspx?data=" + data);
            }); 
            $(".permission").click(function () {
                var data = pageData[$(this).attr("name")].Emp_id;
                showBlackScreen();
                $(".blackFrame").attr("src", "PermissionManagement.aspx?data=" + data);
            });
        }
    </script>
    <style>
        body {
        }

        #queryList {
            background-color: white;
            width: 98%;
            margin-left: 1%;
            margin-top: 1%;
            height: 90px;
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
            height: 40px;
            margin-top: 10px;
        }

        #List {
            overflow-y: scroll;
            width: 100%;
            margin-top: 10px;
            background-color: white;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="queryList">
            <div class="blackScreen">
                <a class="closeBlack">&#xe6b7;</a>
            </div>
            <iframe class="blackFrame" src="" scrolling="no"></iframe>
            <div id="inputList">
                <ul>
                    <li>
                        <span>工作状态:</span>
                        <select id="Emp_state">
                            <option value="">全部</option>
                            <option value="1">在职</option>
                            <option value="0">离职</option>
                        </select>
                    </li>
                    <li>
                        <span>部门:</span>
                        <select id="Emp_deptId">
                            <option value="">全部</option>
                            <option value="1">生产部</option>
                            <option value="2">仓储部</option>
                            <option value="3">发货部</option>
                            <option value="4">客服部</option>
                            <option value="5">运营部</option>
                            <option value="6">财务部</option>
                            <option value="7">采购部</option>
                            <option value="8">管理部</option>
                        </select>
                    </li>
                    <li>
                        <span>职位:</span>
                        <select id="Emp_positionId">
                            <option value="">全部</option>
                            <option value="1">员工</option>
                            <option value="2">组长</option>
                            <option value="3">总管</option>
                            <option value="4">经理</option>
                            <option value="5">总经理</option>
                        </select>
                    </li>
                    <li>
                        <span>工号:</span>
                        <input type="text" id="Emp_id" />
                    </li>
                    <li>
                        <span>姓名:</span>
                        <input type="text" id="Emp_name" />
                    </li>
                    <li>
                        <span>手机号:</span>
                        <input type="text" id="Emp_phone" />
                    </li>
                </ul>
            </div>
            <div class="submitList">
                <button id="searchButton" type="button">
                    搜索
                </button>
                <button id="resetFiltersButton" type="button">
                    重置
                </button>
            </div>
        </div>
        <div id="List">
            <span class="containerTitle">入职/离职管理<a id="onJob">&nbsp;+ 入职&nbsp;&nbsp;</a><a id="offJob">&nbsp;- 离职&nbsp;&nbsp;</a></span>
            <table class="comTable">
                <thead>
                    <tr>
                        <th style="width: 5%;">
                            <input id="checkAll" type="checkbox" /></th>
                        <th style="width: 10%">工号</th>
                        <th style="width: 10%">姓名</th>
                        <th style="width: 10%">部门</th>
                        <th style="width: 5%">职位</th>
                        <th style="width: 5%">状态</th>
                        <th style="width: 10%">手机</th>
                        <th style="width: 15%">证件号码</th>
                        <th style="width: 20%">临时住址</th>
                        <th style="width: 10%">操作</th>
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
