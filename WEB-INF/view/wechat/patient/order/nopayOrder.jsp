<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%
    List<JdOrderQueryModel> orderList = (List<JdOrderQueryModel>)request.getAttribute("orderList");
%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../../include/head.jsp" />
    <style>
        html, body {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            font-size: 100%;
            background: #F2F2F2;
        }

        a {
            color: #000000;
            -webkit-tap-highlight-color: transparent;
        }

        img, li, div {
            -webkit-tap-highlight-color: transparent;
        }

        #mainDiv {
            width: 100%;
            display: none;
        }

        #mainDiv .top_ul {
            width: 100%;
            background: #FB9D3B;
            overflow: hidden;
        }

        #mainDiv .top_ul li {
            text-align: center;
            float: left;
        }

        #mainDiv .top_ul li:nth-child(1) {
            width: 11.5%;
            height: 100%;
            background: url(../../wechat/images/larrow.png) center left no-repeat;
            background-size: 70% auto;
        }

        #mainDiv .top_ul li:nth-child(2) {
            width: 76%;
            height: 100%;
            font-size: 2em;
            color: #FFFFFF;
        }

        #mainDiv .top_ul li:nth-child(3) {
            width: 12%;
            height: 100%;
        }

        #mainDiv .top_ul li:nth-child(3) a {
            font-size: 1.6em;
            color: #FFFFFF;
        }

        #mainDiv .btmul {
            width: 100%;
            overflow: hidden;
            padding: 0 0 1.5em 0;
        }

        #mainDiv .btmul .btmul_li {
            width: 100%;
            float: left;
            background: #FFFFFF;
            margin-top: 1.2em;
        }

        #mainDiv .btmul .btmul_li ul {
            width: 100%;
            overflow: hidden;
        }

        #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 {
            width: 100%;
            padding: 1.5em 0 1.5em 0;
            border-bottom: #F1F1F1 0.13em solid;
            -webkit-border-bottom: #F1F1F1 0.13em solid;
            float: left;
        }

        #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 .btmul_li_ul_li1_sp1 {
            font-size: 1.5em;
            margin-left: 3%;
            float: left;
        }

        #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 .btmul_li_ul_li1_sp2 {
            font-size: 1.5em;
            margin-right: 3%;
            float: right;
            color: #DF0101;
        }

        #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2 {
            width: 100%;
            padding: 1.6em 0 1.6em 0;
            float: left;
            border-bottom: #F1F1F1 0.13em solid;
            -webkit-border-bottom: #F1F1F1 0.13em solid;
        }

        #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2 p {
            width: 94%;
            padding: 0.2em 0 0.2em 0;
            margin-left: 3%;
            font-size: 1.55em;
        }

        #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 {
            width: 100%;
            padding: 1.5em 0 1.5em 0;
            border-bottom: #F1F1F1 0.13em solid;
            -webkit-border-bottom: #F1F1F1 0.13em solid;
            float: left;
        }

        #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 .btmul_li_ul_li3_sp1 {
            font-size: 1.5em;
            margin-left: 3%;
            float: left;
        }

        #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 .btmul_li_ul_li3_sp2 {
            font-size: 1.5em;
            margin-right: 3%;
            float: right;
            color: #FB9D3B;
        }

        #MsgBoxDiv {
            width: 100%;
            height: 100%;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 1000000;
            display: none;
        }

        #MsgBoxDiv ul {
            width: 84%;
            overflow: hidden;
            margin-left: 8%;
            background: rgba(0, 0, 0, 0.65);
            border-radius: 0.2em;
            -webkit-border-radius: 0.2em;
        }

        #MsgBoxDiv ul li {
            width: 100%;
            overflow: hidden;
            text-align: center;
        }

        #MsgBoxDiv ul li:nth-child(1) p {
            width: 100%;
            text-align: center;
            font-size: 1.75em;
            color: #FFFFFF;
        }

        #MsgBoxDiv ul li:nth-child(2) {
            border-top: #FFFFFF 0.04em solid;
            -webkit-border-top: #FFFFFF 0.04em solid;
            font-size: 1.88em;
            color: #FFFFFF;
        }
    </style>
