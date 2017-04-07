<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdAddressQueryModel" %>
<%
  JdAddressQueryModel address = (JdAddressQueryModel)request.getAttribute("address");
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

    #mainDiv .localul{width:100%;overflow:hidden;margin-bottom:1.8em;}
    #mainDiv .localul li{width:100%;background:url(../../wechat/images/icon26.png) center left no-repeat #FFFFFF;background-size:10% auto;padding:1.65em 0 1.65em 0;float:left;}
    #mainDiv .localul li p{width:87%;font-size:1.53em;color:#000000;float:right;}

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;margin-top:3%;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul li{width:96%;margin-left:2%;float:left;}
    #mainDiv .btmul .btmul_li ul .cont_li0{width:100%;margin-left:0;padding:0.5em 0 0.5em 0;background:#F2F2F2;}
    #mainDiv .btmul .btmul_li ul .cont_li0 .cont_li0_p1{width:100%;margin-left:2%;font-size:1.6em;color:#000000;}
    #mainDiv .btmul .btmul_li ul .cont_li1{padding:0.5em 0 0.5em 0;font-size:1.53em;color:#000000;border-bottom:#E6E6E6 0.11em solid;-webkit-border-bottom:#E6E6E6 0.11em solid;}
    #mainDiv .btmul .btmul_li ul .cont_li2{padding:0.5em 0 0.5em 0;font-size:1.53em;color:#000000;border-bottom:#E6E6E6 0.11em solid;-webkit-border-bottom:#E6E6E6 0.11em solid;}
    #mainDiv .btmul .btmul_li ul .cont_li3{padding:0.5em 0 0.5em 0;font-size:1.53em;color:#000000;}


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
    <li>详细路线</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="localul">
    <li><p>地点：<%=address.getAddress()%></p></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul>
        <li class="cont_li0">
          <p class="cont_li0_p1">交通/停车</p>
        </li>
        <li class="cont_li1">
            <%
              String[] tips = address.getTrafficGuide().split("\n");
              for(String tip : tips) {
                if(tip.equals(""))
                  out.println("<br/>");
                else
                  out.println("<p class=\"cont_li1_p1\">"+tip+"</p>");
              }
            %>
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