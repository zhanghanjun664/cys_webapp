<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<JdDoctorQueryModel> doctorList = (List<JdDoctorQueryModel>) request.getAttribute("doctorList");
    List<JdDoctorQueryModel> timeOrderList = (List<JdDoctorQueryModel>) request.getAttribute("timeOrderList");
    String dayDiff = (String)request.getAttribute("dayDiff");
    String hospitalId = (String)request.getAttribute("hospitalId");
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
        <h2><%=request.getAttribute("title")%></h2>
        <div class="header_logo pa">
            <a onclick="toPersonal()" class="mine_center pa"></a>
            <a href="javascript:void(0)" class="pa header_search" id="search_btn"></a>
        </div>
    </header>
    <!--header-->

    <!--navtop-->
    <div class="navtop">
        <ul class="clearfix tab_nav">
            <li class="fl pr tabshow_active tab_time"><span>时间排序</span><b></b></li>
            <li class="fl pr tab_popular"><span>人气</span><b></b></li>
            <li class="fl pr"><span>筛选</span><b></b></li>
        </ul>
    </div>
    <!--navtop-->

    <!--content-->
    <div class="content screen_content">
        <!--时间排序-->
        <section id="timeDoctorList" class="timesort tab_content tab_show"></section>
        <!--人气-->
        <section id="popularDoctorList" class="timesort tab_content"></section>
        <!--筛选-->
        <section class="condition_wrap tab_content">
            <%
                if(dayDiff == null) {
            %>
                <div class="condition">
                    <h4>时间</h4>
                </div>
                <div class="condition_data">
                    <ul class="clearfix" id="condition_data">
                        <%
                            List<String> times = WechatUtils.getTimeInWeek();
                            for(int i = 0, size = times.size(); i < size; i++) {
                                if(i == 6) break;
                                String[] time = times.get(i).split(";");
                        %>
                            <li class="fl" time_id="<%=i%>"><span><%=time[0]%></span><%=time[1]%></li>
                        <%
                            }
                        %>
                    </ul>
                </div>
            <%
                }
            %>
            <div class="condition doctorList_content">
                <h4>病情类型</h4>
            </div>
            <div class="condition_illness doctorList_content">
                <ul class="clearfix" id="condition_illness"></ul>
                <div class="clickmore" id="clickmore"><i></i></div>
            </div>
            <%
                if(hospitalId == null) {
            %>
                <div class="condition">
                    <h4>医院</h4>
                </div>
                <ul class="list condition_hossel" id="condition_hossel"></ul>
            <%
                }
            %>
            <div class="fixbtn" onclick="screen()">确定</div>
        </section>
        <!--筛选-->
    </div>
    <!--content-->
</div>
<!--wrap-->

<!--搜索-->
<div class="search_touch">
    <div class="search_wrap pr">
        <div class="search_input pr">
            <input type="text" placeholder="医院 / 医生 / 疾病 /擅长" id="search"><a class="search_btn pa" onclick="queryByKeyword()"></a>
        </div>
    </div>
