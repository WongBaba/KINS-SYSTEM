<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FolderView.aspx.cs" Inherits="KINS_SYSTEM.Pages.FolderVideo.test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="../../JS/jquery-2.0.0.js"></script>
    <script src="../../JS/commJavascript.js"></script>

    <script>
        $(function () {
            getListData();
            $("#sub").click(function () {
                getListData();
            });
            $("#last").click(function () {
                var content = $("#path").val().split("/");
                var path = "";
                for (var i = 1; i < content.length - 1; i++) {
                    path += "/" + content[i];
                }
                $("#path").val(path);
                getListData();
            })
        });

        function getListData() {
            var data = new Object();
            data.F_adress = "/淘宝运营课程" + $("#path").attr("path");
            $.post("FolderView.ashx", { data: JSON.stringify(data) },
               function (data) {
                   if (data == "") {
                       $("#fol").html("该路径下没有文件");
                       return;
                   }
                   var hl = "";
                   var content = data.split("|||");
                   for (var i = 1; i < content.length ; i++) {
                       hl += "<li name='" + content[i] + "' ";
                       if (content[i].indexOf(".") < 0)
                           hl += " class='folder'><img src='../../Image/folder.png' />";
                       else {
                           if (content[i].toLowerCase().indexOf(".mp4") >= 0 || content[i].toLowerCase().indexOf(".avi") >= 0 || content[i].toLowerCase().indexOf(".flv") >= 0 || content[i].toLowerCase().indexOf(".wma") >= 0 || content[i].toLowerCase().indexOf(".rmvb") >= 0)
                               hl += "class='video' ><img src='../../Image/video.png' />";
                           else
                               hl += "><img src='../../Image/wenhao.png' />";
                       }
                       hl += content[i] + "</li>";
                   }
                   $("#fol").html(hl);
                   $(".folder").click(function () {
                       $("#path").html($("#path").html() + "/<a class='path'>" + $(this).attr("name") + "</a>");
                       $("#path").attr("path", $("#path").attr("path") + "/" + $(this).attr("name"));
                       getListData();
                   });
                   $(".video").click(function () {
                       window.open("Course.html?class=" + "&course=" + $("#path").attr("path") + "/" + $(this).attr("name"));
                   })
                   $(".path").click(function () {
                       var paths = $("#path").attr("path").split('/');
                       var temp = "";
                       var temp2 = "<a class='path'>淘宝运营课程</a>";
                       for (var i = 1; i <= $(this).prevAll(".path").size() ; i++) {
                           temp += "/" + paths[i];
                           temp2 += "/<a class='path'>" + paths[i] + "</a>";
                       }
                       $("#path").attr("path", temp);
                       $("#path").html(temp2);
                       getListData();
                   })
               }
           );
        }

    </script>
    <style>
        body, div, ul, li {
            list-style: none;
            margin: 0;
            padding: 0px;
        }

        body {
            background-color: #F5F8FA;
        }

        .light-title {
            text-align: center;
        }

            .light-title h2 {
                font-size: 30px;
                color: #3c3e3d;
                margin: 0 auto;
                font-weight: 400;
                position: relative;
                display: inline-block;
                margin: 100px 0px 0px 0px;
            }

                .light-title h2:after {
                    content: "";
                    width: 64px;
                    height: 1px;
                    background-color: #60a6e9;
                    margin: 30px auto;
                    display: block;
                }

        .navigation {
            width: 1400px;
            margin: 0 auto;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

            .navigation p {
                font-size: 14pt;
            }

            .navigation .path {
                color: red;
                cursor: pointer;
            }

                .navigation .path:hover {
                    text-decoration:underline;
                    color:blue;
                }

        #fol {
            width: 1400px;
            background-color: red;
            margin: 0 auto;
        }

            #fol li {
                float: left;
                width: 9%;
                min-height: 150px;
                margin-top: 20px;
                cursor: pointer;
            }

                #fol li img {
                    width: 100%;
                }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="light-title">
            <h2>课程列表</h2>
        </div>
        <div class="navigation">
            <p id="path" path="" style="width: 100%"><a class="path">淘宝运营课程</a></p>
        </div>
        <div class="content">
            <ul id="fol">
            </ul>
        </div>
    </form>
</body>
</html>
