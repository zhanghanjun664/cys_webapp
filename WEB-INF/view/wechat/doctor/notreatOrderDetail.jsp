<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdHospitalModel" %>
<%@ page import="cn.aidee.jdoctor.model.AvailableTimeModel" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  JdOrderModel orderModel=(JdOrderModel)request.getAttribute("orderModel");
  JdDoctorModel doctorModel=(JdDoctorModel)request.getAttribute("doctorModel");
  AvailableTimeModel availableTimeModel=(AvailableTimeModel)request.getAttribute("availableTimeModel");
  String address=(String)request.getAttribute("address");
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

    #mainDiv .navi_ul{width:100%;overflow:hidden;border-bottom:#D8D8D8 0.05em solid;-webkit-border-bottom:#D8D8D8 0.05em solid;}
    #mainDiv .navi_ul li{width:49.83%;float:left;text-align:center;padding:1.1em 0 1.1em 0;background:#FAFAFA;}
    #mainDiv .navi_ul li:nth-child(1){float:left;font-size:1.55em;color:#FB9D3B;border-bottom:#FB9D3B 0.17em solid;-webkit-border-bottom:#FB9D3B 0.17em solid;}
    #mainDiv .navi_ul li:nth-child(2){float:right;font-size:1.55em;color:#000000;}

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1{width:100%;padding:1.5em 0 1.5em 0;border-bottom:#F1F1F1 0.13em solid;-webkit-border-bottom:#F1F1F1 0.13em solid;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 .btmul_li_ul_li1_sp1{font-size:1.5em;margin-left:3%;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 .btmul_li_ul_li1_sp2{font-size:1.5em;margin-right:3%;float:right;color:#DF0101;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2{width:100%;padding:1.6em 0 1.6em 0;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li2 p{width:94%;padding:0.2em 0 0.2em 0;margin-left:3%;font-size:1.55em;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3{width:100%;padding:1.6em 0 1.6em 0;border-top:#F1F1F1 0.12em solid;-webkit-border-top:#F1F1F1 0.12em solid;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li3 p{width:94%;padding:0.2em 0 0.2em 0;margin-left:3%;font-size:1.55em;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li4{width:100%;padding:1.5em 0 1.5em 0;border-top:#F1F1F1 0.12em solid;-webkit-border-top:#F1F1F1 0.12em solid;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li4 .btmul_li_ul_li4_sp1{font-size:1.5em;margin-left:3%;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li4 .btmul_li_ul_li4_sp2{font-size:1.72em;margin-right:3%;float:right;color:#FB9D3B;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li4 .btmul_li_ul_li4_sp3{font-size:1.72em;margin-right:8%;float:right;color:#FB9D3B;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li5{width:100%;padding:1.2em 0 1.2em 0;background:#F2F2F2;float:left;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li5 .btmul_li_ul_li5_sp1{font-size:1.5em;margin-left:3%;float:left;color:#858585;}

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
    <a href="javascript:history.back();"><li></li></a>
    <li>待出诊订单详情</li>
    <li></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul">
        <li class="btmul_li_ul_li1">
          <span class="btmul_li_ul_li1_sp1"><%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(availableTimeModel.getDateTime())%></span>
          <span class="btmul_li_ul_li1_sp2">待出诊</span>
        </li>
        <li class="btmul_li_ul_li2">
          <p class="btmul_li_ul_li2_p1">患者姓名：<font style="color:#A4A4A4;"><%=orderModel.getName()%></font></p>
          <p class="btmul_li_ul_li2_p2">联系手机：<font style="color:#A4A4A4;"><%=orderModel.getPhoneNumber()%></font></p>
          <p class="btmul_li_ul_li2_p3">患者年龄：<font style="color:#A4A4A4;"><%=orderModel.getAge()%></font></p>
          <p class="btmul_li_ul_li2_p4">病情描述：<font style="color:#A4A4A4;"><%=orderModel.getSickDescription()%></font></p>
        </li>
        <li class="btmul_li_ul_li3">
          <p class="btmul_li_ul_li3_p1">医生：<font style="color:#A4A4A4;"><%=doctorModel.getName()%></font></p>
          <p class="btmul_li_ul_li3_p3">地点：<font style="color:#A4A4A4;"><%=address%></font></p>
        </li>
        <li class="btmul_li_ul_li4">
          <span class="btmul_li_ul_li4_sp1">诊金：<font style="color:#FB9D3B;"><%=orderModel.getConsultationFee()%>元</font></span>
        </li>
        <li class="btmul_li_ul_li5">
        </li>
      </ul>
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

    $('.btmul').width(mw);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    $('#addOrderDiv').width(mw).height(mh);
    $('#addOrderDiv li input').height(mh*0.065);
    $('#addOrderDiv li').eq(1).height(mh*0.065);
    $('#addOrderDiv li').eq(2).height(mh*0.065);
    $('#addOrderDiv li').eq(1).css('line-height',mh*0.069+'px');
    $('#addOrderDiv li').eq(2).css('line-height',mh*0.069+'px');
    $('#addOrderDiv ul').css('margin-top',mh*0.12);

    $('#cancelDiv').width(mw).height(mh);
    $('#cancelDiv li textarea').height(mh*0.11);
    $('#cancelDiv li').eq(1).height(mh*0.065);
    $('#cancelDiv li').eq(2).height(mh*0.065);
    $('#cancelDiv li').eq(1).css('line-height',mh*0.069+'px');
    $('#cancelDiv li').eq(2).css('line-height',mh*0.069+'px');
    $('#cancelDiv ul').css('margin-top',mh*0.12);

  }

  function jump(orderID){
    window.location.href = '你的域名?orderID='+orderID;
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