<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String phoneNumber = (String)request.getAttribute("phoneNumber");
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
        <h2>设置密码</h2>
    </header>
    <!--header-->
    <!--content-->
    <div class="content mt">
        <!--list-->
        <ul class="list formlist">
            <li class="clearfix borderb">
                <label class="fl formfont">密码</label>
                <label class="fr forminput"><input type="password" class="fl" placeholder="请输入密码" id="forepass1"></label>
            </li>
            <li class="clearfix ">
                <label class="fl formfont">确定密码</label>
                <label class="fr forminput"><input type="password" class="fl" placeholder="请输入确定密码" id="forepass2"></label>
            </li>
        </ul>
        <div class="btn reg_next" disabled id="finishsetpass">完成</div>
        <!--list-->
    </div>
    <!--content-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.ForgetPwdOk);

    /*设置新密码*/
    $('#forepass1').on('input', function (ev) {
        if (checknull('#forepass1')) {
            $('#finishsetpass').removeAttr('disabled');
        } else {
            $('#finishsetpass').attr('disabled', 'true');
        }
    });
    var submitFlag = false;
    $('#finishsetpass').on('click', function (ev) {
        if ($('#finishsetpass').attr('disabled')) {
            return;
        }
        //判断密码是否输入正确
        if (checkregular('#forepass1', '4') == false) {
            layer.alert(errorMsg.password, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forepass1').focus();
            });
            return;
        }
        //判断确定密码是否输入
        if (checknull('#forepass2') == false) {
            layer.alert(errorMsg.password2, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forepass2').focus();
            });
            return;
        }
        //判断两次密码是否输入相同
        if (checksame('#forepass1', '#forepass2') == false) {
            layer.alert(errorMsg.pwdConfirm, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#forepass2').focus();
            });
            return;
        }
        if(submitFlag)
            return;
        submitFlag = true;
        //完成修改密码
        var url = 'forget.htm';
        var data = {password:$('#forepass1').val().trim(),phoneNumber:<%=phoneNumber%>};
        sendRequest(url, "POST", data, function (msg) {
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
                submitFlag = false;
            } else {
                toPersonal();
            }
        }, function () {
            submitFlag = false;
        });
    });
</script>
</html>
