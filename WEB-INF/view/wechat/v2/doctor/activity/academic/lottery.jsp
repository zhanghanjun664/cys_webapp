<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2016/1/12
  Time: 11:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>幸运大抽奖</title>
  <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <script src="/activity/academic/static/js/app/rem.js"></script>
  <link rel="stylesheet" href="/activity/academic/static/css/base.css">
  <link rel="stylesheet" href="/activity/academic/static/css/style.css">

  <script type="text/javascript" src="/activity/academic/static/js/libs/requirejs/require.js" defer asyn="true" data-main="/activity/academic/static/js/app"></script>

</head>
<body>

<!--Lottery_bg-->
<div class="Lottery_bg">


  <!--turnplate_wrap-->
  <div class="turnplate_wrap">
    <div class="turnplate">
      <canvas class="item" id="wheelcanvas" width="422px" height="422px"></canvas>
      <img class="pointer" src="/activity/academic/static/images/turnplate-pointer.png"/>
    </div>
  </div>
  <!--turnplate_wrap-->

  <!--prize-->
  <div class="prize pr">
    <div class="prize_show pa" id="prize_show">
      <p>您尚未进行抽奖</p>
    </div>
    <div class="money_decorate pa"></div>
  </div>
  <!--prize-->

  <!--Lottey_phone-->
  <div class="Lottey_phone">
    <p>工作人员将在2个工作日内寄出</p>
    <p>如有疑问，请及时拨打</p>
    <p>400-061-8989咨询</p>
  </div>
  <!--Lottey_phone-->



</div>
<!--Lottery_bg-->


</body>





</html>
