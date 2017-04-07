<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.constants.OrderStatus" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdOrderQueryModel order = (JdOrderQueryModel) request.getAttribute("order");
    BigDecimal couponAmount = order.getDiscountedConsultationFee().add(order.getDeposit()).subtract(order.getTotalFee());
    String wxconfig = (String)request.getAttribute("wxconfig");
    String limit = (String)request.getAttribute("limit");
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
        <h2>订单详情</h2>
        <div class="header_logo pa">
            <a onclick="toPersonal()" class="mine_center pa"></a>
        </div>
    </header>
    <!--header-->
    <%
        if(order.getTimeLevel() > 0) {
            String title;
            if(order.getStatus().equals(OrderStatus.WAITTO_PAY.getValue())) {
                title = "支付";
            } else if(order.getStatus().equals(OrderStatus.WAITTO_COMMENT.getValue())) {
                title = "评论";
            } else {
                title = "分享";
            }
    %>
            <div class="surplustime order_notime">
                <i>剩余<%=title%>时间</i><span id="timer">0分0秒</span>
            </div>
    <%
        }
    %>
    <!--content-->
    <div class="content order_detail_list">
        <section class="order_number clearfix order_detail_top">
            <span class="fl"><%if(!order.getStatus().equals(OrderStatus.WAITTO_PAY.getValue())) {%>预约号：<%=order.getOrderNumber()%><%}%></span>
            <span class="fr"><%=WechatUtils.getOrderStatusDescription(order.getStatus())%></span>
        </section>
        <section class="order_doctor clearfix order_detail_msg">
            <div class="fl order_header">
                <span style="background:url(<%=order.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
            </div>
            <div class="fl order_dmsg">
                <p><%=order.getDoctor()%> 丨 <%=order.getTitle()%></p>
                <p><%=DateUtils.getWeekOfDate(order.getAppointmentTime())%> <%=DateUtils.format(order.getAppointmentTime(), "HH:mm")%><span>（<%=DateUtils.format(order.getAppointmentTime(), "MM-dd")%>）</span></p>
                <p><%=order.getAppointmentAddress()%></p>
            </div>
        </section>
        <ul class="payul">
            <li class="clearfix">
                <i class="fl">姓名</i><span class="fl"><%=order.getName()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">联系手机</i><span class="fl"><%=order.getPhoneNumber()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">身份证</i><span class="fl"><%=order.getIdCard() == null ? "" : order.getIdCard()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">年龄</i><span class="fl"><%=order.getAge() == null ? "" : order.getAge()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">病情描述</i><span class="fl"><%=order.getSickDescription()%></span>
            </li>
            <%
                //是否需要手术治疗
                if (order.getUseOperation()) {
            %>
            <li class="clearfix">
                <i class="fl">是否手术</i><span class="fl">是</span>
            </li>
            <%
                }
            %>
        </ul>
        <ul class="payul order_detail_ul">
            <li class="clearfix">
                <%
                    String priceDisplay = order.getDiscountedConsultationFee().setScale(0).toString();
                    int discount = order.getDiscount();    
                    if (discount > 0 && discount < 10){
                        priceDisplay += "(" + discount + "折)";
                    }
                %>
                <i class="fl">咨询费</i><span class="fl">￥<%=priceDisplay%></span>
            </li>
            <li class="clearfix">
                <i class="fl">保证金</i><span class="fl">￥<%=order.getDeposit().setScale(0)%></span>
            </li>
            <li class="clearfix">
                <i class="fl">现金券</i><span class="fl"><i class="reduction">-</i>￥<%=couponAmount.intValue()%></span>
            </li>
        </ul>
        <div class="actual_wrap">
            <section class="actual">
                <p class="clearfix">
                    <i class="fl">合计实付</i><span class="fl">￥<%=order.getTotalFee().setScale(0)%></span>
                </p>
                <p>下单时间：<%=DateUtils.format(order.getCreateDate())%></p>
            </section>
        </div>
    </div>
    <!--content-->

    <!--fnfooter-->
    <footer class="fnfooter clearfix">
        <%
            if(order.getStatus().equals(OrderStatus.WAITTO_PAY.getValue())) {
        %>
            <a onclick="OrderOpt.toPay();" class="fr again">去支付</a>
            <a onclick="OrderOpt.cancel();" class="fr">取消订单</a>
        <%
        } else if(order.getStatus().equals(OrderStatus.WAITTO_DIAGNOSE.getValue())) {
        %>
            <a onclick="OrderOpt.cancel();" class="fr">取消订单</a>
        <%
        } else if(order.getStatus().equals(OrderStatus.WAITTO_COMMENT.getValue())) {
        %>
            <a onclick="OrderOpt.dateAgain();" class="fr">再次预约</a>
            <a onclick="OrderOpt.toComment();" class="fr again">去评价</a>
        <%
        } else if(order.getStatus().equals(OrderStatus.WAITTO_SHARE.getValue())) {
        %>
            <a onclick="OrderOpt.dateAgain();" class="fr ">再次预约</a>
            <a onclick="OrderOpt.toShare();" class="fr again">分享订单</a>
        <%
        } else {
        %>
            <a onclick="OrderOpt.dateAgain();" class="fr ">再次预约</a>
        <%
            }
        %>
    </footer>
    <!--fnfooter-->
