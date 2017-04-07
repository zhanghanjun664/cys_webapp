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
    <header class="doctorheader">
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
    </header>
    <!--doctorheader-->

    <!--doctor_price-->
    <%--注释 by xws--%>
    <div class="doctor_price">
        <section class="nowprice pr clearfix">
            <span class="fl nowprice_left pr"><i class="pa">￥</i></span>
            <span class="fl nowprice_center"><%=isPatron ? ((BigDecimal)request.getAttribute("minDiscountedFee")).intValue() : doctorFee.intValue() %></span>
            <span class="fl nowprice_right pr" style="margin-top:3px;width:auto;"><i class="pa">起</i></span>
            <%
                if (isPatron){
                    String discountLabel = "复诊";
                    Integer discount = (Integer) request.getAttribute("discount");
                    if (discount != null && discount > 0){
                        discountLabel += discount + "折";
                    }else if (discount == 0){
                        discountLabel += "免费";
                    }
            %>
            <i class="discount_show fl"><%=discountLabel%></i>
            <%
                }
            %>
            <%
                if(maxCoupon != null && maxCoupon > 0) {
            %>
            <i class="discount_show_use fl" style="display: none;">现金劵可抵用<%=maxCoupon%>元</i>
            <%
                }
            %>
        </section>

        <%
            if (isPatron) {
        %>
        <section class="nowoldprice">
            原价: <span>￥<%=doctorFee.intValue()%></span>
        </section>
        <%
            }
        %>

        <section class="doctor_location clearfix" style="display: none;">
            <span class="fl location_logo"></span>
            <span class="location_address fl"><%=address%></span>
        </section>

    </div>
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
    <%--<div class="profile">--%>
        <%--<ul class="profile clearfix tab_nav">--%>
            <%--<li class="fl pr tabshow_active" id="profileLi">医生简介<b></b></li>--%>
            <%--<li class="fl pr" id="commentLi">评价(<span id="commentCount">0</span>)<b></b></li>--%>
        <%--</ul>--%>
    <%--</div>--%>

        <div id='firstComment'>

        </div>


        <div id='expertise'>

        </div>

        <%--<div class="doctor_details_comment">--%>
        <%--<div class="doctor_details_comment_title">擅长</div>--%>
        <%--<div class="doctor_details_comment_box">--%>
        <%--<div class="doctor_details_comment_content doctor_details_desc">1994年毕业于汕头大学医学院临床医学专业，毕业后从事肿瘤外科普通外科临床工作18年，专业理论基础扎实、临床经验丰富，具有肿瘤外科疑难疾病的诊治经验,擅长乳腺肿瘤和胃肠肿瘤等的诊治工作，特别对癌肿疼痛的诊治有独到的理…</div>--%>
        <%--</div>--%>
        <%--</div>--%>
        <div id="description">
        </div>


        <div id="case">



        </div>




</div>
<!--profile-->

    <!--profile_tab-->
