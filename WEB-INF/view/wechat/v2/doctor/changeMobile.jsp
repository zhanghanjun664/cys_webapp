<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">

    <!--header-->
    <header class="fixed topbar">
        <h3 class="tit">修改手机号</h3>
        <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
    </header>
    <!--header-->


    <!-- get password start -->
    <div class="main register mt-10">
        <form class="form form-get-pwd">

            <!-- step 1 -->
            <div class="step-1">
                <div class="grid">
                    <p>
                        <label for="oldPassword">密码</label>
                        <input type="password" name="oldPassword" id="oldPassword" placeholder="请输入密码"/>
                    </p>
                </div>
                <div class="form-submit">
                    <input type="button" value="下一步" class="btn-submit step-next" disabled/>
                </div>
            </div>
            <!-- step 1 -->
            <!-- step 2 -->
            <div class="step-2" style="display:none;">
                <div class="grid">
                    <p>
                        <label for="forgetpass_phone">手机号</label>
                        <input type="number" name="phone-num" id="forgetpass_phone" placeholder="请输入手机号"/>
                        <a class="get-verify-code sendcode" id="cphonecode">获取验证码</a>
                    </p>

                    <p>
                        <label for="forcode">验证码</label>
                        <input type="text" name="verify-code" id="forcode" placeholder="请输入验证码"/>
                    </p>
                </div>
                <div class="form-submit">
                    <input type="button" value="确定修改" class="btn-submit step-next" disabled id="changephone"/>
                </div>

            </div>
            <!-- step 2 -->
        </form>
    </div>
    <!-- get password end -->
</div>
<div class="call">
    <p>若获取不到验证码,请致电:<b><a href="tel:400-061-8989">400-061-8989</a></b></p>
</div>
<!--wrap-->
</body>
<script>

    /*输入旧密码*/
    $('#oldPassword').on('input', function (ev) {
        if (checknull('#oldPassword')) {
            $('.step-next').removeAttr('disabled');
        } else {
            $('.step-next').attr('disabled', 'true');
        }
    });
    // 下一步
    var nextFlag = false;
    $('.step-next').on('click', function () {
        if ($('.step-next').attr('disabled')) {
            return;
        }
        if (nextFlag)
            return;
        nextFlag = true;

        var oldPassword = $('#oldPassword');
        var oldPass = trim(oldPassword.val());
        if (oldPass.length < 6 || oldPass.length > 20) {
            layer.alert("密码不正确", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                oldPassword.focus();
            });
            nextFlag = false;
        } else {
            var data = {"oldPassword": hex_md5(oldPass)};
            sendRequest("checkOldPassword.htm", "POST", data, function (msg) {
                if (msg) {
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                        oldPassword.focus();
                    });
                    nextFlag = false;
                } else {
                    $('.step-1').hide().siblings().show();
                }
            }, function () {
                nextFlag = false;
            });
        }
    });
    /*检测是否手机号码是否为空*/
    $('#forgetpass_phone').on('input', function (ev) {
        if ($('#forgetpass_phone').val().trim().length != 0) {
            $('#changephone').removeAttr('disabled');
        } else {
            $('#changephone').attr('disabled', 'true');
        }
    });
    $('#cphonecode').on('click', function (ev) {
        //判断是否输入手机号码
        if (checknull('#forgetpass_phone') == false) {
            layer.alert('请输入手机号!', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forgetpass_phone').focus();
            });
            return;
        }
        //判断是否输入正确的手机号码
        if (checkregular('#forgetpass_phone', '1') == false) {
            layer.alert("请输入正确的11位数手机号!", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forgetpass_phone').focus();
            });
            return;
        }
        //异步发送验证码
        sendPhoneCode();
    });
    $('#changephone').on('click', function (ev) {
        if ($('#changephone').attr('disabled')) {
            return;
        }
        //判断是否输入手机号码
        if (checknull('#forgetpass_phone') == false) {
            layer.alert('请输入手机号!', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forgetpass_phone').focus();
            });
            return;
        }
        //判断是否输入正确的手机号码
        if (checkregular('#forgetpass_phone', '1') == false) {
            layer.alert("请输入正确的11位数手机号!", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forgetpass_phone').focus();
            });
            return;
        }
        //判断验证码是否输入
        if (checknull('#forcode') == false) {
            layer.alert('请输入验证码', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forcode').focus();
            });
            return;
        }
        /* 异步请求发送验证码*/
        verifyCode();
    });
    var submitFlag = false;
    function sendPhoneCode() {
        if (submitFlag) return;
        submitFlag = true;
        var data = {"phoneNumber": $.trim($("#forgetpass_phone").val())};
        sendRequest('getRegisterVerifyCode.htm', "GET", data, function (result) {
            if (result) {
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                /* 发送60s到计时*/
                vercode();
            }
            submitFlag = false;
        }, function () {
            layer.closeAll();
            submitFlag = false;
        });
    }
    function verifyCode() {

        var code = $.trim($("#forcode").val());
        var phoneNumber = $.trim($("#forgetpass_phone").val());
        var data = {'phoneNumber': phoneNumber, 'code': code};
        sendRequest('verifyCode.htm', "POST", data, function (msg) {
            if (msg) {
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                /* 修改手机号*/
                changeMobile();
            }
        });
    }
    /* 异步请求修改手机号*/
    function changeMobile() {
        var data = {"newPhoneNumber": $.trim($("#forgetpass_phone").val())};
        sendRequest('changeMobile.htm', "POST", data, function (result) {
            if (result) {
                if (result.indexOf("登录超时") > -1) {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                        goto('toLogin.htm');
                    });
                } else {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                }
            } else {
                layer.alert("修改成功", {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    goto('toSetting.htm');
                });
            }
        }, function () {
            layer.closeAll();
        });
    }
</script>
</html>
