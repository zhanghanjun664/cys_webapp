<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdSickQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.JdSickCategaryQueryModel" %>
<%
  List<JdSickQueryModel> sickQueryModelList=(List<JdSickQueryModel>)request.getAttribute("sickQueryModelList");
  List<JdSickCategaryQueryModel> sickCategaryQueryModelList=(List<JdSickCategaryQueryModel>)request.getAttribute("sickCategaryQueryModelList");
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

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;background:#F2F2F2;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;margin-bottom:0.1em;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li .btmul_li_p1{width:100%;background:url(../../wechat/images/icon25.png) center right no-repeat #FFFFFF;background-size:7% auto;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;padding:1.6em 0 1.6em 0;display:block;}
    #mainDiv .btmul .btmul_li .btmul_li_p1 span{margin-left:3%;font-size:1.6em;color:#585858;}
    #mainDiv .btmul .btmul_li_ul{width:100%;overflow:hidden;display:none;}
    #mainDiv .btmul .btmul_li_ul li{width:45%;float:left;text-align:left;font-size:1.56em;padding:0.8em 0 0.8em 0;margin-left:3%;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}

    #updateNameDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:1000000;background:rgba(0,0,0,0.65);display:none;}
    #updateNameDiv ul{width:80%;overflow:hidden;margin-left:10%;margin-top:10%;}
    #updateNameDiv ul li{float:left;}
    #updateNameDiv li:nth-child(1){width:100%;text-align:center; font-size:1.7em;color:#FFFFFF;}
    #updateNameDiv li:nth-child(2){border-radius:0.5em;border-radius:0.5em;-webkit-border-radius:0.5em;-webkit-border-radius:0.5em;background:#FFFFFF;}
    #updateNameDiv li:nth-child(2) input[type="text"]{width:100%;font-size:1.55em;color:#000000;background:transparent;border:0;-webkit-border:0;float:left;text-align:center;}
    #updateNameDiv li:nth-child(3){background:#FB9D3B;margin-top:10%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;}
    #updateNameDiv li:nth-child(4){background:#FB9D3B;margin-top:10%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;float:right;}
  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li>按病情查找</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="btmul">
    <%
      for(int i=0; i<sickCategaryQueryModelList.size(); i++) {
        JdSickCategaryQueryModel sickCategaryQueryModel = sickCategaryQueryModelList.get(i);
        out.write("<li class=\"btmul_li\"><p class=\"btmul_li_p1\" flag=\"0\" onClick=\"showHide(this);\"><span>");
        out.write(sickCategaryQueryModel.getName());
        out.write("</span></p><ul class=\"btmul_li_ul\">");
        for(int j=0; j < sickQueryModelList.size(); j++) {
          JdSickQueryModel sickQueryModel = sickQueryModelList.get(j);
          if(sickQueryModel.getJdSickCategaryId().equals(sickCategaryQueryModel.getUuid())) {
            out.write("<li onClick=jump('"+sickQueryModel.getUuid()+"','"+sickQueryModel.getName()+"')>"+sickQueryModel.getName()+"</li>");
          }
        }
        out.write("</ul></li>");
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
  function showHide(ob){
    var flag = $(ob).attr('flag');
    if(flag==0){
      $(ob).next('ul').show();
      $(ob).attr('flag',1);
    }else{
      $(ob).next('ul').hide();
      $(ob).attr('flag',0);
    }

  }
  //跳转页面
  function jump(ID,title){
    window.location.href ="detailHospital.htm?title="+encodeURI(encodeURI("搜索"+title))+"&jd_sick_id="+ID;
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