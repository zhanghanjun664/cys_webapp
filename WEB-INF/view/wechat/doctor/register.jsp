<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../include/head.jsp" />
    <style>
        html, body {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            font-size: 100%;
            background: #F2F2F2;
        }

        a {
            color: #000000;
            -webkit-tap-highlight-color: transparent;
        }

        img, li, div {
            -webkit-tap-highlight-color: transparent;
        }

        #mainDiv {
            width: 100%;
            display: none;
        }

        #mainDiv .top_ul {
            width: 100%;
            background: #FB9D3B;
            overflow: hidden;
        }

        #mainDiv .top_ul li {
            text-align: center;
            float: left;
        }

        #mainDiv .top_ul li:nth-child(1) {
            width: 11.5%;
            height: 100%;
            background: url(../../wechat/images/larrow.png) center left no-repeat;
            background-size: 70% auto;
        }

        #mainDiv .top_ul li:nth-child(2) {
            width: 76%;
            height: 100%;
            font-size: 2em;
            color: #FFFFFF;
        }

        #mainDiv .top_ul li:nth-child(3) {
            width: 12%;
            height: 100%;
        }

        #mainDiv .top_ul li:nth-child(3) a {
            font-size: 1.6em;
            color: #FFFFFF;
        }

        #mainDiv .cont_ul {
            width: 94%;
            margin-top: 5%;
            margin-left: 3%;
            overflow: hidden;
        }

        #mainDiv .cont_ul li {
            width: 100%;
            float: left;
            background: #FFFFFF;
        }

        #mainDiv .cont_ul li input[type="text"] {
            width: 59%;
            font-size: 1.55em;
            color: #000000;
            background: transparent;
            border: 0;
            -webkit-border: 0;
            margin-left: 8%;
            float: left;
        }

        #mainDiv .cont_ul li:nth-child(1) {
            background: url(../../wechat/images/icon1.png) center left no-repeat #FFFFFF;
            background-size: auto 43%;
            margin-bottom: 0.18em;
            border-top-left-radius: 0.5em;
            border-top-right-radius: 0.5em;
            -webkit-border-top-left-radius: 0.5em;
            -webkit-border-top-right-radius: 0.5em;
        }

        #mainDiv .cont_ul li:nth-child(2) {
            background: url(../../wechat/images/icon12.png) center left no-repeat #FFFFFF;
            background-size: auto 43%;
            margin-bottom: 0.18em;
        }

        #mainDiv .cont_ul li:nth-child(3) {
            background: url(../../wechat/images/icon13.png) center left no-repeat #FFFFFF;
            background-size: auto 43%;
            margin-bottom: 0.18em;
            border-bottom-left-radius: 0.5em;
            border-bottom-right-radius: 0.5em;
            -webkit-border-bottom-left-radius: 0.5em;
            -webkit-border-bottom-right-radius: 0.5em;
        }

        #mainDiv .cont_ul li:nth-child(4){background:url(../../wechat/images/checkboxed.png) center left no-repeat;background-size:8% auto;text-align:left;}
        #mainDiv .cont_ul li:nth-child(4) span{font-size:1.6em;color:#297CE6;}
        #mainDiv .cont_ul li:nth-child(4) .span1{margin-left:10%;}
        #mainDiv .cont_ul li:nth-child(5){background:#FB9D3B;margin-top:10%;border-radius:0.2em;-webkit-border-radius:0.2em;text-align:center;font-size:1.8em;color:#FFFFFF;}

        #mainDiv .cont_ul li:nth-child(1) .getCodeDiv {
            width: 30%;
            margin-top: 0.45em;
            border-radius: 0.2em;
            -webkit-border-radius: 0.2em;
            text-align: center;
            font-size: 1.5em;
            color: #FFFFFF;
            background: #2882D8;
            float: left;
        }

        #MsgBoxDiv {
            width: 100%;
            height: 100%;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 1000000;
            display: none;
        }

        #MsgBoxDiv ul {
            width: 84%;
            overflow: hidden;
            margin-left: 8%;
            background: rgba(0, 0, 0, 0.65);
            border-radius: 0.2em;
            -webkit-border-radius: 0.2em;
        }

        #MsgBoxDiv ul li {
            width: 100%;
            overflow: hidden;
            text-align: center;
        }

        #MsgBoxDiv ul li:nth-child(1) p {
            width: 100%;
            text-align: center;
            font-size: 1.75em;
            color: #FFFFFF;
        }

        #MsgBoxDiv ul li:nth-child(2) {
            border-top: #FFFFFF 0.04em solid;
            -webkit-border-top: #FFFFFF 0.04em solid;
            font-size: 1.88em;
            color: #FFFFFF;
        }
    </style>
