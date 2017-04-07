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
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit">钱包</h3>
    <a class="more">更多</a>
</header>
<!-- topbar end -->
<div class="viewport wallet">
    <!-- thumb start -->
    <div class="thumb-wallet">
        <p>账户余额</p>
        <p><i>￥</i><span class="account-balance">0</span></p>
    </div>
    <!-- thumb end -->
    <div class="grid no-border-t">
        <a onclick="toWithdrawl()"><i class="icon-item-w ico-cash-1"></i>提现</a>
        <a onclick="goto('toWithdrawlHistory.htm')"><i class="icon-item-w ico-exchange"></i>转账记录</a>
    </div>
    <div class="grid mt-10">
        <a onclick="goto('toBankCardManage.htm')"><i class="icon-item-w ico-card"></i>银行卡<em id="cardNum">0张</em></a>
    </div>
</div>
<!-- more start -->
<div class="mask"></div>
<div class="popup more-wrap">
    <div class="popup-con">
        <a class="btn-more btn-modify-pay-pwd">修改支付密码</a>
        <a class="btn-more btn-forget-pay-pwd">忘记支付密码</a>
    </div>
    <div class="popup-bottom">
        <a class="btn-more btn-m-cancel">取消</a>
    </div>
</div>
<!-- more end -->
</body>
<script>
    // 是否已设置支付密码
    var hasPayPasswd = "<%=doctorModel.getPayPasswd()!=null%>";

    // 异步加载钱包信息
    sendRequest("asynWalletInfo.htm?random="+Math.random()*10000, "GET", function(result) {
        var info = result.split(";");
        if(info.length === 1) {
            MsgOpt.showMsgBox(info[0]);
        } else {
            $(".account-balance").html(info[0]);
            $("#cardNum").html(info[1] + "张");
            hasPayPasswd = info[2];
        }
    });

    // 点击更多
    $('.more').on('click', function(){
        $('.mask, .more-wrap').fadeIn();
    });

    // 隐藏更多
    $('.mask, .btn-m-cancel').on('click', function(){
        $('.mask, .more-wrap').fadeOut();
    });

    // 修改支付密码
    $('.btn-modify-pay-pwd').on('click', function(){
        if(hasPayPasswd === "true") {
            goto("toModifyPayPasswd.htm");
        } else {
            $('.mask, .more-wrap').fadeOut();
            layer.confirm('请先设置支付密码', {
                title: false,
                closeBtn: false,
                btn: ['&nbsp;&nbsp;&nbsp;取消&nbsp;&nbsp;&nbsp;&nbsp;', '设置密码']
            }, function(){
                layer.closeAll();
            }, function(){
                goto("toSetPayPasswd.htm");
            });
        }
    });

    // 忘记支付密码
    $('.btn-forget-pay-pwd').on('click', function(){
        if(hasPayPasswd === "true") {
            goto("toForgetPayPasswd.htm");
        } else {
            $('.mask, .more-wrap').fadeOut();
            layer.confirm('请先设置支付密码', {
                title: false,
                closeBtn: false,
                btn: ['&nbsp;&nbsp;&nbsp;取消&nbsp;&nbsp;&nbsp;&nbsp;', '设置密码']
            }, function(){
                layer.closeAll();
            }, function(){
                goto("toSetPayPasswd.htm");
            });
        }
    });

    // 去提现
    function toWithdrawl() {
        if($("#cardNum").html() === "0张") {
            layer.msg('请先添加银行卡');
        } else if(hasPayPasswd === "true") {
            goto("toWithdrawl.htm");
        } else {
            goto("toSetPayPasswd.htm");
        }
    }
</script>
</html>
