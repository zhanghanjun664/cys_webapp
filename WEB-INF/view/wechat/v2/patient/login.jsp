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
        <h2>登陆</h2>
    </header>
    <!--header-->

    <!--content-->
    <div class="content mt">

        <!--list-->
        <ul class="list formlist">
            <li class="clearfix borderb">
                <label class="fl formfont">手机号</label>
                <label class="fl forminput"><input type="text" maxlength="11" class="fl" placeholder="请输入手机号" id="loginphone"></label>
            </li>
            <li class="clearfix">
                <label class="fl formfont">密码</label>
                <label class="fl forminput"><input type="password" class="fl" placeholder="请输入密码" id="loginpass"></label>
            </li>
        </ul>

        <section class="clearfix gotoreg">
            <label class="fr"><a onclick="goto('toForget.htm')">忘记密码</a></label>
        </section>

        <section class="clearfix gotologin">
            <div class="fl" disabled id="login">登陆</div>
            <a class="fr" onclick="goto('toRegister.htm')">注册</a>
        </section>
        <!--list-->

    </div>
    <!--content-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.Login);

    /*检测是否手机号码是否为空（为空时点击登陆无效）*/
    $('#loginphone').on('input', function (ev) {
        if (checknull('#loginphone')) {
            $('#login').removeAttr('disabled');
        } else {
            $('#login').attr('disabled', 'true');
        }
    });

    $('#login').on('click', function (ev) {
        if ($('#login').attr('disabled')) {
            return;
        }
        //判断是否输入手机号码
        if (checknull('#loginphone') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#loginphone').focus();
            });
            return;
        }
        //判断手机号码是否正确
        if (checkregular('#loginphone', '1') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#loginphone').focus();
            });
            return;
        }
        //判断密码是否为空
        if (checknull('#loginpass') == false) {
            layer.alert(errorMsg.pwd, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#loginpass').focus();
            });
            return;
        }
        //AJAX 提交
        var targetReqUrl = '<%=targetReqUrl%>';
        var data = {"username": $('#loginphone').val().trim(), "password": hex_md5($('#loginpass').val().trim())};
        sendRequest("login.htm", "POST", data, function (msg) {
            if (msg) {
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
            	if(targetReqUrl !=null && targetReqUrl !=''){
                    window.location.href = targetReqUrl;
                    return ;
                } else{
                	toPersonal();
                }
            }
        });
    });

</script>
</html>
