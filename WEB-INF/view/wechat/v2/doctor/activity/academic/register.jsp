<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>注册</title>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <meta name="format-detection" content="telephone=no">
    <script src="/activity/academic/static/js/app/rem.js"></script>
    <link rel="stylesheet" href="/activity/academic/static/css/base.css">
    <link rel="stylesheet" href="/activity/academic/static/css/style.css">

    <script type="text/javascript" src="/activity/academic/static/js/libs/requirejs/require.js" defer asyn="true" data-main="/activity/academic/static/js/app"></script>
    <script type="text/javascript" src="/activity/academic/static/js/libs/hexmd5/md5.js"></script>

</head>
<body class="bgf">

<ul class="resiter">

    <li class="pr">
        <span class="phone_icon pa"></span>
        <input type="tel" placeholder="手机号" maxlength="11" id="mobilePhone">
    </li>

    <li class="pr">
        <span class="password_icon pa"></span>
        <input type="password" placeholder="不少于6位" id="passWord">
    </li>

    <li class="pr">
        <span class="code_icon pa"></span>
        <input type="tel" placeholder="验证码" maxlength="4" id="verCode">
        <span class="getCode pa" id="getCode">获取验证码</span>
    </li>

</ul>

<div class="nextBtn_wrap">
    <div class="nextBtn" id="registerNext">下一步</div>
</div>

<div class="callus pf">
    <p>如果您有任何疑问，请拨打客服电话</p>
    <p><a>400-061-8989</a></p>
</div>


</body>
</html>