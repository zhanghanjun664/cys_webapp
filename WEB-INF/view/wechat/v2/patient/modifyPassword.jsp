<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
      <li class="clearfix">
        <label class="fl formfont">密码</label>
        <label class="fl forminput"><input type="password"  class="fl" placeholder="请输入旧密码" id="oldpass"></label>
      </li>
    </ul>
    <div class="btn changepass_btn" disabled id="oldpasnext">下一步</div>
    <!--list-->
  </div>
  <!--content-->
</div>
<!--wrap-->
</body>
<script>
  sendPageVisit(Page_Constant.Setting);
  /*输入旧密码*/
  $('#oldpass').on('input', function (ev) {
    if (checknull('#oldpass')) {
      $('#oldpasnext').removeAttr('disabled');
    } else {
      $('#oldpasnext').attr('disabled', 'true');
    }
  });
  $('#oldpasnext').on('click', function (ev) {

    if ($('#oldpasnext').attr('disabled')) {
      return;
    }
    //判断旧密码是否输入正确
    var url='checkOldPassword.htm';
    var oldPwd = $("#oldpass").val();
    var data = {"oldPassword" : hex_md5(oldPwd)};
    sendRequest(url, "POST", data, function (result) {
      if (result) {
          var info = result.split(";");
            layer.confirm(info[1], {
               title: false,
               closeBtn: false,
               btn: ['忘记密码', '确定']
            }, function () {
              goto('toResetPassword.htm?forget=true');
            }, function () {
              layer.closeAll();
              $('#oldpass').focus();
            });
      } else {
        goto('toResetPassword.htm');
      }
    },function (){
      layer.closeAll();
      $('#oldpass').focus();
    });
  });
</script>
</html>
