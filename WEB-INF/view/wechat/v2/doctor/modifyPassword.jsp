<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <h3 class="tit">修改密码</h3>
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
</header>
<!-- topbar end -->

<!-- get password start -->
<div class="main register mt-10">
    <form class="form form-get-pwd">
        <!-- step 1 -->
        <div class="step-1">
            <div class="grid">
                <p>
                    <label for="oldPassword">旧密码</label>
                    <input type="password" name="oldPassword" id="oldPassword" placeholder="请输入旧密码"/>
                </p>
            </div>
            <div class="form-submit">
                <input type="button" value="下一步" class="btn-submit step-next"/>
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
</body>
<script>
    $(function () {
        // 下一步
        var nextFlag = false;
        $('.step-next').on('click', function () {
            if(nextFlag)
                return;
            nextFlag = true;

            var oldPassword = $('#oldPassword');
            var oldPass = trim(oldPassword.val());
            if (oldPass.length < 6 || oldPass.length > 20) {
                layer.alert("旧密码不正确", {
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
                    if(msg) {
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
                }, function() {
                    nextFlag = false;
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
                var data = {"password":password};
                sendRequest("resetPassword.htm", "POST", data, function (msg) {
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