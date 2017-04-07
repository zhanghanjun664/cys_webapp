<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.wechat.DoctorDataModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    DoctorDataModel doctorDataModel = (DoctorDataModel) request.getAttribute("doctorData");
    JdDoctorQueryModel doctorModel = (JdDoctorQueryModel) request.getAttribute("doctorModel");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<div class="viewport personal-center">
    <!-- thumb start -->
    <div class="thumb">
        <dl class="clearfix">
            <dt class="fl" onclick="window.location.href='toPersonalInfo.htm'">
                <img src="<%=doctorModel.getHeadPic()%>" class="avatar-doctor" width="64" height="64" alt=""/>
                <div class="brief-info">
                    <p><%=doctorModel.getName()%> 丨 <%=doctorModel.getTitle()%></p>
                    <p style="padding-top: 6px;width: 180px;"><%=doctorModel.getHospital()%></p>
                </div>
            </dt>
            <dd class="fr">
                <img src="../../wechat/images/v2/code.png" width="26" height="26" onclick="window.location.href='toQrcodePage.htm'"/>
            </dd>
        </dl>
    </div>
    <!-- thumb end -->
    <!-- menu start -->
    <div class="menu">
        <ul class="clearfix">
            <li>
                <a href="javascript:void(0);" onclick="toOrderList(1)">
                    <i class="icon-menu ico-visit"></i>待出诊<b>(<%=doctorDataModel.getNoTreat()%>)</b>
                </a>
            </li>
            <li>
                <a href="javascript:void(0);" onclick="toOrderList(2)">
                    <i class="icon-menu ico-confirm"></i>待确认<b>(<%=doctorDataModel.getNoConfirm()%>)</b>
                </a>
            </li>
            <li>
                <a href="javascript:void(0);" onclick="toOrderList(3)">
                    <i class="icon-menu ico-done"></i>已完成(<%=doctorDataModel.getTreated()%>)
                </a>
            </li>
        </ul>
    </div>
    <!-- menu end -->

    <div class="grid mt-10">
        <a href="javascript:void(0);" onclick="goto('toVisitArrange.htm')"><i class="icon-item ico-time"></i>出诊安排</a>
        <a href="javascript:void(0);" onclick="goto('toPatientList.htm')"><i class="icon-item ico-users"></i>我的患者<em><%=doctorDataModel.getPatientCount()%>人</em></a>
        <a href="javascript:void(0);" onclick="goto('toWallet.htm')"><i class="icon-item ico-cash"></i>钱包<em>余额、提现记录</em></a>
        <a href="javascript:void(0);" onclick="goto('toMessageCenter.htm')"><i class="icon-item ico-msg"></i>消息</a>
    </div>

    <div class="grid mt-10">
        <a href="javascript:void(0);" onclick="goto('toSetting.htm')"><i class="icon-item ico-set"></i>设置</a>
    </div>

    <div class="mt-10" style="margin-bottom: 5px;">
        <p style="font-size: 14px;text-align: center;">若如果您有任何疑问，请拨打客服电话:<br><b><a href="tel:400-061-8989" style="color: #167ef9">400-061-8989</a></b></p>
    </div>
</div>
</body>
<script>
    function toOrderList(status) {
        window.location.href = "toOrderList.htm?status=" + status;
    }
</script>
</html>
