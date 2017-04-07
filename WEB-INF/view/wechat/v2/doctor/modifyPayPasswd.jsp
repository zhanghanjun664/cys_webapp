<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <a onclick="backToHome()" class="back-to-home logo">返回首页</a>
    <h3 class="tit">修改密码</h3>
</header>
<!-- topbar end -->
<!-- modify pay password start -->
<div class="main modify-pay-pwd">
    <form class="form-pay-pwd" id="form-pay-pwd">
        <!-- step 1 -->
        <div class="step-1">
            <label for="pay-pwd">请输入支付密码,以验证身份</label>
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
        <!-- step 2 -->
        <div class="step-2" style="display:none;">
            <label for="pay-pwd-1">请输入新的支付密码</label>
					<span class="am-password-handy">
						<input type="tel" id="pay-pwd-1" name="pay-pwd-1" maxlength="6"/>
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
        <!-- step 3 -->
        <div class="step-3" style="display:none;">
            <label for="pay-pwd-2">请再次确认支付密码</label>
					<span class="am-password-handy">
						<input type="tel" id="pay-pwd-2" name="pay-pwd-2" maxlength="6"/>
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
    </form>
</div>
<!-- modify pay password end -->
</body>
<script>
    // 支付密码设置确认
    payPwd('#pay-pwd');
    payPwd('#pay-pwd-1');
    payPwd('#pay-pwd-2');

    // 身份验证
    $('#pay-pwd').on('keyup', function(){
        if($(this).val().length == 6){
            var payPwdVal = $(this).val();
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
                    $('.step-1').hide().next().show();
                }
            });
        }
    });

    $('#pay-pwd-1').on('keyup', function(){
        var pwd = $(this).val();
        if(pwd.length == 6){
            if(!/^[0-9]*$/.test(pwd)){
                layer.alert('支付密码只能输入数字,请重新输入', {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });
                return;
            }
            $('.step-2').hide().next().show();
        }
    });

    $('#pay-pwd-2').on('keyup', function(){
        if($(this).val().length == 6){
            var payPwdNew = $('#pay-pwd-1').val(),
                    payPwdNewConfirm = $('#pay-pwd-2').val();
            if(payPwdNewConfirm != payPwdNew){
                layer.alert('两次输入的密码不一致,请重新输入', {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });
            }else{
                var data = {"payPasswd" : hex_md5(payPwdNew)};
                sendRequest("setPayPasswd.htm", "POST", data, function(result) {
                    if(result) {
                        layer.alert(result, {
                            title: false,
                            closeBtn: false
                        }, function(){
                            layer.closeAll();
                        });
                    } else {
                        layer.msg('支付密码修改成功');
                        setTimeout(function(){
                            goto("toWallet.htm");
                        }, 500);
                    }
                });
            }
        }
    });
</script>
</html>
