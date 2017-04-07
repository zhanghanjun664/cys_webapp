<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <h3 class="tit">忘记密码</h3>
    <a class="back-to-home logo">返回首页</a>
</header>
<!-- topbar end -->

<!-- get password start -->
<div class="main register mt-10">
    <form class="form form-get-pwd">
        <!-- step 1 -->
        <div class="step-1">
            <div class="grid">
                <p>
                    <label for="phone-num">手机号</label>
                    <input type="text" name="phone-num" id="phone-num" placeholder="请输入手机号"/>
                    <a class="get-verify-code">获取验证码</a>
                </p>

                <p>
                    <label for="verify-code">验证码</label>
                    <input type="text" name="verify-code" id="verify-code" placeholder="请输入验证码"/>
                </p>
            </div>
            <div class="form-submit">
                <input type="button" value="下一步" class="btn-submit step-next" disabled/>
            </div>
        </div>
        <!-- step 2 -->
        <div class="step-2" style="display:none;">
            <div class="grid">
                <p>
                    <label for="pwd">密码</label>
                    <input type="password" name="pwd" id="pwd" placeholder="请输入密码"/>
                </p>

                <p>
                    <label for="pwd-1">确认密码</label>
                    <input type="password" name="pwd-1" id="pwd-1" placeholder="再次输入密码"/>
                </p>
            </div>
            <div class="form-submit">
                <input type="button" value="完成" class="btn-submit btn-done-register"/>
            </div>
        </div>
    </form>
</div>
<!-- get password end -->
<div class="call">
    <p>若获取不到验证码,请致电:<b><a href="tel:400-061-8989">400-061-8989</a></b></p>
</div>
</body>
<script>
    $(function () {
        // 提交按钮状态
        $('#phone-num').on('keyup', function () {
            if ($(this).val().length > 0) {
                $('.btn-submit').prop('disabled', false);
            } else {
                $('.btn-submit').prop('disabled', true);
            }
        });

        // 下一步
        var nextFlag = false;
        $('.step-next').on('click', function () {
            if(nextFlag)
                return;
            nextFlag = true;

            var mobile = $('#phone-num'),
                    verifyCode = $('#verify-code');

            var errorMsg = {
                mobile: '请输入正确的手机号',
                verifyCode: '验证码有误,请重新输入!'
            };

            var phone = trim(mobile.val());
            var code = trim(verifyCode.val());
            if (isEmpty('#phone-num')) {
                layer.alert(errorMsg.mobile);
                nextFlag = false;
            } else if (!checkMobile(phone)) {
                layer.alert(errorMsg.mobile, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    mobile.focus();
                });
                nextFlag = false;
            } else if (isEmpty('#verify-code')) {
                layer.alert(errorMsg.verifyCode, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    verifyCode.focus();
                });
                nextFlag = false;
            } else {
                var data = {"phoneNumber": phone, "code": code};
                sendRequest("verifyCode.htm", "POST", data, function (msg) {
                    if(msg) {
                        layer.alert(msg, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                            verifyCode.focus();
                        });
                        nextFlag = false;
                    } else {
                        $('.step-1').hide().siblings().show();
                    }
                }, function() {
                    nextFlag = false;
                });
            }
        });

        var timer = null;
        var _time = 60;
        function validTime() {
            $('.get-verify-code').addClass('disabled').text('重新发送'+ _time +'s');
            _time--;
            timer = setTimeout(validTime, 1000);

            if(_time == -1) {
                $('.get-verify-code').removeClass('disabled').text('获取验证码');
                clearTimeout(timer);
                _time = 60;
                codeFlag = false;
            }
        }

        // 获取验证码
        var codeFlag = false;
        $('.get-verify-code').on('click', function () {
            if(codeFlag)
                return;
            codeFlag = true;

            var mobile = $('#phone-num');
            var phone = trim(mobile.val());
            var errorMsg = {
                mobile: '请输入正确的手机号'
            };

            if (isEmpty('#phone-num')) {
                layer.alert(errorMsg.mobile, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    mobile.focus();
                });
                codeFlag = false;
            } else if (!checkMobile(phone)) {
                layer.alert(errorMsg.mobile, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    mobile.focus();
                });
                codeFlag = false;
            } else {
                sendRequest("getForgetVerifyCode.htm?phoneNumber="+phone, "GET", function (msg) {
                    if(msg) {
                        if (msg.indexOf('未注册') > -1) {
                            layer.confirm(msg, {
                                title: false,
                                closeBtn: false,
                                btn: ['立即注册', '确定']
                            }, function () {
                                window.location.href = 'toRegister.htm';
                            }, function () {
                                layer.closeAll();
                            })
                        } else {
                            layer.alert(msg, {
                                title: false,
                                closeBtn: false
                            }, function () {
                                layer.closeAll();
                            });
                        }
                        codeFlag = false;
                    } else {
                        validTime();
                    }
                }, function() {
                    codeFlag = false;
                });
            }
        });

        // 点击完成
        var submitFlag = false;
        $('.btn-done-register').on('click', function () {
            if(submitFlag)
                return;
            submitFlag = true;

            var pwd = $('#pwd'),
                    pwdConfirm = $('#pwd-1');
            var password = pwd.val();

            var errorMsg = {
                pwd: '密码为6~20位之间的字符组合',
                pwdConfirm: '两次密码不一致,请重新输入!'
            };

            if (password.length < 6 || password.length > 20) {
                layer.alert(errorMsg.pwd, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    pwd.focus();
                });
                submitFlag = false;
            } else if (pwdConfirm.val() != pwd.val()) {
                layer.alert(errorMsg.pwdConfirm, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    pwdConfirm.focus();
                });
                submitFlag = false;
            } else {
                var phoneNumber = trim($('#phone-num').val());
                var data = {"phoneNumber":phoneNumber, "password":password};
                sendRequest("forget.htm", "POST", data, function (msg) {
                    if(msg) {
                        layer.alert(msg, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                        });
                        submitFlag = false;
                    } else {
                        layer.alert('修改密码成功', {
                            title: false,
                            closeBtn: false,
                            btn: '确定'
                        }, function () {
                            layer.closeAll();
                            window.location.href = 'toPersonal.htm';
                        });
                    }
                }, function() {
                    submitFlag = false;
                });
            }
        });
    });
</script>
</html>