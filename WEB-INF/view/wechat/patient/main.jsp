<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.*" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="java.util.List" %>
<%
    List<JdHospitalQueryModel> hospitalQueryModelList=(List<JdHospitalQueryModel>)request.getAttribute("hospitalQueryModelList");
    List<JdSickCategaryModel> sickCategaryModelList=(List<JdSickCategaryModel>)request.getAttribute("sickCategaryModelList");
    List<JdDoctorQueryModel> doctorQueryModelList=(List<JdDoctorQueryModel>)request.getAttribute("doctorQueryModelList");
    List<JdDistrictQueryModel> districtQueryModelList=(List<JdDistrictQueryModel>)request.getAttribute("districtQueryModelList");
    String jd_District_ID=(String)request.getAttribute("jd_District_ID");
%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../include/head.jsp" />
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
            color: #FFFFFF;
            -webkit-tap-highlight-color: transparent;
        }

        img, li, div {
            -webkit-tap-highlight-color: transparent;
        }

        #mainDiv {
            width: 100%;
            display: none;
        }

        #mainDiv .cityul{width:100%;overflow:hidden;position:absolute;left:0;top:0;z-index:1000000;display:none;}
        #mainDiv .cityul li{width:33%;float:right;font-size:1.55em;color:#000000;padding:1.75em 0 1.75em 0;text-align:center;background:#FFFFFF;}

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
            width: 75%;
            height: 100%;
            font-size: 2em;
            text-align: left;
            padding-left: 25px;
            color: #FFFFFF;
        }

        #mainDiv .top_ul li:nth-child(2) {
            height: 100%;
            text-align: left;
        }

        #mainDiv .top_ul li:nth-child(2) a {
            font-size: 1.55em;
            color: #FFFFFF;
        }

        #mainDiv .top_ul li:nth-child(2) span {
            font-size: 1.55em;
            color: #FFFFFF;
            margin-left: 0.35em;
            margin-right: 0.35em;
        }

        #mainDiv .mainul1 {
            width: 100%;
            overflow: hidden;
            padding: 1.3em 0 0.8em 0;
            background: #FFFFFF;
        }

        #mainDiv .mainul1 .mainul1_li1 {
            width: 90%;
            margin-left: 5%;
            padding: 0.5em 0.3em 0.5em 0.3em;
            border-radius: 5em;
            -webkit-border-radius: 5em;
            background: url(../../wechat/images/icon16.png) center left no-repeat #F2F2F2;
            background-size: auto 43%;
            background-position: 91%;
            border: #E6E6E6 0.11em solid;
        }

        #mainDiv .mainul1 li input[type="text"] {
            width: 82%;
            font-size: 1.58em;
            color: #000000;
            background: transparent;
            border: 0;
            -webkit-border: 0;
            margin-left: 3%;
            float: left;
        }
        #mainDiv .mainul1 li div{width:11%;height:100%;background:transparent;float:left;}

        #mainDiv .mainul2 {
            width: 100%;
            overflow: hidden;
            background: #FFFFFF;
        }

        #mainDiv .mainul2 .mainul2_li1 {
            width: 100%;
            float: left;
            background: #DAE8F5;
            text-align: left;
        }

        #mainDiv .mainul2 .mainul2_li1 .mainul2_li1_div1 {
            padding-left: 0.3em;
            border-left: #2882D8 0.5em solid;
            -webkit-border-left: #2882D8 0.5em solid;
            font-size: 1.5em;
            float: left;
            font-weight: bold;
            color: #585858;
        }

        #mainDiv .mainul2 .mainul2_li1 .mainul2_li1_div2 {
            width: 15%;
            float: right;
            background: #2882D8;
            color: #FFFFFF;
            text-align: center;
            font-size: 1.5em;
        }

        #mainDiv .mainul2 .mainul2_li2 {
            width: 100%;
            padding: 1.5em 0 1.5em 0;
            float: left;
            background: #FFFFFF;
            text-align: left;
            border-bottom: #F2F2F2 0.15em solid;
            -webkit-border-bottom: #F2F2F2 0.15em solid;
        }

        #mainDiv .mainul2 .mainul2_li2 .mainul2_li2_p1 {
            width: 96%;
            margin-left: 2%;
            margin-bottom: 0.2em;
            font-size: 1.65em;
            color: #585858;
        }

        #mainDiv .mainul2 .mainul2_li2 .mainul2_li2_p2 {
            width: 96%;
            margin-left: 2%;
            font-size: 1.55em;
            color: #BDBDBD;
        }

        #mainDiv .mainul3 {
            width: 100%;
            overflow: hidden;
            background: #FFFFFF;
            padding-bottom: 1em;
        }

        #mainDiv .mainul3 .mainul3_li1 {
            width: 100%;
            float: left;
            background: #DAE8F5;
            text-align: left;
        }

        #mainDiv .mainul3 .mainul3_li1 .mainul3_li1_div1 {
            padding-left: 0.3em;
            border-left: #2882D8 0.5em solid;
            -webkit-border-left: #2882D8 0.5em solid;
            font-size: 1.5em;
            float: left;
            font-weight: bold;
            color: #585858;
        }

        #mainDiv .mainul3 .mainul3_li1 .mainul3_li1_div2 {
            width: 15%;
            float: right;
            background: #2882D8;
            color: #FFFFFF;
            text-align: center;
            font-size: 1.5em;
        }

        #mainDiv .mainul3 .mainul3_li2 {
            width: 28%;
            float: left;
            background: #FFFFFF;
            text-align: center;
            border-radius: 0.3em;
            -webkit-border-radius: 0.3em;
            border: #E6E6E6 0.12em solid;
            -webkit-border: #E6E6E6 0.12em solid;
            font-size: 1.55em;
            margin-left: 3.6%;
            margin-top: 2.5%;
        }

        #mainDiv .mainul4 {
            width: 100%;
            overflow: hidden;
            background: #FFFFFF;
        }

        #mainDiv .mainul4 .mainul4_li1 {
            width: 100%;
            float: left;
            background: #DAE8F5;
            text-align: left;
        }

        #mainDiv .mainul4 .mainul4_li1 .mainul4_li1_div1 {
            padding-left: 0.3em;
            border-left: #2882D8 0.5em solid;
            -webkit-border-left: #2882D8 0.5em solid;
            font-size: 1.5em;
            float: left;
            font-weight: bold;
            color: #585858;
        }

        #mainDiv .mainul4 .mainul4_li1 .mainul4_li1_div2 {
            width: 15%;
            float: right;
            background: #2882D8;
            color: #FFFFFF;
            text-align: center;
            font-size: 1.5em;
        }

        #mainDiv .mainul4 .mainul4_li2 {
            width: 100%;
            padding: 1.7em 0 1.7em 0;
            float: left;
            background: #FFFFFF;
            text-align: left;
            border-bottom: #F2F2F2 0.15em solid;
            -webkit-border-bottom: #F2F2F2 0.15em solid;
        }

        #mainDiv .mainul4 .mainul4_li2 .mainul4_li2_p1 {
            width: 96%;
            margin-left: 2%;
            font-size: 1.6em;
            color: #585858;
        }

        #mainDiv .mainul5 {
            width: 100%;
            overflow: hidden;
            background: #F2F2F2;
        }

        #mainDiv .mainul5 .mainul5_li1 {
            width: 100%;
            float: left;
            background: #DAE8F5;
            text-align: left;
        }

        #mainDiv .mainul5 .mainul5_li1 .mainul5_li1_div1 {
            padding-left: 0.3em;
            border-left: #2882D8 0.5em solid;
            -webkit-border-left: #2882D8 0.5em solid;
            font-size: 1.5em;
            float: left;
            font-weight: bold;
            color: #585858;
        }

        #mainDiv .mainul5 .mainul5_li1 .mainul5_li1_div2 {
            width: 15%;
            float: right;
            background: #2882D8;
            color: #FFFFFF;
            text-align: center;
            font-size: 1.5em;
        }

        #mainDiv .mainul5 .mainul5_li2 {
            width: 100%;
            padding: 1.2em 0 1.2em 0;
            float: left;
            background: #FFFFFF;
            text-align: left;
            border-bottom: #F2F2F2 0.15em solid;
            -webkit-border-bottom: #F2F2F2 0.15em solid;
        }

        #mainDiv .mainul5 .mainul5_li2 img {
            width: 22%;
            border-radius: 50%;
            -webkit-border-radius: 50%;
            float: left;
            margin-left: 3%;
        }

        #mainDiv .mainul5 .mainul5_li2 .mainul5_li2_p1 {
            width: 73%;
            margin-left: 0.2%;
            margin-bottom: 0.2em;
            margin-top: 0.8em;
            font-size: 1.65em;
            color: #585858;
            float: right;
        }

        #mainDiv .mainul5 .mainul5_li2 .mainul5_li2_p2 {
            width: 73%;
            padding-top: 2%;
            margin-left: 0.2%;
            font-size: 1.55em;
            color: #BDBDBD;
            float: right;
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
        <li>
            <a href="javascript:chooseCity();">
                <%
                    for(int i=0;i<districtQueryModelList.size();i++){
                        JdDistrictQueryModel districtQueryModel=districtQueryModelList.get(i);
                        if(districtQueryModel.getUuid().toString().equals(jd_District_ID)){
                            out.print(districtQueryModel.getName()+" v");
                        }
                    }
                %>
            </a>
        </li>
        <li><a href="toPersonal.htm">个人中心</a></li>
    </ul>
    <ul class="mainul1">
        <li class="mainul1_li1">
            <input id="keywords" type="text" placeholder="医院/医生姓名/疾病"/>
            <div onClick="search();"></div>
        </li>
    </ul>
    <ul class="mainul2">
        <li class="mainul2_li1">
            <div class="mainul2_li1_div1">按医院查找</div>
            <div class="mainul2_li1_div2" onClick="morejump2();">更多</div>
        </li>
        <%
            for(int i=0;i<hospitalQueryModelList.size();i++){
                JdHospitalQueryModel jdHospitalQueryModel=hospitalQueryModelList.get(i);
        %>
        <li class="mainul2_li2" onClick="jump2('<%=jdHospitalQueryModel.getUuid()%>','<%=jdHospitalQueryModel.getName()%>');">
            <p class="mainul2_li2_p1"><%=jdHospitalQueryModel.getName()%></p>

            <p class="mainul2_li2_p2"><%=jdHospitalQueryModel.getAddress()%></p>
        </li>
        <%
            }
        %>
    </ul>
    <ul class="mainul3">
        <li class="mainul3_li1">
            <div class="mainul3_li1_div1">按病情查找</div>
            <div class="mainul3_li1_div2" onClick="morejump3();">更多</div>
        </li>
        <%
            for(int i=0;i<sickCategaryModelList.size();i++){
                JdSickCategaryModel sickCategaryModel=sickCategaryModelList.get(i);
        %>
        <li class="mainul3_li2" onClick="jump3('<%=sickCategaryModel.getUuid()%>','<%=sickCategaryModel.getName()%>');"><%=sickCategaryModel.getName()%></li>
        <%
            }
        %>
    </ul>
    <ul class="mainul4">
        <li class="mainul4_li1">
            <div class="mainul4_li1_div1">按时间查找</div>
            <div class="mainul4_li1_div2" onClick="morejump4();">更多</div>
        </li>
        <%
            List<String> times = WechatUtils.getBytimeList(false);
            for(int i=0; i < times.size(); i++) {
        %>
                <li class="mainul4_li2" onClick="jump4(<%=i%>,'<%=times.get(i)%>');">
                    <p class="mainul4_li2_p1"><%=times.get(i)%></p>
                </li>
        <%
            }
        %>
    </ul>
    <ul class="mainul5">
        <li class="mainul5_li1">
            <div class="mainul5_li1_div1">猜您需要</div>
            <div class="mainul5_li1_div2" onClick="morejump5();">更多</div>
        </li>
        <%
            for(int i=0;i<doctorQueryModelList.size();i++){
                JdDoctorQueryModel jdDoctorQueryModel=doctorQueryModelList.get(i);
        %>
        <li class="mainul5_li2" onClick="jump5('<%=jdDoctorQueryModel.getUuid()%>');">
            <img src="<%=jdDoctorQueryModel.getHeadPic()%>"/>
            <p class="mainul5_li2_p1"><%=jdDoctorQueryModel.getName()%></p>
            <p class="mainul5_li2_p2"><%=jdDoctorQueryModel.getHospital()+"-"+jdDoctorQueryModel.getDepartment()%></p>
        </li>
        <%
            }
        %>
    </ul>
    <ul class="cityul">
        <%
            for(int i=0;i<districtQueryModelList.size();i++){
                JdDistrictQueryModel districtQueryModel=districtQueryModelList.get(i);
        %>
        <li onClick="searchByCity('<%=districtQueryModel.getUuid()%>');" style="<%
             if(districtQueryModel.getUuid().toString().equals(jd_District_ID)){
              out.write("color:#DF0101;");
           }
        %>"><%=districtQueryModel.getName()%></li>
        <%
            }
        %>
    </ul>
