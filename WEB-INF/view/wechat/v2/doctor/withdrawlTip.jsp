<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String amount = (String) request.getAttribute("amount");
    String card = (String) request.getAttribute("card");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <a onclick="backToHome()" class="back-to-home logo">返回首页</a>
    <h3 class="tit">提现详情</h3>
</header>
<!-- topbar end -->
<!-- withdraw detail start -->
<div class="main withdraw-detail">
    <img src="../../wechat/images/v2/status_ok.png" width="120" height="120" />

    <h3>提现申请已提交,需要5-7个工作日到账</h3>

    <div class="grid mt-10">
        <p>
            <label>存蓄卡</label>
            <span><%=card%></span>
        </p>
        <p>
            <label>金额(元)</label>
            <span>￥<%=amount%></span>
        </p>
    </div>
    <div class="withdraw-detail-btn">
        <a onclick="goto('toWallet.htm')" class="btn-withdraw-done">完成</a>
    </div>
</div>
<!-- withdraw detail end -->
</body>
</html>
