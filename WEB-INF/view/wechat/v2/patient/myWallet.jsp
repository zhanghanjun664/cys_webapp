<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <h2>钱包</h2>
    </header>
    <!--header-->

    <!--content-->
    <div class="content">
        <!--balance-->
        <section class="balance pr">
            <p>账户余额</p>
            <p id="balance">￥0</p>
            <i class="pa balance_bg"></i>
        </section>
        <!--balance-->
        <!--balance_list-->
        <ul class="list balance_list">
            <li class="pr">
                <a onclick="goto('toWithdrawl.htm')">
                    <small class="fl">提现</small>
                </a>
                <span class="arrow pa"></span>
            </li>
            <li class="pr">
                <a onclick="goto('toAccountRecord.htm')">
                    <small class="fl">账户记录</small>
                </a>
                <span class="arrow pa"></span>
            </li>
            <li class="pr">
                <a onclick="goto('toCouponList.htm')">
                    <small class="fl">现金劵</small>
                    <i class="fr" id="cashCouponNo">0张</i>
                </a>
                <span class="arrow pa"></span>
            </li>
        </ul>
        <!--balance_list-->
    </div>
    <!--content-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.MyWallet);

    sendRequest("asynWalletInfo.htm?random="+Math.random()*1000, "GET", function(result) {
        var info = result.split(";");
        if(info.length === 1) {
            layer.alert(info[0], {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
        } else {
            $("#balance").html("￥" + info[0]);
            $("#cashCouponNo").html(info[1] + "张");
        }
    });
</script>
</html>
