    <%@ page import="cn.aidee.jdoctor.model.JdOrderQueryModel" %>
        <%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
        <%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
        <%@ page import="cn.com.chengyisheng.sys.constant.SystemParams" %>
        <%@ page import="java.net.URLEncoder" %>
        <%@ page import="cn.aidee.jdoctor.constants.OrderStatus" %>
        <%@ page import="org.apache.commons.lang3.StringUtils" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="cn.aidee.jdoctor.model.JdSickQueryModel" %>
        <%@ page import="java.util.List" %>
            <%
    JdOrderQueryModel orderModel = (JdOrderQueryModel) request.getAttribute("orderModel");
    List<JdSickQueryModel> orderSicks = (List<JdSickQueryModel>) request.getAttribute("orderSick");
    StringBuffer bufferSickNames = new StringBuffer();
    if (orderSicks != null && !orderSicks.isEmpty()) {
        for (JdSickQueryModel jdSickQueryModel : orderSicks) {
            bufferSickNames.append(jdSickQueryModel.getName()).append(";");
        }
    }
    if (bufferSickNames.length() > 0) {
        bufferSickNames = bufferSickNames.deleteCharAt(bufferSickNames.length() - 1);
    }
    String sickName = bufferSickNames.toString();

    String status = (String) request.getAttribute("status");
    String client = (String) request.getSession().getAttribute(WebConstants.SESSION_CLIENT_TYPE);
    boolean isReqFromApp = true;
    if (client == null || !client.equals(WebConstants.SESSION_CLIENT_APP)) {
        isReqFromApp = false;
    }
    String appToken = request.getSession().getAttribute(SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME) != null ?
            URLEncoder.encode((String) request.getSession().getAttribute(SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME), "UTF-8") : "";

%>
        <!DOCTYPE html>
        <html lang="zh-cn">

        <head>
            <% if (isReqFromApp) { %>
        <title>订单详情</title>
            <% } %>
        <jsp:include page="../include/doctor_head.jsp"/>
        </head>
        <body>

        <%--<%=orderModel%>--%>
        <!-- topbar start -->
            <% if (!isReqFromApp) { %>
        <header class="fixed topbar">
        <a href="javascript:void(0);" class="back-to-home logo" onclick="backToHome()">返回首页</a>
        <h3 class="tit">订单详情</h3>
        </header>
            <% } %>
        <!-- topbar end -->

        <!-- main start -->
        <div class="main order-detail" <% if (isReqFromApp) { %> style="padding-top:0px;" <% } %>>
        <div class="grid order-column">
        <label>订单状态</label>
            <% if (StringUtils.isEmpty(status)) {%>
        <em class="order-status"><%=OrderStatus.getDescription(orderModel.getStatus())%>
        </em>
            <%} else {%>
        <em class="order-status"><%="1".equals(status) ? "待出诊" : "2".equals(status) ? "待确认" : "已完成"%>
        </em>
            <%}%>
        </div>

        <div class="grid order-column mt-10">
        <dl class="clearfix">
        <dt class="fl">
        <img src="<%=orderModel.getDocHeadPic() %>" width="52" height="52" alt=""/>
        </dt>
        <dd class="fl" style="width: 75%;">
        <p><%=orderModel.getDoctor()%> &nbsp;|&nbsp; <%=orderModel.getTitle()%>
        </p>

        <p>时间：&nbsp;&nbsp;<b id='time'><%=DateUtils.getWeekOfDate(orderModel.getAppointmentTime())%>
        &nbsp;<%=DateUtils.format(orderModel.getAppointmentTime(), "HH:mm")%>
        &nbsp;(<%=DateUtils.format(orderModel.getAppointmentTime(), "MM-dd")%>)</b></p>

        <p>地址：&nbsp;&nbsp;<%=orderModel.getAppointmentAddress()%>
        </p>
        </dd>
        </dl>
        </div>


        <div class="grid order-column mt-10">
        <p><label>姓名</label><%=orderModel.getName()%>
        </p>

        <p><label>联系手机</label><%=orderModel.getPhoneNumber()%>
        </p>

        <p><label>身份证</label><%=orderModel.getIdCard() == null ? "无" : orderModel.getIdCard()%>
        </p>

        <p><label>年龄</label><%=orderModel.getAge()%>
        </p>

        <p><label>病情描述</label><%=orderModel.getSickDescription()%>
        </p>
        </div>


            <%if (!StringUtils.isEmpty(sickName)) {%>
        <div class="grid order-column mt-10">
        <p><label>诊断信息</label><%=sickName%>
        </p>
        </div>
            <%}%>


        <div class="grid order-column mt-10">
        <p><label>诊金</label><strong>￥<%=orderModel.getDiscountedConsultationFee().setScale(0)%>
        </strong></p>

        <p class="order-time-1">下单时间：&nbsp;<%=DateUtils.format(orderModel.getCreateDate())%>
        </p>

        <p class="order-num">预&nbsp;约&nbsp;号：&nbsp;&nbsp;<%=orderModel.getOrderNumber()%>
        </p>
        </div>
            <%
        if ("2".equals(status)) {
    %>
        <p class="tips">在规定时间内，记录预约号获取诊金</p>
            <%
        }
    %>
        </div>
        <!-- main end -->
            <%
    if ("1".equals(status)
            && !orderModel.getStatus().equals(OrderStatus.WAITTO_PAY.getValue())
            && !orderModel.getStatus().equals(OrderStatus.NO_PAY.getValue())) {
%>
        <div class="fixed order-detail-bott">
        <a href="javascript:void(0);" class="btn-record">取消出诊</a>
        </div>
        <div class="mask"></div>
        <div class="popup record-order-num">
        <div class="popup-con">
        <p>
        <label for="order-num">原因</label>
        <input type="text" id="order-num" placeholder="请输入取消原因"/>
        </p>
        </div>
        <div class="popup-bottom">
        <a class="p-btn-cancel">取消</a>
        <a class="p-btn-confirm">确认</a>
        </div>
        </div>
            <%
} else if ("2".equals(status)) {
%>
        <div class="fixed order-detail-bott">
        <a href="javascript:void(0);" class="btn-record">记录预约号</a>
        </div>

        <div class="mask"></div>
        <div class="popup record-order-num">
        <div class="popup-con">
        <p>
        <label for="order-num">预约号</label>
        <input type="text" id="order-num" placeholder="请输入预约号"/>
        </p>
        </div>
        <div class="popup-bottom">
        <a class="p-btn-cancel">取消</a>
        <a class="p-btn-confirm">确认</a>
        </div>
        </div>
            <%
    }