</head>
<body>
<div id="mainDiv">
    <ul class="top_ul">
        <a href="toPersonal.htm">
            <li></li>
        </a>
        <li>待付款订单</li>
        <li><a href="main.htm">首页</a></li>
    </ul>
    <ul class="btmul">
        <%
            for(int i = 0; i < orderList.size(); i++) {
                JdOrderQueryModel order = orderList.get(i);
        %>
            <li class="btmul_li" onClick="jump('<%=order.getOrderNumber()%>');">
                <ul class="btmul_li_ul">
                    <li class="btmul_li_ul_li1">
                        <span class="btmul_li_ul_li1_sp1">预约号：<font style="color:#A4A4A4;"><%=order.getOrderNumber()%></font></span>
                        <span class="btmul_li_ul_li1_sp2">待付款</span>
                    </li>
                    <li class="btmul_li_ul_li2">
                        <p class="btmul_li_ul_li2_p1">预约医生：<font style="color:#A4A4A4;"><%=order.getDoctor()%></font></p>

                        <p class="btmul_li_ul_li2_p2">预约时间：<font style="color:#A4A4A4;"><%=DateUtils.format(order.getAppointmentTime(), "yyyy-MM-dd HH:mm")%>&nbsp;&nbsp;<%=DateUtils.getWeekOfDate(order.getAppointmentTime())%></font></p>

                        <p class="btmul_li_ul_li2_p3">就诊地点：<font style="color:#A4A4A4;"><%=order.getAppointmentAddress()%></font></p>
                    </li>
                    <li class="btmul_li_ul_li3">
                        <span class="btmul_li_ul_li3_sp1">实付：<font style="color:#FB9D3B;"><%=order.getTotalFee()%>元</font></span>
                        <span class="btmul_li_ul_li3_sp2">前往支付</span>
                    </li>
                </ul>
            </li>
        <%
            }
        %>
    </ul>
</div>
</body>
</html>
<script>
    var mw = $(window).width();
    var mh0 = $(window).height();
    var mh = 1136 * mw / 640;
    window.onload = function () {
        $('#mainDiv').width(mw);
        $('.top_ul').width(mw).height(mh * 0.07);
        $('.top_ul li').height(mh * 0.07);
        $('.top_ul li').css('line-height', mh * 0.07 + 'px');

        $('.btmul').width(mw);

        $('#mainDiv').show();
        $('#MsgBoxDiv').width(mw).height(mh);
        $('#MsgBoxDiv ul').width(mw * 0.84).height(mh * 0.26);
        $('#MsgBoxDiv ul li').eq(0).width(mw * 0.84).height(mh * 0.26 * 0.73);
        $('#MsgBoxDiv ul li').eq(1).width(mw * 0.84).height(mh * 0.26 * 0.27);
        $('#MsgBoxDiv ul li').eq(1).css('line-height', mh * 0.26 * 0.27 + 'px');
        $('#msgcontp').css('margin-top', mh * 0.26 * 0.3);
        $('#MsgBoxDiv ul').css('margin-top', mh * 0.15);

        $('#updateNameDiv').width(mw).height(mh);
        $('#updateNameDiv li').width(mw * 0.8).height(mh * 0.069);
        $('#updateNameDiv li').eq(0).width(mw * 0.8).height(mh * 0.069);
        $('#updateNameDiv li').eq(1).width(mw * 0.8).height(mh * 0.069);
        $('#updateNameDiv li').eq(2).width(mw * 0.8 * 0.45).height(mh * 0.069);
        $('#updateNameDiv li').eq(3).width(mw * 0.8 * 0.45).height(mh * 0.069);
        $('#updateNameDiv li input').width(mw * 0.8).height(mh * 0.069);
        $('#updateNameDiv li').css('line-height', mh * 0.069 + 'px');
        $('#updateNameDiv li input').height(mh * 0.069);
        $('#updateNameDiv ul').css('margin-top', mh * 0.1);
    }

    function jump(orderNumber) {
        window.location.href = 'toNoPayDetail.htm?orderNumber=' + orderNumber;
    }

</script>
