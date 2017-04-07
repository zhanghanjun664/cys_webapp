<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.WithdrawalHistoryQueryModel" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="cn.aidee.jdoctor.constants.PaymentStatus" %>
<%@ page import="cn.aidee.jdoctor.constants.WithdrawlHistoryType" %>
<%
  List<WithdrawalHistoryQueryModel> historyList=(List<WithdrawalHistoryQueryModel>)request.getAttribute("historyList");
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

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 1.5em 0;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;margin-bottom:0.1em;border-top:#E7E7E7 0.1em solid;border-bottom:#E7E7E7 0.1em solid;-webkit-border-top:#E7E7E7 0.1em solid;-webkit-border-bottom:#E7E7E7 0.1em solid;background:#FFFFFF;padding:0.5em 0 0.5em 0;}
    #mainDiv .btmul .btmul_li ul{width:100%;overflow:hidden;}
    #mainDiv .btmul .btmul_li ul li:nth-child(1){width:auto;float:left;text-align:left;margin-left:3%;}
    #mainDiv .btmul .btmul_li ul li:nth-child(1) .cont_li_p1{margin-top:0.8em;font-size:1.6em;color:#585858;}
    #mainDiv .btmul .btmul_li ul li:nth-child(1) .cont_li_p2{font-size:1.55em;color:#BDBDBD;}
    #mainDiv .btmul .btmul_li ul li:nth-child(2){width:auto;float:right;font-size:1.6em;color:#414141;text-align:left;margin-right:3%;}


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
    <li>账户记录</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="btmul">
    <%
      if(historyList!=null){
        for(int i=0;i<historyList.size();i++){
          WithdrawalHistoryQueryModel historyModel=historyList.get(i);
        %>
    <li class="btmul_li">
      <ul>
        <li class="cont_li">
          <p class="cont_li_p1">
            <%
              String type=historyModel.getType();
              if(WithdrawlHistoryType.DOCTOR_WITHDRAWL.getValue().equals(type)){
                out.print("提现");
              }else if(WithdrawlHistoryType.DOCTOR_DIAGNOSE.getValue().equals(type)){
                out.print("诊金");
              }else if(WithdrawlHistoryType.RECOMMEND.getValue().equals(type)){
                out.print("推荐奖金");
              }
            %>
          </p>
          <p class="cont_li_p2"><%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(historyModel.getCreateDate())%></p>
        </li>
        <li class="title_li"><%=historyModel.getAmount()%>元</li>
      </ul>
    </li>
    <%
        }
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
    $('.btmul_li').width(mw).height(mh*0.085);
    $('.btmul_li ul').width(mw).height(mh*0.085);
    $('.title_li').height(mh*0.085);
    $('.cont_li').height(mh*0.085);
    $('.title_li').css('line-height',mh*0.085+'px');

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