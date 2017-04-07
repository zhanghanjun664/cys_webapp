<%@ page import="java.util.Date" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/12/22
  Time: 15:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>橙医生</title>
  <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <script type="text/javascript" src="/activity/christmas/js/rem.js"></script>
  <link rel="stylesheet" href="/activity/christmas/css/base.css">
  <link rel="stylesheet" href="/activity/christmas/css/style.css">
  <link rel="stylesheet" href="/activity/christmas/css/alert.css">
</head>
<body>

<div class="snow pa"></div>
<div class="wrap pr">

  <div class="bg pr">
    <h1 class="active_title"></h1>
    <h2 class="active_title2"></h2>
    <p class="Explain">输入手机号码和验证码，新用户100%获得红包，老用户100%获得现金券，新老用户同时参与抽奖</p>

    <ul class="input_phone">
      <li class="pr" id="clickphone">
        <input type="text" placeholder="输入手机号码" id="phone" maxlength="11">
        <div class="code pa " id="getcode" clickBol="true">获取验证码</div>
      </li>
      <li id="clickcode">
        <input type="text" placeholder="输入验证码" id="code" maxlength="4">
      </li>
    </ul>
    <p class="Explain2">*新用户会同时注册橙医生账户</p>

    <div class="submitbtn pa" id="submit"><img src="/activity/christmas/images/btn.gif" alt=""></div>

  </div>
</div>
</body>
<script src="/activity/christmas/js/jquery.js"></script>
<script src="/activity/christmas/js/fastclick.js"></script>
<script src="/activity/christmas/js/alert.js"></script>
<script src="/activity/christmas/js/call.js?time=<%=new Date().getTime()%>"></script>

</html>
