<%@ page import="cn.aidee.framework.base.result.CommonResultObject" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/12/22
  Time: 15:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  CommonResultObject commonResultObject = (CommonResultObject)request.getAttribute("commonResult");
	//如果commonResult为空，可能是直接跳过来的页面，代表成功。
%>
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

  <script src="/activity/newFeature/js/resizeRoot.js"></script>
  <link rel="stylesheet" href="/activity/newFeature/css/style.css">
  <style>
    .tip{
      margin-top: 1.5rem;
      font-size: 0.6rem;
      text-align: center;
      color: #ffffff;
    }
    #showCode{
    	width:6rem;
    	height:6rem;
    	margin:0.5rem auto;
    	text-align:center;
    	position:relative;
    	z-index:99999999999;
    }
    #showCode img{
    	max-width:100%;
    }
    
  </style>
</head>
<body>

<div class="snow pa"></div>
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
			<p class="tip">
				<%=commonResultObject!=null?commonResultObject.getDescription():"您已经参与活动,留意查收红包或现金券奖励发放!"%>
			</p>
		</div>
		 <% if(commonResultObject!=null&&commonResultObject.getDescription()=="请关注橙医生公众号!"){ %>
		<div id="showCode" style=""><img src="http://cys-static-img.oss-cn-shenzhen.aliyuncs.com/patient/qrcode/XGNSXHD.jpg"/></div>
		<%} %>
  <!--content-->

</div>
</div>


</body>
<script src="/activity/christmas/js/jquery.js"></script>
<script src="/activity/christmas/js/fastclick.js"></script>
<script src="/activity/christmas/js/alert.js"></script>
<script src="/activity/christmas/js/call.js"></script>

</html>
