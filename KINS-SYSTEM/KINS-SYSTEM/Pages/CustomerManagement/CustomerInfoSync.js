// ==UserScript==
// @name         淘宝获取客户详细信息
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        http://*/*
// @grant        none
// ==/UserScript==http://localhost:59614/Pages

(function () {
    'use strict';
    var a = window.location.href;
    if (a.indexOf("buyerId=") < 0 | a.indexOf("count=") < 0) {
        return;
    }
    var data = new Object();
    data.sex = $.trim($(".sex-text").text());
    data.name = $.trim($(".name-text").text());
    data.email = $.trim($(".email-text").text());
    data.birth = $.trim($(".birth-text").text());
    data.phone = $.trim($(".phone-text").text());
    data.city = $.trim($(".info-text").text());
    data.level = $.trim($(".level-text").text());
    data.state = $.trim($(".discount-text").text());
    data.rank = $.trim($(".rank").attr("title")).replace("个买家信用积分，请点击查看详情", "");
    data.tradeNum = $.trim($(".trade-text").text()).replace("次", "");
    data.tradeAmount = $.trim($("input[name='_fm.m._0.tr']").val());
    data.goodsNum = $.trim($(".baobei-text").text()).replace("件", "");
    data.tradeClose = $.trim($(".trade-close").text()).replace("笔", "");
    data.addr = $.trim($(".addr-text").text());
    data.marks = $.trim("");

    //**************//计数获取了多少条数据
    //从链接里获取之前已获取条数
    var reg = new RegExp("(^|&)" + "count" + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null)
        data.count = parseInt(decodeURI(r[2])) + 1;
    else
        data.count = "1";

    //从链接里获取当前客户的查询码
    var reg2 = new RegExp("(^|&)" + "buyerId" + "=([^&]*)(&|$)");
    var r2 = window.location.search.substr(1).match(reg2);
    data.infoName = decodeURI(r2[2]);
    var info = JSON.stringify(data);
    info = info.replace(/\%/g, "%25");
    info = info.replace(/\#/g, "%23");
    info = info.replace(/\&/g, "%26");
    info = info.replace(/<\/?[^>]*>/g, ''); //去除HTML tag
    info = info.replace(/[ | ]*\n/g, '\n'); //去除行尾空白
    //str = str.replace(/\n[\s| | ]*\r/g,'\n'); //去除多余空行
    info = info.replace(/&nbsp;/ig, '');//去掉&nbsp;
    window.location.href = "http://localhost:59614/Pages/CustomerManagement/GetCustomerInfo.aspx?data=" + info;
    // Your code here...
})();