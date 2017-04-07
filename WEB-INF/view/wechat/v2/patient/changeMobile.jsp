<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
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

        <h2>修改手机号码</h2>
    </header>
    <!--header-->


    <!--content-->
    <div class="content mt">

        <!-- step 1 -->
        <div class="step-1">
            <ul class="list formlist">
                <li class="clearfix">
                    <label class="fl formfont">密码</label>
                    <label class="fl forminput"><input type="password" class="fl" placeholder="请输入密码"
                                                       id="oldpass"></label>
                </li>
            </ul>
            <div class="btn reg_next" disabled id="nextStep">下一步</div>
        </div>

        <!-- step 1 -->
        <!-- step 2 -->
        <div class="step-2" style="display:none;">
            <ul class="list formlist">

                <li class="clearfix borderb pr">
                    <label class="fl formfont">手机号</label>
                    <label class="fr forminput"><input type="number" maxlength="11" class="fl" placeholder="请输入手机号"
                                                       id="forgetpass_phone"></label>

                    <div class="sendcode pa" id="cphonecode">获取验证码</div>
                </li>

                <li class="clearfix">
                    <label class="fl formfont">验证码</label>
                    <label class="fr forminput"><input type="number" class="fl" placeholder="请输入验证码"
                                                       id="forcode"></label>
                </li>

            </ul>
            <div class="btn reg_next" disabled id="changephone">确定修改</div>

        </div>
        <!-- step 2 -->

    </div>
    <!--content-->

</div>
<div class="callphone" style="position: absolute;margin-bottom:0.2rem;line-height:0.35rem;">若获取不到验证码，请致电：<a
        href="tel:400-061-8989">400-061-8989</a></div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.ChangeMobile);
    /*输入旧密码*/
    $('#oldpass').on('input', function (ev) {
        if (checknull('#oldpass')) {
            $('#nextStep').removeAttr('disabled');
        } else {
            $('#nextStep').attr('disabled', 'true');
        }
    });
    // 下一步
    var nextFlag = false;
    $('#nextStep').on('click', function () {
        if ($('#nextStep').attr('disabled')) {
            return;
        }
        if (nextFlag)
            return;
        nextFlag = true;

        var oldPassword = $('#oldpass');
        var oldPass = $.trim(oldPassword.val());
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
                    var info = msg.split(";");
                    layer.confirm(info[1], {
                        title: false,
                        closeBtn: false,
                        btn: ['忘记密码', '确定']
                    }, function () {
                        goto('toResetPassword.htm?forget=true');
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
        if (checknull('#forgetpass_phone')) {
            $('#changephone').removeAttr('disabled');
        } else {
            $('#changephone').attr('disabled', 'true');
        }
    });
    //点击获取验证码
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
            submitFlag = false;
        });
    }

    //确定修改
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
                    goto('toPersonalInfo.htm');
                });
            }
        }, function () {
            layer.closeAll();
        });
    }
</script>
</html>
