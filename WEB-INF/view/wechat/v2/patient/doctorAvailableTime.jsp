<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdCaseHistoryQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%
    JdPatientModel patient = (JdPatientModel)request.getSession().getAttribute(WebConstants.SESSION_PATIENT);
    JdDoctorQueryModel doctorInfo = (JdDoctorQueryModel)request.getAttribute("doctorQueryModel");
    List<String> availableTimeArray = (List<String>)request.getAttribute("availableTimeArray");
    String address = (String)request.getAttribute("address");
    boolean isConcern = (Boolean)request.getAttribute("isConcern");
    List<JdCaseHistoryQueryModel> caseList = (List<JdCaseHistoryQueryModel>)request.getAttribute("caseList");
    Integer maxCoupon = (Integer)request.getAttribute("maxCoupon");
    BigDecimal doctorFee = (BigDecimal)request.getAttribute("doctorFee");
    boolean isPatron = (Boolean)request.getAttribute("isPatron");

    if(doctorFee == null) {
        doctorFee = BigDecimal.ZERO;
    }
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--doctorheader-->
    <%--注释 by xws--%>
    <%--    <header class="doctorheader">
            <section class="doctor_back pr">
                <a onclick="toMain()" class="goindex pa"></a>
                <a onclick="toPersonal()" class="gomine pa"></a>
            </section>
            <section class="doc_hw pr">
                <a href="javascript:void(0)" class="pa collect <%=isConcern?"collect_active":""%>" id="collect"></a>
                <div class="doctordepic pa"
                     style="background:url(<%=doctorInfo.getHeadPic()%>) center center no-repeat;background-size:cover;"></div>
                <a href="javascript:void(0)" class="pa share" id="share"></a>
            </section>
            <section class="doctor_dename"><%=doctorInfo.getName()%><i>丨</i><%=doctorInfo.getTitle()%></section>
            <section class="doctor_dehoname"><%=doctorInfo.getHospital()%></section>
        </header>--%>
    <!--doctorheader-->

    <!--doctor_price-->
    <%--注释 by xws--%>
    <%--<div class="doctor_price">--%>
    <%--<section class="nowprice pr clearfix">--%>
    <%--<span class="fl nowprice_left pr"><i class="pa">￥</i></span>--%>
    <%--<span class="fl nowprice_center"><%=isPatron ? ((BigDecimal)request.getAttribute("minDiscountedFee")).intValue() : doctorFee.intValue() %></span>--%>
    <%--<span class="fl nowprice_right pr"><i class="pa">起</i></span>--%>
    <%--<% --%>
    <%--if (isPatron){--%>
    <%--String discountLabel = "复诊";--%>
    <%--int discount = (int)request.getAttribute("discount");--%>
    <%--if (discount > 0){--%>
    <%--discountLabel += discount + "折";--%>
    <%--}else if (discount == 0){--%>
    <%--discountLabel += "免费";--%>
    <%--}--%>
    <%--%>--%>
    <%--<i class="discount_show fl"><%=discountLabel%></i>--%>
    <%--<%--%>
    <%--}--%>
    <%--%>--%>
    <%--<%--%>
    <%--if(maxCoupon != null && maxCoupon > 0) {--%>
    <%--%>--%>
    <%--<i class="discount_show_use fl">现金劵可抵用<%=maxCoupon%>元</i>--%>
    <%--<%--%>
    <%--}--%>
    <%--%>--%>
    <%--</section>--%>
    <%----%>
    <%--<% --%>
    <%--if (isPatron) {--%>
    <%--%>--%>
    <%--<section class="nowoldprice">--%>
    <%--原价: <span>￥<%=doctorFee.intValue()%></span>--%>
    <%--</section>--%>
    <%--<% --%>
    <%--} --%>
    <%--%>--%>

    <%--<section class="doctor_location clearfix">--%>
    <%--<span class="fl location_logo"></span>--%>
    <%--<span class="location_address fl"><%=address%></span>--%>
    <%--</section>--%>

    <%--</div>--%>
    <!--doctor_price-->

    <!--doctor_timeofapp-->
    <div class="doctor_timeofapp pr">
        <section class="appnowdata">
            <div class="fl" id="yearmonth"></div>
            <div class="fr" statu="next" id="nextweek">下一周</div>
        </section>
        <section class="appshowdata">
            <ul id="appshowdata">
                <li>
                    <p class="week"></p>
                    <p class="webday day"></p>
                    <b></b>
                </li>
                <li>
                    <p class="week"></p>
                    <p class="webday day"></p>
                    <b></b>
                </li>
                <li>
                    <p class="week"></p>
                    <p class="webday day"></p>
                    <b></b>
                </li>
                <li>
                    <p class="week"></p>
                    <p class="webday day"></p>
                    <b></b>
                </li>
                <li>
                    <p class="week"></p>
                    <p class="webday day"></p>
                    <b></b>
                </li>
                <li>
                    <p class="week"></p>
                    <p class="webday day"></p>
                    <b></b>
                </li>
                <li>
                    <p class="week"></p>
                    <p class="webday day"></p>
                    <b></b>
                </li>
            </ul>
        </section>
    </div>
    <!--doctor_timeofapp-->

    <!--doctor_apptime-->
    <div class="doctor_apptime" id="doctor_apptime">
        <ul id="pa_select" style="min-height: 48px;"></ul>
    </div>
    <!--doctor_apptime-->

    <!--profile-->
    <%--注释 by xws--%>
    <%--    <div class="profile">
            <ul class="profile clearfix tab_nav">
                <li class="fl pr tabshow_active" id="profileLi">医生简介<b></b></li>
                <li class="fl pr" id="commentLi">评价(<span id="commentCount">0</span>)<b></b></li>
            </ul>
        </div>--%>
