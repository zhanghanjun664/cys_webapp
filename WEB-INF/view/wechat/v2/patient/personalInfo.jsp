<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdPatientModel patientModel = (JdPatientModel) request.getSession().getAttribute(WebConstants.SESSION_PATIENT);
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
        <h2>个人信息</h2>
        <div class="header_logo pa">
            <a onclick="toPersonal()" class="mine_center pa"></a>
        </div>
    </header>
    <!--header-->
    <!--content-->
    <div class="content">
        <ul class="list case_list">
            <li id="information_name">
                <a href="javascript:void(0)" class="pr">
                    姓名<input type="text" id="nameLi" class="showmsg pa" value="<%=patientModel.getName()%>"
                             readonly><span class="pa"></span>
                </a>
            </li>
            <%--<li>--%>
                <%--<a href="javascript:void(0)" class="pr">--%>
                    <%--身份证<input type="text" class="showmsg pa" value="<%=WechatUtils.displayNullValue(patientModel.getIdCard())%>" readonly>--%>
                <%--</a>--%>
            <%--</li>--%>
        </ul>
        <ul class="list case_list">
            <li id="information_phone">
                <a href="javascript:void(0)" class="pr">
                    手机号<input type="text" class="showmsg pa" value="<%=patientModel.getPhoneNumber()%>" readonly><span class="pa" ></span>
                </a>
            </li>
            <li>
                <a href="javascript:void(0)" class="pr">
                    邀请码<input type="text" class="showmsg pa" value="<%=patientModel.getRecommandCode()%>" readonly>
                </a>
            </li>
        </ul>
    </div>
    <!--content-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.PersonalInfo);

    $('#information_name').on('click', function (ev) {
        var a1 = new Attribute({
            number: '4',
            placeholder: '请输入姓名',
            leftfn: function () {
            },
            rightfn: function () {
                var name = this.getData();
                var data = {"name": name};
                sendRequest("updateName.htm", "POST", data, function (result) {
                    $('#nameLi').val(name);
                    layer.closeAll();
                });
            }
        });
    });
    $('#information_phone').on('click', function (ev) {
        layer.confirm("修改手机号码需要解除绑定，确定修改手机号码？", {
            title: false,
            closeBtn: false,
            btn: ['取消', '确定']
        }, function () {
            layer.closeAll();
        }, function () {
            goto('toChangeMobile.htm');
        });
    });
</script>
</html>
