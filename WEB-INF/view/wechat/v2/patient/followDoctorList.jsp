<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<JdDoctorQueryModel> doctorList = (List<JdDoctorQueryModel>) request.getAttribute("doctorList");
%>
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
        <h2>我关注的医生</h2>
        <div class="header_logo pa">
            <a class="pa header_search attention_search" id="search_btn"></a>
        </div>
    </header>
    <!--header-->

    <!--content-->
    <div class="content screen_content">
        <section class="timesort tab_show">
            <div class="atten">
                <div class="no-atten"></div>
                <div class="atten-font">你暂无关注医生~</div>
            </div>
        </section>
    </div>
    <!--content-->

    <!--搜索-->
    <div class="search_touch">
        <div class="search_wrap pr">
            <div class="search_input pr">
                <input type="text" id="searchText" placeholder="医院 / 医生 / 疾病"><a class="search_btn pa" onclick="queryByKeyword()"></a>
            </div>
        </div>
    </div>
    <!--搜索-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.FollowDoctor);

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
        var search = $("#searchText").val().trim();
        updateDoctorList(search)
    }
    function updateDoctorList(search) {
        var len = doctorList.length;
        if (len > 0) {
            var str = new StringBuilder();
            for (var i = 0; i < len; i++) {
                var doctor = doctorList[i];
                if (doctor.name.indexOf(search) > -1 || doctor.hospital.indexOf(search) > -1
                        || doctor.title.indexOf(search) > -1 || doctor.doctorSkills.indexOf(search) > -1) {
                    str.append('<dl class="sort_list"><a onclick="toDoctor(\'' + doctor.uuid + '\')">');
                    str.append('<dt><span class="sort_header" style="background:url(' + doctor.headPic + ') center center no-repeat;background-size:cover;"></span><span class="like_num">人气:' + doctor.popularity + '</span></dt>');
                    str.append('<dd class="base_msg"><div class="clearfix sort_basemsg"><span class="doctor_name">' + doctor.name + '</span><span class="doctor_line">丨</span><span class="doctor_job">' + doctor.title + '</span>');
                    if (doctor.available.indexOf("约满") > -1) {
                        str.append('<label class="fr pr"><span class="like_appoint2">申请加号</span></label></div>');
                    } else {
                        str.append('<label class="fr pr"><span class="like_appoint">' + doctor.available + '</span></label></div>');
                    }
                    str.append('<div class="sort_hosname">' + doctor.hospital + '</div><div class="sort_hosname ">擅长：' + doctor.doctorSkills + '</div>');
                    str.append('</dd></a></dl>');
                }
            }
            $(".timesort").html(str.toString());
        }
    }
    var doctorList = <%=new Gson().toJson(doctorList)%>;
    updateDoctorList("");

    //跳转医生预约页面
    function toDoctor(ID) {
        goto('doctor.htm?jd_doctor_id=' + ID);
    }
</script>
</html>
