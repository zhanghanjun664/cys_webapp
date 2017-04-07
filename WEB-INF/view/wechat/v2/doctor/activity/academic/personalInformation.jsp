<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>填写个人信息</title>
  <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
  <meta name="format-detection" content="telephone=no">
  <script src="/activity/academic/static/js/app/rem.js"></script>
  <link rel="stylesheet" href="/activity/academic/static/css/base.css">
  <link rel="stylesheet" href="/activity/academic/static/css/style.css">
  <script type="text/javascript" src="/activity/academic/static/js/libs/requirejs/require.js" defer asyn="true" data-main="/activity/academic/static/js/app"></script>
</head>
<body class="bgg">

<ul class="personal">
  <input value="<%=request.getAttribute("phoneNumber")%>" id="phoneNumber" style="display: none;"/>
  <input value="<%=request.getAttribute("password")%>" id="password" style="display: none;"/>
  <li class="pr">
    <span class="personal_title">姓名</span><input type="text" id="personalName" placeholder="请输入姓名">
    <i class="arrow pa"></i>
  </li>

  <li class="pr">

    <span class="personal_title">医院所在地区</span>


    <select id="area">
    </select>


    <i class="arrow pa"></i>
  </li>

  <li class="pr">
    <span class="personal_title">医院名称</span>

    <select id="hospital-name">
      <option selected disabled></option>
      <option>请选择医院所在地区</option>

    </select>

    <i class="arrow pa"></i>
  </li>

  <li class="pr">
    <span class="personal_title">职称</span>
    <select id="title">
    </select>
    <i class="arrow pa"></i>
  </li>

  <li class="pr">
    <span class="personal_title">科室</span>
    <select id="department">
    </select>
    <i class="arrow pa"></i>
  </li>

</ul>

<div class="nextBtn_wrap">
  <div class="nextBtn" id="personal_next">提交</div>
</div>




</body>
</html>
