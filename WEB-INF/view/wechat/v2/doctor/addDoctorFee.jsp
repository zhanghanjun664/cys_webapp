<%@ page import="cn.aidee.jdoctor.model.JdDoctorFeeModel" %>
<%@ page import="org.springframework.util.StringUtils" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    BigDecimal oldFeeInDecimal = (BigDecimal)request.getAttribute("oldFee");
    BigDecimal newFeeInDecimal = (BigDecimal)request.getAttribute("newFee");
    int newFee = newFeeInDecimal.intValue();
    int oldFee = oldFeeInDecimal.intValue();
    int preFilledFee = oldFee;
    // oldFee为负，说明是新添加的诊金，则默认填的值为500
    if (oldFee < 0){
        preFilledFee = 500;
    }
    String client = (String)request.getSession().getAttribute(WebConstants.SESSION_CLIENT_TYPE);
	boolean isReqFromApp = true;
	if (client == null || !client.equals(WebConstants.SESSION_CLIENT_APP)){
	    isReqFromApp = false;
	}

%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <% if (isReqFromApp){ %>
            <title>编辑诊金</title>
    <% } %>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<!--  对于从app过来的请求，不显示页面的header -->
<% if (!isReqFromApp) { %>
<header class="fixed topbar">
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit">编辑诊金</h3>
</header>
<% } %> 
<!-- topbar end -->

<!-- fee edit start -->
<div class="main fee-edit" <% if (isReqFromApp){ %> style="padding-top:0px;" <% } %>>
    <form class="form-fee-edit" id="form-fee-edit">
        <p class="clearfix">
            <label>诊金</label>
            <span>￥ <input type="tel" id="new_fee" value="<%=preFilledFee%>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"/></span>
        </p>
        <i class="fee-tips">诊金最大不能超过￥5000</i>
        <div class="form-submit" style="margin-top:10px;">
            <input type="button" value="保存" class="btn-submit"/>
        </div>
    </form>
</div>
<!-- fee edit end -->
</body>
<script>
    $(function(){
        var submitFlag = false;
        $('.btn-submit').on('click', function() {
            var newFee = trim($('#new_fee').val());
            var oldFee = <%=oldFee%>;
            
            if(newFee < 0) {
                layer.alert('诊金不能低于￥0', {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });
            } else if(newFee > 5000) {
                layer.alert('诊金不能超过￥5000', {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });
            } else {
                if(submitFlag)
                    return;
                submitFlag = true;
                var data = {"newFee":newFee, "oldFee":oldFee};
                
                sendRequest("saveDoctorFee.htm", "POST", data, function(msg) {
                    if(msg) {
                        layer.alert(msg, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                        });
                        submitFlag = false;
                    } else {
                        //layer.alert("保存成功", {
                        //    title: false,
                        //    closeBtn: false
                        //}, function () {
                        //    layer.closeAll();
                        goto("toDoctorFeeManage.htm");
                        //});
                    }
                }, function () {
                    submitFlag = false;
                });
            }
        })
    });
</script>
</html>
