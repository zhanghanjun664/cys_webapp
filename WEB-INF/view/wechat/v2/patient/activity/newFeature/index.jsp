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
  <title>新功能,心惊喜</title>
  <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <script type="text/javascript" src="/activity/christmas/js/rem.js"></script>
  <link rel="stylesheet" href="/activity/christmas/css/base.css">
  <link rel="stylesheet" href="/activity/christmas/css/style.css">
  <link rel="stylesheet" href="/activity/christmas/css/alert.css">

  <script src="/activity/newFeature/js/resizeRoot.js"></script>
  <link rel="stylesheet" href="/activity/newFeature/css/style.css">
</head>
<body>

<div class="wrap margin_auto">
  <!--header-->
  <div class="header">

    <h1 class="margin_auto">
      <img src="/activity/newFeature/images/logo.png" alt="" class="max_width">
    </h1>

    <div class="title1 margin_auto">
      <img src="/activity/newFeature/images/title1.png" class="max_width">
    </div>

    <div class="title2 margin_auto">
      <img src="/activity/newFeature/images/title2.png" alt="" class="max_width">
    </div>

  </div>
  <!--header-->

  <!--content-->
  <div class="content margin_auto">

    <div class="tip1 w490 margin_auto">围观新功能，新用户100%获得红包，老用户100%获得现金券。</div>

    <ul class="prize_content margin_auto w490">
      <li id="clickphone">
        <input type="tel" placeholder="输入手机号码" id="phone" maxlength="11">
        <div class="code" id="getcode" clickBol="true">获取验证码</div>
      </li>
      <li id="clickcode">
        <input type="tel" placeholder="输入验证码"  id="code" maxlength="4">
      </li>
    </ul>

    <div class="tip1 w490 margin_auto">＊新用户会同时注册橙医生账户</div>

    <div class="btn margin_auto"  id="submit">
      <img src="/activity/newFeature/images/btn.png" alt="" class="max_width">
    </div>

  </div>
  <!--content-->

</div>
</body>
<script src="/activity/christmas/js/jquery.js"></script>
<script src="/activity/christmas/js/fastclick.js"></script>
<script src="/activity/christmas/js/alert.js"></script>
<script src="/activity/newFeature/js/call.js"></script><%--?time=<%=new Date().getTime()%>--%>
</html>
