<%@ page import="cn.com.chengyisheng.service.wechat.type.WechatUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String resultMsg = (String)request.getAttribute("result");
  WechatUser userObject = (WechatUser)request.getAttribute("userObject");
  request.setAttribute("result",resultMsg);
  request.setAttribute("userObject",userObject);
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

    <div class="nowuse_header" style="background:url('<%=userObject.getHeadimgurl()%>') center center no-repeat;background-size:cover;border-radius: 100%;"></div>

    <div class="nowuse_time">${result}</div>
  </div>

  <a href="javascript:void(0)" onclick="toMain()" class="now_go_use">去首页瞧瞧</a>

  <div class="intive_gomore"><a href="javascript:void(0);" onclick="goto('toNowInvite.htm')">邀请好友，获得更多邀请券，可累计使用哦</a><span></span></div>
</div>
<!--wrap-->
</body>
<script type="text/javascript">
  sendPageVisit(Page_Constant.CouponError);
</script>
</html>
