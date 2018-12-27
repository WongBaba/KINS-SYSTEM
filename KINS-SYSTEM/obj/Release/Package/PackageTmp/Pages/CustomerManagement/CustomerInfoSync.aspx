<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CustomerInfoSync.aspx.cs" Inherits="KINS_SYSTEM.Pages.CustomerManagement.CustomerInfoSync" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../../CSS/commPage.css" rel="stylesheet" />
    <script src="../../JS/jquery-1.6.js"></script>
    <link href="../../CSS/Loading.css" rel="stylesheet" />
    <style>
        #tb_login {
            height: 30px;
            width: 150px;
            border: 0px;
            color: white;
            background-color: rgb(34,153,238);
        }

        #container {
            text-align: center;
            height: 100%;
            width: 100%;
            padding-top: 100px;
        }

        #begin_sync {
            height: 30px;
            width: 100px;
            border: 0px;
            color: white;
            background-color: rgb(34,153,238);
        }

            #begin_sync:disabled {
                color: black;
                background-color: #d4d4d4;
            }

        #sum,#info_sum {
            color: red;
        }

        #run_info {
            display: none;
        }
        #sync {
            width:1000px;
            height:500px;
            border:0px;
        }
        .spinner {
            display:none;
            margin-top:0px;
         padding-top:0px;
        }
    </style>
    <script>
        $(function () {
            //点击开始同步按钮，开始自动同步信息
            $("#begin_sync").click(function () {
                $("#begin_sync").attr("disabled", "disabled");
                $("#buttons").slideUp();
                $("#run_info").show();
                $(".spinner").show();
                $.post("CustomerInfoSync.ashx", null, function (data) {
                    if (data == "null") {
                        $(".spinner").hide();
                        alert("所有用户数据都是最新，无需更新");
                    }
                    else {
                        var info = data.split(",");
                        $("#info_sum").html("/" + info[0]);
                        $("#sync").attr("src", "https://ecrm.taobao.com/p/customer/ecrmMemberDetail.htm?buyerId=" + info[1] + "&count=0")
                    };
                });
            });
        });
        function run_sync(count) {
            $("#sum").html(count);
        }

    </script>
</head>
<body>
    <div id="container">
        <h2>特别说明：此功能需要配合浏览器油猴插件使用</h2>
        <h4>完整油猴JS代码：<a href="CustomerInfoSync.js" target="_blank">点击获取</a></h4>
        <div id="buttons">
        <input id="tb_login" type="button" value="使用此功能需先登录" onclick="window.open('https://login.taobao.com?temp=CI')" />
        <br />
        <br />
        <input id="begin_sync" type="button" value="开始智能同步" />
        </div>
        <div id="run_info">
            <p>正在同步中...期间请勿关闭任何网页</p>
            <a class="run_info">已同步</a><a class="run_info" id="sum">0</a><a id="info_sum"></a><a class="run_info">条数据</a>
        </div>
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
        
        <iframe id="sync" ></iframe>
    </div>
</body>
</html>
