<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String phoneNumber = (String)request.getAttribute("phoneNumber");
    String invitecode = (String)request.getAttribute("invitecode");
%>
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
            <li class="clearfix borderb">
                <label class="fl formfont">密码</label>
                <label class="fr forminput"><input type="password" class="fl" placeholder="请输入密码" id="reg_pass1"></label>
            </li>
            <li class="clearfix ">
                <label class="fl formfont">确定密码</label>
                <label class="fr forminput"><input type="password" class="fl" placeholder="请输入确定密码" id="reg_pass2"></label>
            </li>
        </ul>
        <div class="btn reg_next" disabled id="finish_reg">完成</div>
        <!--list-->
    </div>
    <!--content-->
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.RegisterOk);

    //点击完成
    $('#reg_pass1').on('input', function (ev) {
        if (checknull('#reg_pass1')) {
            $('#finish_reg').removeAttr('disabled');
        } else {
            $('#finish_reg').attr('disabled', 'true');
        }
    });
    var submitFlag = false;
    $('#finish_reg').on('click', function (ev) {
        if ($('#finish_reg').attr('disabled')) {
            return;
        }
        //判断密码是否输入
        if (checknull('#reg_pass1') == false) {
            layer.alert(errorMsg.password, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#reg_pass1').focus();
            });
            return;
        }
        //判断密码是否输入正确
        if (checkregular('#reg_pass1', '4') == false) {
            layer.alert(errorMsg.password, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#reg_pass1').focus();
            });

            return;
        }
        //判断确定密码是否输入
        if (checknull('#reg_pass2') == false) {
            layer.alert(errorMsg.password2, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#reg_pass2').focus();
            });
            return;
        }
        //判断两次密码是否输入相同
        if (checksame('#reg_pass1', '#reg_pass2') == false) {
            layer.alert(errorMsg.pwdConfirm, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#reg_pass2').focus();
            });
            return;
        }
        if(submitFlag)
            return;
        submitFlag = true;
        //注册
        var url = 'register.htm';
        var data = {invitecode:'',password:hex_md5($('#reg_pass1').val().trim()),phoneNumber:<%=phoneNumber%>};
        var inviteCode = "<%=invitecode%>";
        if(inviteCode != "") {
            data.invitecode = inviteCode;
        }
        var targetReqUrl = '<%=targetReqUrl%>';
        sendRequest(url, "POST", data, function (msg) {
            if (msg) {
                if(msg.indexOf('success') > -1){
                    if(targetReqUrl !=null && targetReqUrl !=''){
                        window.location.href = targetReqUrl;
                        return ;
                    }else {
                        layer.confirm(errorMsg.phonesave, {
                            title: false,
                            closeBtn: false,
                            btn: ['登陆', '确定']
                        }, function () {
                            goto('toLogin.htm')
                        }, function () {
                            layer.closeAll();
                        });
                        return;
                    }
                    toPersonal();
                    return;
                }
                if (msg.indexOf('已注册') > -1) {
                    layer.confirm(errorMsg.phonesave, {
                        title: false,
                        closeBtn: false,
                        btn: ['登陆', '确定']
                    }, function () {
                        goto('toLogin.htm')
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
