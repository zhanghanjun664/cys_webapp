<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.AvailableTimeQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderModel" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdOrderModel orderModel = (JdOrderModel)request.getAttribute("orderModel");
    JdDoctorModel doctorModel = (JdDoctorModel)request.getAttribute("doctorModel");
    AvailableTimeQueryModel availableTime = (AvailableTimeQueryModel)request.getAttribute("availableTime");
    long second = (Long)request.getAttribute("second");
    Boolean hasPayed = (Boolean)request.getAttribute("hasPayed");
    BigDecimal couponAmount = orderModel.getDiscountedConsultationFee().add(orderModel.getDeposit()).subtract(orderModel.getTotalFee());
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/head.jsp"/>
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
                <i class="fl">医生</i><span class="fl"><%=doctorModel.getName()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">时间</i><span class="fl"><%=DateUtils.getWeekOfDate(availableTime.getDateTime())%> <%=DateUtils.format(availableTime.getDateTime(), "HH:mm")%> <small class="paydate">(<%=DateUtils.format(availableTime.getDateTime(), "MM-dd")%>)</small></span>
            </li>
            <li class="clearfix">
                <i class="fl">地址</i><span class="fl payment_address"><%=availableTime.getAddress()%></span>
            </li>
        </ul>
        <ul class="payul">
            <li class="clearfix">
                <i class="fl">就诊人</i><span class="fl"><%=orderModel.getName()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">身份证</i><span class="fl"><%=orderModel.getIdCard()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">手机</i><span class="fl"><%=orderModel.getPhoneNumber()%></span>
            </li>
            <%
                //是否需要手术治疗
                if (orderModel.getUseOperation()) {
            %>
            <li class="clearfix">
                <i class="fl">是否手术</i><span class="fl">是</span>
            </li>
            <%
                }
            %>
        </ul>
        <ul class="payul">
            <li class="clearfix">
                <%
                    String priceDisplay = orderModel.getDiscountedConsultationFee().setScale(0).toString();
                    int discount = orderModel.getDiscount();    
                    if (discount > 0 && discount < 10){
                        priceDisplay += "(" + discount + "折)";
                    }
                %>
                <i class="fl">咨询费</i><span class="fl">￥<%=priceDisplay%></span>
            </li>
            <li class="clearfix">
                <i class="fl">保证金</i><span class="fl">￥<%=orderModel.getDeposit().setScale(0)%></span>
            </li>
            <%
                if(couponAmount.intValue() > 0) {
            %>
            <li class="clearfix">
                <i class="fl">现金劵</i><span class="fl">-￥<%=couponAmount.intValue()%></span>
            </li>
            <%
                }
            %>
            <li class="clearfix">
                <i class="fl">合计</i><span class="fl payall">￥<%=orderModel.getTotalFee().setScale(0)%></span>
            </li>
        </ul>



    </div>
    <!--content-->

    <!--gotoorder-->
    <footer class="gotoorder">
        <div class="fl total"><i>合计：<span>￥</span><span><%=orderModel.getTotalFee().setScale(0)%></span></i></div>
        <div class="fr orderto" onclick="submitOrder()">确认支付</div>
    </footer>
    <!--gotoorder-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.PayOrder);

    var hasPayed = <%=hasPayed%>;
    if(hasPayed) {
        layer.alert("您的订单已成功付款!", {
            title: false,
            closeBtn: false
        }, function () {
            layer.closeAll();

    window.location.href = '/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=1';
        });
    } else {
        var seconds =<%=second%>;
        if(seconds == 0) {
            layer.alert("您的订单超过支付时间，已被取消!", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
        window.location.href='/wechat_web/wap_wechat_patient/html/hospital.html#hospital';
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
            function submitOrder() {
                if(submitFlag)
                    return;
                submitFlag = true;
                var data = {"orderId" : "<%=orderModel.getUuid().toString()%>"};
                var btnword = '确定';
                if(overtime) {
                    sendRequest("deleteNopayOrder.htm", "POST", data, function(result) {
                        if(result == "success"){
                            layer.alert("您的订单超过支付时间，已被取消!", {
                                title: false,
                                closeBtn: false
                            }, function () {
                                layer.closeAll();

                                window.location.href='/wechat_web/wap_wechat_patient/html/hospital.html#hospital';
                            });
                        } else if(result == "hasPayed") {
                            layer.alert("您的订单已成功付款!", {
                                title: false,
                                closeBtn: false
                            }, function () {
                                layer.closeAll();

                                window.location.href = '/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=1';
                            });
                        }
                    }, function() {
                        submitFlag = false;
                    });
                } else {
    				window.location.href='/wechat_web/wap_wechat_patient/html/cashier.html?order_id=' + 
    				        '<%=orderModel.getUuid().toString()%>'+'&order_type=OFFLINE';
                }
            }
        }
    }
</script>
</html>
