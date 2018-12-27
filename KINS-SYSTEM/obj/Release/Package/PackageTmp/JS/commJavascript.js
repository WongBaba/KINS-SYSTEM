function showBlackScreen() {
    $(".blackScreen,.blackFrame").fadeIn();
}
//隐藏灰色不可操作背景以及弹出窗口
function hideBlackScreen() {
    $(".blackFrame,.blackScreen").fadeOut();
}
$(function () {
    $(".closeBlack").click(function () {
        hideBlackScreen();
    });

    //显示灰色不可操作背景以及弹出窗口
});

//获取链接URL中的参数值
function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return decodeURI(r[2]); return null;
}

//将标准时区时间返回YYYY-MM-DD HH-MM-SS
function toDateTime(str) {
    return toDate(str) + " " + toTime(str);
}

//将标准时区时间返回HH-MM-SS
function toTime(str) {
    try {
        str.replace(/Date\([\d+]+\)/, function (a) { eval('d = new ' + a) });
        return (d.getHours() < 10 ? '0' : '') + d.getHours() + ":" + (d.getMinutes() < 10 ? '0' : '') + d.getMinutes() + ":" + (d.getSeconds() < 10 ? '0' : '') + d.getSeconds();
    } catch (err) {
        var now = new Date();
        return "无";
    }
}
//将标准时区时间返回YYYY-MM-DD
function toDate(str) {
    try {
        str.replace(/Date\([\d+]+\)/, function (a) { eval('d = new ' + a) });
        return d.getFullYear() + '-' + (d.getMonth() + 1 < 10 ? '0' : '') + (d.getMonth() + 1) + '-' + (d.getDate() < 10 ? '0' : '') + d.getDate();
    } catch (err) {
        return "获取数据错误";
    }
}

//URL传值时，需要将特殊字符先转码
function safeUrlValue(data) {
    data = data.replace(/\%/g, "%25");
    data = data.replace(/\#/g, "");
    data = data.replace(/\&/g, "%26");
    data = data.replace(/\\/g, "%5C");
    data = data.replace(/\=/g, "%3D");
    data = data.replace(/\?/g, "%3F");
    data = data.replace(/\./g, "%2E");
    return data;
}

$()