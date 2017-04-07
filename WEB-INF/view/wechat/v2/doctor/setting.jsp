<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdDoctorModel doctorModel = (JdDoctorModel) request.getSession().getAttribute(WebConstants.SESSION_DOCTOR);

%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <h3 class="tit">设置</h3>
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
</header>
<!-- topbar end -->
<div class="viewport personal-center">
    <div style="padding-top: 15%">
    </div>
    <div class="grid mt-10">
        <a href="javascript:void(0);" onclick="goto('toModifyPassword.htm')">&nbsp;&nbsp;修改密码<i class="icon-item "></i></a>
        <a href="javascript:void(0);" onclick="goto('toChangeMobile.htm')">&nbsp;&nbsp;修改手机号<i class="icon-item "></i><em><%= doctorModel.getOfficePhoneNumber()%></em></a>
    </div>
</div>

</body>
</html>