</head>
<body>
<div id="mainDiv">
    <ul class="top_ul">
        <a href="javascript:history.back();">
            <li></li>
        </a>
        <li>注册</li>
        <li><a href="main.htm">首页</a></li>
    </ul>
    <ul class="cont_ul">
        <li><input type="text" id="phone" placeholder="请输入手机号码" Maxlength="11"/>

            <div class="getCodeDiv" onClick="RegisterOpt.getCode();">获取验证码</div>
        </li>
        <li><input type="text" id="code" placeholder="请输入验证码"/></li>
        <li style="display: none;"><input type="text" id="invitecode" placeholder="请输入邀请码（选填）"/></li>
        <li><span class="span1" style="color:#000000;">同意</span><span onClick="showRule();">《橙医生用户服务协议》</span></li>
        <li onClick="RegisterOpt.register();">下一步</li>
    </ul>
</div>
<div id="MsgBoxDiv">
    <ul>
        <li><p id="msgcontp"></p></li>
        <li id="btnli" onClick="MsgOpt.hideMsgBox();"></li>
    </ul>
</div>
</body>
</html>
<script>
    var mw = $(window).width();
    var mh0 = $(window).height();
    var mh = 1136 * mw / 640;
    window.onload = function () {
        $('#mainDiv').width(mw);
        $('.top_ul').width(mw).height(mh*0.07);
        $('.top_ul li').height(mh*0.07);
        $('.top_ul li').css('line-height',mh*0.07+'px');
        $('.cont_ul li').height(mh*0.07);
        $('.cont_ul li').eq(3).css('line-height',mh*0.07+'px');
        $('.cont_ul li input').height(mh*0.068);
        $('.cont_ul li').eq(4).height(mh*0.07);
        $('.cont_ul li').eq(4).css('line-height',mh*0.07+'px');
        $('.getCodeDiv').height(mh*0.056);
        $('.getCodeDiv').css('line-height',mh*0.056+'px');

        $('#mainDiv').show();
        $('#MsgBoxDiv').width(mw).height(mh);
        $('#MsgBoxDiv ul').width(mw * 0.84).height(mh * 0.26);
        $('#MsgBoxDiv ul li').eq(0).width(mw * 0.84).height(mh * 0.26 * 0.73);
        $('#MsgBoxDiv ul li').eq(1).width(mw * 0.84).height(mh * 0.26 * 0.27);
        $('#MsgBoxDiv ul li').eq(1).css('line-height', mh * 0.26 * 0.27 + 'px');
        $('#msgcontp').css('margin-top', mh * 0.26 * 0.3);
        $('#MsgBoxDiv ul').css('margin-top', mh * 0.15);
    }

    //注册协议
    function showRule(){
        window.location.href = "registerProtocol.htm";
    }

    //消息弹窗类
    var MsgOpt = {
        msgt: null,
        showMsgBox: function (msg, btnword) {
            var mythis = this;
            $('#msgcontp').html(msg);
            $('#btnli').html(btnword);
            $('#MsgBoxDiv').fadeIn(200);
            mythis.msgt = setTimeout(function () {
                MsgOpt.hideMsgBox();
            }, 5000);
        },
        hideMsgBox: function () {
            var mythis = this;
            clearTimeout(mythis.msgt);
            $('#MsgBoxDiv').fadeOut(400);
            $('#msgcontp').html('');
            $('#btnli').html('');
        }
    };

    function changeCodeBtn() {
        $('.getCodeDiv').css('background-color', '#98D6FF');
        $('.getCodeDiv').html('重新获取(' + times + ')');
        recordtime();
    }
    var times = 59;
    var t = null;
    function recordtime() {
        if (times <= 1) {
            $('.getCodeDiv').css('background-color', '#2882D8');
            $('.getCodeDiv').html('获取验证码');
            times = 59;
            clearTimeout(t);
            RegisterOpt.codeflag = false;
            return;
        }
        times -= 1;
        $('.getCodeDiv').html('重新获取(' + times + ')');
        t = setTimeout(function () {
            recordtime();
        }, 1000);
    }
    //获取验证码以及注册类
    var RegisterOpt = {
        codeflag: false,
        regflag: false,
        getCode: function () {
            var mythis = this;
            if (mythis.codeflag) {
                return;
            }
            mythis.codeflag = true;
            var phone = $.trim($('#phone').val());

            if (phone.length <= 0) {
                var msg = '请填写手机号';
                var btnword = '确定';
                MsgOpt.showMsgBox(msg, btnword);
                mythis.codeflag = false;
                return;
            }
            if (RegisterOpt.checkphone(phone)) {
                var msg = '手机号码格式错误';
                var btnword = '确定';
                MsgOpt.showMsgBox(msg, btnword);
                mythis.codeflag = false;
                return;
            }
            changeCodeBtn();
            var url = 'getRegisterVerifyCode.htm?phoneNumber=' + phone;
            $.ajax({
                type: 'GET',
                url: url,
                success: function (result) {
                    if (result) {
                        var btnword = '确定';
                        MsgOpt.showMsgBox(result, btnword);
                        $('.getCodeDiv').css('background-color', '#2882D8');
                        $('.getCodeDiv').html('获取验证码');
                        times = 59;
                        clearTimeout(t);
                        mythis.codeflag = false;
                        mythis.regflag = false;
                        return;
                    }
                },
                timeout: 10000,
                error: function (result) {
                    $('.getCodeDiv').css('background-color', '#2882D8');
                    $('.getCodeDiv').html('获取验证码');
                    times = 59;
                    clearTimeout(t);
                    mythis.codeflag = false;
                    mythis.codeflag = false;
                    return;
                }
            });
        },
        register: function () {
            var mythis = this;
            if (mythis.regflag) {
                return;
            }
            mythis.regflag = true;
            var phone = $.trim($('#phone').val());
            var code = $.trim($('#code').val());
            var invitecode = $.trim($('#invitecode').val());
            if (phone.length <= 0) {
                var msg = '请填写手机号';
                var btnword = '确定';
                MsgOpt.showMsgBox(msg, btnword);
                mythis.regflag = false;
                return;
            }
            if (RegisterOpt.checkphone(phone)) {
                var msg = '手机号码格式错误';
                var btnword = '确定';
                MsgOpt.showMsgBox(msg, btnword);
                mythis.regflag = false;
                return;
            }
            if (code.length <= 0) {
                var msg = '请填写验证码';
                var btnword = '确定';
                MsgOpt.showMsgBox(msg, btnword);
                mythis.regflag = false;
                return;
            }
            var url = 'verifyCode.htm';
            var data = {'phoneNumber': phone, 'code': code};
            $.ajax({
                type: 'POST',
                url: url,
                data: data,
                success: function (msg) {
                    if (msg) {
                        var btnword = '确定';
                        MsgOpt.showMsgBox(msg, btnword);
                        mythis.regflag = false;
                        return;
                    } else {
                        window.location.href = "toRegister2.htm?phoneNumber="+phone+"&invitecode="+invitecode;
                    }
                },
                timeout: 10000,
                error: function () {
                    var msg = '验证码错误或超时';
                    var btnword = '确定';
                    MsgOpt.showMsgBox(msg, btnword);
                    mythis.regflag = false;
                    return;
                }
            });
        },
        checkphone: function (mobile) {
            var myreg = /^[1][34578]\d{9}$/;
            if (!myreg.test(mobile)) {
                return true;
            }
        }
    };
</script>
