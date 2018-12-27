<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate" />
    <meta http-equiv="expires" content="0" />
    <script src="../JS/jquery-2.0.0.js"></script>
    <script src="../JS/jquery-ui-1.8.20.js"></script>
    <title></title>
    <script>
        $(function () {
            var jifen = GetJifen();
            jifen = SortJifen(jifen);
            SetJifen(jifen);

            var history = GetHistory();
            history = SortHistory(history);
            SetHistory(history);

            var newMeal = parseFloat(history[0][0].split('.')) + 0.2;
            if (newMeal == parseFloat(history[0][0]))
                newMeal = parseFloat(history[0][0].split('.')) + 1.1;
            $(".newMeal").html("第" + newMeal + "天洗碗排期");
            $(".Sc_Xiwan").click(function () {
                if ($(".newCook").val() == "") {
                    alert("请先选择做菜人");
                    return;
                }
                for (var i = 0; i < jifen.length; i++) {
                    if (jifen[i].name == $(".newCook").val() || jifen[i].name == $(".huomian").val() || jifen[i].name == history[0][1])
                        continue;
                    $(".Xiwanba").html(jifen[i].name)
                    break;
                }
            });
            $(".tijiao").click(function () {
                if ($(".Xiwanba").html() == "" || $(".newCook").val() == "") {
                    alert("做菜人没有选择，或者没有生成洗碗人");
                    return;
                }
                for (var i = 0; i < jifen.length; i++) {
                    if ($(".Xiwanba").html() == jifen[i].name || $(".newCook").val() == jifen[i].name) {
                        jifen[i].jifen += 1;
                    }
                }
                var record = newMeal + "/" + $(".newCook").val() + "/" + $(".Xiwanba").html()
                history.push(record.split("/"));
                var data = new Object();
                data.jifen = "";
                data.history = "";
                for (var i = 0; i < jifen.length; i++) {
                    data.jifen += jifen[i].name + "/" + jifen[i].jifen + "\n";
                }
                for (var i = 0; i < history.length; i++) {
                    data.history += history[i][0] + "/" + history[i][1] + "/" + history[i][2] + "\n";
                }
                $.post("save.ashx", { data: JSON.stringify(data) },
                function (data) {
                    if (data == "0") {
                        alert("失败，请刷新网页重试或联系管理员");
                    } else {
                        alert("信息记录成功")
                    }
                    window.location.reload()
                });
            })
        });

        function SetHistory(history) {  //将历史记录添加到网页
            for (var i = 0; i < history.length; i++) {
                if (i % 2 == 0)
                    $(".history ul").append("<li class='time oddrowcolor'>" + history[i][0] + "</li>" + "<li class='zuocai oddrowcolor'>" + history[i][1] + "</li>" + "<li class='xiwan oddrowcolor'>" + history[i][2] + "</li>")
                else
                    $(".history ul").append("<li class='time evenrowcolor'>" + history[i][0] + "</li>" + "<li class='zuocai evenrowcolor'>" + history[i][1] + "</li>" + "<li class='xiwan evenrowcolor'>" + history[i][2] + "</li>")
            }
        }

        function SortHistory(history) {  //将获取的记录按照时间进行由近到远的排序
            for (var i = history.length - 1; i > 0; i--) {
                for (var j = 0; j < i; j++) {
                    if (parseFloat(history[i][0]) > parseFloat(history[j][0])) {
                        var temp = history[i];
                        history[i] = history[j];
                        history[j] = temp;
                    }
                }
            }
            return history;
        }

        function GetHistory() {     //获取历史记录
            var history = new Array();
            $.ajax({
                async: false,
                type: "GET",//请求方式
                url: "db/history.txt?" + parseInt(Math.random() * 100000),//地址，就是action请求路径
                data: "text",//数据类型text xml json  script  jsonp
                success: function (msg) {//返回的参数就是 action里面所有的有get和set方法的参数
                    var data = msg.split('\n');
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].length < 2)
                            continue;
                        history.push(data[i].replace("\r", "").split("/"));
                    }
                }
            });
            return history;
        }
        function GetJifen() {   //读取积分txt
            var jifen = new Array();
            $.ajax({
                async: false,
                type: "GET",//请求方式
                url: "db/jifen.txt?" + parseInt(Math.random() * 100000),//地址，就是action请求路径
                data: "text",//数据类型text xml json  script  jsonp
                success: function (msg) {//返回的参数就是 action里面所有的有get和set方法的参数
                    //$(".jifen").html(msg);
                    var data = msg.split('\n');
                    for (var i = 0; i < data.length; i++) {
                        var person = new Object();
                        if (data[i].length < 2)
                            continue;
                        person.name = data[i].split("/")[0];
                        person.jifen = parseInt(data[i].split("/")[1]);
                        person.huomian = 0;
                        jifen.push(person);
                    }
                }
            });
            return jifen;
        }
        function SetJifen(jifen) {  //将积分记录添加到网页
            for (var i = 0; i < jifen.length; i++) {
                if (i % 2 == 0)
                    $(".jifen ul").append("<li class='name oddrowcolor'>" + jifen[i].name + "</li>" + "<li class='num oddrowcolor'>" + jifen[i].jifen + "分</li>")
                else
                    $(".jifen ul").append("<li class='name evenrowcolor'>" + jifen[i].name + "</li>" + "<li class='num evenrowcolor'>" + jifen[i].jifen + "分</li>")
            }
        }
        function SortJifen(jifen) {  //将获取的积分进行由小到大的排序
            for (var i = jifen.length - 1; i > 0; i--) {
                for (var j = 0; j < i; j++) {
                    if (jifen[i].jifen < jifen[j].jifen) {
                        var tempJifen = jifen[i].jifen;
                        var tempName = jifen[i].name;
                        var tempHuomian = jifen[i].huomian;
                        jifen[i].name = jifen[j].name;
                        jifen[i].jifen = jifen[j].jifen;
                        jifen[i].huomian = jifen[j].huomian;
                        jifen[j].name = tempName;
                        jifen[j].jifen = tempJifen;
                        jifen[j].huomian = tempHuomian;
                    }
                }
            }
            return jifen;
        }
    </script>
    <style>
        div, ul, li {
            font-family: 微软雅黑;
            font-size: 40px;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        .big {
            margin-top: 20px;
            width: 100%;
        }

        .jifen ul {
            width: 100%;
        }

        .jifen li {
            box-sizing: border-box;
            text-align: center;
            float: left;
            width: 50%;
            border-width: 1px;
            padding: 8px;
            border-style: solid;
            border-color: #a9c6c9;
        }

        .num {
            text-align: left;
        }

        .oddrowcolor {
            background-color: #d4e3e5;
        }

        .evenrowcolor {
            background-color: #c3dde0;
        }

        .history li {
            width: 33.3%;
            float: left;
            text-align: center;
            box-sizing: border-box;
            border-width: 1px;
            padding: 8px;
            border-style: solid;
            border-color: #a9c6c9;
        }

        .newCook, .huomian {
            background: transparent;
            width: 300px;
            padding: 5px;
            font-size: 16px;
            border: 1px solid #ccc;
            height: 70px;
            font-size: 50px;
            -webkit-appearance: none; /*for chrome*/
        }

        input[type=button] {
            font-size: 50px;
            height: 70px;
            margin-top: 30px;
            width: 300px;
        }

        .tijiao {
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="newXiwan big">
            <p class="newMeal"></p>
            本餐做饭
                <select class="newCook">
                    <option value=""></option>
                    <option value="王鑫">王鑫</option>
                    <option value="陈智">陈智</option>
                    <option value="彭啸">彭啸</option>
                    <option value="朱叶">朱叶</option>
                    <option value="星南">星南</option>
                </select>
            手动豁免
                <select class="huomian">
                    <option value=""></option>
                    <option value="王鑫">王鑫</option>
                    <option value="陈智">陈智</option>
                    <option value="彭啸">彭啸</option>
                    <option value="朱叶">朱叶</option>
                    <option value="星南">星南</option>
                </select>
            <br />
            <input class="Sc_Xiwan" type="button" value="生成洗碗" /><a class="Xiwanba"></a>
            <br />
            <input class="tijiao" type="button" value="确定" />
        </div>
        <div class="jifen big">
            积分榜
            <ul class="aa">
            </ul>
        </div>
        <div class="history big">
            历史记录
            <ul>
                <li class="hs_title evenrowcolor">日期</li>
                <li class="zuocai hs_title evenrowcolor">做菜</li>
                <li class="xiwan hs_title evenrowcolor">洗碗</li>
            </ul>
        </div>
    </form>
</body>
</html>