</div>
<!--profile-->

<!--profile_tab-->
<%--注释 by xws--%>
<%--<section class="profile_tab tab_content tab_show">--%>
<%--<div class="doctor_profile">--%>
<%--<%--%>
<%--String[] descriptions = doctorInfo.getDescription().split("\n");--%>
<%--for(String desc : descriptions) {--%>
<%--out.println(desc + "<br>");--%>
<%--}--%>
<%--%>--%>
<%--</div>--%>
<%--<div class="begoodat clearfix">--%>
<%--<div class="begoodat_title pr"><span class="belogo pa"></span><i class="bgt1">擅长</i></div>--%>
<%--<div class="begooat_content">--%>
<%--<ul class="clearfix">--%>
<%--<%--%>
<%--for(JdSickQueryModel sick : doctorInfo.getDoctorSelectSkills()) {--%>
<%--%>--%>
<%--<li class="fl"><%=sick.getName()%></li>--%>
<%--<%--%>
<%--}--%>
<%--%>--%>
<%--</ul>--%>
<%--</div>--%>
<%--</div>--%>
<%--<div class="begoodat clearfix">--%>
<%--<div class="begoodat_title pr"><span class="belogo2 pa"></span><i class="bgt2">病情咨询</i></div>--%>
<%--<div class="begooat_content">--%>
<%--<ul class="clearfix">--%>
<%--<%--%>
<%--if(caseList == null || caseList.size() == 0) {--%>
<%--%>--%>
<%--<li class="fl">暂无病历</li>--%>
<%--<%--%>
<%--} else {--%>
<%--for(int i = 0; i < caseList.size(); i++) {--%>
<%--JdCaseHistoryQueryModel c = caseList.get(i);--%>
<%--%>--%>
<%--<li class="fl"><%=c.getSickCategoryName()%>(<%=c.getCount()%>)</li>--%>
<%--<%--%>
<%--}--%>
<%--}--%>
<%--%>--%>
<%--</ul>--%>
<%--</div>--%>
<%--</div>--%>
<%--</section>--%>
<!--profile_tab-->

<!--comment_tab-->
<%--注释 by xws--%>
<%--<section class="profile_tab comment tab_content">--%>
<%--<ul class="list" id="commentList"></ul>--%>
<%--</section>--%>
<!--comment_tab-->
</div>
<!--wrap-->

<div class="share_wrap">
    <div class="share_pic"></div>
