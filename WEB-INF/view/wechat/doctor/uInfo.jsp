<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.wechat.DoctorDataModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%
  DoctorDataModel doctorDataModel=(DoctorDataModel)request.getAttribute("doctorDataModel");
  JdDoctorModel jdDoctorModel=(JdDoctorModel)request.getAttribute("jdDoctorModel");
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
    #mainDiv .top_ul li:nth-child(1){width:100%;height:100%;font-size:2em;color:#FFFFFF;}

    #mainDiv .head_ul{width:100%;background:#FB9D3B;overflow:hidden;padding:1.6em 0 1.6em 0;}
    #mainDiv .head_ul li{text-align:center;float:left;}
    #mainDiv .head_ul li:nth-child(1){width:100%;margin-top:1%;}
    #mainDiv .head_ul li:nth-child(1) img{height:100%;border-radius:50%;-webkit-border-radius:50%;}
    #mainDiv .head_ul li:nth-child(2){width:100%;color:#FFFFFF;font-size:1.5em;}

    #mainDiv .navi_ul{width:100%;overflow:hidden;padding:0 0 0.15em 0;}
    #mainDiv .navi_ul li{text-align:center;background:#FFFFFF;padding:0.5em 0 0.5em 0;}
    #mainDiv .navi_ul li p{width:100%;text-align:center;display:block;}
    #mainDiv .navi_ul li .navi_ul_p1{margin-top:5%;}
    #mainDiv .navi_ul li .navi_ul_p1 .navimsg{width:45%;font-size:1.45em;color:#DF0101;}
    #mainDiv .navi_ul li .navi_ul_p2{font-size:1.4em;}
    #mainDiv .navi_ul li:nth-child(1){float:left;}
    #mainDiv .navi_ul li:nth-child(2){float:right;}

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;margin-top:0.05em;border-top:#E7E7E7 0.1em solid;border-bottom:#E7E7E7 0.1em solid;-webkit-border-top:#E7E7E7 0.1em solid;-webkit-border-bottom:#E7E7E7 0.1em solid;}
    #mainDiv .btmul #btmul_li1{background:url(../../wechat/images/icon3.png) center left no-repeat #FFFFFF;background-size:auto 58%;background-position:0.8em;}
    #mainDiv .btmul #btmul_li2{background:url(../../wechat/images/icon17.png) center left no-repeat #FFFFFF;background-size:auto 58%;background-position:0.8em;}
    #mainDiv .btmul #btmul_li3{background:url(../../wechat/images/icon18.png) center left no-repeat #FFFFFF;background-size:auto 58%;background-position:0.8em;}
    #mainDiv .btmul #btmul_li4{background:url(../../wechat/images/icon5.png) center left no-repeat #FFFFFF;background-size:auto 58%;background-position:0.8em;}
    #mainDiv .btmul #btmul_li5{background:url(../../wechat/images/icon7.png) center left no-repeat #FFFFFF;background-size:auto 58%;background-position:0.8em;}
    #mainDiv .btmul #btmul_li6{background:url(../../wechat/images/icon8.png) center left no-repeat #FFFFFF;background-size:auto 58%;background-position:0.8em;}
    #mainDiv .btmul li .btmul_liDiv{background:url(../../wechat/images/icon6.png) center right no-repeat;background-size:auto 56%;font-size:1.6em;margin-left:12%;}
    #mainDiv .btmul li .btmul_liDiv span{color:#DF0101;margin-left:1%;}

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
    <li>个人中心</li>
  </ul>
  <ul class="head_ul">
    <li><img id="uheadimg" src="<%=jdDoctorModel.getHeadPic()%>"/></li>
    <li><%=jdDoctorModel.getName()%></li>
  </ul>
  <ul class="navi_ul">
    <li clas="navi_ul_li" onClick="seekMsg(1);">
      <p class="navi_ul_p1"><span id="navi_msg1" class="navimsg"><%=doctorDataModel.getNoTreat()%></span></p>
      <p class="navi_ul_p2">待出诊</p>
    </li>
    <li clas="navi_ul_li" onClick="seekMsg(2);">
      <p class="navi_ul_p1"><span id="navi_msg2" class="navimsg"><%=doctorDataModel.getTreated()%></span></p>
      <p class="navi_ul_p2">已出诊</p>
    </li>
  </ul>
  <ul class="btmul">
    <li id="btmul_li1" class="btmul_li" onClick="BtmJump(1);">
      <div class="btmul_liDiv">我的资料</div>
    </li>
    <li id="btmul_li2" class="btmul_li" onClick="BtmJump(2);">
      <div class="btmul_liDiv">出诊安排<span id="followDoc"></span></div>
    </li>
    <li id="btmul_li3" class="btmul_li" onClick="BtmJump(3);">
      <div class="btmul_liDiv">我的患者<span id="patient"></span></div>
    </li>
    <li id="btmul_li4" class="btmul_li" onClick="BtmJump(4);">
      <div class="btmul_liDiv">账户余额<span id="money"></span></div>
    </li>
    <li id="btmul_li5" class="btmul_li" onClick="BtmJump(5);">
      <div class="btmul_liDiv">我的消息<span id="message">(<%=doctorDataModel.getMsgCount()%>)</span></div>
    </li>
    <li id="btmul_li6" class="btmul_li" onClick="BtmJump(6);">
      <div class="btmul_liDiv">设置</div>
    </li>
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

    $('.head_ul').width(mw).height(mh*0.11);
    $('.head_ul li').eq(0).height(mh*0.11*0.55);
    $('.head_ul li').eq(1).height(mh*0.11*0.45);
    $('.head_ul li').eq(1).css('line-height',mh*0.11*0.45+'px');

    $('.navi_ul').width(mw).height(mh*0.1);
    $('.navi_ul li').width(mw*0.499).height(mh*0.07);

    $('.btmul').width(mw);
    $('.btmul li').width(mw).height(mh*0.083);
    $('.btmul_liDiv').width(mw*0.87).height(mh*0.083);
    $('.btmul_liDiv').css('line-height',mh*0.083+'px');

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);
  };

  //查看消息
  function seekMsg(num){
    switch(num){
      case 1:
        window.location.href = 'notreatOrder.htm';
        break;
      case 2:
        window.location.href = 'treatedOrder.htm';
        break;

    }
  }
  //查看底部导航栏消息
  function BtmJump(num){
    switch(num){
      case 1:
        window.location.href = 'myinfo.htm';
        break;
      case 2:
        window.location.href = 'treatingPlan.htm';
        break;
      case 3:
        window.location.href = 'mypatient.htm';
        break;
      case 4:
        window.location.href = 'mymoney.htm';
        break;
      case 5:
        window.location.href = 'message.htm';
        break;
      case 6:
        window.location.href = 'updatepwd.htm';
        break;
    }
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