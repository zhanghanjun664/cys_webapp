<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="java.util.List" %>
<%
    request.setCharacterEncoding("utf-8");
    String doctorQueryModelList=(String)request.getAttribute("doctorQueryModelList");
    String timeOrderList=(String)request.getAttribute("timeOrderList");
    String title = (String)request.getAttribute("title");
    String dayDiff = (String)request.getAttribute("dayDiff");
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
        #mainDiv .top_ul li:nth-child(3) span{font-size:1.55em;color:#FFFFFF;margin-left:0.5em;margin-right:0.5em;}

        #mainDiv .mainul3{width:100%;overflow:hidden;background:#F2F2F2;}
        #mainDiv .mainul3 .mainul3_li1{width:100%;background:#FFFFFF;float:left;padding:1.6em 0 1.6em 0;border-bottom:#F2F2F2 0.15em solid;-webkit-border-bottom:#F2F2F2 0.15em solid;}
        #mainDiv .mainul3 .mainul3_li1 img{width:30%;margin-left:3%;float:left;border-radius:50%;-webkit-border-radius:50%;}
        #mainDiv .mainul3 .mainul3_li1 ul{width:68%;float:right;overflow:hidden;}
        #mainDiv .mainul3 .mainul3_li1 ul li{width:100%;float:left;margin-bottom:0.12em;}
        #mainDiv .mainul3 .mainul3_li1 ul li .cont_div1{float:left;font-size:1.6em;}
        #mainDiv .mainul3 .mainul3_li1 ul li .cont_div1 .jobsp{color:#FA9D3E;}
        #mainDiv .mainul3 .mainul3_li1 ul li .cont_div2{float:right;text-align:center;font-size:1.58em; color:#2882D8;margin-right:3%;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li1{font-size:1.5em;margin-top: 0.4em;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li2{font-size:1.5em;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li2 span{color:#6E6E6E;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li3{font-size:1.5em;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li3 span{color:#6E6E6E;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li4{font-size:1.5em;}
        #mainDiv .mainul3 .mainul3_li1 ul .mainul3_li1_ul_li4 span{color:#6E6E6E;}

        .chooseDiv{width:100%;position:absolute;left:0;top:0;background:rgba(0,0,0,0.45); display:none;z-index:1000000;}
        .chooseDiv .chooseul1{width:78%;padding-bottom:5.5em;float:right;overflow:hidden;background:#F2F2F2;}
        .chooseDiv .chooseul1 .chooseul1_li{width:100%; float:left;background:#FFFFFF;margin-bottom:1.2em;}

        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul1{width:100%;overflow:hidden; float:left;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul1 .chooseul1_li_ul1_li1{width:100%;padding:1.6em 0 1.6em 0;float:left;background:#FFFFFF;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;text-align:left;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;background-size:auto 65%;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul1 .chooseul1_li_ul1_li1 span{margin-left:2%;font-size:1.5em;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul1 .chooseul1_li_ul1_li2{width:100%;padding:1.6em 0 1.6em 0;float:left;background:#FFFFFF;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;text-align:left;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;background-size:auto 65%;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul1 .chooseul1_li_ul1_li2 span{margin-left:2%;font-size:1.5em;}

        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul2{width:100%;overflow:hidden; float:left;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul2 .chooseul1_li_ul2_li1{width:100%;padding:1.6em 0 1.6em 0;float:left;background:#FFFFFF;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;text-align:left;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;background-size:auto 65%;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul2 .chooseul1_li_ul2_li1 span{margin-left:2%;font-size:1.5em;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul2 .chooseul1_li_ul2_li2{width:100%;padding:1.6em 0 1.6em 0;float:left;background:#FFFFFF;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;text-align:left;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;background-size:auto 65%;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul2 .chooseul1_li_ul2_li2 span{margin-left:2%;font-size:1.5em;}

        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul3{width:100%;overflow:hidden;float:left;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul3 .chooseul1_li_ul3_li1{width:100%;padding:1.6em 0 1.6em 0;float:left;background:#FFFFFF;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;text-align:left;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;background-size:auto 65%;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul3 .chooseul1_li_ul3_li1 span{margin-left:2%;font-size:1.5em;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul3 .chooseul1_li_ul3_li2{width:100%;padding:1.6em 0 1.6em 0;float:left;background:#FFFFFF;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;text-align:left;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;background-size:auto 65%;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul3 .chooseul1_li_ul3_li2 span{margin-left:2%;font-size:1.5em;}

        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul4{width:100%;overflow:hidden;float:left;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul4 .chooseul1_li_ul4_li1{width:100%;padding:1.6em 0 1.6em 0;float:left;background:#FFFFFF;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;text-align:left;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;background-size:auto 65%;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul4 .chooseul1_li_ul4_li1 span{margin-left:2%;font-size:1.5em;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul4 .chooseul1_li_ul4_li2{width:100%;padding:1.6em 0 1.6em 0;float:left;background:#FFFFFF;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;text-align:left;background:url(../../wechat/images/icon11.png) center right no-repeat #FFFFFF;background-size:auto 65%;}
        .chooseDiv .chooseul1 .chooseul1_li .chooseul1_li_ul4 .chooseul1_li_ul4_li2 span{margin-left:2%;font-size:1.5em;}

        #mainDiv .moreDiv{width:100%;padding:1em 0 1em 0;color:#2382D4;font-size:1.55em;background:#FFFFFF;margin-bottom:1em;text-align:center;}
        .choosed {background:url(../../wechat/images/icon10.png) center right no-repeat #FFFFFF !important;}
        .choosed span {color:#FB9D3B;}
    </style>
</head>
<body>
<div id="mainDiv">
    <ul class="top_ul">
        <a href="javascript:history.back();"><li></li></a>
        <li><%=title%></li>
        <li><a href="main.htm">首页</a><span>|</span><a id="chooseBtn">筛选</a></li>
    </ul>
    <ul class="mainul3">
        <!-- 医生列表 -->
    </ul>
    <div class="moreDiv" onClick="more();">点击查看更多</div>
    <div class="chooseDiv">
        <ul class="chooseul1">
            <li class="chooseul1_li">
                <ul class="chooseul1_li_ul1">
                    <li class="chooseul1_li_ul1_li1 choosed" onClick="chooseAct1(this,1);"><span>时间最近</span></li>
                    <li class="chooseul1_li_ul1_li2" onClick="chooseAct1(this,2);"><span>人气最高</span></li>
                </ul>
            </li>
            <li class="chooseul1_li">
                <ul class="chooseul1_li_ul2">
                    <li class="chooseul1_li_ul2_li1 choosed" onClick="chooseAct2(this,'0');"><span>全部医院</span></li>
                </ul>
            </li>
            <li class="chooseul1_li">
                <ul class="chooseul1_li_ul3">
                    <li class="chooseul1_li_ul3_li1 choosed" onClick="chooseAct3(this,'0');"><span>全部病情</span></li>
                </ul>
            </li>
            <%
                if(dayDiff ==null) {
            %>
                    <li class="chooseul1_li">
                        <ul class="chooseul1_li_ul4">
                            <li class="chooseul1_li_ul4_li1 choosed" onClick="chooseAct4(this,0);"><span>全部时间</span></li>
                            <%
                                List<String> times = WechatUtils.getBytimeList(false);
                                for(int i=0; i < times.size(); i++) {
                            %>
                            <li class="chooseul1_li_ul4_li2" onClick="chooseAct4(this,<%=i+1%>);"><span><%=times.get(i)%></span></li>
                            <%
                                }
                            %>
                        </ul>
                    </li>
            <%
                }
            %>
        </ul>
    </div>
</div>
</body>
</html>
<script>
    var g_doctorList;
    var doctorList; //粉丝排序的医生列表
    var timeOrderList; //预约时间排序的医生列表
    var targetList; //当前条件结果集
    var currentPage = 0; //当前页码
    var showflag = false;
    var mw = $(window).width();
    var mh0 = $(window).height();
    var mh = 1136*mw/640;
    window.onload = function(){
        $('#mainDiv').width(mw);
        $('.top_ul').width(mw).height(mh*0.07);
        $('.top_ul li').height(mh*0.07);
        $('.top_ul li').css('line-height',mh*0.07+'px');
        $('.mainul3').width(mw);
        $('#mainDiv').show();
        $('.chooseDiv').css({left:0,top:mh0*0.075});

        $("#chooseBtn").click(function(e){
            if(showflag)
                $(".chooseDiv").hide();
            else
                $(".chooseDiv").show();
            showflag = !showflag;
            var ev = e || window.event;
            if(ev.stopPropagation){
                ev.stopPropagation();
            } else if(window.event){
                window.event.cancelBubble = true;
            }
        })
        document.onclick = function(){
            $(".chooseDiv").hide();
        }
        $(".chooseul1").click(function(e){
            var ev = e || window.event;
            if(ev.stopPropagation){
                ev.stopPropagation();
            } else if(window.event){
                window.event.cancelBubble = true;
            }
        });
        timeOrderList = <%=timeOrderList%>;
        doctorList = <%=doctorQueryModelList%>;
        var hospitals = [];
        var doctorskills = [];
        doctorList.forEach(function(doctor) {
            if(!strInArray(hospitals, doctor.hospital)) {
                hospitals.push(doctor.hospital);
                $(".chooseul1_li_ul2").append('<li class="chooseul1_li_ul2_li2" onClick="chooseAct2(this,\'' + doctor.hospital + '\');"><span>' + doctor.hospital + '</span></li>');
            }
            var skills = doctor.doctorSkills.split(",");
            skills.forEach(function(skill){
                if(!strInArray(doctorskills, skill)){
                    doctorskills.push(skill);
                    $(".chooseul1_li_ul3").append('<li class="chooseul1_li_ul3_li2" onClick="chooseAct3(this,\''+skill+'\');"><span>'+skill+'</span></li>');
                }
            });
        });
        g_doctorList = timeOrderList;
        targetList = timeOrderList;
        getShowContent(0);
    }

    //跳转医生页面
    function toDoctor(ID){
        window.location.href ='doctor.htm?jd_doctor_id='+ID;
    }
    //选择排序
    var g_num = 1;
    function chooseAct1(obj,num){
        if(g_num == num)
            return;
        g_num = num;
        $(".chooseul1_li_ul1 li").removeClass("choosed");
        $(obj).addClass("choosed");
        if(num == 1) g_doctorList = timeOrderList;
        else g_doctorList = doctorList;
        updateTargetList();
    }

    //选择医院
    var g_hospital="0";
    function chooseAct2(obj,hospital){
        if(hospital == g_hospital)
            return;
        g_hospital = hospital;
        $(".chooseul1_li_ul2 li").removeClass("choosed");
        $(obj).addClass("choosed");
        updateTargetList();
    }
    //选择病情
    var g_skill="0";
    function chooseAct3(obj,skill){
        if(skill == g_skill)
            return;
        g_skill = skill;
        $(".chooseul1_li_ul3 li").removeClass("choosed");
        $(obj).addClass("choosed");
        updateTargetList();
    }
    //选择时间
    var g_time = 0;
    function chooseAct4(obj,num){
        if(g_time == num)
            return;
        g_time = num;
        $(".chooseul1_li_ul4 li").removeClass("choosed");
        $(obj).addClass("choosed");
        updateTargetList();
    }

    //查看更多
    function more() {
        var begin = currentPage * 10;
        getShowContent(begin);
    }

    function updateTargetList() {
        $(".chooseDiv").hide();
        $(".mainul3").html("");
        targetList = [];
        g_doctorList.forEach(function(doctor){
            if((g_hospital == "0" || doctor.hospital == g_hospital)
                    && (g_skill == "0" || strInArray(doctor.doctorSkills.split(","), g_skill))) {
                if(g_time != 0) {
                    if((g_time == 1 && doctor.available == "今天可约") ||
                            (g_time == 2 && doctor.available == "明天可约") ||
                            (g_time == 3 && doctor.available == "后天可约")) {
                        targetList.push(doctor);
                    }
                } else {
                    targetList.push(doctor);
                }
            }
        });
        currentPage = 0;
        getShowContent(0);
    }

    //加载显示内容
    function getShowContent(begin) {
        var str = new StringBuilder();
        var index = 0;
        for(var i = begin; i < targetList.length; i++) {
            var doctor = targetList[i];
            str.append('<li class="mainul3_li1" onClick="toDoctor(\''+doctor.uuid+'\');">');
            str.append('<img src="'+doctor.headPic+'"/>');
            str.append('<ul><li><div class="cont_div1">');
            str.append('<span class="namesp">'+doctor.name+'</span>');
            str.append('<span class="jobsp">'+doctor.title+'</span>');
            str.append('</div><div class="cont_div2">'+doctor.available+'</div></li>');
            str.append('<li class="mainul3_li1_ul_li1">'+doctor.hospital+'</li>');
            str.append('<li class="mainul3_li1_ul_li2">科室：<span>'+doctor.department+'</span></li>');
            str.append('<li class="mainul3_li1_ul_li3">擅长：<span>'+doctor.doctorSkills+'</span></li>');
            str.append('<li class="mainul3_li1_ul_li4">人气：<span>'+doctor.popularity+'</span></li></ul></li>');
            index++;
            if(index == 10)
                break;
        }
        if(begin + index >= targetList.length)
            $(".moreDiv").hide();
        else
            $(".moreDiv").show();
        $(".mainul3").append(str.toString());
        currentPage++;
        $('.mainul3_li1').width(mw);
        $('.mainul3_li1 img').width(mw*0.25).height(mw*0.25);
    }

</script>