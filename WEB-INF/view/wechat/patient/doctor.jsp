<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdCaseHistoryQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.constants.DoctorAuditStatus" %>
<%@ page import="java.lang.Integer" %>
<%
  JdDoctorQueryModel doctorQueryModel=(JdDoctorQueryModel)request.getAttribute("doctorQueryModel");
  Integer warmText = (Integer)request.getAttribute("warmText");
  String address = (String)request.getAttribute("address");
  String commentList=(String)request.getAttribute("commentList");
  Boolean isConcern = (Boolean)request.getAttribute("isConcern");
  List<JdCaseHistoryQueryModel> caseList = (List<JdCaseHistoryQueryModel>)request.getAttribute("caseList");
  boolean auditFlag = doctorQueryModel.getStatus().equals(DoctorAuditStatus.AUDIT_PASSED.getValue());
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
    #mainDiv .top_ul li:nth-child(1){width:11.5%;height:100%;background:url(../../wechat/images/larrow.png) center left no-repeat;background-size:70% auto;}
    #mainDiv .top_ul li:nth-child(2){width:76%;height:100%;font-size:2em;color:#FFFFFF;}
    #mainDiv .top_ul li:nth-child(3){width:12%;height:100%;}
    #mainDiv .top_ul li:nth-child(3) a{font-size:1.6em;color:#FFFFFF;}

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 0.75em 0;background:#F2F2F2;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;margin-bottom:0.1em;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;padding:1.5em 0 1.5em 0;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1{width:20%;overflow:hidden;float:left;margin-left:3%;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li1{width:100%;float:left;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li1 img{width:100%;border-radius:50%;-webkit-border-radius:50%;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li2{width:100%;float:left;margin-left:9%;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li2 div{width:100%;margin-top:0.2em;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.45em;color:#FFFFFF;}

    #mainDiv .btmul .btmul_li .btmul_li_ul2{width:73%;margin-left:3%;overflow:hidden;float:left;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1{width:100%;padding-bottom:0.35em;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1 .btmul_li_ul2_li1_sp1{font-size:1.65em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1 .btmul_li_ul2_li1_sp2{font-size:1.55em;color:#FB9D3B;}

    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2{width:100%;padding-bottom:0.35em;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .df_sp{font-size:1.5em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .hospital_sp{font-size:1.5em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .room_sp{font-size:1.5em;color:#A4A4A4;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .goodat_sp{font-size:1.5em;color:#A4A4A4;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .number_sp{font-size:1.5em;color:#A4A4A4;}

    #mainDiv .warm_sp{font-size:1.1em;color:#A4A4A4;text-align:center;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #mainDiv .timeul1{width:100%;overflow:hidden;margin-top:0.5em;}
    #mainDiv .timeul1 li{float:left;background:#FFFFFF;padding:1.3em 0 1.3em 0;}
    #mainDiv .timeul1 li .timeul1p1{width:100%;text-align:center;font-size:1.5em;color:#FB9D3B;border-bottom:#F2F2F2 0.03em solid;padding-bottom:0.2em;}
    #mainDiv .timeul1 li .timeul1p2{width:100%;text-align:center;font-size:1.5em;color:#FB9D3B;}

    #mainDiv .dattingul{width:100%;overflow:hidden;padding-top:1.5em;padding-bottom:1.5em;border-top:#F2F2F2 0.15em solid;-webkit-border-top:#F2F2F2 0.15em solid;display:none;background:#FFFFFF;}
    #mainDiv .dattingul .dattingul_li1{float:left;text-align:center;font-size:1.5em;color:#FFFFFF;background:#FB9D3B;border-radius:0.2em;-webkit-border-radius:0.2em;margin-left:0.6em;margin-bottom:0.65em;}
    #mainDiv .dattingul .dattingul_li2{float:left;text-align:center;font-size:1.5em;color:#FFFFFF;background:#BDBDBD;border-radius:0.2em;-webkit-border-radius:0.2em;margin-left:0.6em;margin-bottom:0.65em;}

    #mainDiv .dayoverul{width:100%;overflow:hidden;padding-top:1.5em;padding-bottom:1em;border-top:#F2F2F2 0.15em solid;-webkit-border-top:#F2F2F2 0.15em solid;display:none;background:#FFFFFF;}
    #mainDiv .dayoverul .dayoverul_li1{width:100%;float:left;text-align:center;display:none;}
    #mainDiv .dayoverul .dayoverul_li1 .dayoverul_li1_sp1{margin-left:3em;margin-top:0.6em;float:left;font-size:1.5em;color:#DF0101;}
    #mainDiv .dayoverul .dayoverul_li1 .dayoverul_li1_sp2{margin-top:0.6em;float:left;font-size:1.5em;color:#000000;}
    #mainDiv .dayoverul .dayoverul_li1 .dayoverul_div1{margin-left:0.3em;float:left;font-size:1.5em;color:#FB9D3B;border-radius:0.5em;-webkit-border-radius:0.5em;border:#BDBDBD 0.07em solid;-webkit-border:#BDBDBD 0.07em solid;text-align:center;}

    #mainDiv .dayoverul .dayoverul_li2{width:100%;float:left;text-align:center;display:none;}
    #mainDiv .dayoverul .dayoverul_li2 .dayoverul_li2_sp1{margin-left:2.5em;margin-top:0.6em;float:left;font-size:1.5em;color:#DF0101;}
    #mainDiv .dayoverul .dayoverul_li2 .dayoverul_li2_sp2{margin-top:0.6em;float:left;font-size:1.5em;color:#000000;}
    #mainDiv .dayoverul .dayoverul_li2 .dayoverul_div2{margin-left:0.3em;float:left;font-size:1.5em;color:#FB9D3B;border-radius:0.5em;-webkit-border-radius:0.5em;border:#BDBDBD 0.07em solid;-webkit-border:#BDBDBD 0.07em solid;text-align:center;}

    #mainDiv .addressul{width:100%;overflow:hidden;}
    #mainDiv .addressul .addressul_li1{width:100%;padding:1em 0 1em 0;float:left;}
    #mainDiv .addressul .addressul_li1 span{margin-left:3%;font-size:1.6em;color:#000000;}
    #mainDiv .addressul .addressul_li2{width:100%;float:left;padding:1.5em 0 1.5em 0;background:#FFFFFF;}
    #mainDiv .addressul .addressul_li2 span{margin-left:3%;font-size:1.55em;color:#585858;}

    #mainDiv .introduceul{width:100%;overflow:hidden;}
    #mainDiv .introduceul .introduceul_li1{width:100%;padding:1em 0 1em 0;float:left;}
    #mainDiv .introduceul .introduceul_li1 span{margin-left:3%;font-size:1.6em;color:#000000;}
    #mainDiv .introduceul .introduceul_li2{width:100%;float:left;padding:1.5em 0 1.5em 0;background:#FFFFFF;}
    #mainDiv .introduceul .introduceul_li2 .introduceul_li2_div{width:94%;margin-left:3%;}
    #mainDiv .introduceul .introduceul_li2 .introduceul_li2_div #showsp{font-size:1.55em;color:#585858;}
    #mainDiv .introduceul .introduceul_li2 .introduceul_li2_div #beyondsp{font-size:1.55em;color:#585858;display:none;}
    #mainDiv .introduceul .introduceul_li3{width:100%;float:left;padding:0.9em 0 0.9em 0;background:#FFFFFF;font-size:1.53em;color:#2382D4;text-align:center;border:#F2F2F2 0.07em solid;-webkit-border:#F2F2F2 0.07em solid;}

    #mainDiv .caseul{width:100%;overflow:hidden;background:#FFFFFF;padding:0 0 1em 0;}
    #mainDiv .caseul .caseul_li1{width:100%;padding:1em 0 1em 0;float:left;background:#F2F2F2;}
    #mainDiv .caseul .caseul_li1 span{margin-left:3%;font-size:1.6em;color:#000000;}
    #mainDiv .caseul .caseul_li2{float:left;text-align:center;font-size:1.5em;color:#FFFFFF;background:#FFFFFF;border-radius:0.2em;-webkit-border-radius:0.2em;margin-left:0.66em;margin-top:0.85em;margin-bottom:0.3em;color:#2382D4;padding:0.65em 0.9em 0.65em 0.9em;border:#BDBDBD 0.0815em solid;-webkit-border:#BDBDBD 0.0815em solid;}

    #mainDiv .commentul{width:100%;overflow:hidden;background:#F2F2F2;}
    #mainDiv .commentul .commentul_li{width:100%;padding:1em 0 1em 0;float:left;border-bottom:#F2F2F2 0.15em solid;-webkit-border-bottom:#F2F2F2 0.15em solid;background:#FFFFFF;}
    #mainDiv .commentul .commentul_li0{width:100%;padding:1em 0 1em 0;float:left;background:#F2F2F2;}
    #mainDiv .commentul .commentul_li0 span{margin-left:3%;font-size:1.6em;color:#000000;}
    #mainDiv .commentul .commentul_li .commentul_li_ul{width:94%;margin-left:3%;float:left;}
    #mainDiv .commentul .commentul_li .commentul_li_ul .commentul_li_ul_li1{width:100%;float:left;font-size:1.55em;color:#2382D4;padding:0.2em 0 0.35em 0;}
    #mainDiv .commentul .commentul_li .commentul_li_ul .commentul_li_ul_li2{width:100%;float:left;}
    #mainDiv .commentul .commentul_li .commentul_li_ul .commentul_li_ul_li2 .commentul_li_ul_li2_img{width:36%;float:left;}
    #mainDiv .commentul .commentul_li .commentul_li_ul .commentul_li_ul_li2 .commentul_li_ul_li2_sp{float:right;font-size:1.45em;color:#BDBDBD;margin-top:0.3em;}
    #mainDiv .commentul .commentul_li .commentul_li_ul .commentul_li_ul_li3{width:100%;float:left;font-size:1.55em;padding:0.85em 0 0.8em 0;}

    #mainDiv .moreCommentDiv{width:100%;padding:1em 0 1em 0;color:#2382D4;font-size:1.55em;background:#FFFFFF;margin-bottom:1em;text-align:center;}
  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li><%=doctorQueryModel.getName()%></li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul1">
        <li class="btmul_li_ul1_li1"><img id="docheadimg" src="<%=doctorQueryModel.getHeadPic()%>"/></li>
        <li class="btmul_li_ul1_li2">
          <%
            if(isConcern) {
          %>
            <div class="followDiv" alt="cancel" onClick="follow();" style="background: #04B45F">已关注</div>
          <%
            } else {
          %>
            <div class="followDiv" alt="add" onClick="follow();" style="background: #2882D8">+关注</div>
          <%
            }
          %>
        </li>
      </ul>
      <ul class="btmul_li_ul2">
        <li class="btmul_li_ul2_li1">
          <span class="btmul_li_ul2_li1_sp1"><%=doctorQueryModel.getName()%></span>
          <span class="btmul_li_ul2_li1_sp2"><%=doctorQueryModel.getTitle()%></span>
        </li>
        <li class="btmul_li_ul2_li2"><span class="hospital_sp"><%=doctorQueryModel.getHospital()%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">科室：</span><span class="room_sp"><%=doctorQueryModel.getDepartment()%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">擅长：</span><span class="goodat_sp"><%=WechatUtils.showDoctorSkills(doctorQueryModel.getDoctorSelectSkills())%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">人气：</span><span class="number_sp"><%=doctorQueryModel.getPopularity()%></span></li>
      </ul>
    </li>
  </ul>
  <ul class="warm_sp">
    <li><span><%="预约有奖：每位医生每天前"%><%=warmText%><%="个成功预约，诊金由橙医生补贴（每月限一次）"%></span></li>
  </ul>
  <ul class="timeul1">
    <li onClick="changeTime(0,8);">
      <p class="timeul1p1"></p>
      <p class="timeul1p2">8</p>
    </li>
    <li onClick="changeTime(1,9);">
      <p class="timeul1p1"></p>
      <p class="timeul1p2">9</p>
    </li>
    <li onClick="changeTime(2,10);">
      <p class="timeul1p1"></p>
      <p class="timeul1p2">10</p>
    </li>
    <li onClick="changeTime(3,11);">
      <p class="timeul1p1"></p>
      <p class="timeul1p2">11</p>
    </li>
    <li onClick="changeTime(4,12);">
      <p class="timeul1p1"></p>
      <p class="timeul1p2">12</p>
    </li>
    <li onClick="changeTime(5,13);">
      <p class="timeul1p1"></p>
      <p class="timeul1p2">13</p>
    </li>
    <li onClick="changeTime(6,14);">
      <p class="timeul1p1"></p>
      <p class="timeul1p2">14</p>
    </li>
  </ul>
  <ul class="dattingul">

  </ul>
  <ul class="dayoverul">
    <li class="dayoverul_li1"><span class="dayoverul_li1_sp1">当天预约已满</span><span class="dayoverul_li1_sp2">，最近预约时间</span><div class="dayoverul_div1">2015-05-09</div></li>
    <li class="dayoverul_li2"><span class="dayoverul_li2_sp1">该医生预约已满</span><span class="dayoverul_li2_sp2">，请选择其他医生</span><div class="dayoverul_div2">相关医生预约推荐</div></li>
  </ul>
  <ul class="addressul">
    <li class="addressul_li1"><span>就诊地址</span></li>
    <li class="addressul_li2"><span><%=address%></span></li>
  </ul>
  <ul class="introduceul">
    <li class="introduceul_li1"><span>医生简介</span></li>
    <%
      if(doctorQueryModel.getDescription().length() > 60) {
    %>
    <li class="introduceul_li2">
      <div class="introduceul_li2_div">
        <span id="showsp"><%=doctorQueryModel.getDescription().substring(0, 60)%></span>
        <span id="beyondsp"><%=doctorQueryModel.getDescription().substring(60, doctorQueryModel.getDescription().length())%></span>
      </div>
    </li>
    <li class="introduceul_li3" onClick="showAllIntroduce(this);">展开全部</li>
    <%
      } else {
    %>
    <li class="introduceul_li2">
      <div class="introduceul_li2_div"><span id="showsp"><%=doctorQueryModel.getDescription()%></span></div>
    </li>
    <%
      }
    %>
  </ul>
  <ul class="caseul">
    <li class="caseul_li1"><span>咨询病例</span></li>
    <%
      if(caseList == null || caseList.size() == 0) {
    %>
      <li class="caseul_li2">暂无病例</li>
    <%
      } else {
        for(int i = 0; i < caseList.size(); i++) {
          JdCaseHistoryQueryModel c = caseList.get(i);
    %>
      <li class="caseul_li2"><%=c.getSickCategoryName()%>(<%=c.getCount()%>)</li>
    <%
        }
      }
    %>
  </ul>
  <ul class="commentul">
    <li class="commentul_li0"><span>用户评价</span></li>
  </ul>
  <div class="moreCommentDiv" onClick="moreComment();">点击查看更多评价</div>
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
  var commentList; //评论列表
  var currentPage = 0; //当前页码

  var mw = $(window).width();
  var mh0 = $(window).height();
  var mh = 1136*mw/640;
  var jd_doctor_id='<%=doctorQueryModel.getUuid()%>';
  window.onload = function(){
    $('#mainDiv').width(mw);
    $('.top_ul').width(mw).height(mh*0.07);
    $('.top_ul li').height(mh*0.07);
    $('.top_ul li').css('line-height',mh*0.07+'px');

    $('.btmul').width(mw);
    $('.btmul_li').width(mw);
    $('.followDiv').width(mw*0.15).height(mh*0.04);
    $('.followDiv').css('line-height',mh*0.04+'px');

    $('.btmul_li_ul1_li1').width(mw);
    $('.btmul_li_ul1_li1 img').width(mw*0.2).height(mw*0.2);

    $('.timeul1').width(mw);
    $('.timeul1 li').width(mw/7);
    $('.timeul1 li').eq(0).css('background','#FB9D3B');
    $('.timeul1 li').eq(0).find('p').css('color','#FFFFFF');

    $('.dattingul').width(mw);
    $('.dattingul li').width(mw*0.175).height(mh*0.055);
    $('.dattingul li').css('line-height',mh*0.055+'px');
    $('.dattingul').show();

    $('.dayoverul li').width(mw);
    $('.dayoverul_div1').width(mw*0.25).height(mh*0.05);
    $('.dayoverul_div1').css('line-height',mh*0.05+'px');
    $('.dayoverul_div2').width(mw*0.25).height(mh*0.05);
    $('.dayoverul_div2').css('line-height',mh*0.05+'px');

    $('.addressul').width(mw);
    $('.introduceul').width(mw);
    $('.caseul').width(mw);
    $('#mainDiv').show();

    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    commentList = <%=commentList%>;
    getCommentPage(0);

    setdate();
    changeTime(0);
  }

  var day=['周日','周一','周二','周三','周四','周五','周六'];
  function setdate() {
    var dayelements=$(".timeul1p1");
    var elements = $(".timeul1p2");
    var onedayTimes = 1000 * 60 * 60 * 24;
    for (var i = 0; i <7; i++) {
        var date0 = new Date();
        var milliseconds = date0.getTime() + onedayTimes *i;
        var date1 = new Date();
        date1.setTime(milliseconds);
        elements.eq(i).html(date1.getDate());
        var date=date1.getFullYear()+"-"+(date1.getMonth()+1)+"-"+date1.getDate();
        elements.eq(i).attr("date",date);
        dayelements.eq(i).text(day[date1.getDay()])
    }
  }

  function moreComment() {
    var begin = currentPage * 10;
    getCommentPage(begin);
  }

  function getCommentPage(begin) {
    var str = new StringBuilder();
    var index = 0;
    for(var i = begin; i < commentList.length; i++) {
      var comment = commentList[i];
      str.append('<li class="commentul_li"><ul class="commentul_li_ul">');
      str.append('<li class="commentul_li_ul_li1">'+comment.phoneNumber+'</li>');
      str.append('<li class="commentul_li_ul_li2">');
      str.append('<img class="commentul_li_ul_li2_img" src="../../wechat/images/mark'+comment.stars+'.png"/>');
      str.append('<span class="commentul_li_ul_li2_sp">'+comment.orderTime+'</span></li>');
      str.append('<li class="commentul_li_ul_li3">'+comment.comment+'</li></ul></li>');
      index++;
      if(index == 5)
        break;
    }
    if(begin + index >= commentList.length)
      $(".moreCommentDiv").hide();
    else
      $(".moreCommentDiv").show();
    if(commentList.length == 0)
      $(".commentul").append('<li class="commentul_li"><ul class="commentul_li_ul"><li class="commentul_li_ul_li3">暂无用户评价</li></ul></li>');
    else
      $(".commentul").append(str.toString());
    currentPage++;
  }

  //选择日期
  function changeTime(num,date){
    $('.timeul1 li').css('background','#FFFFFF');
    $('.timeul1 li').find('p').css('color','#FB9D3B');
    $('.timeul1 li').eq(num).css('background','#FB9D3B');
    $('.timeul1 li').eq(num).find('p').css('color','#FFFFFF');

    var auditFlag = <%=auditFlag%>;
    if(auditFlag) {
      var elements = $(".timeul1p2");
      var date=elements.eq(num).attr("date");
      var data="availableDate="+date+"&jd_doctor_id="+jd_doctor_id;
      $.ajax({
        type:'GET',
        url:'getDoctorAvailableTimes.htm',
        data:data,
        dataType:'json',
        success:function(msg){
          var sb=new StringBuilder();
          $(".dattingul_li1").remove();
          $(".dattingul_li2").remove();
          for(var i=0;i<msg.length;i++){
            var obj=msg[i];
            if(obj.hasBooked==true){
              sb.append("<li class='dattingul_li2'>");
              var datenumber=Date.parse(obj.dateTime.replace('-','/').replace('-','/'));
              var datetime=new Date();
              datetime.setTime(datenumber);
              sb.append(datetime.getHours()+":"+(datetime.getMinutes()==0?"00":datetime.getMinutes()));
              sb.append("</li>");
            }else{
              sb.append("<li class='dattingul_li1' onclick=\"");
              sb.append("ToDate('");
              sb.append(obj.uuid+"')\">");
              var datenumber=Date.parse(obj.dateTime.replace('-','/').replace('-','/'));
              var datetime=new Date();
              datetime.setTime(datenumber);
              sb.append(datetime.getHours()+":"+(datetime.getMinutes()==0?"00":datetime.getMinutes()));
              sb.append("</li>");
            }
          }
          $(".dattingul").append(sb.toString());
          $('.dattingul li').width(mw*0.175).height(mh*0.055);
          $('.dattingul li').css('line-height',mh*0.055+'px');
        },
        timeout: 20000,
        error:function(){
          var msg = '获取数据失败，请检查网络';
          var btnword = '确定';
          MsgOpt.showMsgBox(msg, btnword);
          return;
        }
      });
    }
  }
  //去预约
  function ToDate(time){
    sendRequest("checkWaitToPayCount.htm", "GET", function(result){
      if(result > 0) {
        var tip = "您有待付款订单，请先支付或取消待付款的订单后，再提交新订单。现在跳转待付款订单列表？";
        if(confirm(tip)) {
          window.location.href = "toOrderList.htm?status=1";
        }
      } else {
        window.location.href = "fillOrder.htm?jd_doctor_id=<%=doctorQueryModel.getUuid()%>&time_id="+time;
      }
    });
  }
  //关注医生
  function follow(){
    var flag = $('.followDiv').attr('alt');
    var data = {flag:flag, doctorId:'<%=doctorQueryModel.getUuid()%>'};
    $.ajax({
      type: 'POST',
      url: 'concern.htm',
      data: data,
      success: function (result) {
        if(result){
          var btnword = '确定';
          MsgOpt.showMsgBox(result, btnword);
        }else{
          if(flag=='add'){
            $('.followDiv').html('已关注');
            $('.followDiv').css('background','#04B45F');
            $('.followDiv').attr('alt','cancel');
          }else{
            $('.followDiv').html('+关注');
            $('.followDiv').css('background','#2882D8');
            $('.followDiv').attr('alt','add');
          }
        }
      },
      timeout: 10000,
      error: function (result) {
        var msg = '获取数据失败，请检查网络';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
      }
    });
  }
  //医生简介展开/收起
  var showIntroduceFlag = false;
  function showAllIntroduce(ob){
    if(showIntroduceFlag) {
      $('#beyondsp').hide();
      $(ob).html("展开全部");
    } else {
      $('#beyondsp').show();
      $(ob).html("收起简介");
    }
    showIntroduceFlag = !showIntroduceFlag;
  }
</script>