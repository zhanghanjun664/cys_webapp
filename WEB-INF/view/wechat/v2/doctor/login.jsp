<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <h3 class="tit">登陆</h3>
    <a href="javascript:void(0);" class="back-to-home logo">返回首页</a>
</header>
<!-- topbar end -->

<!-- login start -->
<div class="main login mt-10">
    <form class="form form-login" id="form-login">
        <div class="grid">
            <p>
                <label for="phone-num">手机号</label>
                <input type="text" name="phone-num" id="phone-num" placeholder="请输入手机号"/>
            </p>

            <p>
                <label for="pwd">密码</label>
                <input type="password" name="pwd" id="pwd" placeholder="请输入密码"/>
            </p>
        </div>
        <dl class="mt-10 clearfix">
            <dt class="fl">
                <%--<input type="checkbox" id="remember-pwd"/>--%>
                <%--<label for="remember-pwd">记住密码</label>--%>
            </dt>
            <dd class="fr">
                <a href="javascript:void(0);" onclick="window.location.href='toForget.htm'" class="forget-pwd">忘记密码</a>
            </dd>
        </dl>
        <div class="form-submit">
            <input type="button" value="登陆" class="btn-submit"/>
        </div>
    </form>
</div>
<div id="test"></div>
<!-- login end -->
<div class="bottom-btn">
    <a href="javascript:void(0);" onclick="window.location.href='toRegister.htm'" class="btn-register">注册</a>
</div>
</body>
<script>
    $(function () {
        // 表单校验
        var submitFlag = false;
        $('.btn-submit').on('click', function () {
            if(submitFlag)
                return;
            submitFlag = true;
            var mobile = $('#phone-num'),
                    pwd = $('#pwd');
            var errorMsg = {
                mobile: '请输入正确的手机号',
                pwd: '密码输入有误,请重新输入'
            };

            var phone = trim(mobile.val());
            var password = trim(pwd.val());
            if (isEmpty('#phone-num')) {
                layer.alert(errorMsg.mobile);
                submitFlag = false;
            } else if (!checkMobile(phone)) {
                layer.alert(errorMsg.mobile, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    mobile.focus();
                });
                submitFlag = false;
            } else if (isEmpty('#pwd')) {
                layer.alert(errorMsg.pwd, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    pwd.focus();
                });
                submitFlag = false;
            } else if (password.length < 6) {
                layer.alert(errorMsg.pwd, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    pwd.focus();
                });
                submitFlag = false;
            } else {
                var data = {"username": phone, "password": hex_md5(password)};
                sendRequest("login.htm", "POST", data, function (msg) {
                    if (msg) {
                        layer.alert(msg, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                        });
                        submitFlag = false;
                    } else {
                        window.location.href = "toPersonal.htm";
                    }
                }, function() {
                    submitFlag = false;
                });
            }
        })
    })
</script>
</html>
