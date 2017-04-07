<%@ page import="cn.aidee.jdoctor.model.JdBankCardQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdDoctorModel doctorModel = (JdDoctorModel) request.getSession().getAttribute(WebConstants.SESSION_DOCTOR);
    List<JdBankCardQueryModel> bankCardList = (List<JdBankCardQueryModel>)request.getAttribute("bankCardList");
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
    <h3 class="tit">提现</h3>
</header>
<!-- topbar end -->
<!-- withdraw start -->
<div class="main withdraw">
    <form class="form-withdraw" id="form-withdraw">
        <div class="grid mt-10">
            <p>
                <label for="savings-card">存蓄卡</label>
                <input type="text" name="savings-card" id="savings-card" placeholder="请选择" readonly/>
            </p>
            <p>
                <label for="amount">金额(元)</label>
                <input type="tel" name="amount" id="amount" onafterpaste="this.value=this.value.replace(/\D/g,'')"
                       placeholder="可提现金额<%=doctorModel.getAccountBalance().setScale(0)%>元"/>
            </p>
        </div>
        <div class="withdraw-tips">提现金额需要5-7个工作日到账，金额不能小于500元，且必须为500的倍数。</div>
        <div class="form-submit">
            <input type="button" value="提交" class="btn-submit" disabled/>
        </div>
    </form>
</div>
<!-- withdraw end -->

<!-- pay pwd start -->
<div class="mask"></div>
<div class="popup withdraw-pwd">
    <div class="popup-hd">
        <h3>请输入支付密码</h3>
        <a class="btn-colose"></a>
    </div>
    <div class="popup-con">
        <p>提现<br><em class="withdraw-amount">￥0.00</em></p>

        <div class="pwd-box">
					<span class="am-password-handy">
						<input type="tel" id="pay-pwd" name="pay-pwd" maxlength="6"/>
						<ul class="am-password-handy-security">
                            <li><i></i></li>
                            <li><i></i></li>
                            <li><i></i></li>
                            <li><i></i></li>
                            <li><i></i></li>
                            <li><i></i></li>
                        </ul>
					</span>
        </div>
    </div>
</div>
<!-- pay pwd end -->

<!-- card select start -->
<div class="popup visit-addr-wrap">
    <div class="popup-content">
        <%
            for(JdBankCardQueryModel bankCard : bankCardList) {
                if(bankCard.getReceiptAccount() != null)
                    out.println("<a id='"+bankCard.getUuid().toString()+"'>"+bankCard.getBankName()+"("+bankCard.getReceiptAccount().substring(bankCard.getReceiptAccount().length()-4, bankCard.getReceiptAccount().length())+")</a>");
            }
        %>
        <a class="popup-add-addr" onclick="goto('toAddBankCard.htm?from=withdrawl')">使用新卡提现</a>
    </div>
    <div class="popup-bottom">
        <a class="popup-btn-cancel">取消</a>
    </div>
</div>
<!-- card select start -->
</body>
<script>
    payPwd('#pay-pwd');

    // 银行卡选择
    var bankCardId;
    $('#savings-card').on('click', function(){
        $('.mask, .visit-addr-wrap').fadeIn();
    });
    $('.visit-addr-wrap .popup-content a').not('.popup-add-addr').click(function(){
        bankCardId = $(this).attr("id");
        var txt = $(this).html();
        $('.mask, .visit-addr-wrap').fadeOut();
        $('#savings-card').val(txt);
    });

    $('#amount').on('keyup', function () {
        this.value=this.value.replace(/\D/g,'');
        var _amount = $(this).val();
        if (_amount.length > 0) {
            $('.btn-submit').prop('disabled', false);
        }
    });

    // 提交
    $('.btn-submit').on('click', function () {
        if(!bankCardId) {
            layer.msg("请选择存储卡");
            return;
        }
        // 初始化
        $('#pay-pwd').val('');
        $('.am-password-handy-security i').css('visibility', 'hidden');

        var amount = $('#amount').val();
        var canWithdrawl = <%=doctorModel.getAccountBalance().setScale(0)%>;
        if (amount < 500) {
            layer.alert('提现金额不能小于500元', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#amount').focus();
            });
        } else if(amount %500 != 0) {
            layer.alert('提现金额必须为500元的倍数', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#amount').focus();
            });
        } else if(amount > canWithdrawl) {
            layer.alert('提现金额超出余额', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#amount').focus();
            });
        } else {
            $(".withdraw-amount").html("￥"+amount+".00");
            $('.mask, .withdraw-pwd').fadeIn();
        }
    });

    $('#pay-pwd').on('keyup', function () {
        if ($(this).val().length == 6) {
            var payPwdVal = $('#pay-pwd').val();
            var data = {"payPasswd" : hex_md5(payPwdVal)};
            sendRequest("checkPayPasswd.htm", "POST", data, function(result) {
                if(result) {
                    layer.confirm(result, {
                        title: false,
                        closeBtn: false,
                        btn: ['&nbsp;&nbsp;&nbsp;重试&nbsp;&nbsp;&nbsp;&nbsp;', '忘记密码']
                    }, function(){
                        layer.closeAll();
                    }, function(){
                        goto("toForgetPayPasswd.htm");
                    })
                } else {
                    var amount = $('#amount').val();
                    var data1 = {"amount" : amount, "bankCardId" : bankCardId};
                    sendRequest("withdraw.htm", "POST", data1, function(result) {
                        if(result) {
                            $('.mask, .withdraw-pwd').fadeOut();
                            layer.alert(result, {
                                title: false,
                                closeBtn: false
                            }, function(){
                                layer.closeAll();
                            });
                        } else {
                            goto("toWithdrawlTip.htm?amount="+amount+"&card="+encodeURI(encodeURI($('#savings-card').val())));
                        }
                    });
                }
            });
        }
    });

    // 取消
    $('.popup-btn-cancel, .mask').on('click', function(){
        $('.mask, .popup').fadeOut();
    });
    $('.btn-colose').on('click', function () {
        $('.mask, .withdraw-pwd').fadeOut();
    });
</script>
</html>
