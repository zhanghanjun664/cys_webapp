<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdHospitalQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdSickCategaryQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdSickQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.wechat.DistrictModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.List" %>

<%
    Boolean recordLogin = (Boolean) request.getAttribute("recordLogin");
    List<DistrictModel> districtList = (List<DistrictModel>)request.getAttribute("districtList");
    List<JdHospitalQueryModel> hospitalList = (List<JdHospitalQueryModel>)request.getAttribute("hospitalList");
    List<JdSickCategaryQueryModel> sickCategaryList = (List<JdSickCategaryQueryModel>)request.getAttribute("sickCategaryList");
    List<JdSickQueryModel> sickList = (List<JdSickQueryModel>)request.getAttribute("sickList");
    String cityName = null;
    String g_districtId = null;
    for(DistrictModel districtModel : districtList) {
        if(districtModel.isSelected()) {
            g_districtId = districtModel.getId();
            cityName = districtModel.getName();
            break;
        }
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
    <!--header-->
    <header class="search">
        <form class="search_form">

        <div class="search_left" id="selectarea">
            <span><%=cityName%>地区</span><i></i>
        </div>

        <div class="search_center pr">
            <span class="pa" onclick="queryByKeyword()"></span>
            <input type="text" id="search" placeholder="医院 / 医生 / 疾病">
        </div>
        <div class="search_right pr">
            <a onclick="toPersonal()" class="pa"></a>
        </div>

        </form>
    </header>
    <!--header-->
    <!--content-->
    <div class="content index_content">
        <!--医院-->
        <section class="tab_c hos tabactive">
            <!--index_banner-->
            <div class="index_banner" id="index_banner">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <!-- Required swiper-lazy class and image source specified in data-src attribute -->
                            <img data-src="../../wechat/images/v2/advertisement_friends.jpg" class="swiper-lazy" onclick="goto('toNowInvite.htm')">
                            <!-- Preloader image -->
                            <div class="swiper-lazy-preloader swiper-lazy-preloader-white"></div>
                        </div>
                        <div class="swiper-slide">
                            <img data-src="../../wechat/images/v2/advertisement_product.jpg" class="swiper-lazy" onclick="goto('doctor.htm?jd_doctor_id=a262bb86-14e0-4922-8b9a-95bf721a5c52')">
                            <div class="swiper-lazy-preloader swiper-lazy-preloader-white"></div>
                        </div>


                    </div>
                    <div class="swiper-pagination"></div>
                </div>
            </div>
            <!--index_banner-->
            <div id="hospitalList"></div>
        </section>
        <!--医院-->
        <!--疾病-->
        <section class="tab_c pr">
            <div class="disease">
                <section class="area_left fl">
                    <div class="area_scroll" id="des_left">
                        <div class="scroll_wrap pr">
                            <ul id="des_sel">
                                <%
                                    for(int i = 0, size = sickCategaryList.size(); i < size; i++) {
                                        JdSickCategaryQueryModel sickCategary = sickCategaryList.get(i);
                                        if(i == 0) {
                                %>
                                        <li class="area_active"><i></i><%=sickCategary.getName()%></li>
                                <%
                                        } else {
                                %>
                                        <li><i></i><%=sickCategary.getName()%></li>
                                <%
                                        }
                                    }
                                %>
                            </ul>
                        </div>
                    </div>
                </section>
                <%
                    for(int i = 0, size = sickCategaryList.size(); i < size; i++) {
                        JdSickCategaryQueryModel sickCategary = sickCategaryList.get(i);
                %>
                    <section class="area_right des_right fr pr area_show" style="width: 60%;">
                        <div class="area_scroll">
                            <div class="scroll_wrap pr">
                                <ul class="right_list">
                                    <li>
                                        <a onclick="queryBySick('<%=sickCategary.getUuid()%>', '<%=sickCategary.getName()%>')">全部</a>
                                    </li>
                                    <%
                                        for(JdSickQueryModel sickModel : sickList) {
                                            if(sickModel.getJdSickCategaryId().toString().equals(sickCategary.getUuid().toString())) {
                                    %>
                                        <li>
                                            <a onclick="queryBySick('<%=sickModel.getUuid()%>', '<%=sickModel.getName()%>')"><%=sickModel.getName()%></a>
                                        </li>
                                    <%
                                            }
                                        }
                                    %>
                                </ul>
                            </div>
                        </div>
                    </section>
                <%
                    }
                %>
            </div>
        </section>
        <!--疾病-->
        <!--时间-->
        <section class="tab_c time">
            <div class="timebox pr">
                <span class="boxline1 pa"></span>
                <span class="boxline2 pa"></span>
                <%
                    List<String> times = WechatUtils.getTimeInWeek();
                    for(int i = 0; i < 3; i++) {
                        String[] time = times.get(i).split(";");
                %>
                    <div class="time_box_left fl">
                        <a onclick="queryByTime('<%=i%>', '<%=time[2]+"("+time[0]+")"%>')">
                            <p class="time_title"><%=time[2]%></p>
                            <p class="time_data"><%=time[0]%><i></i><%=time[1]%></p>
                        </a>
                    </div>
                <%
                    }
                %>
            </div>
            <ul class="list time_list">
                <%
                    for(int i = 3, size = times.size(); i < size; i++) {
                        String[] time = times.get(i).split(";");
                %>
                <li><a onclick="queryByTime('<%=i%>', '<%=time[0]+"("+time[1]+")"%>')"><span><%=time[0]%></span><%=time[1]%></a></li>
                <%
                    }
                %>
            </ul>
        </section>
        <!--时间-->
        <!--关注-->
        <section class="timesort tab_c">
            <div class="atten">
                <div class="no-atten"></div>
                <div class="atten-font">你暂无关注医生~</div>
            </div>
        </section>
        <!--关注-->
    </div>
    <!--content-->
    <!--footer-->
    <footer class="tab" id="footer">
        <ul class="clearfix">
            <li class="fl footer_active">
                <p class="tab_lg1"></p>
                <p class="tab_font">医院</p>
            </li>
            <li class="fl">
                <p class="tab_lg2"></p>
                <p class="tab_font">疾病</p>
            </li>
            <li class="fl">
                <p class="tab_lg3"></p>
                <p class="tab_font">时间</p>
            </li>
            <li class="fl">
                <p class="tab_lg4"></p>
                <p class="tab_font">关注</p>
            </li>
        </ul>
    </footer>


    <!--footer-->
    <!--地区选择-->
    <div class="selectarea" id="selectarea_wrap">
        <section class="area_left fl">
            <ul id="area_wsel">
                <%
                    for(DistrictModel districtModel : districtList) {
                        if(districtModel.isSelected()) {
                %>
                        <li class="area_active"><i></i><%=districtModel.getName()%></li>
                <%
                        } else {
                %>
                        <li><i></i><%=districtModel.getName()%></li>
                <%
                        }
                    }
                %>
            </ul>
        </section>
        <section class="area_right fr pr" id="show_areasel">
            <div class="scroll_wrap pr">
                <%
                    for(DistrictModel districtModel : districtList) {
                        if(districtModel.isSelected()) {
                %>
                        <ul class="show_list_area" style="display:block;">
                            <li attr="<%=districtModel.getName()%>地区" onclick="asynUpdateHospitals('<%=districtModel.getId()%>')">全部</li>
                            <%
                                for(DistrictModel childDistrict : districtModel.getChildDistricts()) {
                            %>
                            <li attr="<%=districtModel.getName()%><%=childDistrict.getName().substring(0, childDistrict.getName().length() - 1)%>"
                                onclick="asynUpdateHospitals('<%=districtModel.getId()%>', '<%=childDistrict.getId()%>')"><%=childDistrict.getName()%>
                            </li>
                            <%
                                }
                            %>
                        </ul>
                <%
                    } else {
                %>
                        <ul class="show_list_area" style="display:none;">
                            <li attr="<%=districtModel.getName()%>地区" onclick="asynUpdateHospitals('<%=districtModel.getId()%>')">全部</li>
                            <%
                                for(DistrictModel childDistrict : districtModel.getChildDistricts()) {
                            %>
                            <li attr="<%=districtModel.getName()%><%=childDistrict.getName().substring(0, childDistrict.getName().length() - 1)%>"
                                onclick="asynUpdateHospitals('<%=districtModel.getId()%>', '<%=childDistrict.getId()%>')"><%=childDistrict.getName()%>
                            </li>
                            <%
                                }
                            %>
                        </ul>
                <%
                        }
                    }
                %>
            </div>
        </section>
    </div>
    <!--地区选择-->
</div>
<!--wrap-->
</body>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=GOQ6CwFr0c5r84oMGHnCUgTBSyExRUsa"></script>
<script src="../../wechat/js/weixin.js" type="text/javascript"></script>
<script>
    function getWechatLocation(){
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
                    wx.config({
                        debug: false,
                        appId:s.result.appId,
                        timestamp:s.result.timestamp,
                        nonceStr:s.result.nonceStr,
                        signature:s.result.signature,
                        jsApiList: ['checkJsApi','getLocation']
                    });
                    wx.ready(function(){
                        wx.checkJsApi({
                            jsApiList: [
                                'getLocation'
                            ],
                            success: function (res) {
                                if (res.checkResult.getLocation == false) {
                                    alert('你的微信版本太低，不支持微信JS接口，请升级到最新的微信版本！');
                                    return;
                                }else{
                                    wx.getLocation({
                                        success: function (res) {
                                            var latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
                                            var longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
                                            alert(longitude+" wx "+latitude);
                                            var ggPoint = new BMap.Point(longitude, latitude);
                                            var pointArr = [];
                                            pointArr.push(ggPoint);
                                            var translateCallback = function (data) {
                                                console.log(data);
                                                if (data.status === 0) {
                                                    var marker = new BMap.Marker(data.points[0]);
                                                    var baiduPoint = "百度 lat:" + marker.point.lat + " lng:" + marker.point.lng;
                                                    alert(baiduPoint);
                                                } else {
                                                    alert("啥也找不到");
                                                }
                                            };
                                            var convertor = new BMap.Convertor();
                                            convertor.translate(pointArr, 1, 5, translateCallback)

//                                            var speed = res.speed; // 速度，以米/每秒计
//                                            var accuracy = res.accuracy; // 位置精度
//                                            var tude = "lat:"+latitude+" long:"+longitude;
//                                            alert(tude);
//                                            var ggPoint = new BMap.Point(longitude,latitude);
//                                            var pointArr = [];
//                                            pointArr.push(ggPoint);
//                                            translateCallback = function (data){
//                                                if(data.status === 0) {
//                                                    var marker = new BMap.Marker(data.points[0]);
//                                                    var baiduPoint = "百度 lat:"+marker.point.lat+" lng:"+marker.point.lng;
//                                                    alert(baiduPoint);
//
//                                                }
//                                            }
//                                            var convertor = new BMap.Convertor();
//                                            convertor.translate(pointArr, 1, 5, translateCallback)
                                        },
                                        cancel: function (res) {
                                            alert('用户拒绝授权获取地理位置');
                                        }
                                    });
                                }
                            }
                        });
                    });
                }else{
                    console.log('get share config fail');
                }
            }
        });
    }
    getWechatLocation();

    var g_districtId = '<%=g_districtId%>';
    var g_areaId = null;
    //回车触发关键字搜索
    document.onkeydown = function (event) {
        if (event.keyCode == 13) {
            event.preventDefault();
            queryByKeyword();
        }
    };

    //生成医院列表HTML  onclick="goto('toNowInvite.htm')"   onclick="goto('doctor.htm?jd_doctor_id=a262bb86-14e0-4922-8b9a-95bf721a5c52')"
    function generateHospitalList(hospitalList) {
        var str = new StringBuilder();
        for(var i = 0, len = hospitalList.length; i < len; i++) {
            var hospital = hospitalList[i];
            str.append('<div class="pr hos_a" onclick="queryByHospital(\'' + hospital.uuid + '\',\'' + hospital.name + '\')">');
            str.append('<div class="hos_pic" style="background:url(' + hospital.logoUrl + ') center center no-repeat;background-size:cover;"></div>');
            str.append('<div class="hos_mes"><div class="hos_name">' + hospital.name + '</div>');
            str.append('<div class="hos_address">' + displayNullValue(hospital.address) + '</div></div>');
            str.append('<span class="pa"></span></div>');
        }
        $("#hospitalList").html(str.toString());
    }
    var hospitalList = <%=new Gson().toJson(hospitalList)%>;
    generateHospitalList(hospitalList);

    //异步更新医院列表
    function asynUpdateHospitals(districtId, areaId) {
        g_districtId = districtId;
        g_areaId = areaId;
        var url = "asynUpdateHospitals.htm?districtId=" + districtId;
        if(areaId)
            url += "&areaId=" + areaId;
        sendRequest(url, "GET", function(result) {
            generateHospitalList(result);
        });
    }

    /*===================================滚动条事件定义===================================*/
    /*是否允许滑动屏幕*/
    var myScroll2;
    var myScroll3;
    /*===================================预约主页===================================*/
    var asynDoctorFlag = false;
    var recordLogin = <%=recordLogin%>;
    if(recordLogin) {
        sendPageVisit(Page_Constant.Home_Hospital, true);
    } else {
        sendPageVisit(Page_Constant.Home_Hospital);
    }
    $('#footer').on('click','li',function(){
        $('.tab_c').removeClass('tabactive');
        $('.tab_c').eq($(this).index()).addClass('tabactive');
        $('#footer li').removeClass('footer_active');
        $('#footer li').eq($(this).index()).addClass('footer_active');
        var index = $(this).index();
        if(index == 0) {
            sendPageVisit(Page_Constant.Home_Hospital);
        } else if (index == 1) {
            sendPageVisit(Page_Constant.Home_Disease);
            myScroll2=new IScroll('#des_left', {click: true,bounce:false});
        } else if (index == 2) {
            sendPageVisit(Page_Constant.Home_Time);
        } else if (index == 3) {
            sendPageVisit(Page_Constant.Home_Focus);
            if(!asynDoctorFlag) {
                asynDoctorFlag = true;
                //异步获取关注的医生列表
                sendRequest("asynGetFollowDoctors.htm", "GET", function(result) {
                    var len = result.length;
                    if(len > 0) {
                        var str = new StringBuilder();
                        for(var i = 0; i < len; i++) {
                            var doctor = result[i];
                            str.append('<dl class="sort_list"><a onclick="toDoctor(\''+doctor.uuid+'\')">');
                            str.append('<dt><span class="sort_header" style="background:url('+doctor.headPic+') center center no-repeat;background-size:cover;"></span><span class="like_num">人气:'+doctor.popularity+'</span></dt>');
                            str.append('<dd class="base_msg"><div class="clearfix sort_basemsg"><span class="doctor_name">'+doctor.name+'</span><span class="doctor_line">丨</span><span class="doctor_job">'+doctor.title+'</span>');
                            if(doctor.available.indexOf("约满") > -1) {
                                str.append('<label class="fr pr"><span class="like_appoint2">申请加号</span></label></div>');
                            } else {
                                str.append('<label class="fr pr"><span class="like_appoint">'+doctor.available+'</span></label></div>');
                            }
                            str.append('<div class="sort_hosname">'+doctor.hospital+'</div><div class="sort_hosname ">擅长：'+doctor.doctorSkills+'</div>');
                            str.append('</dd></a></dl>');
                        }
                        $(".timesort").html(str.toString());
                    }
                });
            }
        }
    });

    /*===================================地区选择===================================*/
    $('#selectarea').on('click',function(ev){
        $('#selectarea_wrap').css({'display':'block'});
        myScroll3 = new IScroll('#show_areasel', {click: true,bounce:false});
        ev.preventDefault();
        ev.stopPropagation();
    });

    $('#area_wsel').on('click','li',function(ev){
        $('#area_wsel  li').removeClass('area_active');
        $('#area_wsel  li').eq($(this).index()).addClass('area_active');
        myScroll3.scrollTo(0, 0, 0);
        $('.show_list_area').css({'display':'none'});
        $('.show_list_area').eq($(this).index()).css({'display':'block'});
        ev.preventDefault();
        ev.stopPropagation();
    });

    $('.show_list_area').on('click','li',function(ev){
        $('#selectarea span').html($(this).attr('attr'));
        $('#selectarea_wrap').css({'display':'none'});
        ev.preventDefault();
        ev.stopPropagation();
    });

    $('#selectarea_wrap').on('click',function(ev){
        $('#selectarea_wrap').css({'display':'none'});
        ev.preventDefault();
        ev.stopPropagation();
    });

    /*===================================疾病选择===================================*/
    function attrid(){
        for (var i = 0; i < $('.des_right').length; i++) {
            var id="des_right"+i;
            $('.des_right').eq(i).find('.area_scroll').attr('id',id);
        }
    }
    attrid();

    $('#des_sel').on('click','li',function(ev){
        $('#des_sel  li').removeClass('area_active');
        $('#des_sel  li').eq($(this).index()).addClass('area_active');
        $('.des_right').css({'display':'none'});
        $('.des_right').eq($(this).index()).css({'display':'block'});
    });

    //跳转医生预约页面
    function toDoctor(ID) {
        window.location.href ='doctor.htm?jd_doctor_id='+ID;
    }

    function queryByHospital(hospitalId, title) {
        queryDoctorList(hospitalId, null, null, null, title);
    }
    function queryBySick(sickId, title) {
        title = "搜索" + title;
        queryDoctorList(null, sickId, null, null, title);
    }
    function queryByTime(dayDiff, title) {
        queryDoctorList(null, null, dayDiff, null, title);
    }
    function queryByKeyword() {
        var keywords = $.trim($('#search').val());
        if(keywords.length > 0) {
            var title = "搜索" + keywords;
            queryDoctorList(null, null, null, keywords, title);
        }
    }
    function queryDoctorList(hospitalId, sickId, dayDiff, keywords, title) {
        var url = "toDoctorList.htm?districtId=" + g_districtId + "&title=" + encodeURI(encodeURI(title));
        if(g_areaId)
            url += "&areaId=" + g_areaId;
        if(hospitalId)
            url += "&hospitalId=" + hospitalId;
        if(sickId)
            url += "&sickId=" + sickId;
        if(dayDiff)
            url += "&dayDiff=" + dayDiff;
        if(keywords)
            url += "&keywords=" + encodeURI(encodeURI(keywords));
        goto(url);
    }

    /*===================================banner滚动===================================*/
    var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        // Disable preloading of all images
        preloadImages: false,
        // Enable lazy loading
        lazyLoading: true
    });
    function maxscroll() {
        var maxscrollHeight=($('.swiper-slide').height())-44;
        if($(document).scrollTop()>maxscrollHeight) {
            $('.search').css({'background':'#f6f6f7'});
        } else {
            $('.search').css({'background':'rgba(255,255,255,.62)'});
        }
    }
    maxscroll();
    $(window).on('scroll',function(ev){
        maxscroll();
    });
</script>
</html>
