<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdCaseHistoryQueryModel" %>
<%@ page import="java.util.List" %>
<%
  List<JdCaseHistoryQueryModel> caseHistoryQueryModelList=(List<JdCaseHistoryQueryModel>)request.getAttribute("caseHistoryQueryModelList");
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
    #mainDiv .top_ul li:nth-child(1){width:14.5%;height:100%;background:url(../../wechat/images/larrow.png) center left no-repeat;background-size:auto 55%;}
    #mainDiv .top_ul li:nth-child(2){width:65%;height:100%;font-size:2em;color:#FFFFFF;}
    #mainDiv .top_ul li:nth-child(3){width:20%;height:100%;float:right;}
    #mainDiv .top_ul li:nth-child(3) a{font-size:1.6em;color:#FFFFFF;}

    #mainDiv .mainul1{width:100%;overflow:hidden;padding:1.3em 0 0.8em 0;background:#FFFFFF;}
    #mainDiv .mainul1 .mainul1_li1{width:90%;margin-left:5%;padding:0.5em 0.3em 0.5em 0.3em;border-radius:5em;-webkit-border-radius:5em;background:url(../../wechat/images/icon16.png) center left no-repeat #F2F2F2;background-size:auto 43%;background-position:1.2%;border:#E6E6E6 0.11em solid;}
    #mainDiv .mainul1 li input[type="text"]{width:85%;font-size:1.58em;color:#000000;background:transparent;border:0;-webkit-border:0;margin-left:7%;float:left;}

    #mainDiv .btmul{width:100%;overflow:hidden;margin-top:5%;padding:0 0 1.5em 0;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1{width:100%;border-bottom:#F1F1F1 0.125em solid;-webkit-border-bottom:#F1F1F1 0.125em solid;padding:1.5em 0 1.5em 0;float:left;background:url(../../wechat/images/icon6.png) center right no-repeat #FFFFFF;background-size:auto 58%;}
    #mainDiv .btmul .btmul_li ul .btmul_li_ul_li1 p{width:94%;padding:0.2em 0 0.2em 0;margin-left:3%;font-size:1.55em;}

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
    <li>我的患者</li>
    <li><a href=""></a></li>
  </ul>
  <ul class="mainul1">
    <li class="mainul1_li1">
      <input id="keywords" type="text" placeholder="搜索患者姓名"/>
    </li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul">
        <%
          for(int i=0;i<caseHistoryQueryModelList.size();i++){
            JdCaseHistoryQueryModel caseHistoryQueryModel=caseHistoryQueryModelList.get(i);
        %>
        <li class="btmul_li_ul_li1" onClick="jump('<%=caseHistoryQueryModel.getJdSickCategaryId()%>');">
          <p class="btmul_li_ul_li1_p1"><%=caseHistoryQueryModel.getSickCategoryName()%><font style="color:#DF0101;">(<%=caseHistoryQueryModel.getCount()%>)</font></p>
        </li>
        <%
          }
        %>
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

    $('.mainul1').width(mw);
    $('.mainul1_li1').width(mw*0.9).height(mh*0.05);
    $('.mainul1_li1 input').width(mw*0.9*0.85).height(mh*0.05);

    $('.btmul').width(mw);

    $('#mainDiv').show();
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw*0.84).height(mh*0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw*0.84).height(mh*0.26*0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw*0.84).height(mh*0.26*0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height',mh*0.26*0.27+'px');
    $('#msgcontp').css('margin-top',mh*0.26*0.3);
    $('#MsgBoxDiv ul').css('margin-top',mh*0.15);

    //查询
    document.onkeydown=function(){
      if(event.keyCode == 13){
        var keywords = $.trim($('#keywords').val());
        if(keywords.length<=0){
          var msg = '请输入查询关键字';
          var btnword = '确定';
          MsgOpt.showMsgBox(msg, btnword);
          return;
        }
        window.location.href = 'searchCasePatient.htm?name='+keywords;
      }
    }
  }

  function jump(sickCategoryID){
    window.location.href ='CasePatient.htm?jd_sick_category_id='+sickCategoryID;
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