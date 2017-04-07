<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdCommentModel" %>
<%
  JdOrderQueryModel order = (JdOrderQueryModel)request.getAttribute("order");
  JdDoctorQueryModel doctorQueryModel = (JdDoctorQueryModel)request.getAttribute("doctorQueryModel");
  JdCommentModel commentModel = (JdCommentModel)request.getAttribute("commentModel");
  String wxconfig = (String)request.getAttribute("wxconfig");
  String limit = (String)request.getAttribute("limit");
  Long diff = (Long)request.getAttribute("diff");
%>
<!DOCTYPE html>
<html>
<head>
  <jsp:include page="../../include/head.jsp" />
  <script src="../../wechat/js/weixin.js" type="text/javascript"></script>
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

    #mainDiv .btmul{width:100%;overflow:hidden;padding:0 0 0.06em 0;border-top:#BDBDBD 0.11em solid;-webkit-border-top:#BDBDBD 0.11em solid; background:#F2F2F2;}
    #mainDiv .btmul .btmul_li{width:100%;float:left;margin-bottom:0.1em;border-bottom:#F2F2F2 0.12em solid;-webkit-border-bottom:#F2F2F2 0.12em solid;padding:1.5em 0 1.5em 0;background:#FFFFFF;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1{width:20%;overflow:hidden;float:left;margin-left:3%;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li1{width:100%;float:left;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li1 img{width:100%;border-radius:50%;-webkit-border-radius:50%;}
    #mainDiv .btmul .btmul_li .btmul_li_ul1 .btmul_li_ul1_li2{width:100%;float:left;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2{width:73%;margin-left:3%;overflow:hidden;float:left;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1{width:100%;padding-bottom:0.35em;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1 .btmul_li_ul2_li1_sp1{font-size:1.65em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li1 .btmul_li_ul2_li1_sp2{font-size:1.55em;color:#FB9D3B;}

    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2{width:100%;padding-bottom:0.35em;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .df_sp{font-size:1.5em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .hospital_sp{font-size:1.5em;color:#000000;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .room_sp{font-size:1.5em;color:#A4A4A4;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .goodat_sp{font-size:1.5em;color:#A4A4A4;}
    #mainDiv .btmul .btmul_li .btmul_li_ul2 .btmul_li_ul2_li2 .number_sp{font-size:1.5em;color:#A4A4A4;}

    #mainDiv .serviceTagul{width:100%;overflow:hidden;padding:0.75em 0 0.75em 0;background:#FFFFFF;margin-top:0.9em;border-bottom:#F0F0F0 0.1em solid;}
    #mainDiv .serviceTagul li{font-size:1.45em;margin-left:2%;float:left;padding:0.55em 0.9em 0.55em 0.9em;border-radius:0.3em;-webkit-border-radius:0.3em;border:#E6E6E6 0.08em solid;-webkit-border:#E6E6E6 0.08em solid;color:#A4A4A4;}

    #mainDiv .starul{width:100%;overflow:hidden;padding:0.6em 0 0 0;}
    #mainDiv .starul .starul_li1{float:left;width:100%;padding:0.75em 0 0.75em 0;background:#FFFFFF;}
    #mainDiv .starul .starul_li1 span{margin-left:2%;margin-top:0.55em;float:left;font-size:1.58em;}
    #mainDiv .starul .starul_li1 img{margin-left:1.55%;float:left;}
    #mainDiv .starul .starul_li2{float:left;width:100%;padding:0.75em 0 0.75em 0;background:#FFFFFF;}
    #mainDiv .starul .starul_li2 .starul_li2_sp1{margin-left:2%;float:left;font-size:1.6em;}
    #mainDiv .starul .starul_li2 .starul_li2_sp2{margin-left:2%;float:left;font-size:1.6em;color:#BDBDBD;}

    #mainDiv .introul{width:100%;overflow:hidden;padding:0.6em 0 1.6em 0;background:#FFFFFF;margin-top:1.5em;}
    #mainDiv .introul .introul_li0{float:left;width:100%;padding:0.75em 0 0.75em 0;background:#FFFFFF;}
    #mainDiv .introul .introul_li0 span{margin-left:2%;font-size:1.7em;color:#FB9D3B;}
    #mainDiv .introul .introul_li1{float:left;width:100%;padding:0.15em 0 0.15em 0;background:#FFFFFF;}
    #mainDiv .introul .introul_li1 .introul_li1_sp1{margin-left:2%;float:left;font-size:1.6em;}
    #mainDiv .introul .introul_li1 .introul_li1_sp2{margin-left:2%;float:left;font-size:1.6em;color:#BDBDBD;}

    #mainDiv .btnul{width:100%;margin-top:3.6em;overflow:hidden;padding-bottom:1.8em;}
    #mainDiv .btnul li{width:96%;margin-left:2%;float:left;text-align:center;font-size:1.6em;color:#FFFFFF;background:#FB9D3B;border-radius:0.3em;-webkit-border-radius:0.3em;}

    #MsgBoxDiv{width:100%;height:100%;position:fixed;left:0;top:0;z-index:1000000;display:none;}
    #MsgBoxDiv ul{width:84%;overflow:hidden;margin-left:8%;background:rgba(0,0,0,0.65);border-radius:0.2em;-webkit-border-radius:0.2em;}
    #MsgBoxDiv ul li{width:100%;overflow:hidden;text-align:center;}
    #MsgBoxDiv ul li:nth-child(1) p{width:100%;text-align:center;font-size:1.75em;color:#FFFFFF;}
    #MsgBoxDiv ul li:nth-child(2){border-top:#FFFFFF 0.04em solid;-webkit-border-top:#FFFFFF 0.04em solid;font-size:1.88em;color:#FFFFFF;}
    #mcover{ position: fixed; top:0;  left:0; width:100%; height:100%;background:rgba(0, 0, 0, 0.3);display:none;z-index:200000;}
    #mcover img {position: fixed;right:0;top:7%;width:100%;z-index:20001;}

    #shareDiv{width:100%;height:100%;position:absolute;left:0;top:0;z-index:100000;display:none;background:#FEECD6;}
    #shareDiv ul{width:100%;overflow:hidden;}
    #shareDiv ul li{width:100%;float:left;text-align:center;}
    #shareDiv ul li:nth-child(1) img{width:100%;text-align:center;}
    #shareDiv ul li:nth-child(2) p{width:90%;margin-left:5%;text-align:center;font-size:1.6em;}
    #shareDiv ul li:nth-child(3){width:96%;margin-left:2%;margin-top:3em;float:left;text-align:center;font-size:1.6em;color:#FFFFFF;background:#FB9D3B;border-radius:0.3em;-webkit-border-radius:0.3em;}
  </style>
</head>
<body>
<div id="mainDiv">
  <ul class="top_ul">
    <a href="javascript:history.back();"><li></li></a>
    <li>分享至朋友圈</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="btmul">
    <li class="btmul_li">
      <ul class="btmul_li_ul1">
        <li class="btmul_li_ul1_li1"><img id="docheadimg" src="<%=doctorQueryModel.getHeadPic()%>"/></li>
      </ul>
      <ul class="btmul_li_ul2">
        <li class="btmul_li_ul2_li1">
          <span class="btmul_li_ul2_li1_sp1"><%=doctorQueryModel.getName()%></span>
          <span class="btmul_li_ul2_li1_sp2">(<%=doctorQueryModel.getTitle()%>)</span>
        </li>
        <li class="btmul_li_ul2_li2"><span class="hospital_sp"><%=doctorQueryModel.getHospital()%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">科室：</span><span class="room_sp"><%=doctorQueryModel.getDepartment()%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">擅长：</span><span class="goodat_sp"><%=WechatUtils.showDoctorSkills(doctorQueryModel.getDoctorSelectSkills())%></span></li>
        <li class="btmul_li_ul2_li2"><span class="df_sp">人气：</span><span class="number_sp"><%=doctorQueryModel.getPopularity()%></span></li>
      </ul>
    </li>
  </ul>
  <ul class="starul">
    <li class="starul_li1">
      <span>评分 </span>
      <img class="trueimg" src="../../wechat/images/mark<%=commentModel.getStars()%>.png"/>
    </li>
    <li class="starul_li2">
      <span class="starul_li2_sp1">评论: </span>
      <span class="starul_li2_sp2"><%=commentModel.getComment()%></span>
    </li>
  </ul>
  <ul class="btnul">
    <li onClick="toShareWXTimeLine();">分享至微信朋友圈即获得红包</li>
  </ul>
</div>
<div id="MsgBoxDiv">
  <ul>
    <li><p id="msgcontp"></p></li>
    <li id="btnli" onClick="MsgOpt.hideMsgBox();"></li>
  </ul>
</div>
<div id="mcover" style="display:none;z-index: 100" onClick="hideshare();"><img src="../../wechat/images/guide.png"></div>
<div id="shareDiv">
  <ul class="shareDiv_ul">
    <li><img src="../../wechat/images/sharebg.png"/></li>
    <li><p>感谢您对橙医生的支持，我们已在橙医生微信公众号中为您发了10元微信红包，请您在24小时之内领取，否则红包会过期。</p></li>
    <li onClick="back();">确定</li>
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
    $('.btmul_li_ul1_li1').width(mw);
    $('.btmul_li_ul1_li1 img').width(mw*0.2).height(mw*0.2);

    $('.starul_li1').width(mw).height(mh*0.05);
    $('.starul_li1 img').height(mh*0.04);
    $('.starul_li2').width(mw).height(mh*0.05);

    $('.inputul').width(mw);
    $('.inputul li').width(mw*0.96).height(mh*0.3);
    $('#comment').width(mw*0.96).height(mh*0.3);

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

    $('#shareDiv').width(mw).height(mh*0.9);
    $('#shareDiv').css({left:0,top:mh*0.07});
    $('.shareDiv_ulli').eq(2).width(mw*0.96).height(mh*0.07);
    $('.shareDiv_ul li').eq(2).css('line-height',mh*0.07+'px');
    var wxconfig = <%=wxconfig%>;
    wx.config({
      debug: false,
      appId: wxconfig.appId,
      timestamp: wxconfig.timestamp,
      nonceStr: wxconfig.nonceStr,
      signature: wxconfig.signature,
      jsApiList: ['onMenuShareTimeline','onMenuShareAppMessage']
    });
    wx.ready(function() {
      wx.onMenuShareTimeline({
        title: '我推荐你关注"橙医生"，随时随地预约心脑血管名医',
        link: 'http://mp.weixin.qq.com/s?__biz=MzAwNTUxNDQ0NQ==&mid=206184853&idx=2&sn=a069d4623b4eeb03999821a787e5c15c&scene=1&from=singlemessage&isappinstalled=0#rd',
        imgUrl: 'http://m.chengyisheng.com.cn/data/static_img/logo.jpg',
        success: function () {
          shareOk();
        }
      });
      wx.onMenuShareAppMessage({
        title: '我推荐你关注"橙医生"，随时随地预约心脑血管名医',
        link: 'http://mp.weixin.qq.com/s?__biz=MzAwNTUxNDQ0NQ==&mid=206184853&idx=2&sn=a069d4623b4eeb03999821a787e5c15c&scene=1&from=singlemessage&isappinstalled=0#rd',
        imgUrl: 'http://m.chengyisheng.com.cn/data/static_img/logo.jpg',
        type: 'link',
        success: function () {
          shareOk();
        }
      });
    });
  }

  //分享成功
  function shareOk(){
    $.ajax({
      type: 'GET',
      url: 'sendRedpack.htm?orderId=<%=order.getUuid()%>',
      success: function (msg) {
        if (msg == "nologin") {
          var msg = '登录超时，请重新登录';
          MsgOpt.showMsgBox(msg, '确定', 'toLogin.htm');
          return;
        } else if (msg == "error") {
          var msg = '红包推送失败，10元奖励已放到您的账户余额，请查收';
          MsgOpt.showMsgBox(msg, '确定', 'toOrderList.htm?status=4');
          return;
        } else if (msg == "limitTime") {
          var msg = '分享成功，但00:00~08:00期间分享没有红包奖励';
          MsgOpt.showMsgBox(msg, '确定', 'toOrderList.htm?status=4');
          return;
        } else if(msg == "overtime") {
          var msg = '您的订单已超出分享时间！';
          MsgOpt.showMsgBox(msg, '确定', 'toOrderList.htm?status=4');
          return;
        } else if(msg == "shared") {
          var msg = '此订单不是待分享状态！';
          MsgOpt.showMsgBox(msg, '确定', 'toOrderList.htm?status=4');
          return;
        } else {
          $('#shareDiv').show();
        }
      },
      timeout: 15000,
      error: function () {
        var msg = '网络连接错误或超时';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        return;
      }
    });
  }

  function toShareWXTimeLine(){
    $('#mcover').show();
  }
  function hideshare(){
    $('#mcover').hide();
  }

  function back() {
    window.location.href ='toOrderList.htm?status=4';
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

  var limit = "<%=limit%>";
  var diff = <%=diff%>;
  if(diff < 0) {
    var msg = '您的订单已超出分享时间！';
    var btnword = '确定';
    MsgOpt.showMsgBox(msg, btnword, "toOrderList.htm?status=4");
  } else if(limit!="null") {
    var msg = "00:00~08:00期间分享将不会得到红包!";
    MsgOpt.showMsgBox(msg, "确定");
  }
</script>
