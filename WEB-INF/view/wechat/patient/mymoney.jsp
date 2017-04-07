<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%
  JdPatientModel patientModel=(JdPatientModel)request.getAttribute("patientModel");
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

    #mainDiv .moneyul{width:100%;overflow:hidden;}
    #mainDiv .moneyul .moneyul_li1{width:100%;background:#FB9D3B;float:left;padding:1.5em 0 1.5em 0;}
    #mainDiv .moneyul .moneyul_li1 p{width:100%;text-align:center;}
    #mainDiv .moneyul .moneyul_li1 #moneyul_li1_p1{margin-top:2%;font-size:3.8em;color:#FFFFFF;font-weight:bold;}
    #mainDiv .moneyul .moneyul_li1 #moneyul_li1_p2{font-size:1.55em;color:#FFFFFF;}
    #mainDiv .moneyul .moneyul_li2{width:50%;background:#FFFFFF;float:left;padding:1.5em 0 0 0;}
    #mainDiv .moneyul .moneyul_li2 ul{width:100%;overflow:hidden;}
    #mainDiv .moneyul .moneyul_li2 ul li{width:100%;float:left;text-align:center;font-size:1.51em;}

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
    <li>账户余额</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="moneyul">
    <li class="moneyul_li1">
      <p id="moneyul_li1_p1"><%=patientModel.getAccountBalance()%></p>
      <p id="moneyul_li1_p2">账户余额</p>
    </li>
    <li class="moneyul_li2" style="float:left;" onClick="jump(1);">
      <ul>
        <li><img src="../../wechat/images/icon15.png"/></li>
        <li>提现</li>
      </ul>
    </li>
    <li class="moneyul_li2" style="float:right;" onClick="jump(2);">
      <ul>
        <li><img src="../../wechat/images/icon14.png"/></li>
        <li>账户记录</li>
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

    $('.moneyul').width(mw);
    $('.moneyul .moneyul_li1').width(mw).height(mh*0.13);
    $('.moneyul li').eq(1).width(mw*0.499).height(mh*0.1);
    $('.moneyul li').eq(2).width(mw*0.499).height(mh*0.1);
    $('.moneyul_li2 ul').width(mw*0.499).height(mh*0.1);
    $('.moneyul_li2 ul li').width(mw*0.499).height(mh*0.1*0.5);
    $('.moneyul_li2 ul li img').height(mh*0.1*0.5);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

  }

  //跳转连接
  function jump(num){
    if(num==1){
      window.location.href = 'getcash.htm';
    }
    if(num==2){
      window.location.href = 'payRecord.htm';
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