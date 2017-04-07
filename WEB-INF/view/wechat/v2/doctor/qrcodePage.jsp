<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.SystemParams" %>
<%@ page import="cn.aidee.jdoctor.constants.DoctorAuditStatus" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdDoctorQueryModel doctorModel = (JdDoctorQueryModel) request.getAttribute("doctorModel");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <h3 class="tit">我的二维码</h3>
    <a href="javascript:void(0);" class="back-to-home logo" onclick="backToHome()">返回首页</a>
</header>
<!-- topbar end -->

<!-- my qr code start -->
<div class="qr-code">
    <div class="qr-code-hd">
        <dl class="clearfix">
            <dt class="fl">
                <img src="<%= doctorModel.getHeadPic() %>" class="avatar-doctor" width="64" height="64" alt=""/>
            </dt>
            <dd class="fl">
                <p><%=doctorModel.getName()%> 丨 <%=doctorModel.getTitle()%></p>

                <p style="padding-top: 6px;"><%=doctorModel.getHospital()%></p>
            </dd>
        </dl>
    </div>
    <div class="qr-code-con">
        <img src="<%=doctorModel.getQrCodeImageUrl() %>"
             width="220" height="220" alt="资料审核通过后，系统会自动为您生成个人主页二维码"/>
        <%
            if(DoctorAuditStatus.AUDIT_PASSED.getValue().equals(doctorModel.getStatus())) {
        %>
            <h3>扫一扫上面的二维码,关注我的橙医生账号</h3>
        <%
            } else {
        %>
            <h3>资料审核通过后，系统会自动为您生成个人主页二维码</h3>
        <%
            }
        %>
    </div>
</div>
<!-- my qr code end -->
</body>
</html>
