<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%
    List<JdDoctorQueryModel> doctorQueryModelList=(List<JdDoctorQueryModel>)request.getAttribute("doctorQueryModelList");
    String title = (String)request.getAttribute("title");
%>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../include/head.jsp" />
    <style>
        html,body{width:100%;height:100%;margin:0;padding:0;font-size:100%;background:#F2F2F2;}
        a{color:#000000;-webkit-tap-highlight-color: transparent;}
        img,li,div{-webkit-tap-highlight-color:transparent;}
        #mainDiv{width:100%;display:none;}
        #mainDiv .top_ul{width:100%;background:#FB9D3B;overflow:hidden;}
        #mainDiv .top_ul li{text-align:center;float:left;}
        #mainDiv .top_ul li:nth-child(1){width:22.5%;height:100%;background:url(../../wechat/images/larrow.png) center left no-repeat;background-size:auto 60%;}
        #mainDiv .top_ul li:nth-child(2){width:54%;height:100%;font-size:2em;color:#FFFFFF;}
        #mainDiv .top_ul li:nth-child(3){width:23%;height:100%;text-align:left;}
        #mainDiv .top_ul li:nth-child(3) a{font-size:1.55em;color:#FFFFFF;}
        #mainDiv .top_ul li:nth-child(3) span{font-size:1.55em;color:#FFFFFF;margin-left:0.65em;margin-right:0.65em;}

        #mainDiv .mainul1{width:100%;overflow:hidden;padding:1.3em 0 0.8em 0;background:#FFFFFF;}
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
        #mainDiv .mainul1 li input[type="text"]{width:82%;font-size:1.58em;color:#000000;background:transparent;border:0;-webkit-border:0;margin-left:3%;float:left;}
        #mainDiv .mainul1 li div{width:11%;height:100%;background:transparent;float:left;}

        #mainDiv .mainul2{width:100%;overflow:hidden;background:#F2F2F2;padding-top:1em;padding-bottom:1em;}
        #mainDiv .mainul2 .mainul2_li1{width:94%;margin-left:3%;float:left;background:#F2F2F2;text-align:left;font-size:1.5em;color:#6E6E6E;}
        #mainDiv .mainul2 .mainul2_li2{width:22%;float:left;background:#FFFFFF;text-align:center;border:#E6E6E6 0.1em solid;-webkit-border:#E6E6E6 0.1em solid;font-size:1.45em;margin-left:2.1%;margin-top:2%;}

        #mainDiv .mainul3{width:100%;overflow:hidden;padding:1.3em 0 1.3em 0;background:#F2F2F2;}
        #mainDiv .mainul3 .mainul3_li1{width:100%;background:#FFFFFF;float:left;padding:0.9em 0 0.9em 0;border-bottom:#F2F2F2 0.15em solid;-webkit-border-bottom:#F2F2F2 0.15em solid;}
        #mainDiv .mainul3 .mainul3_li1 img{width:30%;margin-left:3%;float:left;border-radius:50%;-webkit-border-radius:50%;}
        #mainDiv .mainul3 .mainul3_li1 ul{width:68%;float:right;overflow:hidden;}
        #mainDiv .mainul3 .mainul3_li1 ul li{width:100%;float:left;margin-bottom:0.12em;}
        #mainDiv .mainul3 .mainul3_li1 ul li .cont_div1{float:left;font-size:1.6em;}
        #mainDiv .mainul3 .mainul3_li1 ul li .cont_div1 .jobsp{color:#FA9D3E;}
        #mainDiv .mainul3 .mainul3_li1 ul li .cont_div2{float:right;text-align:center;font-size:1.58em; color:#2882D8;margin-right:3%;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li1{font-size:1.5em;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li2{font-size:1.5em;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li2 span{color:#6E6E6E;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li3{font-size:1.5em;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li3 span{color:#6E6E6E;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li4{font-size:1.5em;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li4 span{color:#6E6E6E;}

        #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
        #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
        #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
        #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
        #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}
    </style>
</head>
<body>
<div id="mainDiv">
    <ul class="top_ul">
        <a href="main.htm"><li></li></a>
        <li>搜索<%=title%></li>
        <li><a href="toPersonal.htm">我的</a><span>|</span><a href="main.htm">首页</a></li>
    </ul>
    <ul class="mainul1">
        <li class="mainul1_li1">
            <input id="keywords" type="text" placeholder="医院/医生姓名/疾病" value="<%=title%>" />
            <div onClick="search();"></div>
        </li>
    </ul>
    <ul class="mainul2">
        <li class="mainul2_li1">热门搜索</li>
        <li class="mainul2_li2" onClick="hotSearch('931ab16b-8867-4aba-b572-691271490e18','高血压');">高血压</li>
        <li class="mainul2_li2" onClick="hotSearch('6e3a5021-3644-4477-bd4d-3117771b673b','冠心病');">冠心病</li>
        <li class="mainul2_li2" onClick="hotSearch('843a8df4-983a-44fb-9335-d9088dd56e7f','心律失常');">心律失常</li>
        <li class="mainul2_li2" onClick="hotSearch('8de63dd4-3ffd-40fa-b7bc-db39ecb1e767','心力衰竭');">心力衰竭</li>
    </ul>
    <ul class="mainul3">
        <%
            if(doctorQueryModelList!=null){
            for(int i=0;i<doctorQueryModelList.size();i++){
                JdDoctorQueryModel doctorQueryModel=doctorQueryModelList.get(i);
        %>
        <li class="mainul3_li1" onClick="jump('<%=doctorQueryModel.getUuid()%>');">
            <img src="<%=doctorQueryModel.getHeadPic()%>"/>
            <ul>
                <li>
                    <div class="cont_div1">
                        <span class="namesp"><%=doctorQueryModel.getName()%></span>
                        <span class="jobsp"><%=doctorQueryModel.getTitle()%></span>
                    </div>
                    <div class="cont_div2"><%=doctorQueryModel.getAvailable()%></div>
                </li>
                <li class="mainul3_li1_ul_li1" style="margin-top: 0.3em;"><%=doctorQueryModel.getHospital()%></li>
                <li class="mainul3_li1_ul_li2">科室：<span><%=doctorQueryModel.getDepartment()%></span></li>
                <li class="mainul3_li1_ul_li3">擅长：<span><%=WechatUtils.showDoctorSkills(doctorQueryModel.getDoctorSelectSkills())%></span></li>
                <li class="mainul3_li1_ul_li4">人气：<span><%=doctorQueryModel.getPopularity()%></span></li>
            </ul>
        </li>
        <%
                }
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
    var mh = 1136*mw/640;
    window.onload = function(){
        $('#mainDiv').width(mw);
        $('.top_ul').width(mw).height(mh*0.07);
        $('.top_ul li').height(mh*0.07);
        $('.top_ul li').css('line-height',mh*0.07+'px');

        $('.mainul1').width(mw);
        $('.mainul1_li1').width(mw*0.9).height(mh*0.05);
        $('.mainul1_li1 input').width(mw*0.9*0.82).height(mh*0.05);

        $('.mainul2').width(mw);
        $('.mainul2_li2').width(mw*0.22).height(mh*0.055);
        $('.mainul2_li2').css('line-height',mh*0.055+'px');

        $('.mainul3').width(mw);
        $('.mainul3_li1').width(mw);
        $('.mainul3_li1 img').width(mw*0.25).height(mw*0.25);

        $('#mainDiv').show();
        $('#MsgBoxDiv').width(mw).height(mh);
        $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
        $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
        $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
        $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
        $('#msgcontp').css('margin-top',mh*0.26*0.3);
        $('#MsgBoxDiv ul').css('margin-top',mh*0.16);

        document.onkeydown = function () {
            if (event.keyCode == 13) {
                search();
            }
        }
    }

    function search(){
        var keywords = $.trim($('#keywords').val());
        if(keywords.length>0){
            window.location.href="search.htm?keyword="+encodeURI(encodeURI(keywords));
        }
    }
    //跳转页面
    function jump(ID){
        window.location.href ="doctor.htm?jd_doctor_id="+ID;
    }

    function hotSearch(jd_sick_id, name){
        window.location.href = "detailHospital.htm?title="+encodeURI(encodeURI("搜索"+name))+"&jd_sick_id="+jd_sick_id;
    }

    //消息弹窗类
    var MsgOpt = {
        msgt:null,
        showMsgBox:function(msg, btnword){
            var mythis = this;
            $('#msgcontp').html(msg);
            $('#btnli').html(btnword);
            $('#MsgBoxDiv').fadeIn(200);
            mythis.msgt = setTimeout(function(){MsgOpt.hideMsgBox();},5000);
        },
        hideMsgBox:function(){
            var mythis = this;
            clearTimeout(mythis.msgt);
            $('#MsgBoxDiv').fadeOut(400);
            $('#msgcontp').html('');
            $('#btnli').html('');
        }
    };
</script>