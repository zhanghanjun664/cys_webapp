<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.constants.OrderStatus" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderPlusQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<JdOrderQueryModel> orderList = (List<JdOrderQueryModel>) request.getAttribute("orderList");
    List<JdOrderPlusQueryModel> orderPlusList = (List<JdOrderPlusQueryModel>) request.getAttribute("orderPlusList");
    String status = (String) request.getAttribute("status");
    List<String> intervalList = new ArrayList<String>();
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
        <h2>我的预约</h2>
        <div class="header_logo pa">
            <a class="pa header_search attention_search" id="search_btn"></a>
        </div>
    </header>
    <!--header-->

    <!--order_top-->
    <div id="order_list_wrap">
        <ul class="order_top" id="order_top">
            <li class="pr fl tabshow_active">全部<b></b></li>
            <li class="pr fl">待付款<b></b></li>
            <li class="pr fl">待就诊<b></b></li>
            <li class="pr fl">待确认<b></b></li>
            <li class="pr fl">待评价<b></b></li>
            <li class="pr fl">待分享<b></b></li>
        </ul>
    </div>
    <!--order_top-->

    <!--content-->
    <div class="content">
        <section class="tab_content tab_show">
            <ul class="orderlist">
                <%
                    boolean allFlag = false;
                    for(JdOrderPlusQueryModel orderPlus : orderPlusList) {
                        allFlag = true;
                        String id = "op_all_" + orderPlus.getOrderNumber();
                        String interval = id + "," + orderPlus.getTimeLevel();
                        intervalList.add(interval);
                        String keyword = orderPlus.getOrderNumber() + orderPlus.getDoctorName() + orderPlus.getName() + orderPlus.getHospital();
                %>
                <li onclick="goto('toPayOrderPlus.htm?orderPlusId=<%=orderPlus.getUuid().toString()%>')" keyword="<%=keyword%>">
                    <a href="javascript:void(0)" class="pr">
                        <section class="order_number clearfix">
                            <span class="fl"></span>
                            <span class="fr">待付款</span>
                        </section>
                        <section class="order_doctor clearfix">
                            <div class="fl order_header">
                                <span style="background:url(<%=orderPlus.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
                            </div>
                            <div class="fl order_dmsg">
                                <p><%=orderPlus.getDoctorName()%> 丨 <%=orderPlus.getTitle()%></p>
                                <p><%=orderPlus.getOrderDate()%></p>
                                <p><%=WechatUtils.displayNullValue(orderPlus.getAddress())%></p>
                            </div>
                        </section>
                        <section class="order_price clearfix pr">
                            <span class="fl">实付：￥20</span>
                            <i class="pa">
                                剩余：<c id="<%=id%>">0分0秒</c>
                                <small class="pa"></small>
                            </i>
                            <a href="javascript:void(0)" class="pa go">去支付</a>
                        </section>
                    </a>
                </li>
                <%
                    }
                    for(JdOrderQueryModel order : orderList) {
                        allFlag = true;
                        String id = "all_" + order.getOrderNumber();
                        String keyword = order.getOrderNumber() + order.getDoctor() + order.getName() + order.getHospital();
                        if(order.getStatus().equals(OrderStatus.WAITTO_PAY.getValue())) {
                            String interval = id + "," + order.getTimeLevel();
                            intervalList.add(interval);
                        } else if(order.getStatus().equals(OrderStatus.WAITTO_COMMENT.getValue())) {
                            String interval = id + "," + order.getTimeLevel();
                            intervalList.add(interval);
                        } else if(order.getStatus().equals(OrderStatus.WAITTO_SHARE.getValue())) {
                            String interval = id + "," + order.getTimeLevel();
                            intervalList.add(interval);
                        }
                %>
                <li onclick="toOrderDetail('<%=order.getOrderNumber()%>')" keyword="<%=keyword%>">
                    <a href="javascript:void(0)" class="pr">
                        <section class="order_number clearfix">
                            <span class="fl"><%if(!order.getStatus().equals(OrderStatus.WAITTO_PAY.getValue())) {%>预约号：<%=order.getOrderNumber()%><%}%></span>
                            <span class="fr"><%=WechatUtils.getOrderStatusDescription(order.getStatus())%></span>
                        </section>
                        <section class="order_doctor clearfix">
                            <div class="fl order_header">
                                <span style="background:url(<%=order.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
                            </div>
                            <div class="fl order_dmsg">
                                <p><%=order.getDoctor()%> 丨 <%=order.getTitle()%></p>
                                <p><%=DateUtils.getWeekOfDate(order.getAppointmentTime())%> <%=DateUtils.format(order.getAppointmentTime(), "HH:mm")%><span>（<%=DateUtils.format(order.getAppointmentTime(), "MM-dd")%>）</span></p>
                                <p><%=order.getAppointmentAddress()%></p>
                            </div>
                        </section>
                        <section class="order_price clearfix pr">
                            <span class="fl">实付：￥<%=order.getTotalFee().setScale(0)%></span>
                            <%
                                if(order.getStatus().equals(OrderStatus.WAITTO_PAY.getValue())) {
                            %>
                            <i class="pa">
                                剩余：<c id="<%=id%>">0分0秒</c>
                                <small class="pa"></small>
                            </i>
                            <a href="javascript:void(0)" class="pa go">去支付</a>
                            <%
                            } else if(order.getStatus().equals(OrderStatus.WAITTO_COMMENT.getValue())) {
                            %>
                            <i class="pa">
                                评价有奖：<c id="<%=id%>">0分0秒</c>
                                <small class="pa"></small>
                            </i>
                            <a href="javascript:void(0)" class="pa go">去评价</a>
                            <%
                            } else if(order.getStatus().equals(OrderStatus.WAITTO_SHARE.getValue())) {
                            %>
                            <i class="pa">
                                分享红包：<c id="<%=id%>">0分0秒</c>
                                <small class="pa"></small>
                            </i>
                            <a href="javascript:void(0)" class="pa go">去分享</a>
                            <%
                                }
                            %>
                        </section>
                    </a>
                </li>
                <%
                    }
                %>
            </ul>
            <%
                if(!allFlag) {
            %>
            <div class="no_case">
                <p class="no_case_pic no_order_pic"></p>
                <p class="no_case_font">暂无订单记录！</p>
            </div>
            <%
                }
            %>
        </section>

        <section class="tab_content">
            <ul class="orderlist">
                <%
                    boolean waitToPayFlag = false;
                    for(JdOrderPlusQueryModel orderPlus : orderPlusList) {
                        waitToPayFlag = true;
                        String id = "op_pay_" + orderPlus.getOrderNumber();
                        String interval = id + "," + orderPlus.getTimeLevel();
                        intervalList.add(interval);
                        String keyword = orderPlus.getOrderNumber() + orderPlus.getDoctorName() + orderPlus.getName() + orderPlus.getHospital();
                %>
                <li onclick="goto('toPayOrderPlus.htm?orderPlusId=<%=orderPlus.getUuid().toString()%>')" keyword="<%=keyword%>">
                    <a href="javascript:void(0)" class="pr">
                        <section class="order_number clearfix">
                            <span class="fl"></span>
                            <span class="fr">待付款</span>
                        </section>
                        <section class="order_doctor clearfix">
                            <div class="fl order_header">
                                <span style="background:url(<%=orderPlus.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
                            </div>
                            <div class="fl order_dmsg">
                                <p><%=orderPlus.getDoctorName()%> 丨 <%=orderPlus.getTitle()%></p>
                                <p><%=orderPlus.getOrderDate()%></p>
                                <p><%=orderPlus.getAddress()%></p>
                            </div>
                        </section>
                        <section class="order_price clearfix pr">
                            <span class="fl">实付：￥20</span>
                            <i class="pa">
                                剩余：<c id="<%=id%>">0分0秒</c>
                                <small class="pa"></small>
                            </i>
                            <a href="javascript:void(0)" class="pa go">去支付</a>
                        </section>
                    </a>
                </li>
                <%
                    }
                    for(JdOrderQueryModel order : orderList) {
                        if(order.getStatus().equals(OrderStatus.WAITTO_PAY.getValue())) {
                            waitToPayFlag = true;
                            String keyword = order.getOrderNumber() + order.getDoctor() + order.getName() + order.getHospital();
                            String id = "pay_" + order.getOrderNumber();
                            String interval = id + "," + order.getTimeLevel();
                            intervalList.add(interval);
                %>
                <li onclick="toOrderDetail('<%=order.getOrderNumber()%>')" keyword="<%=keyword%>">
                    <a href="javascript:void(0)" class="pr">
                        <section class="order_number clearfix">
                            <span class="fl"></span>
                            <span class="fr"><%=WechatUtils.getOrderStatusDescription(order.getStatus())%></span>
                        </section>
                        <section class="order_doctor clearfix">
                            <div class="fl order_header">
                                <span style="background:url(<%=order.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
                            </div>
                            <div class="fl order_dmsg">
                                <p><%=order.getDoctor()%> 丨 <%=order.getTitle()%></p>
                                <p><%=DateUtils.getWeekOfDate(order.getAppointmentTime())%> <%=DateUtils.format(order.getAppointmentTime(), "HH:mm")%><span>（<%=DateUtils.format(order.getAppointmentTime(), "MM-dd")%>）</span></p>
                                <p><%=order.getAppointmentAddress()%></p>
                            </div>
                        </section>
                        <section class="order_price clearfix pr">
                            <span class="fl">实付：￥<%=order.getTotalFee().setScale(0)%></span>
                            <i class="pa">
                                剩余：<c id="<%=id%>">0分0秒</c>
                                <small class="pa"></small>
                            </i>
                            <a href="javascript:void(0)" class="pa go">去支付</a>
                        </section>
                    </a>
                </li>
                <%
                        }
                    }
                %>
            </ul>
            <%
                if(!waitToPayFlag) {
            %>
            <div class="no_case">
                <p class="no_case_pic no_order_pic"></p>
                <p class="no_case_font">暂无订单记录！</p>
            </div>
            <%
                }
            %>
        </section>

        <section class="tab_content">
            <ul class="orderlist">
                <%
                    boolean waitToDiagnoseFlag = false;
                    for(JdOrderQueryModel order : orderList) {
                        if(order.getStatus().equals(OrderStatus.WAITTO_DIAGNOSE.getValue())) {
                            waitToDiagnoseFlag = true;
                            String keyword = order.getOrderNumber() + order.getDoctor() + order.getName() + order.getHospital();
                %>
                <li onclick="toOrderDetail('<%=order.getOrderNumber()%>')" keyword="<%=keyword%>">
                    <a href="javascript:void(0)" class="pr">
                        <section class="order_number clearfix">
                            <span class="fl">预约号：<%=order.getOrderNumber()%></span>
                            <span class="fr"><%=WechatUtils.getOrderStatusDescription(order.getStatus())%></span>
                        </section>
                        <section class="order_doctor clearfix">
                            <div class="fl order_header">
                                <span style="background:url(<%=order.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
                            </div>
                            <div class="fl order_dmsg">
                                <p><%=order.getDoctor()%> 丨 <%=order.getTitle()%></p>
                                <p><%=DateUtils.getWeekOfDate(order.getAppointmentTime())%> <%=DateUtils.format(order.getAppointmentTime(), "HH:mm")%><span>（<%=DateUtils.format(order.getAppointmentTime(), "MM-dd")%>）</span></p>
                                <p><%=order.getAppointmentAddress()%></p>
                            </div>
                        </section>
                        <section class="order_price clearfix pr">
                            <span class="fl">实付：￥<%=order.getTotalFee().setScale(0)%></span>
                        </section>
                    </a>
                </li>
                <%
                        }
                    }
                %>
            </ul>
            <%
                if(!waitToDiagnoseFlag) {
            %>
            <div class="no_case">
                <p class="no_case_pic no_order_pic"></p>
                <p class="no_case_font">暂无订单记录！</p>
            </div>
            <%
                }
            %>
        </section>

        <section class="tab_content">
            <ul class="orderlist">
                <%
                    boolean waitToConfirmFlag = false;
                    for(JdOrderQueryModel order : orderList) {
                        if(order.getStatus().equals(OrderStatus.WAITTO_CONFIRM.getValue())) {
                            waitToConfirmFlag = true;
                            String keyword = order.getOrderNumber() + order.getDoctor() + order.getName() + order.getHospital();
                %>
                <li onclick="toOrderDetail('<%=order.getOrderNumber()%>')" keyword="<%=keyword%>">
                    <a href="javascript:void(0)" class="pr">
                        <section class="order_number clearfix">
                            <span class="fl">预约号：<%=order.getOrderNumber()%></span>
                            <span class="fr"><%=WechatUtils.getOrderStatusDescription(order.getStatus())%></span>
                        </section>
                        <section class="order_doctor clearfix">
                            <div class="fl order_header">
                                <span style="background:url(<%=order.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
                            </div>
                            <div class="fl order_dmsg">
                                <p><%=order.getDoctor()%> 丨 <%=order.getTitle()%></p>
                                <p><%=DateUtils.getWeekOfDate(order.getAppointmentTime())%> <%=DateUtils.format(order.getAppointmentTime(), "HH:mm")%><span>（<%=DateUtils.format(order.getAppointmentTime(), "MM-dd")%>）</span></p>
                                <p><%=order.getAppointmentAddress()%></p>
                            </div>
                        </section>
                        <section class="order_price clearfix pr">
                            <span class="fl">实付：￥<%=order.getTotalFee().setScale(0)%></span>
                        </section>
                    </a>
                </li>
                <%
                        }
                    }
                %>
            </ul>
            <%
                if(!waitToConfirmFlag) {
            %>
            <div class="no_case">
                <p class="no_case_pic no_order_pic"></p>
                <p class="no_case_font">暂无订单记录！</p>
            </div>
            <%
                }
            %>
        </section>

        <section class="tab_content">
            <ul class="orderlist">
                <%
                    boolean waitToCommentFlag = false;
                    for(JdOrderQueryModel order : orderList) {
                        if(order.getStatus().equals(OrderStatus.WAITTO_COMMENT.getValue())) {
                            waitToCommentFlag = true;
                            String keyword = order.getOrderNumber() + order.getDoctor() + order.getName() + order.getHospital();
                            String id = "comment_" + order.getOrderNumber();
                            String interval = id + "," + order.getTimeLevel();
                            intervalList.add(interval);
                %>
                <li onclick="toOrderDetail('<%=order.getOrderNumber()%>')" keyword="<%=keyword%>">
                    <a href="javascript:void(0)" class="pr">
                        <section class="order_number clearfix">
                            <span class="fl">预约号：<%=order.getOrderNumber()%></span>
                            <span class="fr"><%=WechatUtils.getOrderStatusDescription(order.getStatus())%></span>
                        </section>
                        <section class="order_doctor clearfix">
                            <div class="fl order_header">
                                <span style="background:url(<%=order.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
                            </div>
                            <div class="fl order_dmsg">
                                <p><%=order.getDoctor()%> 丨 <%=order.getTitle()%></p>
                                <p><%=DateUtils.getWeekOfDate(order.getAppointmentTime())%> <%=DateUtils.format(order.getAppointmentTime(), "HH:mm")%><span>（<%=DateUtils.format(order.getAppointmentTime(), "MM-dd")%>）</span></p>
                                <p><%=order.getAppointmentAddress()%></p>
                            </div>
                        </section>
                        <section class="order_price clearfix pr">
                            <span class="fl">实付：￥<%=order.getTotalFee().setScale(0)%></span>
                            <i class="pa">
                                评价有奖：<c id="<%=id%>">0分0秒</c>
                                <small class="pa"></small>
                            </i>
                            <a href="javascript:void(0)" class="pa go">去评价</a>
                        </section>
                    </a>
                </li>
                <%
                        }
                    }
                %>
            </ul>
            <%
                if(!waitToCommentFlag) {
            %>
            <div class="no_case">
                <p class="no_case_pic no_order_pic"></p>
                <p class="no_case_font">暂无订单记录！</p>
            </div>
            <%
                }
            %>
        </section>

        <section class="tab_content">
            <ul class="orderlist">
                <%
                    boolean waitToShareFlag = false;
                    for(JdOrderQueryModel order : orderList) {
                        if(order.getStatus().equals(OrderStatus.WAITTO_SHARE.getValue())) {
                            waitToShareFlag = true;
                            String keyword = order.getOrderNumber() + order.getDoctor() + order.getName() + order.getHospital();
                            String id = "share_" + order.getOrderNumber();
                            String interval = id + "," + order.getTimeLevel();
                            intervalList.add(interval);
                %>
                <li onclick="toOrderDetail('<%=order.getOrderNumber()%>')" keyword="<%=keyword%>">
                    <a href="javascript:void(0)" class="pr">
                        <section class="order_number clearfix">
                            <span class="fl">预约号：<%=order.getOrderNumber()%></span>
                            <span class="fr"><%=WechatUtils.getOrderStatusDescription(order.getStatus())%></span>
                        </section>
                        <section class="order_doctor clearfix">
                            <div class="fl order_header">
                                <span style="background:url(<%=order.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
                            </div>
                            <div class="fl order_dmsg">
                                <p><%=order.getDoctor()%> 丨 <%=order.getTitle()%></p>
                                <p><%=DateUtils.getWeekOfDate(order.getAppointmentTime())%> <%=DateUtils.format(order.getAppointmentTime(), "HH:mm")%><span>（<%=DateUtils.format(order.getAppointmentTime(), "MM-dd")%>）</span></p>
                                <p><%=order.getAppointmentAddress()%></p>
                            </div>
                        </section>
                        <section class="order_price clearfix pr">
                            <span class="fl">实付：￥<%=order.getTotalFee().setScale(0)%></span>
                            <i class="pa">
                                分享红包：<c id="<%=id%>">0分0秒</c>
                                <small class="pa"></small>
                            </i>
                            <a href="javascript:void(0)" class="pa go">去分享</a>
                        </section>
                    </a>
                </li>
                <%
                        }
                    }
                %>
            </ul>
            <%
                if(!waitToShareFlag) {
            %>
            <div class="no_case">
                <p class="no_case_pic no_order_pic"></p>
                <p class="no_case_font">暂无订单记录！</p>
            </div>
            <%
                }
            %>
        </section>
    </div>
    <!--content-->
