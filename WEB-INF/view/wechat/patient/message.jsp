<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.JdPushTextMessageQueryModel" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  List<JdPushTextMessageQueryModel> pushTextMessageQueryModelList=(List<JdPushTextMessageQueryModel>)request.getAttribute("pushTextMessageQueryModelList");
%>
<!DOCTYPE html>
<html>
<head>
  <jsp:include page="../include/head.jsp" />
  <style>
    html,body{width:100%;height:100%;margin:0;padding:0;font-size:100%;background:#F2F2F2;}
    a{color:#000000;-webkit-tap-highlight-color: transparent;}
    img,li,div{-webkit-tap-highlight-color:transparent;}
    #mainDiv{width:100%;display:none;padding-bottom:3em;}
    #mainDiv .top_ul{width:100%;background:#FB9D3B;overflow:hidden;}
    #mainDiv .top_ul li{text-align:center;float:left;}
    #mainDiv .top_ul li:nth-child(1){width:11.5%;height:100%;background:url(../../wechat/images/larrow.png) center left no-repeat;background-size:70% auto;}
    #mainDiv .top_ul li:nth-child(2){width:76%;height:100%;font-size:2em;color:#FFFFFF;}
    #mainDiv .top_ul li:nth-child(3){width:12%;height:100%;}
    #mainDiv .top_ul li:nth-child(3) a{font-size:1.6em;color:#FFFFFF;}

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;margin-top:3%;background:#FFFFFF;padding:0.5em 0 0.5em 0;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul li{width:100%;float:left;margin-top:1.5%;padding:0.5em 0 0.5em 0;}
    #mainDiv .btmul .btmul_li ul .cont_li1_sp1{font-size:1.55em;color:#000000;margin-left:3%;}
    #mainDiv .btmul .btmul_li ul .cont_li1_sp2{font-size:1.55em;color:#FB9D3B;}
    #mainDiv .btmul .btmul_li ul .cont_li2_sp1{font-size:1.55em;color:#000000;margin-left:3%;}
    #mainDiv .btmul .btmul_li ul .cont_li2_sp2{font-size:1.55em;color:#000000;margin-left:1%;}
    #mainDiv .btmul .btmul_li ul .cont_li2_sp3{font-size:1.55em;color:#000000;margin-left:1.5%;}
    #mainDiv .btmul .btmul_li ul .cont_li2{border-bottom:#E6E6E6 0.15em solid;-webkit-border-bottom:#E6E6E6 0.15em solid;}
    #mainDiv .btmul .btmul_li ul .cont_li3{padding:0.45em 0 0.45em 0;}
    #mainDiv .btmul .btmul_li ul .cont_li3_sp1{margin-left:3%;font-size:1.55em;color:#000000;padding:0.45em 0 0.45em 0;}
    #mainDiv .btmul .btmul_li ul .cont_li4{padding:0.35em 0 0.35em 0;}
    #mainDiv .btmul .btmul_li ul .cont_li4_p1{margin-left:3%;font-size:1.55em;color:#000000;padding:0.35em 0 0.35em 0;}

    #mainDiv .moreDiv{width:100%;margin-top:3%;padding:0.91em 0 0.91em 0;border-top:#FB9D3B 0.055em solid;-webkit-border-top:#FB9D3B 0.055em solid;border-bottom:#FB9D3B 0.055em solid;-webkit-border-bottom:#FB9D3B 0.055em solid;color:#FB9D3B;font-size:1.6em;text-align:center;background:#FFFFFF;}

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
    <li>消息</li>
    <li><a href="uInfo.htm">首页</a></li>
  </ul>
  <ul class="btmul">
    <%
      for(int i=0;i<pushTextMessageQueryModelList.size();i++){
        JdPushTextMessageQueryModel model=pushTextMessageQueryModelList.get(i);
        %>
    <li class="btmul_li">
      <ul>
        <li class="cont_li1">
          <span class="cont_li1_sp1">预约号：</span>
          <span class="cont_li1_sp2"><%=model.getOrderNumber()%></span>
        </li>
        <li class="cont_li2">
          <span class="cont_li2_sp1">预约时间：</span>
          <span class="cont_li2_sp2"><%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(model.getOppointmentDate())%></span>
          <span class="cont_li2_sp3"><%=model.getName()%></span>
        </li>
        <li class="cont_li3"><span class="cont_li3_sp1"><%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(model.getCreateDate())%></span></li>
        <li class="cont_li4"><p class="cont_li4_p1"><%=model.getContent()%></p></li>
      </ul>
    </li>
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
  var mh = 1136*mw/640;
  window.onload = function(){
    $('#mainDiv').width(mw);
    $('.top_ul').width(mw).height(mh*0.07);
    $('.top_ul li').height(mh*0.07);
    $('.top_ul li').css('line-height',mh*0.07+'px');

    $('.btmul').width(mw);
    $('.btmul_li').width(mw);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

  }

  //跳转到消息详细页面
  function jump(msgID){
    window.location.href = '你的域名?msgID='+msgID;
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