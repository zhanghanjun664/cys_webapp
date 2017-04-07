<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderPlusModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdOrderPlusModel orderModel = (JdOrderPlusModel)request.getAttribute("orderModel");
    JdDoctorModel doctorModel = (JdDoctorModel)request.getAttribute("doctorModel");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>申请加号</h2>
        <div class="header_logo pa">
            <a onclick="toPersonal()" class="mine_center pa"></a>
        </div>
    </header>
    <!--header-->

    <ul class="payul success_msg">
        <li class="clearfix">
            <i class="fl">预约号</i><span class="fl"><%=orderModel.getOrderNumber()%></span>
        </li>
    </ul>
    <!--content-->
    <div class="content pay_wrap">
        <ul class="payul">
            <li class="clearfix">
                <i class="fl">医生</i><span class="fl"><%=doctorModel.getName()%></span>
            </li>
        </ul>
        <ul class="payul">
            <li class="clearfix">
                <i class="fl">姓名</i><span class="fl"><%=orderModel.getName()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">身份证</i><span class="fl"><%=orderModel.getIdCard()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">年龄</i><span class="fl"><%=orderModel.getAge()%></span>
            </li>
            <li class="clearfix">
                <i class="fl">病情描述</i><span class="fl"><%=orderModel.getSickDescription()%></span>
            </li>
        </ul>
        <ul class="payul success_phone">
            <li class="clearfix pr">
                <i class="fl">联系手机</i><span class="fl"><input type="text" value="<%=orderModel.getPhoneNumber()%>" readonly></span>
            </li>
        </ul>

    </div>
    <div class="fixbtn" onclick="toMain()">回到首页</div>
</div>
<!--wrap-->
</body>
</html>
