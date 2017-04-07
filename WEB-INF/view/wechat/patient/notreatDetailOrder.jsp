<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.AvailableTimeModel" %>
<%
  JdOrderModel orderModel=(JdOrderModel)request.getAttribute("orderModel");
  JdDoctorModel doctorModel=(JdDoctorModel)request.getAttribute("doctorModel");
  AvailableTimeModel availableTime =(AvailableTimeModel)request.getAttribute("availableTime");
  String address = (String)request.getAttribute("address");
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

    #mainDiv .shownumberul{width:100%;overflow:hidden;padding:0 0 0.06em 0;background:#F2F2F2;border-top:#F0F0F0 0.19em solid;border-bottom:#F0F0F0 0.18em solid;}
    #mainDiv .shownumberul li{width:100%;float:left;background:#FFFFFF;padding:1.5em 0 1em 0;}
    #mainDiv .shownumberul li .shownumberul_li_sp1{float:left;margin-left:2%;font-size:1.6em;color:#000000;}
    #mainDiv .shownumberul li .shownumberul_li_sp2{float:left;font-size:1.6em;color:#BDBDBD;}
    #mainDiv .shownumberul li .shownumberul_li_sp3{margin-right:2%;float:right;font-size:1.6em;color:#DF0101;}


    #mainDiv .dateul{width:100%;overflow:hidden;padding:0.6em 0 0.6em 0;background:#FFFFFF;border-top:#F0F0F0 0.125em solid;}
    #mainDiv .dateul li{width:100%;float:left;padding:0.3em 0 0.3em 0;}
    #mainDiv .dateul li .title_sp0{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .dateul li .cont_sp0{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .dateul li .title_sp1{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .dateul li .cont_sp1{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .dateul li .title_sp2{margin-left:2%;font-size:1.4em;color:#000000;}
    #mainDiv .dateul li .cont_sp2{font-size:1.4em;color:#A4A4A4;}
    #mainDiv .dateul li .cont_li2_div{width:30%;font-size:1.4em;color:#FB9D3B;padding:0.3em;text-align:center;border-radius:0.2em;-webkit-border-radius:0.2em;border:#FB9D3B 0.12em solid;-webkit-border:#FB9D3B 0.12em solid;margin-left:22%;}

    #mainDiv .orderul{width:100%;overflow:hidden;padding:0.6em 0 0.6em 0;background:#FFFFFF;}
    #mainDiv .orderul li{width:100%;float:left;padding:0.3em 0 0.3em 0;}
    #mainDiv .orderul li .orderultitle_sp0{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .orderul li .orderulcont_sp0{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .orderul li .orderultitle_sp1{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .orderul li .orderulcont_sp1{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .orderul li .orderultitle_sp2{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .orderul li .orderulcont_sp2{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .orderul li .orderultitle_sp3{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .orderul li .orderulcont_sp3{font-size:1.55em;color:#A4A4A4;float:left;}

    #mainDiv .moneyul{width:100%;overflow:hidden;padding:0.65em 0 0 0;background:#FFFFFF;border-top:#F0F0F0 0.1em solid;border-bottom:#F0F0F0 0.1em solid;}
    #mainDiv .moneyul li{width:100%;float:left;padding:0.3em 0 0.3em 0;}
    #mainDiv .moneyul li .moneyultitle_sp0{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .moneyul li .moneyulcont_sp0{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .moneyul li .moneyultitle_sp1{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .moneyul li .moneyulcont_sp1{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .moneyul li .moneyultitle_sp2{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .moneyul li .moneyulcont_sp2{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .moneyul li .moneyultitle_sp3{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .moneyul li .moneyulcont_sp3{font-size:1.55em;color:#A4A4A4;float:left;}
    #mainDiv .moneyul li .moneyultitle_sp4{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .moneyul li .moneyulcont_sp4{font-size:1.55em;color:#FB9D3B;float:left;}
    #mainDiv .moneyul li:nth-child(4){margin-bottom:0.5em;}
    #mainDiv .moneyul .moneyul_li4{padding:1.2em 0 1.2em 0;border-top:#F0F0F0 0.12em solid;border-bottom:#F0F0F0 0.12em solid;}


    #mainDiv .btnul{width:100%;margin-top:2.1em;overflow:hidden;padding-bottom:1.8em;}
    #mainDiv .btnul li{width:96%;margin-left:2%;float:left;text-align:center;font-size:1.6em;color:#FFFFFF;background:#FB9D3B;border-radius:0.3em;-webkit-border-radius:0.3em;}

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
    <a href="toOrderList.htm?status=2"><li></li></a>
    <li>待就诊订单</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="shownumberul">
    <li><span class="shownumberul_li_sp1">订单编号：</span><span class="shownumberul_li_sp2"><%=orderModel.getOrderNumber()%></span></li>
  </ul>
  <ul class="orderul">
    <li>
      <span class="orderultitle_sp0">联系电话：</span>
      <span class="orderulcont_sp0"><%=orderModel.getPhoneNumber()%></span>
    </li>
    <li>
      <span class="orderultitle_sp1">患者姓名：</span>
      <span class="orderulcont_sp1"><%=orderModel.getName()%></span>
    </li>
    <li>
      <span class="orderultitle_sp2">患者年龄：</span>
      <span class="orderulcont_sp2"><%=orderModel.getAge()%></span>
    </li>
    <li>
      <span class="orderultitle_sp3">病情描述：</span>
      <span class="orderulcont_sp3"><%=orderModel.getSickDescription()%></span>
    </li>
  </ul>
  <ul class="dateul">
    <li>
      <span class="title_sp0">预约医生：</span>
      <span class="cont_sp0"><%=doctorModel.getName()%></span>
    </li>
    <li>
      <span class="title_sp1">预约时间：</span>
      <span class="cont_sp1"><%=DateUtils.format(availableTime.getDateTime(), "yyyy-MM-dd HH:mm")%>&nbsp;&nbsp;<%=DateUtils.getWeekOfDate(availableTime.getDateTime())%></span>
    </li>
    <li>
      <span class="title_sp2">就诊地址：</span>
      <span class="cont_sp2"><%=address%></span>
      <div class="cont_li2_div" onClick="trafficGuide();">详细路线</div>
    </li>
  </ul>
  <ul class="moneyul">
    <%
      if(orderModel.getExceed() != null && orderModel.getExceed().length() > 0) {
    %>
      <li>
        <span class="moneyultitle_sp0">专家诊金：</span>
        <span class="moneyulcont_sp0"><%=orderModel.getConsultationFee()%>元<font style="color:#DF0101;">(诊金是给医生的咨询费，评价后不可返还)</font></span>
      </li>
    <%
      } else if(orderModel.getConsultationFee().subtract(orderModel.getSubsidy()).intValue() > 0) {
    %>
      <li>
        <span class="moneyultitle_sp0">专家诊金：</span>
        <span class="moneyulcont_sp0"><%=orderModel.getConsultationFee()%>元<font style="color:#DF0101;">(诊金是给医生的咨询费，评价后不可返还)</font></span>
      </li>
      <li>
        <span class="moneyultitle_sp1">平台补贴：</span>
        <span class="moneyulcont_sp1"><%=orderModel.getSubsidy()%>元</span>
      </li>
    <%
      }
    %>
    <li>
      <span class="moneyultitle_sp2">保证金：</span>
      <span class="moneyulcont_sp2"><%=orderModel.getDeposit()%>元<font style="color:#DF0101;">(就医结束，评价后即可返还)</font></span>
    </li>
    <li class="moneyul_li4">
      <span class="moneyultitle_sp4">合计：</span>
      <span class="moneyulcont_sp4"><%=orderModel.getTotalFee()%>元</span>
    </li>
  </ul>
  <ul class="btnul">
    <li onClick="jump();">取消预约</li>
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

    $('.btnul').width(mw);
    $('.btnul li').width(mw*0.96).height(mh*0.07);
    $('.btnul li').css('line-height',mh*0.07+'px');

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

  }

  var showflag = false;
  function orderDetail(){
    if(showflag){
      $('.payul_li2_ul').hide();
      showflag = false;
    }else{
      $('.payul_li2_ul').show();
      showflag = true;
    }
  }

  function trafficGuide(){
    window.location.href = "trafficGuide.htm?orderId=<%=orderModel.getUuid()%>";
  }

  var payDate = <%=orderModel.getPayedDate()==null?0:orderModel.getPayedDate().getTime()%>;
  //取消预约
  var cancelFlg = false;
  function jump(){
    if(!cancelFlg) {
      cancelFlg = true;
      var diff = (new Date().getTime()-payDate) / 1000;
      var tip;
      if(diff > 3600) { //超过一小时
        tip = '预约取消，将只返回20%保证金到您的账户余额！确定吗？';
      } else {
        tip = '预约取消，保证金将返回您的账户余额！';
      }
      if(confirm(tip)){
        $.ajax({
          type:'GET',
          url:'deleteNotreatOrder.htm?orderId=<%=orderModel.getUuid()%>',
          success:function(msg){
            if(msg=="success"){
              window.location.href = "toPersonal.htm";
            } else if(msg=="canceled"){
              var msg = '此订单不是待就诊状态';
              var btnword = '确定';
              MsgOpt.showMsgBox(msg, btnword, "toPersonal.htm");
            } else if(msg=="nologin"){
              var msg = '页面过期，请重新从公众号进入页面';
              var btnword = '确定';
              MsgOpt.showMsgBox(msg, btnword, "toPersonal.htm");
            }
          },
          timeout: 10000,
          error:function(){
            var msg = '请检查网络';
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword);
            return;
          }
        });
      } else {
        cancelFlg = false;
      }
    }
  }

  //消息弹窗类
  var MsgOpt = {
    msgt:null,
    href:null,
    showMsgBox:function(msg, btnword, href){
      var mythis = this;
      if(href)
        mythis.href = href;
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
      if(mythis.href)
        window.location.href = mythis.href;
    }
  };

</script>