</div>
<!--搜索-->
</body>
<script>
    sendPageVisit(Page_Constant.DoctorList);

    //后台返回医生列表
    var doctorList = <%=doctorList.size() == 0 ? "[]" : new Gson().toJson(doctorList)%>;
    var timeDoctorList = <%=timeOrderList.size() == 0 ? "[]" : new Gson().toJson(timeOrderList)%>;
    //初始化疾病、医生
    var hospitals = [];
    var doctorskills = [];
    doctorList.forEach(function(doctor) {
        if(!strInArray(hospitals, doctor.hospital)) {
            hospitals.push(doctor.hospital);
            $("#condition_hossel").append('<li class="pr" name="' + doctor.hospital + '">' + doctor.hospital + '<i class="pa"><span class="pa"></span></i></li>');
        }
        <%--console.log(doctor);--%>
        var skills = doctor.doctorCategorys.split(",");
        skills.forEach(function(skill){
            if(!strInArray(doctorskills, skill)){
                doctorskills.push(skill);
                if(skill!==null && skill!==""){
                    $("#condition_illness").append('<li class="fl" name="' + skill + '">' + skill + '</li>');
                 }
            }
        });

        if($('#condition_illness li').length===0){
            $('.doctorList_content').hide();
        }else{
            $('.doctorList_content').show();
        }

    });

    /*===================================tab切换===================================*/
    var currentTab = "tab_time"; //当前打开的Tab
    var firstClick = true; //病情类型高度只有第一次点击才处理
    $('.tab_nav').on('click', 'li', function (ev) {
        if($(this).hasClass("tab_time")) {
            currentTab = "tab_time";
        } else if($(this).hasClass("tab_popular")) {
            currentTab = "tab_popular";
        }
        $('.tab_nav li').removeClass('tabshow_active');
        $('.tab_nav li').eq($(this).index()).addClass('tabshow_active');
        $('.tab_content').removeClass('tab_show');
        $('.tab_content').eq($(this).index()).addClass('tab_show');
        //病情类型高度处理
        if (firstClick && $('#condition_illness').length>0 && $(this).index()==2) {
            firstClick = false;
            //如果小于两列
            if($('#condition_illness').height()<=107){
                $('#clickmore').css({'display':'none'});
            }else{
                $('#condition_illness').css({'height':'2rem'});
            }
        }
    });
    /*===================================筛选===================================*/
    var timeArray = new Array(); //选中的时间点数组
    var diseasesArray = new Array(); //选中的病情类型数组
    var hospitalArray = new Array(); //选中的医院数组
    var keywords; //输入的查询关键字
    $('#condition_data').on('click', 'li', function (ev) {
        var id = $(this).attr("time_id");
        if ($(this).hasClass('conddata_active')) {
            $(this).removeClass('conddata_active');
            var indx = arraySearch(timeArray, id);
            timeArray.splice(indx, 1);
        } else {
            $(this).addClass('conddata_active');
            timeArray.push(id);
        }
    });

    $('#condition_illness').on('click', 'li', function (ev) {
        var name = $(this).attr("name");
        if ($(this).hasClass('conddata_active')) {
            $(this).removeClass('conddata_active');
            var indx = arraySearch(diseasesArray, name);
            diseasesArray.splice(indx, 1);
        } else {
            $(this).addClass('conddata_active');
            diseasesArray.push(name);
        }
    });

    var addbol = true;
    $('#clickmore').on('click', function (ev) {
        if (addbol) {
            $('#clickmore').addClass('moreactive');
            $('#condition_illness').css({'height': 'auto'});
            addbol = false;
        } else {
            $('#clickmore').removeClass('moreactive');
            $('#condition_illness').css({'height': '2rem'});
            addbol = true;
        }
    });

    $('#condition_hossel').on('click', 'li', function (ev) {
        var name = $(this).attr("name");
        if ($(this).hasClass('hossel_active')) {
            $(this).removeClass('hossel_active');
            var indx = arraySearch(hospitalArray, name);
            hospitalArray.splice(indx, 1);
        } else {
            $(this).addClass('hossel_active');
            hospitalArray.push(name);
        }
    });

    /*===================================搜索===================================*/
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
    //回车触发关键字搜索
    document.onkeydown = function (ev) {
        if (ev.keyCode == 13) {
            ev.preventDefault();
            queryByKeyword();
        }
    };
    function queryByKeyword() {
        $('.search_touch').css({'display': 'none'});
        keywords = $('#search').val().trim();
        screen();
    }
    //确定筛选条件
    var doctorLen = doctorList.length;
    function screen() {
        window.scrollTo(0,0);
        if(doctorLen > 0) {
            $("#timeDoctorList").html(generateDoctorList(timeDoctorList));
            $("#popularDoctorList").html(generateDoctorList(doctorList));
        }
        $("."+currentTab).click();
    }
    //生成医生列表HTML
    function generateDoctorList(paramDoctorList) {
        var timeStrArray = new Array();
        if(timeArray.length > 0) {
            for(var i = 0, len = timeArray.length; i < len; i++) {
                var timeStr;
                switch (parseInt(timeArray[i])) {
                    case 0:
                        timeStr = "今天可约";
                        break;
                    case 1:
                        timeStr = "明天可约";
                        break;
                    case 2:
                        timeStr = "后天可约";
                        break;
                    case 3:
                        timeStr = "3天后可约";
                        break;
                    case 4:
                        timeStr = "4天后可约";
                        break;
                    case 5:
                        timeStr = "5天后可约";
                        break;
                }
                timeStrArray.push(timeStr);
            }
        }
        var str = new StringBuilder();
        outer:
        for(var i = 0; i < doctorLen; i++) {
            var doctor = paramDoctorList[i];
            //搜索关键字
            if(keywords) {

                if(!(doctor.name.indexOf(keywords) > -1) && !(doctor.hospital.indexOf(keywords) > -1)
                        && !(doctor.title.indexOf(keywords) > -1) && !(doctor.doctorCategorys.indexOf(keywords) > -1) && !(doctor.expertise.indexOf(keywords) > -1)) {
                    continue outer;
                }
            }
            //时间
            if(timeArray.length > 0) {
                if(!strInArray(timeStrArray, doctor.available)) {
                    continue outer;
                }
            }
            //疾病
            if(diseasesArray.length > 0) {
                var skills = doctor.doctorCategorys.split(",");
                for(var j = 0, len = skills.length; j < len; j++) {
                    if(strInArray(diseasesArray, skills[j])) {
                        break;
                    }
                    if(j == len - 1) {
                        continue outer;
                    }
                }
            }
            //医院
            if(hospitalArray.length > 0) {
                if(!strInArray(hospitalArray, doctor.hospital)) {
                    continue outer;
                }
            }

            var beGoodAt=doctor.expertise;

            if(typeof beGoodAt === 'undefined'){
                beGoodAt='';
            }else{

                if(beGoodAt.length > 40){
                    beGoodAt=beGoodAt.substr(0,38)+'...'
                }
            }


            var expertise=doctor.expertise;
            if(typeof expertise==='undefined'){
                expertise='';
            }

            str.append('<dl class="sort_list"><a onclick="toDoctor(\''+doctor.uuid+'\')">');
            str.append('<dt><span class="sort_header" style="background:url(' + doctor.headPic + ') center center no-repeat;background-size:cover;"></span><span class="like_num">人气:' + doctor.popularity + '</span></dt>');
            str.append('<dd class="base_msg"><div class="clearfix sort_basemsg"><span class="doctor_name">' + doctor.name + '</span><span class="doctor_line">丨</span><span class="doctor_job">' + doctor.title + '</span>');
            if (doctor.available.indexOf("约满") > -1) {
                str.append('<label class="fr pr"><span class="like_appoint2">申请放号</span></label></div>');
            } else {
                str.append('<label class="fr pr"><span class="like_appoint">' + doctor.available + '</span></label></div>');
            }
            str.append('<div class="sort_hosname">' + doctor.hospital + '</div><div class="sort_hosname ">' + beGoodAt + '</div>');
            str.append('</dd></a></dl>');
        }
        return str.toString();
    }
    screen();

    function showDoctorSkills(doctorSkill) {
        var sb = new StringBuilder();
        var skills = doctorSkill.split(",");
        for(var j = 0, len = skills.length; j < len; j++) {
            if (j == 0)
                sb.append(skills[j]);
            else
                sb.append("," + skills[j]);
            //最多显示8个，超出...表示
            if(j == 7) {
                sb.append("...");
                break;
            }
        }
        return sb.toString();
    }

    //跳转医生预约页面
    function toDoctor(ID) {
        <%--goto('doctor.htm?jd_doctor_id='+ID);--%>
        window.location.href='/wechat_web/wap_wechat_patient/html/doctorHomePage.html?doctor_id='+ID;
    }
</script>
</html>
