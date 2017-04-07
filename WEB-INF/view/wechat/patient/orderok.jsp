<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.aidee.jdoctor.model.AvailableTimeModel" %>
<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
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

    #mainDiv .showorderNOul{width:100%;overflow:hidden;padding:0 0 0.06em 0;background:#F2F2F2;}
    #mainDiv .showorderNOul li{width:100%;float:left;background:#FFFFFF;padding:1.5em 0 1em 0;text-align:left;}
    #mainDiv .showorderNOul li .showorderNOul_li_sp1{margin-left:2%;font-size:1.6em;color:#000000;}
    #mainDiv .showorderNOul li .showorderNOul_li_sp2{font-size:1.6em;color:#2882D8;}


    #mainDiv .dateul{width:100%;overflow:hidden;padding:0.65em 0 0.65em 0;background:#FFFFFF;border-top:#F0F0F0 0.19em solid;border-bottom:#F0F0F0 0.18em solid;}
    #mainDiv .dateul li{width:100%;float:left;padding:0.3em 0 0.3em 0;}
    #mainDiv .dateul li .title_sp0{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .dateul li .cont_sp0{font-size:1.5em;color:#A4A4A4;float:left;}
    #mainDiv .dateul li .title_sp1{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .dateul li .cont_sp1{font-size:1.5em;color:#A4A4A4;float:left;}
    #mainDiv .dateul li .title_sp2{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .dateul li .cont_sp2{font-size:1.5em;color:#A4A4A4;float:left;}

    #mainDiv .orderul{width:100%;overflow:hidden;padding:0.65em 0 0.65em 0;background:#FFFFFF;}
    #mainDiv .orderul li{width:100%;float:left;padding:0.3em 0 0.3em 0;}
    #mainDiv .orderul li .orderultitle_sp0{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .orderul li .orderulcont_sp0{font-size:1.5em;color:#A4A4A4;float:left;}
    #mainDiv .orderul li .orderulword_sp0{font-size:1.55em;color:#DF0101;float:left;margin-left:1%;}
    #mainDiv .orderul li .orderulphone_div0{font-size:1.43em;color:#FFFFFF;float:right;padding:0.33em 0.75em 0.33em 0.75em;background:#2882D8;margin-right:3%;margin-top:-0.3em;border-radius:0.2em;-webkit-border-radius:0.2em;}
    #mainDiv .orderul li .orderultitle_sp1{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .orderul li .orderulcont_sp1{font-size:1.5em;color:#A4A4A4;float:left;}
    #mainDiv .orderul li .orderultitle_sp2{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .orderul li .orderulcont_sp2{font-size:1.5em;color:#A4A4A4;float:left;}
    #mainDiv .orderul li .orderultitle_sp3{margin-left:2%;font-size:1.5em;color:#000000;float:left;}
    #mainDiv .orderul li .orderulcont_sp3{font-size:1.5em;color:#A4A4A4;float:left;}


    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #mainDiv .okDiv{width:90%;margin-top:1.5em;margin-left:5%;background:#FB9D3B;background-size:auto 43%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;}

    #updatePhoneDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;background:rgba(0,0,0,0.65);display:none;}
    #updatePhoneDiv ul{width:80%;overflow:hidden;margin-left:10%;margin-top:10%;}
    #updatePhoneDiv ul li{float:left;}
    #updatePhoneDiv li:nth-child(1){width:100%;text-align:center; font-size:1.7em;color:#FFFFFF;}
    #updatePhoneDiv li:nth-child(2){border-radius:0.5em;border-radius:0.5em;-webkit-border-radius:0.5em;-webkit-border-radius:0.5em;background:#FFFFFF;}
    #updatePhoneDiv li:nth-child(2) input[type="text"]{width:100%;font-size:1.55em;color:#000000;background:transparent;border:0;-webkit-border:0;float:left;text-align:center;}
    #updatePhoneDiv li:nth-child(3){background:#FB9D3B;margin-top:10%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;}
    #updatePhoneDiv li:nth-child(4){background:#FB9D3B;margin-top:10%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;float:right;}
    .consultation_tips {  padding: 0 12px;  color: #999;  font-size: 15px;  }
    .consultation_tips h2 {  color: #333;  font-size: 17px;  margin-bottom: 5px;  }
    .consultation_tips p {  line-height: 28px;  color: #fe992e;  }
  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="toOrderList.htm?status=2"><li></li></a>
    <li>预约成功</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="showorderNOul">
    <li><span class="showorderNOul_li_sp1">订单编号：</span><span class="showorderNOul_li_sp2"><%=orderModel.getOrderNumber()%></span></li>
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
    </li>
  </ul>
  <ul class="orderul">
    <li>
      <span class="orderultitle_sp0">联系电话：</span>
      <span class="orderulcont_sp0"><%=orderModel.getPhoneNumber()%></span>
      <span class="orderulword_sp0">(请再次确认)</span>
      <div class="orderulphone_div0" onClick="ShowUpdatePhone();">修改</div>
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
    <%
    //是否需要手术治疗
      if(orderModel.getUseOperation()){
    %>
    <li>
      <span class="orderultitle_sp4">需要手术治疗：</span>
      <span class="orderulcont_sp4">是</span>
    </li>
    <%
      }
    %>
  </ul>
  <div class="consultation_tips">
    <p>如需修改点击编辑按钮即可;</p>
    <p>就诊完成后，评价订单即可退还保证金，订单分享到朋友圈，就可以获得10元微信红包。</p>
  </div>
  <div class="okDiv" onClick="confirm();">确认信息</div>
</div>
<div id="MsgBoxDiv">
  <ul>
    <li><p id="msgcontp"></p></li>
    <li id="btnli" onClick="MsgOpt.hideMsgBox();"></li>
  </ul>
</div>
<div id="updatePhoneDiv">
  <ul>
    <li>修改手机号码</li>
    <li><input id="phone" type="text" maxlength="11"/></li>
    <li onClick="CancelUpdate();">取消</li>
    <li onClick="UpdatePhone();">修改</li>
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

    $('.okDiv').width(mw*0.9).height(mh*0.07);
    $('.okDiv').css('line-height',mh*0.07+'px');

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    $('#updatePhoneDiv').width(mw).height(mh);
    $('#updatePhoneDiv li').width(mw*0.8).height(mh*0.069);
    $('#updatePhoneDiv li').eq(0).width(mw*0.8).height(mh*0.069);
    $('#updatePhoneDiv li').eq(1).width(mw*0.8).height(mh*0.069);
    $('#updatePhoneDiv li').eq(2).width(mw*0.8*0.45).height(mh*0.069);
    $('#updatePhoneDiv li').eq(3).width(mw*0.8*0.45).height(mh*0.069);
    $('#updatePhoneDiv li input').width(mw*0.8).height(mh*0.069);
    $('#updatePhoneDiv li').css('line-height',mh*0.069+'px');
    $('#updatePhoneDiv li input').height(mh*0.069);
    $('#updatePhoneDiv ul').css('margin-top',mh*0.1);
  }
  //确认
  function confirm(){
    var phone = $('.orderulcont_sp0').text();
    window.location.href ='notreatDetailOrder.htm?phone='+phone+'&jd_order_id=<%=orderModel.getUuid()%>';
  }

  //显示修改姓名弹窗
  function ShowUpdatePhone(){
    var phone = $('.orderulcont_sp0').text();
    $('#phone').val(phone);
    $('#updatePhoneDiv').show();
  }
  function CancelUpdate(){
    $('#phone').val('');
    $('#updatePhoneDiv').hide();
  }
  function UpdatePhone(){
    var phone = $('#phone').val();
    if(checkphone(phone)){
      $('.orderulcont_sp0').text(phone);
      $('#updatePhoneDiv').hide();
    } else {
      alert('手机号码格式不正确');
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