%>
        <!-- record order number end -->
        </body>
        <script>

        //获取token
        function getToken(name){
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r !== null) {
        return decodeURIComponent(r[2]);
        } else {
        return null;
        }
        }

        var order_id=getToken('orderId');

        var token=getToken('token');


        $('.btn-record').on('click', function () {

        var text=$(this).html();

        if(text==='记录预约号'){
        if(token!==null){

        var time='<%=DateUtils.getWeekOfDate(orderModel.getAppointmentTime())%>'+' '+'<%=DateUtils.format(orderModel.getAppointmentTime(), "HH:mm")%>'+' ('+'<%=DateUtils.format(orderModel.getAppointmentTime(), "MM-dd")%>'+')';


        var content={
        'uuid':order_id,
        'oppointmentTimeStart':time,
        'name': '<%=orderModel.getName()%>',
        'age':'<%=orderModel.getAge()%>',
        'fee':'<%=orderModel.getDiscountedConsultationFee().setScale(0)%>',
        'sickDescription':'<%=orderModel.getSickDescription()%>',
        'appointmentAddress':'<%=orderModel.getAppointmentAddress()%>'
        };

        <%--console.log(content);--%>

        window.sessionStorage.setItem('order_detail', JSON.stringify(content));

        window.location.href='/app_web/app_doctor_web/view/inputDiagnosis.html?token='+token;
        }else{
        $('.mask, .record-order-num').fadeIn();
        }

        }else{
        $('.mask, .record-order-num').fadeIn();
        }



        });

        var submitFlag = false;
            <%
        if("1".equals(status)) {
    %>
        $('.p-btn-confirm').on('click', function () {
        if (submitFlag)
        return;
        submitFlag = true;

        var orderNumVal = trim($('#order-num').val());
        if (orderNumVal.length < 1) {
        $('.mask, .record-order-num').fadeOut();
        layer.alert('请输入取消原因', {
        title: false,
        closeBtn: false
        }, function () {
        layer.closeAll();
        $('.mask, .record-order-num').fadeIn();
        $('#order-num').focus();
        });
        submitFlag = false;
        return;
        }
        var data = {"orderId": "<%=orderModel.getUuid().toString()%>", "cancelReason": orderNumVal};
        sendRequest("cancelOrder.htm", "POST", data, function (result) {
        $('.mask, .record-order-num').fadeOut();
        if (result) {
        layer.alert(result, {
        title: false,
        closeBtn: false
        }, function () {
        layer.closeAll();
        $('.mask, .record-order-num').fadeIn();
        $('#order-num').focus();
        });
        } else {
        layer.alert('取消成功', {
        title: false,
        closeBtn: false
        }, function () {
        layer.closeAll();
        window.location.href = "toOrderList.htm?status=1&<%=SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME%>=<%=appToken%>";
        });
        }
        submitFlag = false;
        }, function () {
        submitFlag = false;
        });
        });
            <%
        } else if("2".equals(status)) {
    %>
        $('.p-btn-confirm').on('click', function () {
        if (submitFlag)
        return;
        submitFlag = true;

        var orderNumVal = trim($('#order-num').val());
        if (orderNumVal.length < 1) {
        $('.mask, .record-order-num').fadeOut();
        layer.alert('请输入正确的预约号', {
        title: false,
        closeBtn: false
        }, function () {
        layer.closeAll();
        $('.mask, .record-order-num').fadeIn();
        $('#order-num').focus();
        });
        submitFlag = false;
        return;
        }
        var data = {"orderId": "<%=orderModel.getUuid().toString()%>", "orderNumber": orderNumVal};
        sendRequest("recordOrderNumber.htm", "POST", data, function (result) {
        $('.mask, .record-order-num').fadeOut();
        if (result) {
        layer.alert(result, {
        title: false,
        closeBtn: false
        }, function () {
        layer.closeAll();
        $('.mask, .record-order-num').fadeIn();
        $('#order-num').focus();
        });
        } else {
        layer.alert('录入成功', {
        title: false,
        closeBtn: false
        }, function () {
        layer.closeAll();
        window.location.href = "toOrderList.htm?status=2&<%=SystemParams.APP_JSP_REQUEST_TOKEN_PARAM_NAME%>=<%=appToken%>";
        });
        }
        submitFlag = false;
        }, function () {
        submitFlag = false;
        });
        });
            <%
        }
    %>
        $('.p-btn-cancel, .mask').on('click', function () {
        $('.mask, .record-order-num').fadeOut();
        $('#order-num').val("");
        });
        </script>
        </html>
