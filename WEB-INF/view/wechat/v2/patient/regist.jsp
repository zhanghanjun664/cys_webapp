<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/head.jsp"/>
</head>
<body>
<%
    String targetReqUrl = (String)request.getSession().getAttribute("targetReqUrl") == 
                        null ? "" : (String)request.getSession().getAttribute("targetReqUrl");
%>
<!--wrap-->
<div class="wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>注册</h2>
    </header>
    <!--header-->

    <!--content-->
    <div class="content mt">
        <!--list-->
        <ul class="list formlist">
            <li class="clearfix borderb pr">
                <label class="fl formfont">手机号</label>
                <label class="fr forminput"><input type="text" maxlength="11" class="fl" placeholder="请输入手机号" id="regphone"></label>
                <div class="sendcode pa" id="reggetcode" bol=true>获取验证码</div>
            </li>
            <li class="clearfix borderb">
                <label class="fl formfont">验证码</label>
                <label class="fr forminput"><input type="text" class="fl" placeholder="请输入验证码" id="regcode"></label>
            </li>
            <li class="clearfix">
                <label class="fl formfont">邀请码</label>
                <label class="fr forminput"><input type="text" class="fl" placeholder="选填" id="invitecode"></label>
            </li>
        </ul>
        <section class="clearfix gotoreg">
            <label class="fr">已有账号，请<a onclick="goto('toLogin.htm')" class="thline">登录</a></label>
        </section>
        <div class="btn reg_next2" disabled id="regnext">下一步</div>
        <!--list-->
    </div>
    <!--content-->
    <div class="callphone">若获取不到验证码，请致电：<a href="tel:400-061-8989">400-061-8989</a></div>
</div>
<!--wrap-->
</body>
<script>
    var targetReqUrl = '<%=targetReqUrl%>';
    if(targetReqUrl !=null && targetReqUrl !=''){
        window.localStorage.setItem("targetReqUrl",targetReqUrl);
    }
    sendPageVisit(Page_Constant.Register);

    /*检测是否手机号码是否为空*/
    $('#regphone').on('input', function (ev) {
        if (checknull('#regphone')) {
            $('#regnext').removeAttr('disabled');
        } else {
            $('#regnext').attr('disabled', 'true');
        }
    });

    //点击发送验证码
    $('#reggetcode').on('click', function (ev) {
        if ($(this).attr('bol') == "false") {
            return;
        }
        //判断用户是否输入手机号码
        if (checknull('#regphone') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#regphone').focus();
            });
            return;
        }
        //判断手机号码是否正确
        if (checkregular('#regphone', '1') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#regphone').focus();
            });
            return;
        }
        var url = 'getRegisterVerifyCode.htm?phoneNumber=' + $('#regphone').val().trim();
        sendRequest(url, "GET", function (msg) {
            if (msg) {
                if (msg.indexOf('已注册') > -1) {
                    layer.confirm(errorMsg.phonesave, {
                        title: false,
                        closeBtn: false,
                        btn: ['登陆', '确定']
                    }, function () {
                        goto('toLogin.htm');
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

    /*点击下一步*/
    $('#regnext').on('click', function (ev) {
        if ($('#regnext').attr('disabled')) {
            return;
        }
        //判断是否输入手机号码
        if (checknull('#regphone') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#regphone').focus();
            });
            return;
        }
        //判断手机号码是否正确
        if (checkregular('#regphone', '1') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#regphone').focus();
            });
            return;
        }
        //判断验证码是否输入
        if (checknull('#regcode') == false) {
            layer.alert(errorMsg.code, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#regcode').focus();
            });
            return;
        }
        var url = 'verifyCode.htm';
        var data = {'phoneNumber': $('#regphone').val().trim(), 'code': $('#regcode').val().trim()};
        sendRequest(url, "POST", data, function (msg) {
            if (msg) {
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                goto("toRegister2.htm?phoneNumber="+$('#regphone').val().trim()+"&invitecode="+$('#invitecode').val().trim());
            }
        });
    });
</script>
</html>