</div>
<div id="MsgBoxDiv">
    <ul>
        <li><p id="msgcontp"></p></li>
        <li id="btnli" onClick="MsgOpt.hideMsgBox();"></li>
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

        $('.mainul1').width(mw);
        $('.mainul1_li1').width(mw * 0.9).height(mh * 0.05);
        $('.mainul1_li1 input').width(mw * 0.9 * 0.82).height(mh * 0.05);

        $('.mainul2').width(mw);
        $('.mainul2_li1').width(mw).height(mh * 0.065);
        $('.mainul2_li1_div1').height(mh * 0.065);
        $('.mainul2_li1_div1').css('line-height', mh * 0.065 + 'px');
        $('.mainul2_li1_div2').width(mw * 0.17).height(mh * 0.065);
        $('.mainul2_li1_div2').css('line-height', mh * 0.065 + 'px');
        $('.mainul2_li2').width(mw);

        $('.mainul3').width(mw);
        $('.mainul3_li1').width(mw).height(mh * 0.065);
        $('.mainul3_li1_div1').height(mh * 0.065);
        $('.mainul3_li1_div1').css('line-height', mh * 0.065 + 'px');
        $('.mainul3_li1_div2').width(mw * 0.17).height(mh * 0.065);
        $('.mainul3_li1_div2').css('line-height', mh * 0.065 + 'px');
        $('.mainul3_li2').width(mw * 0.28).height(mh * 0.06);
        $('.mainul3_li2').css('line-height', mh * 0.065 + 'px');

        $('.mainul4').width(mw);
        $('.mainul4_li1').width(mw).height(mh * 0.065);
        $('.mainul4_li1_div1').height(mh * 0.065);
        $('.mainul4_li1_div1').css('line-height', mh * 0.065 + 'px');
        $('.mainul4_li1_div2').width(mw * 0.17).height(mh * 0.065);
        $('.mainul4_li1_div2').css('line-height', mh * 0.065 + 'px');
        $('.mainul4_li2').width(mw);

        $('.mainul5').width(mw);
        $('.mainul5_li1').width(mw).height(mh * 0.065);
        $('.mainul5_li1_div1').height(mh * 0.065);
        $('.mainul5_li1_div1').css('line-height', mh * 0.065 + 'px');
        $('.mainul5_li1_div2').width(mw * 0.17).height(mh * 0.065);
        $('.mainul5_li1_div2').css('line-height', mh * 0.065 + 'px');
        $('.mainul5_li2').width(mw);
        $('.mainul5_li2 img').width(mw * 0.2).height(mw * 0.2);

        $('#mainDiv').show();
        $('#MsgBoxDiv').width(mw).height(mh);
        $('#MsgBoxDiv ul').width(mw * 0.84).height(mh * 0.26);
        $('#MsgBoxDiv ul li').eq(0).width(mw * 0.84).height(mh * 0.26 * 0.73);
        $('#MsgBoxDiv ul li').eq(1).width(mw * 0.84).height(mh * 0.26 * 0.27);
        $('#MsgBoxDiv ul li').eq(1).css('line-height', mh * 0.26 * 0.27 + 'px');
        $('#msgcontp').css('margin-top', mh * 0.26 * 0.3);
        $('#MsgBoxDiv ul').css('margin-top', mh * 0.16);

        $('.cityul').css({left:0,top:mh*0.07});

        document.onkeydown = function () {
            if (event.keyCode == 13) {
                search();
            }
        }
    }

    var chooseflag = false;
    function chooseCity(){
        if(chooseflag){
            chooseflag = false;
            $('.cityul').hide();
        }else{
            chooseflag = true;
            $('.cityul').show();
        }
        return false;
    }

    function search(){
        var keywords = $.trim($('#keywords').val());
        if(keywords.length>0){
            window.location.href="search.htm?keyword="+encodeURI(encodeURI(keywords));
        }
    }
    function morejump2() {
        window.location.href="byHospital.htm";
    }

    function morejump3() {
        window.location.href="byCases.htm";
    }

    function morejump4() {
        window.location.href="byTime.htm";
    }

    function morejump5() {
        var title = encodeURI(encodeURI("医生列表"));
        window.location.href="detailHospital.htm?title="+title;
    }

    function jump2(ID, title) {
        window.location.href ="detailHospital.htm?title="+encodeURI(encodeURI(title))+"&jd_hospital_id="+ID;
    }

    function jump3(ID, title) {
        window.location.href ="detailHospital.htm?title="+encodeURI(encodeURI("搜索"+title))+"&jd_sick_id="+ID;
    }

    function jump4(ID, title) {
        window.location.href ="detailHospital.htm?title="+encodeURI(encodeURI(title))+"&dayDiff="+ID;
    }

    function jump5(ID) {
        window.location.href ="doctor.htm?jd_doctor_id="+ID;
    }

    function searchByCity(city){
        window.location.href="main.htm?citysearch="+city;
    }

    //消息弹窗类
    var MsgOpt = {
        msgt: null,
        showMsgBox: function (msg, btnword) {
            var mythis = this;
            $('#msgcontp').html(msg);
            $('#btnli').html(btnword);
            $('#MsgBoxDiv').fadeIn(200);
            mythis.msgt = setTimeout(function () {
                MsgOpt.hideMsgBox();
            }, 5000);
        },
        hideMsgBox: function () {
            var mythis = this;
            clearTimeout(mythis.msgt);
            $('#MsgBoxDiv').fadeOut(400);
            $('#msgcontp').html('');
            $('#btnli').html('');
        }
    };


</script>