</div>
<!--wrap-->
<%
    if(order.getStatus().equals(OrderStatus.WAITTO_SHARE.getValue())) {
%>
    <div id="mcover" style="display:none;z-index: 100" onClick="OrderOpt.hideShare();"><img src="../../wechat/images/guide.png"></div>
    <div id="shareDiv">
        <ul class="shareDiv_ul">
            <li><img src="../../wechat/images/sharebg.png"/></li>
            <li><p>感谢您对橙医生的支持，我们已在橙医生微信公众号中为您发了10元微信红包，请您在24小时之内领取，否则红包会过期。</p></li>
            <li onClick="back();">确定</li>
        </ul>
    </div>
<%
    }
%>
</body>
<script src="../../wechat/js/weixin.js" type="text/javascript"></script>
<script>
    sendPageVisit(Page_Constant.OrderDetail);
    var timeLevel = <%=order.getTimeLevel()%>;
    var status = "<%=order.getStatus()%>";
    var wxconfig = <%=wxconfig%>;
    wx.config({
        debug: false,
        appId: wxconfig.appId,
        timestamp: wxconfig.timestamp,
        nonceStr: wxconfig.nonceStr,
        signature: wxconfig.signature,
        jsApiList: ['checkJsApi','onMenuShareTimeline','onMenuShareAppMessage']
    });
    wx.ready(function() {
        wx.checkJsApi({
            jsApiList: ['onMenuShareTimeline','onMenuShareAppMessage'],
            success: function(res) {
                if(!res.checkResult.onMenuShareTimeline || !res.checkResult.onMenuShareAppMessage) {
                    var msg = '您的微信版本不支持分享接口，请升级后再分享，否则无法获得红包！';
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                }
            }
        });
        wx.onMenuShareTimeline({
            title: '我推荐你关注"橙医生"，随时随地预约心脑血管名医',
            link: 'http://mp.weixin.qq.com/s?__biz=MzAwNTUxNDQ0NQ==&mid=206184853&idx=2&sn=a069d4623b4eeb03999821a787e5c15c&scene=1&from=singlemessage&isappinstalled=0#rd',
            imgUrl: 'http://m.chengyisheng.com.cn/data/static_img/logo.jpg',
            desc:'我在橙医生预约的<%=order.getDoctor()%>医生,医术、态度都很不错，找心血管医生推荐你橙医生平台。',
            success: function () {
                shareOk();
            }
        });
        wx.onMenuShareAppMessage({
            title: '我推荐你关注"橙医生"，随时随地预约心脑血管名医',
            link: 'http://mp.weixin.qq.com/s?__biz=MzAwNTUxNDQ0NQ==&mid=206184853&idx=2&sn=a069d4623b4eeb03999821a787e5c15c&scene=1&from=singlemessage&isappinstalled=0#rd',
            imgUrl: 'http://m.chengyisheng.com.cn/data/static_img/logo.jpg',
            type: 'link',
            desc:'我在橙医生预约的<%=order.getDoctor()%>医生,医术、态度都很不错，找心血管医生推荐你橙医生平台。',
            success: function () {
                shareOk();
            }
        });
    });
    //分享成功
    function shareOk() {
        if(status == "WAITTO_SHARE" && timeLevel > 0) {
            var data = {"orderId" : "<%=order.getUuid().toString()%>"};
            sendRequest("sendRedpack.htm", "POST", data, function(msg) {
                if (msg == "nologin") {
                    msg = '登录超时，请重新登录';
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                        goto("toLogin.htm");
                    });
                    return;
                } else if (msg == "error") {
                    msg = '红包推送失败，10元奖励已放到您的账户余额，请查收';
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
        window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=0';
                    });
                    return;
                } else if (msg == "limitTime") {
                    msg = '分享成功，但00:00~08:00期间分享没有红包奖励';
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
        window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=0';
                    });
                    return;
                } else if(msg == "overtime") {
                    msg = '您的订单已超出分享时间！';
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
        window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=0';
                    });
                    return;
                } else if(msg == "shared") {
                    msg = '此订单不是待分享状态！';
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
        window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=0';
                    });
                    return;
                } else {
                    $('#shareDiv').show();
                }
            });
        }
        var dateStr=datetimeFormatters(new Date());
        _hmt.push(['_trackEvent', '分享成功', '分享订单成功','<%=order.getName()%>在'+dateStr+'时分享了订单']);
    }
    //倒计时
    var addTimer = function () {
        var list = [], interval;
        return function (id, time) {
            if (!interval)
                interval = setInterval(go, 1000);
            list.push({ele: document.getElementById(id), time: time});
        };
        function go() {
            for (var i = 0; i < list.length; i++) {
                list[i].ele.innerHTML = getTimerString(list[i].time ? list[i].time -= 1 : 0);
                if (!list[i].time)
                    list.splice(i--, 1);
            }
        }
        function getTimerString(time) {
            var d = Math.floor(time / 86400),
                    h = Math.floor((time % 86400) / 3600),
                    m = Math.floor(((time % 86400) % 3600) / 60),
                    s = Math.floor(((time % 86400) % 3600) % 60);
            if (time > 0) {
                var str = new StringBuilder();
                if(d > 0)
                    str.append(d + "天");
                if(h > 0)
                    str.append(h + "时");
                if(m > 0)
                    str.append(m + "分");
                str.append(s + "秒");
                return str.toString();
            } else {
                overFlag = true;
                return "已过期";
            }
        }
    }();
    if(timeLevel < 0) {
        var msg = "";
        if(status == "NO_PAY") {
            msg = '您的订单超过支付时间，已被取消！';
        } else if(status == "NO_COMMENT") {
            msg = '您的订单已超过评论时间！';
        } else if(status == "NO_SHARE") {
            msg = '您的订单已超过分享时间！';
        }
        layer.alert(msg, {
            title: false,
            closeBtn: false
        }, function () {
            layer.closeAll();
    window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=0';
        });
    } else if(timeLevel > 0) {
        addTimer("timer", timeLevel);
        if(status == "WAITTO_SHARE") {
            $('#shareDiv').width($(window).width()).height(document.body.scrollHeight);
            $('#shareDiv').css({left:0,top:$(window).height()*0.08});
            $('.shareDiv_ul').css({"padding-left":"0px"});
            $('.shareDiv_ul li').eq(2).width($(window).width()*0.96).height($(window).height()*0.07);
            $('.shareDiv_ul li').eq(2).css('line-height',$(window).height()*0.07+'px');

            var limit = "<%=limit%>";
            if(limit!="null") {
                var msg = "00:00~08:00期间分享将不会得到红包！";
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            }
        }
    }

    var submitFlag = false;
    var overFlag = false;
    var OrderOpt = {
        //取消订单
        cancel:function(){
            if(submitFlag)
                return;
            submitFlag = true;
            if(status == "WAITTO_PAY") { //待付款
                layer.confirm("确定要取消订单？", {
                    title: false,
                    closeBtn: false,
                    btn: ['取消', '确定']
                }, function () {
                    submitFlag = false;
                    layer.closeAll();
                }, function () {
                    var data = {"orderId" : "<%=order.getUuid().toString()%>"};
                    sendRequest("deleteNopayOrder.htm", "POST", data, function(result) {
                        if(result == "success"){
                            var msg = '取消成功！';
                            layer.alert(msg, {
                                title: false,
                                closeBtn: false
                            }, function () {
                                layer.closeAll();
                        window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=0';
                            });
                        } else if(result == "hasPayed") {
                            var msg = '您的订单已付款！';
                            layer.alert(msg, {
                                title: false,
                                closeBtn: false
                            }, function () {
                                layer.closeAll();
                            window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=1';
                            });
                        }
                    }, function() {
                        submitFlag = false;
                    });
                });
            } else if(status == "WAITTO_DIAGNOSE") { //待就诊
                var payDate = <%=order.getPayedDate()==null?0:order.getPayedDate().getTime()%>;
                var diff = (new Date().getTime() - payDate) / 1000;
                var tip;
                if(diff > 3600) { //超过一小时
                    tip = '预约成功后1小时取消订单将扣除80%的保证金，确定要取消？';
                } else {
                    tip = '取消订单，保证金和优惠券将返回您的账户，确定要取消？';
                }
                layer.confirm(tip, {
                    title: false,
                    closeBtn: false,
                    btn: ['取消', '确定']
                }, function () {
                    submitFlag = false;
                    layer.closeAll();
                }, function () {
                    var data = {"orderId" : "<%=order.getUuid().toString()%>"};
                    sendRequest("deleteNotreatOrder.htm", "POST", data, function(result) {
                        layer.alert(result, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                            window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=0';
                        });
                    }, function() {
                        submitFlag = false;
                    });
                });
            }
        },
        //付款
        toPay:function(){
            if(submitFlag)
                return;
            submitFlag = true;
            var data = {"orderId" : "<%=order.getUuid().toString()%>"};
            if(overFlag) {
                sendRequest("deleteNopayOrder.htm", "POST", data, function(result) {
                    if(result == "success"){
                        layer.alert("您的订单超过支付时间，已被取消!", {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                             window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=0';
                        });
                    } else if(result == "hasPayed") {
                        layer.alert("您的订单已成功付款!", {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                            window.location.href='/wechat_web/wap_wechat_patient/html/offlineOrder.html?status=1';
                        });
                    }
                }, function() {
                    submitFlag = false;
                });
            } else {

    window.location.href='/wechat_web/wap_wechat_patient/html/cashier.html?order_id='+'<%=order.getUuid().toString()%>'+'&order_type=OFFLINE&source=wx';



            }
        },
        //去评论
        toComment:function(){
            window.location.href = "toCommentOrderDetail.htm?orderNumber=<%=order.getOrderNumber()%>";
        },
        //去分享
        toShare:function(){
        	//分享
        	_hmt.push(['_trackEvent', "点击分享", "点击分享订单"]);
            $('#mcover').show();
        },
        hideShare:function(){
            $('#mcover').hide();
        },
        //再次预约
        dateAgain:function(){
            window.location.href='/wechat_web/wap_wechat_patient/html/doctorHomePage.html?doctor_id='+'<%=order.getJdDoctorId().toString()%>';
        }
    };

    function back() {
        window.location.href ='toOrderList.htm?status=0';
    }
</script>
</html>
