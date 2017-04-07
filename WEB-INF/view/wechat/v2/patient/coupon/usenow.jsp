<%@ page import="cn.com.chengyisheng.service.wechat.type.WechatUser" %>
<%@ page import="cn.aidee.jdoctor.model.JdCouponModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String resultMsg = (String)request.getAttribute("result");
  String day = (String)request.getAttribute("day");
  Boolean isCanDraw = (Boolean)request.getAttribute("isCanDraw");
  WechatUser userObject = (WechatUser)request.getAttribute("userObject");
  JdCouponModel coupon = (JdCouponModel)request.getAttribute("coupon");
  request.setAttribute("result",resultMsg);
  request.setAttribute("isCanDraw",isCanDraw);
  request.setAttribute("day",day);
  request.setAttribute("userObject",userObject);
  request.setAttribute("coupon",coupon);
%>
<!doctype html>
<html lang="en">
<head>
  <jsp:include page="../../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
  <div class="nowuse">
    <span class="nowuse_left"></span>
    <span class="nowuse_right"></span>
    <div class="nowuse_header" style="background:url('${userObject.headimgurl}') center center no-repeat;background-size:cover;border-radius: 100%;"></div>
    <div class="nowuse_price">￥<%=coupon.getValue()%></div>
    <div class="nowuse_title">红包已送完,现金券已收入您的钱包！</div>
    <div class="nowuse_time">有效期至：<%=day%></div>
  </div>
  <a href="javascript:void(0)" onclick="toMain()" class="now_go_use">马上使用</a>

  <div class="intive_gomore"><a href="javascript:void(0);" onclick="goto('toNowInvite.htm')">邀请好友，获得更多邀请券，可累计使用哦</a><span></span></div>

</div>
<!--wrap-->
</body>
<script type="text/javascript">
  sendPageVisit(Page_Constant.UseNow);
</script>
</html>
