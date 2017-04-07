<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.AvailableTimeModel" %>
<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%
  JdOrderQueryModel order = (JdOrderQueryModel)request.getAttribute("order");
  AvailableTimeModel availableTime =(AvailableTimeModel)request.getAttribute("availableTime");
  long minute = (Long)request.getAttribute("minute");
  long second = (Long)request.getAttribute("second");
  Boolean hasPayed = (Boolean)request.getAttribute("hasPayed");
%>
<!DOCTYPE html>
<html>
<head>
  <jsp:include page="../../include/head.jsp" />
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

    #mainDiv .showtimeul{width:100%;overflow:hidden;padding:0 0 0.06em 0;background:#F2F2F2;}
    #mainDiv .showtimeul li{width:100%;float:left;background:#FFFFFF;padding:1.5em 0 1em 0;text-align:center;}
    #mainDiv .showtimeul li .showtimeul_li_sp1{font-size:1.6em;color:#000000;}
    #mainDiv .showtimeul li .showtimeul_li_sp2{font-size:1.6em;color:#2882D8;}

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
    #mainDiv .dateul li .title_sp2{margin-left:2%;font-size:1.55em;color:#000000;float:left;}
    #mainDiv .dateul li .cont_sp2{font-size:1.55em;color:#A4A4A4;float:left;}

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
    #mainDiv .btnul li{text-align:center;font-size:1.6em;color:#FFFFFF;background:#FB9D3B;border-radius:0.3em;-webkit-border-radius:0.3em;}
    #mainDiv .btnul li:nth-child(1){width:43%;float:left;margin-left:3%;background:#2882D8;}
    #mainDiv .btnul li:nth-child(2){width:43%;float:right;margin-right:3%;}

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
    <li>待付款订单</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="showtimeul">
    <li><span class="showtimeul_li_sp1">剩余支付时间：</span><span class="showtimeul_li_sp2"><%=minute%>:<%=second%></span></li>
  </ul>
  <ul class="shownumberul">
    <li><span class="shownumberul_li_sp1">订单编号：</span><span class="shownumberul_li_sp2"><%=order.getOrderNumber()%></span></li>
  </ul>
  <ul class="orderul">
    <li>
      <span class="orderultitle_sp0">联系电话：</span>
      <span class="orderulcont_sp0"><%=order.getPhoneNumber()%></span>
    </li>
    <li>
      <span class="orderultitle_sp1">患者姓名：</span>
      <span class="orderulcont_sp1"><%=order.getName()%></span>
    </li>
    <li>
      <span class="orderultitle_sp2">患者年龄：</span>
      <span class="orderulcont_sp2"><%=order.getAge()%>岁</span>
    </li>
    <li>
      <span class="orderultitle_sp3">病情描述：</span>
      <span class="orderulcont_sp3"><%=order.getSickDescription()%></span>
    </li>
  </ul>
  <ul class="dateul">
    <li>
    <span class="title_sp0">预约医生：</span>
      <span class="cont_sp0"><%=order.getDoctor()%></span>
    </li>
    <li>
      <span class="title_sp1">预约时间：</span>
      <span class="cont_sp1"><%=DateUtils.format(availableTime.getDateTime(), "yyyy-MM-dd HH:mm")%>&nbsp;&nbsp;<%=DateUtils.getWeekOfDate(availableTime.getDateTime())%></span>
    </li>
    <li>
      <span class="title_sp2">就诊地址：</span>
      <span class="cont_sp2"><%=order.getAppointmentAddress()%></span>
    </li>
  </ul>
  <ul class="moneyul">
    <%
      if(order.getExceed() != null && order.getExceed().length() > 0) {
    %>
      <li>
        <span class="moneyultitle_sp0">专家诊金：</span>
        <span class="moneyulcont_sp0"><%=order.getConsultationFee()%>元<font style="color:#DF0101;">(诊金是给医生的咨询费，评价后不可返还)</font></span>
      </li>
    <%
      } else if(order.getConsultationFee().subtract(order.getSubsidy()).intValue() > 0) {
    %>
      <li>
        <span class="moneyultitle_sp0">专家诊金：</span>
        <span class="moneyulcont_sp0"><%=order.getConsultationFee()%>元<font style="color:#DF0101;">(诊金是给医生的咨询费，评价后不可返还)</font></span>
      </li>
      <li>
        <span class="moneyultitle_sp1">平台补贴：</span>
        <span class="moneyulcont_sp1"><%=order.getSubsidy()%>元</span>
      </li>
    <%
      }
    %>
    <li>
      <span class="moneyultitle_sp2">保证金：</span>
      <span class="moneyulcont_sp2"><%=order.getDeposit()%>元<font style="color:#DF0101;">(就医结束，评价后即可返还)</font></span>
    </li>
    <li class="moneyul_li4">
      <span class="moneyultitle_sp4">合计：</span>
      <span class="moneyulcont_sp4"><%=order.getTotalFee()%>元</span>
    </li>
  </ul>
  <ul class="btnul">
    <li onClick="todelete();">删除</li>
    <li onClick="topay();">确认支付</li>
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
  //倒计时
  var m =<%=minute%>;
  var s =<%=second%>;
  var hasPayed = <%=hasPayed%>;
  var t = null;
  var overflag = 0;
  function GetRTime(){
    if(s.toString().length==1){
      if(m.toString().length==1){
        $('.showtimeul_li_sp2').html('0'+m+':0'+s);
      }else{
        $('.showtimeul_li_sp2').html(m+':0'+s);
      }
    }else{
      if(m.toString().length==1){
        $('.showtimeul_li_sp2').html('0'+m+':'+s);
      }else{
        $('.showtimeul_li_sp2').html(m+':'+s);
      }
    }
    if(s==0){
      s = 59;
      if(m==0){
        overflag = 1;
        clearTimeout(t);
        return;
      }
      m-=1;
    }
    s -=1;
    t = setTimeout(function(){GetRTime();},1000);
  }

  var mw = $(window).width();
  var mh0 = $(window).height();
  var mh = 1136*mw/640;
  window.onload = function(){
    if(hasPayed){
      var msg = '您的订单已成功付款！';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword, "toOrderList.htm?status=1");
    } else if(m == 0 && s == 0) {
      var msg = '您的订单已超过30分钟未支付，订单已被取消！';
      var btnword = '确定';
      MsgOpt.showMsgBox(msg, btnword, "toOrderList.htm?status=1");
    }
    $('#mainDiv').width(mw);
    $('.top_ul').width(mw).height(mh*0.07);
    $('.top_ul li').height(mh*0.07);
    $('.top_ul li').css('line-height',mh*0.07+'px');

    $('.btnul').width(mw);
    $('.btnul li').width(mw*0.43).height(mh*0.07);
    $('.btnul li').css('line-height',mh*0.07+'px');

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    GetRTime();
  }

  //删除订单
  function todelete(){
    if(confirm('订单删除将无法恢复，确认删除？')){
      $.ajax({
        type:'GET',
        url:'deleteNopayOrder.htm?orderId=<%=order.getUuid()%>',
        success:function(msg){
          if(msg=="success"){
            window.location.href = "toOrderList.htm?status=1";
          } else if(msg=="hasPayed") {
            var msg = '您的订单已成功付款！';
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword, "toOrderList.htm?status=1");
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
    }
  }

  var payflag = false;
  function topay(){
    if(payflag) return;
    payflag = true;
    if(overflag==1){
      $.ajax({
        type:'GET',
        url:'deleteNopayOrder.htm?orderId=<%=order.getUuid()%>',
        success:function(msg){
          if(msg=="success"){
            var msg = '您的订单已超过30分钟未支付，订单已被取消！';
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword, "toOrderList.htm?status=1");
          } else if(msg=="hasPayed") {
            var msg = '您的订单已成功付款！';
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword, "toOrderList.htm?status=1");
          }
        },
        timeout: 10000,
        error:function(){
          var msg = '请检查网络';
          var btnword = '确定';
          MsgOpt.showMsgBox(msg, btnword);
        }
      });
      return;
    } else {
      $.ajax({
        url:"toPay.htm?orderId=<%=order.getUuid()%>",
        method:'get',
        success:function(data) {
          var obj = data;
          if(obj.loginTimeout) {
            var msg = "登录超时，请重新登录";
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword, "toLogin.htm");
          } else if(obj.hasPayed) {
            var msg = "您已成功付款";
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword, "toOrderList.htm?status=2");
          } else if(obj.balance) {
            window.location.href = obj.notifyUrl;
          } else {
            if (parseInt(obj.agent) < 5) {
              var msg = "您的微信版本低于5.0无法使用微信支付";
              var btnword = '确定';
              MsgOpt.showMsgBox(msg, btnword);
              return;
            }
            var tip = "您的账户余额不足，还需支付"+obj.amount+"元保证金";
            if(confirm(tip)) {
              WeixinJSBridge.invoke('getBrandWCPayRequest', {
                "appId": obj.appId,                  //公众号名称，由商户传入
                "timeStamp": obj.timeStamp,          //时间戳，自 1970 年以来的秒数
                "nonceStr": obj.nonceStr,         //随机串
                "package": obj.package,      //<span style="font-family:微软雅黑;">商品包信息</span>
                "signType": obj.signType,        //微信签名方式:
                "paySign": obj.paySign           //微信签名
              }, function (res) {
                if (res.err_msg == "get_brand_wcpay_request:ok") {
                  window.location.href = "wechatOrderok.htm?orderId=<%=order.getUuid()%>";
                } else {
                  payflag = false;
                  var msg = '付款失败';
                  var btnword = '确定';
                  MsgOpt.showMsgBox(msg, btnword);
                }
              });
            } else {
              payflag = false;
            }
          }
        },
        timeout:10000,
        error:function(){
          var msg = '请检查网络';
          var btnword = '确定';
          MsgOpt.showMsgBox(msg, btnword);
        }
      });
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
