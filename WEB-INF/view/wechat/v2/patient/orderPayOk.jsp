<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.AvailableTimeModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdOrderModel orderModel = (JdOrderModel)request.getAttribute("orderModel");
    JdDoctorModel doctorModel = (JdDoctorModel)request.getAttribute("doctorModel");
    AvailableTimeModel availableTime = (AvailableTimeModel)request.getAttribute("availableTime");
    String address = (String)request.getAttribute("address");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>预约成功</h2>
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
            <li class="clearfix">
                <i class="fl">时间</i><span class="fl"><%=DateUtils.getWeekOfDate(availableTime.getDateTime())%> <%=DateUtils.format(availableTime.getDateTime(), "HH:mm")%> <small class="paydate">(<%=DateUtils.format(availableTime.getDateTime(), "MM-dd")%>)</small></span>
            </li>
            <li class="clearfix">
                <i class="fl">地址</i><span class="fl"><%=address%></span>
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
                <i class="fl">联系手机</i><span class="fl"><input type="text" value="<%=orderModel.getPhoneNumber()%>" readonly placeholder="请输入联系手机" id="successphone" maxlength="11"></span><a href="javascript:void(0)" class="pa" id="setsuccess"></a>
            </li>
        </ul>
        <p class="success_tit">如需修改点击编辑按钮即可；</p>
        <p class="success_tit">就诊完成后，评价订单即可退还保证金，订单分享到朋友圈，还可以获得10元微信红包。</p>
    </div>
    <!--content-->

    <!--gotoorder-->
    <footer class="gotoorder successfooter" onclick="confirmOrder()">
        <span>确认信息</span>
    </footer>
    <!--gotoorder-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.OrderPayOk);

    $('#setsuccess').on('click',function(ev){
        $('#successphone').removeAttr('readonly');
        $('#successphone').focus();
    });

    function confirmOrder() {
        if(checknull('#successphone')==false) {
            layer.alert('请输入联系手机', {
                title: false,
                closeBtn: false
            }, function(){
                layer.closeAll();
                $('#successphone').focus();
            });
            return;
        }
        if (checkregular('#successphone','1')==false) {
            layer.alert("请输入正确的手机号码", {
                title: false,
                closeBtn: false
            }, function(){
                layer.closeAll();
                $('#successphone').focus();
            });
            return;
        }
        var phone = $('#successphone').val().trim();
        goto("toOrderDetail.htm?phone="+phone+"&orderNumber=<%=orderModel.getOrderNumber()%>");
    }
</script>
</html>
