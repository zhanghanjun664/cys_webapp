<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String forget = (String)request.getAttribute("forget");
  JdPatientModel patientModel = (JdPatientModel)request.getSession().getAttribute(WebConstants.SESSION_PATIENT);
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <jsp:include page="../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
  <!--header-->
  <header class="header pr">
    <h1 class="logo pa">
      <a onclick="toMain()"></a>
    </h1>
    <h2>修改密码</h2>
  </header>
  <!--header-->
  <!--content-->
  <div class="content mt">
    <!--list-->
    <ul class="list formlist">
      <%
        if(forget != null) {
      %>
      <li class="clearfix" style="font-size: 30px;">
        <span style="font-size: 12px;">验证码已发送到您绑定的手机号，请查收并填写.</span>
      </li>
      <li class="clearfix borderb">
        <label class="fl formfont">验证码</label>
        <label class="fr forminput"><input type="text"  class="fl" placeholder="请输入验证码" id="code"></label>
      </li>
      <%
        }
      %>
      <li class="clearfix borderb">
        <label class="fl formfont">密码</label>
        <label class="fl forminput"><input type="password"  class="fl" placeholder="请输入密码" id="newpass"></label>
      </li>

      <li class="clearfix ">
        <label class="fl formfont">确认密码</label>
        <label class="fl forminput"><input type="password"  class="fl" placeholder="请再次输入密码" id="newpassok"></label>
      </li>
    </ul>
    <div class="btn changepass_btn" disabled id="changpassfinish">完成</div>
    <!--list-->
  </div>
  <!--content-->
</div>
<!--wrap-->
</body>
<script>
  sendPageVisit(Page_Constant.ResetPassword);

  /*设置新密码*/
  $('#newpass').on('input',function(ev){
    if (checknull('#newpass')) {
      $('#changpassfinish').removeAttr('disabled');
    }else{
      $('#changpassfinish').attr('disabled','true');
    }
  });
  var forget = <%=forget%>;
  $('#changpassfinish').on('click',function(ev){
    if($('#changpassfinish').attr('disabled')){
      return;
    }
    //判断密码是否输入正确
    if (checkregular('#newpass','4')==false) {
      layer.alert(errorMsg.password, {
        title: false,
        closeBtn: false
      }, function(){
        layer.closeAll();
        $('#newpass').focus();
      });
      return;
    }
    //判断确定密码是否输入
    if(checknull('#newpassok')==false){
      layer.alert(errorMsg.password2, {
        title: false,
        closeBtn: false
      }, function(){
        layer.closeAll();
        $('#newpassok').focus();
      });
      return;
    }
    //判断两次密码是否输入相同
    if(checksame('#newpass','#newpassok')==false){
      layer.alert(errorMsg.pwdConfirm, {
        title: false,
        closeBtn: false
      }, function(){
        layer.closeAll();
        $('#newpassok').focus();
      });
      return;
    }
    //完成修改密码
    if(forget) {
      verifyCode();
    } else {
      resetPassword();
    }
  });

  function verifyCode() {
    var code = $.trim($("#code").val());
    if (code.length <= 0) {
      layer.alert("请输入验证码", {
        title: false,
        closeBtn: false
      }, function(){
        layer.closeAll();
        $('#code').focus();
      });
    }
    var url = 'verifyCode.htm';
    var data = {'phoneNumber': <%=patientModel.getPhoneNumber()%>, 'code': code};
    sendRequest(url, "POST", data, function (msg) {
      if (msg) {
        layer.alert(msg, {
          title: false,
          closeBtn: false
        }, function(){
          layer.closeAll();
        });
      } else {
        resetPassword();
      }
    });
  }
  //post请求修改密码
  function resetPassword(){
    var data = {"password": $.trim($("#newpass").val())};
    sendRequest('resetPassword.htm', "POST", data, function (msg) {
      if (msg) {
        layer.alert(msg, {
          title: false,
          closeBtn: false
        }, function() {
          layer.closeAll();
        });
      } else {
        goto('toPersonal.htm');
      }
    }, function () {
      layer.closeAll();
    });
  }
</script>
</html>