</div>
</body>
<script>
    sendPageVisit(Page_Constant.DoctorHomePage);

    var patient = '<%=patient%>';
    /*点击分享*/
    $('#share').on('click', function (ev) {
        $('.share_wrap').css({'display': 'block'});
    });
    $('.share_wrap').on('click', function (ev) {
        $('.share_wrap').css({'display': 'none'});
    });

    /*点击关注*/
    $('#collect').on('click', function (ev) {
        var flag;
        var $this = $(this);
        if ($this.hasClass('collect_active')) {
            flag = "del";
        } else {
            flag = "add";
        }
        var data = {flag:flag, doctorId:'<%=doctorInfo.getUuid().toString()%>'};
        sendRequest("asynConcern.htm", "POST", data, function(result) {
            if(result) {
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                if(flag == "add") {
                    $this.addClass('collect_active');
                } else {
                    $this.removeClass('collect_active');
                }
            }
        });
    });

    //医生有号的日期
    var availableTimeArray = <%=availableTimeArray==null?"[]":new Gson().toJson(availableTimeArray)%>;
    //记录第一个有号源的日期并自动加载
    var firstAvailableFind = false;
    var firstAvailableIndex = 0;
    /*生成日期*/
    function nowweek(j) {
        var date = new Date();
        var onedayTimes = 1000 * 60 * 60 * 24;
        for (var i = 0; i < 7; i++) {
            var $day = $('.day').eq(i);
            var milliseconds = date.getTime() + onedayTimes * (i + j);
            var date1 = new Date();
            date1.setTime(milliseconds);
            $day.html(date1.getDate());
            var month = date1.getMonth() + 1;
            if(month < 10) month = "0" + month;
            var day = date1.getDate();
            if(day < 10) day = "0" + day;
            var dayStr = date1.getFullYear() + "-" + month + '-' + day;
            if(strInArray(availableTimeArray, dayStr)) {
                if(!firstAvailableFind) {
                    firstAvailableFind = true;
                    firstAvailableIndex = i;
                }
                $day.attr("able", "true");
            } else {
                $day.removeAttr("able");
            }
            $day.parent().attr('today', dayStr);
            var weekday = parseInt(date1.getDay());
            switch (weekday) {
                case 1:
                    weekday = '一';
                    break;
                case 2:
                    weekday = '二';
                    break;
                case 3:
                    weekday = '三';
                    break;
                case 4:
                    weekday = '四';
                    break;
                case 5:
                    weekday = '五';
                    break;
                case 6:
                    weekday = '六';
                    break;
                case 0:
                    weekday = '日';
                    break;
            }
            $('.week').eq(i).html(weekday);
        }
    }
    nowweek(0);

    /*点击上下周*/
    $('#nextweek').on('click', function (ev) {
        if ($(this).attr('statu') == "next") {
            nowweek(7);
            $(this).attr('statu', "last");
            $('#nextweek').html("上一周");
        } else if ($(this).attr('statu') == "last") {
            nowweek(0);
            $('#nextweek').html("下一周");
            $(this).attr('statu', "next");
        }
        $('#appshowdata li:eq('+selectindex+')').click();
    });

    /*点击日期*/
    var selectindex = 0;//记录点击日期的索引
    $('#appshowdata').on('click', 'li', function (ev) {
        $('#appshowdata li').removeClass('data_active');
        $(this).addClass('data_active');
        $("#pa_select").html("");
        var today = $(this).attr("today");
        $('#yearmonth').html(today.substring(0,today.length-3));
        selectindex = $(this).index();
        if ($(this).find('.webday').attr('able') == "true") {
            //获取医生选中日期的可预约时间点
            var data = {"availableDate":today, "doctorId":"<%=doctorInfo.getUuid().toString()%>"};
            sendRequest("getDoctorAvailableTimes.htm", "GET", data, function(result) {
                var str = new StringBuilder();
                var len = result.length;
                if(len > 0) {
                    for(var i = 0; i < len; i++) {
                        var obj = result[i];
                        if(obj.hasBooked == true) {
                            str.append('<li><span>' + obj.dateTime + '</span></li>');
                        } else {
                            str.append('<li class="apptime_active" id="' + obj.uuid + '"><span>' + obj.dateTime + '</span></li>');
                        }
                    }
                }
                $("#pa_select").html(str.toString());
            });
            seltime();
        } else if(availableTimeArray.length == 0) {
            $("#pa_select").html('<a class="apply_plus" href="javascript:void(0)" onclick="applyPlus()">申请加号</a>');
        }
    });
    $('#appshowdata li:eq('+firstAvailableIndex+')').click();

    /*点击时间事件*/
    function seltime() {
        $('#pa_select').on('click', 'li', function (ev) {
            var $this = $(this);
            if ($this.hasClass('apptime_active')) {
                var checkUserDrawCoupon = 0;
                sendRequest("checkUserDrawCoupon.htm", "GET", null, function(msg){
                    if(msg == 'true'){
                        layer.alert("您还有有未领取的券,请领取！", {
                            title: false,
                            closeBtn: false
                        }, function () {
                            checkUserDrawCoupon = 0;
                            goto("coupon.htm?doctroId=<%=doctorInfo.getUuid().toString()%>&timestamp="+(new Date()).getTime());
                        });
                    }else{
                        checkUserDrawCoupon = 1;
                    }
                }, function(data){}, false);
                if(checkUserDrawCoupon == 1){
                    sendRequest("checkWaitToPayCount.htm", "GET", function(result) {
                        if(result > 0) {
                            var tip = "您有待付款订单，请先支付或取消待付款的订单后，再提交新订单。现在跳转待付款订单列表？";
                            layer.confirm(tip, {
                                title: false,
                                closeBtn: false,
                                btn: ['取消', '确定']
                            }, function () {
                                layer.closeAll();
                            }, function () {
                                goto("toOrderList.htm?status=1");
                            });
                        } else {
                            var timeId = $this.attr("id");
                            goto("fillOrder.htm?doctorId=<%=doctorInfo.getUuid().toString()%>&timeId="+timeId);
                        }
                    });
                }
            } else {
                layer.alert("时间已被预约或已过期,请重新选择", {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            }
        });
    }
    seltime();

    function applyPlus() {
        var checkUserDrawCoupon = 0;
        sendRequest("checkUserDrawCoupon.htm", "GET", null, function(msg){
            if(msg == 'true'){
                layer.alert("您还有有未领取的券,请领取！", {
                    title: false,
                    closeBtn: false
                }, function () {
                    checkUserDrawCoupon = 0;
                    goto("coupon.htm?doctroId=<%=doctorInfo.getUuid().toString()%>&timestamp="+(new Date()).getTime());
                });
            }else{
                checkUserDrawCoupon = 1;
            }
        }, function(data){}, false);
        if(checkUserDrawCoupon == 1){
            if(patient == "null") {
                layer.alert("请先登录", {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
                return;
            }
            goto('toFillOrderPlus.htm?doctorId=<%=doctorInfo.getUuid().toString()%>');
        }
    }
    /*===================================tab切换===================================*/
    var currentLi;
    $('.tab_nav').on('click','li',function(ev){
        $('.tab_nav li').removeClass('tabshow_active');
        $('.tab_nav li').eq($(this).index()).addClass('tabshow_active');
        $('.tab_content').removeClass('tab_show');
        $('.tab_content').eq($(this).index()).addClass('tab_show');
        currentLi = $(this).attr("id");
    });

    /*************************** start 医生评论列表 ***************************/
    var pageIndex = 1;
    var loadEnd = false;
    var doctorId = '<%=doctorInfo.getUuid().toString()%>';
    function asynPageCommentList() {
        var data = {"pageIndex":pageIndex, "doctorId":doctorId};
        sendRequest("asynPageCommentList.htm", "GET", data, function(resultPage) {
            if(pageIndex == 1) {
                $("#commentCount").html(resultPage.totalCount);
            }
            var str = new StringBuilder();
            for(var i = 0, len = resultPage.result.length; i < len; i++) {
                var comment = resultPage.result[i];
                str.append('<li><p class="clearfix"><span class="fl start star' + getCommentStar(comment.stars) + '"></span>');
                str.append('<span class="fr user_msg"><i class="phone">' + comment.phoneNumber + '</i><i>' + comment.orderTime + '</i></span></p>');
                str.append('<p class="commet_content">' + comment.comment + '</p></li>');
            }
            $("#commentList").append(str.toString());
            if(pageIndex >= resultPage.totalPage) {
                loadEnd = true;
            } else {
                pageIndex++;
            }
        });
    }
    asynPageCommentList();

    function getCommentStar(stars) {
        stars = stars+"";
        var index = stars.indexOf(".5");
        if(index > -1) {
            stars = stars.substring(0,1) + "f";
        }
        return stars;
    }

    //滚动到底部自动加载评论列表
    var totalheight;
    $(window).scroll(function () {
        if(currentLi == "commentLi" && !loadEnd) {
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() <= totalheight) {
                asynPageCommentList();
            }
        }
    });
    /*************************** end 医生评论列表 ***************************/
</script>
</html>
