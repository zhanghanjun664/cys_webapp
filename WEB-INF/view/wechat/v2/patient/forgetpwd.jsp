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
        <h2>忘记密码</h2>
    </header>
    <!--header-->
    <!--content-->
    <div class="content mt">
        <!--list-->
        <ul class="list formlist">
            <li class="clearfix borderb pr">
                <label class="fl formfont">手机号</label>
                <label class="fr forminput"><input type="text" maxlength="11" class="fl" placeholder="请输入手机号" id="forgetpass_phone"></label>
                <div class="sendcode pa" id="fpassscode">获取验证码</div>
            </li>
            <li class="clearfix">
                <label class="fl formfont">验证码</label>
                <label class="fr forminput"><input type="text" class="fl" placeholder="请输入验证码" id="forcode"></label>
            </li>
        </ul>
        <div class="btn reg_next" disabled id="forpass_next">下一步</div>
        <!--list-->
    </div>
    <!--content-->
</div>

<div class="callphone">若获取不到验证码，请致电：<a href="tel:400-061-8989">400-061-8989</a></div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.ForgetPwd);

    /*检测是否手机号码是否为空*/
    $('#forgetpass_phone').on('input', function (ev) {
        if (checknull('#forgetpass_phone')) {
            $('#forpass_next').removeAttr('disabled');
        } else {
            $('#forpass_next').attr('disabled', 'true');
        }
    });

    //点击发送验证码
    $('#fpassscode').on('click', function (ev) {
        //判断是否输入手机号码
        if (checknull('#forgetpass_phone') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forgetpass_phone').focus();
            });
            return;
        }
        //判断手机号码是否正确
        if (checkregular('#forgetpass_phone', '1') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forgetpass_phone').focus();
            });
            return;
        }
        var url = 'getForgetVerifyCode.htm?phoneNumber=' + $('#forgetpass_phone').val().trim();
        sendRequest(url, "GET", function (msg) {
            if (msg) {
                if (msg.indexOf('未注册') > -1) {
                    layer.confirm(errorMsg.noreg, {
                        title: false,
                        closeBtn: false,
                        btn: ['注册', '确定']
                    }, function () {
                        goto('toRegister.htm')
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                }
            } else {
                //执行发送验证码
                vercode();
            }
        });
    });

    $('#forpass_next').on('click', function (ev) {
        if ($('#forpass_next').attr('disabled')) {
            return;
        }
        //判断是否输入手机号码
        if (checknull('#forgetpass_phone') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forgetpass_phone').focus();
            });
            return;
        }
        //判断手机号码是否正确
        if (checkregular('#forgetpass_phone', '1') == false) {
            layer.alert(errorMsg.mobile, {
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
            layer.alert(errorMsg.code, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forcode').focus();
            });
            return;
        }
        var url = 'verifyCode.htm';
        var data = {'phoneNumber': $('#forgetpass_phone').val().trim(), 'code': $('#forcode').val().trim()};
        sendRequest(url, "POST", data, function (msg) {
            if (msg) {
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                goto("toForget2.htm?phoneNumber="+$('#forgetpass_phone').val().trim());
            }
        });
    });
</script>
</html>
