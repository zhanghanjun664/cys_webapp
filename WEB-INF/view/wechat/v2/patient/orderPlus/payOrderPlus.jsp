<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderPlusModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdOrderPlusModel orderPlusModel = (JdOrderPlusModel)request.getAttribute("orderPlusModel");
    JdDoctorQueryModel doctorModel = (JdDoctorQueryModel)request.getAttribute("doctorModel");
    long second = (Long)request.getAttribute("second");
    String address = (String)request.getAttribute("address");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>支付订单</h2>
        <div class="header_logo pa">
            <a onclick="toPersonal()" class="mine_center pa"></a>
        </div>
    </header>
    <!--header-->

    <!--surplustime-->
    <div class="surplustime">
        <i>剩余支付时间</i><span id="timer">00:00</span>
    </div>
    <!--surplustime-->

    <!--content-->
    <div class="content pay_wrap">
        <ul class="payul">
            <li class="clearfix">
                <i class="fl">医生</i><span class="fl"><%=doctorModel.getName()%>&nbsp;<%=doctorModel.getTitle()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">医院</i><span class="fl"><%=doctorModel.getHospital()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">地址</i><span class="fl payment_address"><%=address%></span>
            </li>
        </ul>
        <ul class="payul">
            <li class="clearfix">
                <i class="fl">就诊人</i><span class="fl"><%=orderPlusModel.getName()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">身份证</i><span class="fl"><%=orderPlusModel.getIdCard()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">手机</i><span class="fl"><%=orderPlusModel.getPhoneNumber()%></span>
            </li>
        </ul>
        <ul class="payul">
            <li class="clearfix">
                <i class="fl">预约时间</i><span class="fl"><%=orderPlusModel.getOrderDate()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">保证金</i><span class="fl">￥20</span>
            </li>
        </ul>

    </div>
    <!--content-->

    <!--gotoorder-->
    <footer class="gotoorder">
        <div class="fl total"><i>合计：<span>￥</span><span>20</span></i></div>
        <div class="fr orderto" onclick="confirmPay()">确认支付</div>
    </footer>
    <!--gotoorder-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.PayOrderPlus);

    var seconds =<%=second%>;
    if(seconds == 0) {
        layer.alert("您的订单超过支付时间，已被取消!", {
            title: false,
            closeBtn: false
        }, function () {
            layer.closeAll();
            goto("main.htm");
        });
    } else {
        var overtime = false;
        var TimerOpt = {
            timer:function(seconds) {
                window.setInterval(function(){
                    var minute=0, second=0;
                    if(seconds > 0) {
                        minute = Math.floor(seconds / 60);
                        second = Math.floor(seconds) - (minute * 60);
                    } else {
                        overtime = true;
                    }
                    if (minute <= 9) minute = '0' + minute;
                    if (second <= 9) second = '0' + second;
                    $('#timer').html(minute+':'+second);
                    seconds--;
                }, 1000);
            }
        };
        TimerOpt.timer(seconds);

        var submitFlag = false;
        function confirmPay() {
            if(submitFlag)
                return;
            submitFlag = true;
            var data = {"orderPlusId" : "<%=orderPlusModel.getUuid().toString()%>"};
            if(overtime) {
                sendRequest("deleteNoPayOrderPlus.htm", "POST", data, function(result) {
                    if(result == "success"){
                        layer.alert("您的订单超过支付时间，已被取消!", {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                            goto("main.htm");
                        });
                    } else if(result == "hasPayed") {
                        layer.alert("您的订单已成功付款!", {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                            goto("toOrderList.htm?status=1");
                        });
                    }
                }, function() {
                    submitFlag = false;
                });
            } else {

    window.location.href='/wechat_web/wap_wechat_patient/html/cashier.html?order_id='+'<%=orderPlusModel.getUuid().toString()%>'+'&order_type=ORDERPLUS&source=wx';


            }
        }
    }
</script>
</html>