</div>
<!--wrap-->

<!--搜索-->
<div class="search_touch">
    <div class="search_wrap pr">
        <div class="search_input pr">
            <input type="text" placeholder="预约号 / 医生 / 医院 / 患者" id="searchText"><a class="search_btn pa" onclick="updateOrderList()"></a>
        </div>
    </div>
</div>
<!--搜索-->
</body>
<script>
    sendPageVisit(Page_Constant.MyOrder);
    /*===================================tab滚动===================================*/
    var screenWidth=$(window).width();
    var liWidth=screenWidth*0.22;
    var ulWidth=liWidth*6;
    // $('#order_top li').css({'width':liWidth+'px'});
    // $('#order_top').css({'width':ulWidth+"px"});
    // var myScroll = new IScroll('#order_list_wrap', {
    //     scrollX: true,
    //     scrollY: false,
    //     momentum: false,
    //     snap: '#order_top li',
    //     click:true,
    //     snapSpeed: 400,
    //     keyBindings: true,
    //     bounce:false
    // });
    /*===================================tab切换===================================*/
    $('#order_top').on('click','li',function(ev){
        $('#order_top li').removeClass('tabshow_active');
        $(this).addClass('tabshow_active');
        $('.tab_content').removeClass('tab_show');
        $('.tab_content').eq($(this).index()).addClass('tab_show');
        if ($(this).index()=="1") {
            // myScroll.scrollTo(0,0,0);
            $('#order_top').css({'left':-0+'px'});
            return;
        }
        if ($(this).index()=="4" || $(this).index()=="5") {
            var dis=parseInt(($('#order_top li').width()/2)+liWidth)-4;
            // myScroll.scrollTo(-dis,0,0);
            $('#order_top').css({'left':-dis+'px'});
            return;
        }
    });
    var status = "<%=status%>";
    var statusInt = parseInt(status);
    $('#order_top li:eq('+statusInt+')').click();

    //回车触发关键字搜索
    document.onkeydown = function (event) {
        if (event.keyCode == 13) {
            event.preventDefault();
            updateOrderList();
        }
    };
    $('#search_btn').on('click', function (ev) {
        $('.search_touch').css({'display': 'block'});
        $('.search_input input').focus();
        ev.preventDefault();
    });
    $('.search_touch').on('click', function (ev) {
        $(this).css({'display': 'none'});
    });
    $('.search_wrap').on('click', function (ev) {
        ev.stopPropagation();
    });
    function updateOrderList() {
        $('.search_touch').css({'display': 'none'});
        var search = $("#searchText").val().trim();
        $("ul.orderlist li").each(function() {
            var keyword = $(this).attr("keyword");
            if(keyword.indexOf(search) > -1) {
                $(this).css("display", "");
            } else {
                $(this).css("display", "none");
            }
        });
    }

    //倒计时
    var addTimer = function () {
        var list = [],
                interval;
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
                if(d > 0 || h > 0)
                    str.append(h + "时");
                if(d > 0 || h > 0 || m > 0)
                    str.append(m + "分");
                if(d == 0)
                    str.append(s + "秒");
                return str.toString();
            } else {
                return "已过期";
            }
        }
    }();
    var intervalList = <%=new Gson().toJson(intervalList)%>;
    var intervalLen = intervalList.length;
    if(intervalLen > 0) {
        for(var i = 0; i < intervalLen; i++) {
            var interval = intervalList[i].split(",");
            addTimer(interval[0], interval[1]);
        }
    }

    //跳转订单详情
    function toOrderDetail(orderNumber) {
        goto("toOrderDetail.htm?orderNumber=" + orderNumber);
    }
</script>
</html>
