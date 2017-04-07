<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String phone = (String) request.getAttribute("phone");
%>
<html>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
  <a onclick="backToHome()" class="back-to-home logo">返回首页</a>
  <h3 class="tit">忘记密码</h3>
</header>
<!-- topbar end -->
<!-- modify pay password start -->
<div class="main modify-pay-pwd">
  <form class="form-pay-pwd" id="form-pay-pwd">
    <!-- step 1 -->
    <div class="step-1 form" style="margin-top: -70px;">
      <span style="font-size: 14px;width: 95%">
        验证码已发送到您的手机号码：<font color="#164ED8"><%=phone%></font>，请查收并填写
      </span>
      <div class="grid" style="margin-top: 10px">
        <p style="padding: 6px 0 0 0;">
          <label for="verify-code">验证码</label>
          <input type="text" name="verify-code" id="verify-code" placeholder="请输入验证码"/>
        </p>
      </div>
      <div class="form-submit">
        <input type="button" value="下一步" class="btn-submit step-next"/>
      </div>
      <div class="call">
        <p style="padding-left: 30px">若获取不到验证码,请致电:<b><a href="tel:400-061-8989">400-061-8989</a></b></p>
      </div>
    </div>
    <!-- step 2 -->
    <div class="step-2" style="display:none;">
      <label for="pay-pwd-1">请输入新的支付密码</label>
					<span class="am-password-handy">
						<input type="tel" id="pay-pwd-1" name="pay-pwd-1" maxlength="6"/>
						<ul class="am-password-handy-security">
                          <li><i></i></li>
                          <li><i></i></li>
                          <li><i></i></li>
                          <li><i></i></li>
                          <li><i></i></li>
                          <li><i></i></li>
                        </ul>
					</span>
    </div>
    <!-- step 3 -->
    <div class="step-3" style="display:none;">
      <label for="pay-pwd-2">请再次确认支付密码</label>
					<span class="am-password-handy">
						<input type="tel" id="pay-pwd-2" name="pay-pwd-2" maxlength="6"/>
						<ul class="am-password-handy-security">
                          <li><i></i></li>
                          <li><i></i></li>
                          <li><i></i></li>
                          <li><i></i></li>
                          <li><i></i></li>
                          <li><i></i></li>
                        </ul>
					</span>
    </div>
  </form>
</div>
<!-- modify pay password end -->
</body>
<script>
  // 支付密码设置确认
  payPwd('#pay-pwd-1');
  payPwd('#pay-pwd-2');

  // 验证码
  var verifyCode = $('#verify-code');
  $('.step-next').on('click', function(){
    if (isEmpty('#verify-code')) {
      layer.alert('验证码有误,请重新输入', {
        title: false,
        closeBtn: false
      }, function () {
        layer.closeAll();
        verifyCode.focus();
      });
      return;
    }
    var code = trim(verifyCode.val());
    var data = {"phoneNumber": "<%=phone%>", "code": code};
    sendRequest("verifyCode.htm", "POST", data, function (msg) {
      if(msg) {
        layer.alert(msg, {
          title: false,
          closeBtn: false
        }, function () {
          layer.closeAll();
          verifyCode.focus();
        });
      } else {
        $('.step-1').hide();
        $('.step-2').show();
      }
    });
  });

  $('#pay-pwd-1').on('keyup', function(){
    var pwd = $(this).val();
    if(pwd.length == 6){
      if(!/^[0-9]*$/.test(pwd)){
        layer.alert('支付密码只能输入数字,请重新输入', {
          title: false,
          closeBtn: false
        }, function(){
          layer.closeAll();
        });
        return;
      }
      $('.step-2').hide().next().show();
    }
  });

  $('#pay-pwd-2').on('keyup', function(){
    if($(this).val().length == 6){
      var payPwdNew = $('#pay-pwd-1').val(),
              payPwdNewConfirm = $('#pay-pwd-2').val();
      if(payPwdNewConfirm != payPwdNew){
        layer.alert('两次输入的密码不一致,请重新输入', {
          title: false,
          closeBtn: false
        }, function(){
          layer.closeAll();
        });
      }else{
        var data = {"payPasswd" : hex_md5(payPwdNew)};
        sendRequest("setPayPasswd.htm", "POST", data, function(result) {
          if(result) {
            layer.alert(result, {
              title: false,
              closeBtn: false
            }, function(){
              layer.closeAll();
            });
          } else {
            layer.msg('支付密码重置成功');
            setTimeout(function(){
              goto("toWallet.htm");
            }, 500);
          }
        });
      }
    }
  });
</script>
</html>
