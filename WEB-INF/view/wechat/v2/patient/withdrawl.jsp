<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdPatientModel patientModel = (JdPatientModel) request.getSession().getAttribute(WebConstants.SESSION_PATIENT);
    String canWithdrawl = patientModel.getAccountBalance().setScale(2).toString();
    BigDecimal minWithdrawal = (BigDecimal) request.getAttribute("minWithdrawal");
    String date = DateUtils.format(DateUtils.add(new Date(), Calendar.DAY_OF_MONTH, 3), "yyyy-MM-dd");
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
        <h2>提现</h2>
    </header>
    <!--header-->

    <!--content-->
    <div class="content mt">
        <!--list-->
        <ul class="list formlist">
            <li class="clearfix">
                <label class="fl formfont">金额(元)</label>
                <label class="fl forminput"><input type="text" maxlength="8" class="fl" placeholder="可提现金额<%=canWithdrawl%>元" id="money"></label>
            </li>
        </ul>
        <section class="witdraw_tis">目前仅支持微信钱包，预计到账：<%=date%> 日</section>
        <div class="btn" disabled id="getmoney">提现</div>
        <!--list-->
    </div>
    <!--content-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.Withdrawl);

    $('#money').on('input',function(ev){
        if (checknull('#money')) {
            $('#getmoney').removeAttr('disabled');
        }else{
            $('#getmoney').attr('disabled','true');
        }
    });
    var flag = false;
    var canWithdrawl = <%=canWithdrawl%>;
    var minWithdrawal = <%=minWithdrawal.setScale(0).toString()%>;
    $('#getmoney').on('click',function(ev){
        if ($(this).attr('disabled')) {
            return;
        }
        //判断金额是否正确
        if (checkregular('#money','7')==false) {
            layer.alert("请输入正确的金额", {
                title: false,
                closeBtn: false
            }, function(){
                layer.closeAll();
                $('#money').focus();
            });
            return;
        }
        var ob = $('#money').val().trim();
        //判断输入的是否超过总额
        if (parseFloat(ob)>parseFloat(canWithdrawl)) {
            layer.alert("提现金额超出余额", {
                title: false,
                closeBtn: false
            }, function(){
                layer.closeAll();
                $('#money').focus();
            });
            return;
        } else if(parseFloat(ob)<parseFloat(minWithdrawal)) {
            var msg = '提现金额不能小于' + minWithdrawal + '元';
            layer.alert(msg, {
                title: false,
                closeBtn: false
            }, function(){
                layer.closeAll();
                $('#money').focus();
            });
            return;
        }
        if(flag)
            return;
        flag = true;
        var data = {"amount": ob};
        sendRequest("withdrawl.htm", "POST", data, function (msg) {
            if (msg) {
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });
            } else {
                layer.alert("申请成功，提现金额会在1-3个工作日内到账", {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });
                canWithdrawl = parseFloat(canWithdrawl) - parseFloat(ob);
                $("#money").attr("placeholder", "可提现金额" + canWithdrawl + "元");
                $("#money").val("");
            }
            flag = false;
        }, function() {
            flag = false;
        });
    });
</script>
</html>
