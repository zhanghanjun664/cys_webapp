<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String phoneNumber = (String)request.getAttribute("phoneNumber");
    String invitecode = (String)request.getAttribute("invitecode");
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

    #mainDiv .cont_ul{width:94%;margin-top:5%;margin-left:3%;overflow:hidden;}
    #mainDiv .cont_ul li{width:100%;float:left;background:#FFFFFF;}
    #mainDiv .cont_ul li input[type="password"]{width:70%;font-size:1.55em;color:#000000;background:transparent;border:0;-webkit-border:0;margin-left:8%;float:left;}
    #mainDiv .cont_ul li:nth-child(1){background:url(../../wechat/images/icon2.png) center left no-repeat #FFFFFF;background-size:auto 43%;margin-bottom:0.18em;border-top-left-radius:0.5em;border-top-right-radius:0.5em;-webkit-border-top-left-radius:0.5em;-webkit-border-top-right-radius:0.5em;}
    #mainDiv .cont_ul li:nth-child(2){background:url(../../wechat/images/icon2.png) center left no-repeat #FFFFFF;background-size:auto 43%;margin-bottom:0.18em;border-bottom-left-radius:0.5em;border-bottom-right-radius:0.5em;-webkit-border-bottom-left-radius:0.5em;-webkit-border-bottom-right-radius:0.5em;}
    #mainDiv .cont_ul li:nth-child(3){background:#FB9D3B;background-size:auto 43%;margin-top:10%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;}

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
    <li>注册</li>
    <li><a href="main.htm">首页</a></li>
  </ul>
  <ul class="cont_ul">
    <li><input type="password" id="password" placeholder="请输入新密码"/></li>
    <li><input type="password" id="repassword" placeholder="再次确认新密码"/></li>
    <li onClick="RegisterOpt.register();">完成</li>
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
    $('.cont_ul li').height(mh*0.07);
    $('.cont_ul li input').height(mh*0.068);
    $('.cont_ul li').eq(2).height(mh*0.07);
    $('.cont_ul li').eq(2).css('line-height',mh*0.07+'px');

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

  //获取验证码以及注册类
  var RegisterOpt = {
    regflag:false,
    register:function(){
      var mythis = this;
      if(mythis.regflag){
        return;
      }
      mythis.regflag = true;
      var password = $.trim($('#password').val());
      var repassword = $.trim($('#repassword').val());
      if(password.length<=0){
        var msg = '请填写新密码';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        mythis.regflag = false;
        return;
      }
      if(password.length<6||password.length>=20){
        var msg = '密码为6~20位之间的字符组合';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        mythis.regflag = false;
        return;
      }
      if(repassword.length<=0){
        var msg = '请填写确认新密码';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        mythis.regflag = false;
        return;
      }
      if(password!=repassword){
        var msg = '两次输入的密码不一致';
        var btnword = '确定';
        MsgOpt.showMsgBox(msg, btnword);
        mythis.regflag = false;
        return;
      }
      var url = 'register.htm';
      var data = {'password':password,'phoneNumber':<%=phoneNumber%>};
      var inviteCode = "<%=invitecode%>";
      if(inviteCode != "") {
        data.invitecode = inviteCode;
      }
      $.ajax({
        type:'POST',
        url:url,
        data:data,
        success:function(msg){
          if(msg){
            if(msg == "redirectLogin") {
              window.location.href = 'toLogin.htm';
              return;
            } else if(msg == "registered") {
              msg = "您已注册，请直接登陆";
            }
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword);
            mythis.regflag = false;
          }else{
            window.location.href = 'uInfo.htm';
          }
        },
        timeout: 10000,
        error:function(){
          mythis.regflag = false;
          return;
        }
      });
    }
  };

</script>
