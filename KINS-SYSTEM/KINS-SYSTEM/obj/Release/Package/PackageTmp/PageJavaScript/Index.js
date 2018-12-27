
function initPage() {   //初始化首页主要容器大小
    $("#mainPanel").css("height", $(window).height());
    $("#main").css("height", $(window).height() - $("#top").height() - 30);
    $("#dropdown_menu").css("max-height", $(window).height() - 60);
};

    //左边菜单栏脚本
    $(function () {
        $(".menu_closed").siblings().hide();
        $(".menu_opened").siblings().show();

        //$(".menu_opened").click(function () {
        //    $(this).removeAttr();
        //    $(this).removeClass();
        //    $(this).attr("class", "menu_closed");
        //    alert($(this).attr("class"));
        //    $(this).siblings().hide();
        //});

        //$(".menu_closed").click(function () {
        //    if ($(this).siblings().length == '0') {
        //        return;
        //    }
        //    $(this).removeAttr();
        //    $(this).removeClass();
        //    $(this).attr("class", "menu_opened");
        //    $(this).siblings().show();
        //});
        for (var i = 1; i <= 8; i++) {
            (function (i) {
                $("#d" + i).click(function () {
                    if ($(this).attr("class") == "menu_opened") {
                        $(this).attr("class", "menu_closed");
                        $(this).siblings().slideUp();
                    } else {
                        $(this).attr("class", "menu_opened");
                        $(this).siblings().slideDown();
                    }
                });
            })(i);
        }


        $("#dt,dd").click(function () {
            $("#main").attr("src", $(this).attr("data-url"));
            $("#navbar", document.frames('iframename').document)
            
        });
        $("#attendance").click(function () {
            $("#main").attr("src", "AttendanceManagement/AttendanceManagement.aspx");
        })
    })