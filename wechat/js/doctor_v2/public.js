/*===================================错误提示===================================*/
var errorMsg = {
    mobile: '请输入正确的11位数手机号',
    pwd: '账号或密码输入有误,请重新输入',
    phonesave: '该手机号已注册,请直接登陆',
    code: '验证码有误,请重新输入',
    password: '密码为6~20位之间的字符组合',
    password2: '请输入确认密码',
    pwdConfirm: '两次密码不一致,请重新输入',
    noreg: '你输入的手机号码尚未注册,请注册'
};

//判断正则表达式是否正确,正确的返回true，错误的话返回false,
//传送两个参数(需要判断的值,需要调用的正则表达式的编号,正确的话返回true，错误的话返回false)
//{'手机号码':1,'固定电话':2,"中文字符":3,"密码":4,"QQ":5,"网站":6,"价格":'7',"身份证":'8'}
function checkregular(obj, regnum) {

    var reg;//正则表达式
    var phonereg = /^[1][34578]\d{9}$/;//手机号码的正则表达式
    var telephonereg = /^0\d{2,4}?\d{7,8}$/;//固定电话的正则表达式
    var chinesereg = /[\u4e00-\u9fa5a-zA-Z]{2}/;//中文字符的正则表达式
    var passreg = /^['a-z0-9A-Z']{6,20}/;//密码的正则表达式
    var qqreg = /^\d{5,10}$/;//QQ的正则表达式
    var webreg = /^((([hH][tT][tT][pP][sS]?|[fF][tT][pP])\:\/\/)?([\w\.\-]+(\:[\w\.\&%\$\-]+)*@)?((([^\s\(\)\<\>\\\"\.\[\]\,@;:]+)(\.[^\s\(\)\<\>\\\"\.\[\]\,@;:]+)*(\.[a-zA-Z]{2,4}))|((([01]?\d{1,2}|2[0-4]\d|25[0-5])\.){3}([01]?\d{1,2}|2[0-4]\d|25[0-5])))(\b\:(6553[0-5]|655[0-2]\d|65[0-4]\d{2}|6[0-4]\d{3}|[1-5]\d{4}|[1-9]\d{0,3}|0)\b)?((\/[^\/][\w\.\,\?\'\\\/\+&%\$#\=~_\-@]*)*[^\.\,\?\"\'\(\)\[\]!;<>{}\s\x7F-\xFF])?)$/;
    var pricereg = /^(0|[1-9][0-9]{0,9})(\.[0-9]{1,2})?$/;
    var cardreg = /(^\d{18}$)|(^\d{17}(\d|X|x)$)/;

    switch (regnum) {
        case '1':
            reg = phonereg;
            break;
        case '2':
            reg = telephonereg;
            break;
        case '3':
            reg = chinesereg;
            break;
        case '4':
            reg = passreg;
            break;
        case '5':
            reg = qqreg;
            break;
        case '6':
            reg = webreg;
            break;
        case '7':
            reg = pricereg;
            break;
        case '8':
            reg = cardreg;
            break;
    }

    var str = $(obj).val().trim();
    if (!reg.test(str)) {
        return false;
    } else {
        return true;
    }
}

//判断是两次是否相同
function checksame(obj, obj2) {
    if ($(obj2).val().trim() != $(obj).val().trim()) {
        return false;
    }
    else {
        return true;
    }
}

//判断是否为空,正确的返回true，错误的话返回false
function checknull(obj) {
    if ($(obj).val().trim().length != 0) {
        return true;
    } else {
        return false;
    }
}

//发送验证码
function vercode() {
    $('.sendcode').attr('bol', 'false');
    var timer = null;
    var _time = 60;
    timer = setInterval(function () {
        _time--;
        $('.sendcode').css({'color': '#999'});
        $('.sendcode').html('重新发送' + _time + 's');
        if (_time == 0) {
            clearInterval(timer);
            $('.sendcode').css({'color': '#262626'});
            $('.sendcode').html('获取验证码');
            $('.sendcode').attr('bol', 'true');
        }
    }, 1000);
}
