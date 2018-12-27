<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ImportOrder.aspx.cs" Inherits="KINS_SYSTEM.Pages.OrderManagement.OrderManagement" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="../../JS/jquery-2.0.0.js"></script>
    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <link href="../../CSS/Loading.css" rel="stylesheet" />
    <script src="../../JS/commJavascript.js"></script>
    <script src="../../JS/ajaxfileupload.js"></script>
    <title></title>
    <script>
        $(function () {
            initPage();
            //显示当前选择文件
            $("#uploadFile").change(function () {
                $("#txt_filePath").val($("#uploadFile").val());
                $("#txt_filePath").attr("title", $("#txt_filePath").val());
            })

            //提交路径，导入到后台
            $("#submit").click(function () {
                var filePath = $("#uploadFile").val();
                //设置上传文件类型
                if (filePath.indexOf(".xls") != -1 || filePath.indexOf(".xlsx") != -1) {
                    //上传文件
                    $(".blackScreen").fadeIn();
                    ajaxFileUpload()
                } else {
                    alert("请选择正确的文件格式！");
                    //清空上传路径
                    $("#txt_filePath").val("");
                    $("#txt_filePath").removeAttr("title");
                }
            });
        })
        function ajaxFileUpload() {
            $.ajaxFileUpload
            (
                {
                    url: 'ImportOrder.ashx', //用于文件上传的服务器端请求地址
                    secureuri: false, //一般设置为false
                    fileElementId: 'uploadFile', //文件上传空间的id属性  <input type="file" id="file" name="file" />
                    dataType: 'json', //返回值类型 一般设置为json
                    success: function (data, status) {
                        //获取上传文件路径
                        $(".blackScreen").fadeOut();
                        if (typeof (data.error) != 'undefined') {
                            if (data.error != '') {
                                alert(data.error);
                            } else {
                                alert(data.msg);
                            }
                        }
                        $("#txt_filePath").val("");
                        $("#txt_filePath").removeAttr("title");
                    },
                    error: function (data, status, e) {
                        $(".blackScreen").fadeOut();
                        alert(e);
                    }
                }
            );
        }


        //初始化页面布局
        function initPage() {
            $("body,html").css("height", $(window).height() - 20);
            $("body,html").css("max-height", $(window).height() - 20);
        }
    </script>
    <style>
        body {
            background-color: white;
        }

        #container {
            text-align: center;
            height: 100%;
            width: 100%;
        }

        button {
            border: 0px;
        }

        #import {
            padding-top:100px;
        }

        .file {
            position: relative;
            background-color: #b32b1b;
            border: 1px solid #ddd;
            width: 68px;
            height: 25px;
            display: inline-block;
            text-decoration: none;
            text-indent: 0;
            line-height: 25px;
            font-size: 14px;
            color: #fff;
            margin: 0 auto;
            cursor: pointer;
            text-align: center;
            border: none;
            border-radius: 3px;
        }

            .file input {
                position: absolute;
                top: 0;
                left: -2px;
                opacity: 0;
                width: 70px;
            }
        #submit {
            margin-top:20px;
        }
    </style>
</head>
<body>
    <div id="container">
        <div class="blackScreen" style="background-color: rgba(150,150,150,0.45);">
            <div class="spinner">
                <div class="spinner-container container1">
                    <div class="circle1"></div>
                    <div class="circle2"></div>
                    <div class="circle3"></div>
                    <div class="circle4"></div>
                </div>
                <div class="spinner-container container2">
                    <div class="circle1"></div>
                    <div class="circle2"></div>
                    <div class="circle3"></div>
                    <div class="circle4"></div>
                </div>
                <div class="spinner-container container3">
                    <div class="circle1"></div>
                    <div class="circle2"></div>
                    <div class="circle3"></div>
                    <div class="circle4"></div>
                </div>

                <p style="color: white; padding-top: 80px; width: 100px; text-align: left;">导入中...</p>
            </div>
        </div>
        <div id="import">
            <form method="post" enctype="multipart/form-data" action="ImporOrder.ashx">

                <%--<asp:FileUpload ID="fileId" runat="server" />--%>
                <%--<input type="file" id="up" name="ups" />
                    <input type="submit" value="导入" />--%>
                <span>选择文件：</span><input id="txt_filePath" type="text" readonly="readonly" />
                <a class="file" id="file">
                    <input id="uploadFile" name="uploadFile" type="file" />浏览</a>
                <br />
                <input type="button" class="file" value="导入" id="submit" />
            </form>
        </div>
    </div>
</body>
</html>
