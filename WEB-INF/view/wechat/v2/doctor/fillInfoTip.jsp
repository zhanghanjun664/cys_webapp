<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
  <h3 class="tit">预约订单</h3>
  <a href="javascript:void(0);" class="back-to-home logo">返回首页</a>
</header>
<!-- topbar end -->

<!-- order booking start -->
<div class="main order-booking">
  <img src="../../wechat/images/v2/regi_info.png" width="100" height="auto"/>
  <p>需完善信息才能接受订单预约</p>
  <a href="javascript:void(0);" class="btn-block info-eidt mt-20" onclick="window.location.href='toFillInfo.htm'">立即填写&gt;</a>
</div>
<!-- order booking end -->
</body>
</html>