<%--注释 by xws--%>
    <%--<section class="profile_tab tab_content tab_show">--%>
        <%--<div class="doctor_profile">--%>
            <%--<%--%>
                <%--if(!StringUtils.isEmpty(doctorInfo.getDescription())){--%>
                    <%--String[] descriptions = doctorInfo.getDescription().split("\n");--%>
                    <%--for(String desc : descriptions) {--%>
                        <%--out.println(desc + "<br>");--%>
                    <%--}--%>
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




<%--</div>--%>
<!--wrap-->


        <div class="comment_box_wrap">

           <div class="comment_box_wrap_header pr"><span class="pa" id="commentBack"></span><i id="commentName"></i></div>

        <div class="doctor_details_comment">
                <div class="doctor_details_comment_title" id="commentTotal">评价(0)</div>


        <div id="moreComment"></div>



        </div>


        </div>








<div class="share_wrap">
    <div class="share_pic"></div>
</div>
</body>
<script src="../../wechat/js/weixin.js" type="text/javascript"></script>
<script>
    sendPageVisit(Page_Constant.DoctorHomePage);
    var wechatShare=function(title,desc,images,link){
        $.ajax({
            url:'/wxapi/public/wxConfig/patient',
            data:JSON.stringify({
                url:window.location.href
            }),
            dataType:'json',
            contentType: "application/json; charset=utf-8",
            type:'post',
            async:true,
            success:function(s){
                if(s.code===2000){
                    shareConfig({
                        appId:s.result.appId,
                        timestamp:s.result.timestamp,
                        nonceStr:s.result.nonceStr,
                        signature:s.result.signature,
                        title:title,
                        desc:desc,
                        images:images,
                        shareLink:link
                    });
                }else{
                    console.log('get share config fail');
                }
            }
        });
    };
    var shareConfig=function(object){
        wx.config({
            debug: false,
            appId:object.appId,
            timestamp:object.timestamp ,
            nonceStr:object.nonceStr,
            signature:object.signature,
            jsApiList: ['checkJsApi','onMenuShareTimeline','onMenuShareAppMessage']
        });

        wx.ready(function(){
            wx.checkJsApi({
                jsApiList: ['onMenuShareTimeline','onMenuShareAppMessage'],
                success: function (res) {
                    if (!res.checkResult.onMenuShareTimeline || !res.checkResult.onMenuShareTimeline) {
                        console.log('you can not share');
                    }else{
                        wx.onMenuShareTimeline({
                            title: object.title,
                            link:object.shareLink,
                            imgUrl: object.images,
                            type:'link',
                            desc:object.desc,
                            success:function () {
                                console.log('share success');
                            },
                            fail:function(){
                            }
                        });

                        wx.onMenuShareAppMessage({
                            title: object.title,
                            link:object.shareLink,
                            imgUrl: object.images,
                            type:'link',
                            desc:object.desc,
                            success:function () {
                                console.log('share success');
                            },
                            fail:function(){
                            }
                        });


                    }
                }
            });
        });


    };
    var title="为您推荐一个医术很不错的医生<%=doctorInfo.getName()%>";
    var desc = '我在橙医生预约的<%=doctorInfo.getName()%>医生,医术、态度都很不错，找心血管医生推荐你橙医生平台。';
    var icon = '<%=doctorInfo.getHeadPic()%>';
    var link=null;
    switch (window.location.hostname){
        case "m.chengyisheng.com.cn":
            link='https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx549181202951b22f&redirect_uri=http%3a%2f%2fm.chengyisheng.com.cn%2fAuthWechat%2fcode%3fcys_url%3dhttp%3a%2f%2fm.chengyisheng.com.cn%2fweixin%2fpatient%2fdoctor.htm%3fjd_doctor_id%3d<%=doctorInfo.getUuid().toString()%>&response_type=code&scope=snsapi_base&state=ORDER&connect_redirect=1#wechat_redirect';
            break;
        case "staging.chengyisheng.com.cn":
            link='https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxbef8cd584beb9788&redirect_uri=http%3a%2f%2fstaging.chengyisheng.com.cn%2fAuthWechat%2fcode%3fcys_url%3dhttp%3a%2f%2fstaging.chengyisheng.com.cn%2fweixin%2fpatient%2fdoctor.htm%3fjd_doctor_id%3d<%=doctorInfo.getUuid().toString()%>&response_type=code&scope=snsapi_base&state=ORDER&connect_redirect=1#wechat_redirect';
            break;
    }
    wechatShare(title,desc, icon,link);
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
                    $(".discount_show_use").show();
                    $(".doctor_location").show();
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
            $(".nowprice_center").html("20元");
            $(".nowprice_right").html("&nbsp;保证金");
            $("#pa_select").html('<a class="apply_plus" href="javascript:void(0)" onclick="applyPlus()">申请放号</a>');
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

        var doctorId = '<%=doctorInfo.getUuid().toString()%>';

        /*************************** start 获取医生基本信息 ***************************/

        $.ajax({
                url: '/wxapi/public/doctor/',
                type: 'get',
                data: {'doctor_id': doctorId},
                dataType: 'json',
                async: true,
                success:function(s){
                      if(s.code===2000){

        if (s.result.doctor.expertise_str && s.result.doctor.expertise_str !== '') {
        var expertise_str=s.result.doctor.expertise_str;
        var newExp=expertise_str.substring(0,46)+'....';
        var showExp=null;
        if(expertise_str.length>48){
        showExp=newExp;
        }else{
        showExp=expertise_str;
        }

        $('#expertise').html('<div class="doctor_details_comment">'+
        '<div class="doctor_details_comment_title pr">擅长 <small></small></div>'+
        '<div class="doctor_details_comment_box">'+
        '<div class="doctor_details_comment_content doctor_details_desc">'+showExp+'</div>'+
        '</div>'+
        '</div>');

        if(expertise_str.length>48){
        $('#expertise .doctor_details_comment_title small').show().off().on('click',function(){
        if($(this).hasClass('show_more')){
        $('#expertise').find('.doctor_details_desc').html(newExp);
        $(this).removeClass('show_more');
        }else{
        $(this).addClass('show_more');
        $('#expertise').find('.doctor_details_desc').html(expertise_str);
        }
        });
        }else{
        $('#expertise .doctor_details_comment_title small').hide();
        }



        }




        if( s.result.doctor.description && s.result.doctor.description!==''){


        var description=s.result.doctor.description;
        var newDescription=description.substring(0,46)+'....';
        var showDec=null;
        if(description.length>48){
        showDec=newDescription;
        }else{
        showDec=description;
        }


        $('#description').html(
        '<div class="doctor_details_comment">'+
        '<div class="doctor_details_comment_title">医生简介<small></small></div>'+
        '<div class="doctor_details_comment_box">'+
        '<div class="doctor_details_comment_content doctor_details_desc">'+showDec+'</div>'+
        '</div>'+
        '</div>'
        );

        if(description.length>48){
        $('#description .doctor_details_comment_title small').show().off().on('click',function(){
        if($(this).hasClass('show_more')){
        $('#description').find('.doctor_details_desc').html(newDescription);
        $(this).removeClass('show_more');
        }else{
        $(this).addClass('show_more');
        $('#description').find('.doctor_details_desc').html(description);
        }
        });
        }else{
        $('#description .doctor_details_comment_title small').hide();
        }

        }




                        if(s.result.cases.length>0){

                        $('#case').html(
                        '<div class="doctor_details_comment">'+
                        '<div class="doctor_details_comment_title">病情咨询('+s.result.cases.length+')</div>'+
                        '<div class="doctor_details_comment_box">'+
                        '<div class="doctor_details_comment_content doctor_details_desc clearfix doctor_details_sick">'+
                        '<div class="clearfix doctor_details_comment_sick_wrap">'+
                        '</div>'+
                        '</div>'+
                        '</div>'+
                        '</div>'
                        );


                          for(var i=0;i<s.result.cases.length;i++){
                                var obj=$('<div class="fl doctor_details_comment_sick">'+s.result.cases[i].name+'</div>');
                                obj.appendTo($('.doctor_details_comment_sick_wrap'));
                          }
                        }








                        }
                }

        });


        /*************************** end 获取医生基本信息 ***************************/






    /*************************** start 医生评论列表 ***************************/

        var name='<%=doctorInfo.getName()%>';
        var pageIndex = 0;
        var canSet=true;

        //获取更多评论
        function getMoreComment(){
        $('#commentName').html(name+'医生的患者评论');
        $.ajax({
                url:'/wxapi/public/doctor/comment',
                type: 'get',
                dataType: 'json',
                data: {'doctor_id': doctorId, 'page_num': pageIndex, 'page_size': 10},
                success: function (s) {
                        if(s.code===2000){


                                $('#commentTotal').html('评论('+s.result.total_records+')');

                                        for(var k=0;k<s.result.content.length;k++){
                                        var phone=s.result.content[k].phone;
                                        var time=s.result.content[k].time;
                                        var content=s.result.content[k].comment;

                                        var startNumber=parseInt(s.result.content[k].stars);
                                        var string=$(
                                        '<div class="doctor_details_comment_box border_bottom">'+
                                        '<div class="doctor_details_comment_base_information">'+
                                        '<div class="doctor_details_comment_base_information_star">'+
                                        '<span></span><span></span><span></span><span></span><span></span>'+
                                        '</div>'+
                                        '<div class="doctor_details_comment_base_information_phone">'+phone+'</div>'+
                                        '<div class="doctor_details_comment_base_information_time">'+time+'</div>'+
                                        '</div>'+
                                        '<div class="doctor_details_comment_content">'+content+'</div>'+
                                        '</div>'
                                        );

                                        string.appendTo($('#moreComment'));
                                        for(var i=0;i<startNumber;i++){
                                        string.find('span').eq(i).addClass('start_on');
                                        }
                                        }

                                getScrollComment();

                                        pageIndex=pageIndex+1;

                                if(s.result.has_next===false){

                                        if($('#noData').length<=0){

                                                        var noData=$('<div id="noData" style="height: 40px;line-height: 40px;text-align: center;color: #999;font-size: 14px;">没有更多评论了</div>')
                                        noData.appendTo($('#moreComment'));
        }
                                }


                        }else{
                                canSet=true;
                        }
                },error:function(){
                        canSet=true;
                }
                 });
        }

                function getScrollComment(){
                        $(window).off().on('scroll', function () {
                                if($('.comment_box_wrap').css('display') ==='block'){
                                var scrollTop = $(this).scrollTop();
                                var scrollHeight = $(document).height();
                                var windowHeight = $(window).height();

                                if (scrollTop + windowHeight == scrollHeight) {
                                getMoreComment();
                                }
                }
        });


        }







        //获取第一条评论
        $.ajax({
           url: '/wxapi/public/doctor/comment',
           type: 'get',
           dataType: 'json',
           data: {'doctor_id': doctorId, 'page_num': 0, 'page_size': 1},
           async: false,
           success: function (s) {
             if (s.code === 2000) {
                if(s.result.content.length===0){
                    return false;
                }


                $('#firstComment').html(
                        '<div class="doctor_details_comment">'+
                '<div class="doctor_details_comment_title">评价('+s.result.total_records+')</div>'+
                '<div class="doctor_details_comment_box">'+
                '<div class="doctor_details_comment_base_information">'+
                '<div class="doctor_details_comment_base_information_star">'+
                '<span></span><span></span><span></span><span></span><span></span>'+
                '</div>'+
                '<div class="doctor_details_comment_base_information_phone">'+s.result.content[0].phone+'</div>'+
                '<div class="doctor_details_comment_base_information_time">'+s.result.content[0].time+'</div>'+
                '</div>'+
                '<div class="doctor_details_comment_content">'+s.result.content[0].comment+'</div>'+
                '</div>'+

                '<div class="doctor_details_comment_more" id="getMoreComment">更多评价</div>'+
                '</div>');


                var startNumber=parseInt(s.result.content[0].stars);

                if(startNumber>0){
                        for(var i=0;i<startNumber;i++){
                                $('.doctor_details_comment_base_information_star span').eq(i).addClass('start_on');
                        }
                }


                //点击展开评论
                $('#getMoreComment').off().on('click',function(){
                        $('.comment_box_wrap').show();
                        $('#moreComment').html('');
                         $('.wrap').hide();
                        getMoreComment();
                });


                //点击关闭评论
                $('#commentBack').off().on('click',function(){
                        $('.comment_box_wrap').hide();
                         $('.wrap').show();
                         pageIndex=0;
                });

             }
          }
        });




    <%--var pageIndex = 1;--%>
    <%--var loadEnd = false;--%>

    <%--function asynPageCommentList() {--%>
        <%--var data = {"pageIndex":pageIndex, "doctorId":doctorId};--%>
        <%--sendRequest("asynPageCommentList.htm", "GET", data, function(resultPage) {--%>
            <%--if(pageIndex == 1) {--%>
                <%--$("#commentCount").html(resultPage.totalCount);--%>
            <%--}--%>
            <%--var str = new StringBuilder();--%>
            <%--for(var i = 0, len = resultPage.result.length; i < len; i++) {--%>
                <%--var comment = resultPage.result[i];--%>
                <%--str.append('<li><p class="clearfix"><span class="fl start star' + getCommentStar(comment.stars) + '"></span>');--%>
                <%--str.append('<span class="fr user_msg"><i class="phone">' + comment.phoneNumber + '</i><i>' + comment.orderTime + '</i></span></p>');--%>
                <%--str.append('<p class="commet_content">' + comment.comment + '</p></li>');--%>
            <%--}--%>
            <%--$("#commentList").append(str.toString());--%>
            <%--if(pageIndex >= resultPage.totalPage) {--%>
                <%--loadEnd = true;--%>
            <%--} else {--%>
                <%--pageIndex++;--%>
            <%--}--%>
        <%--});--%>
    <%--}--%>
    <%--asynPageCommentList();--%>

    <%--function getCommentStar(stars) {--%>
        <%--stars = stars+"";--%>
        <%--var index = stars.indexOf(".5");--%>
        <%--if(index > -1) {--%>
            <%--stars = stars.substring(0,1) + "f";--%>
        <%--}--%>
        <%--return stars;--%>
    <%--}--%>

    //滚动到底部自动加载评论列表
    <%--var totalheight;--%>
    <%--$(window).scroll(function () {--%>
        <%--if(currentLi == "commentLi" && !loadEnd) {--%>
            <%--totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());--%>
            <%--if($(document).height() <= totalheight) {--%>
                <%--asynPageCommentList();--%>
            <%--}--%>
        <%--}--%>
    <%--});--%>


    /*************************** end 医生评论列表 ***************************/
</script>
</html>
