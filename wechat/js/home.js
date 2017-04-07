var mw = $(window).width();
var mh = $(window).height();
//var mh = 1136 * mw / 640;
window.onload = function () {
    $('#MsgBoxDiv').width(mw).height(mh);
    $('#MsgBoxDiv ul').width(mw * 0.84).height(mh * 0.26);
    $('#MsgBoxDiv ul li').eq(0).width(mw * 0.84).height(mh * 0.26 * 0.73);
    $('#MsgBoxDiv ul li').eq(1).width(mw * 0.84).height(mh * 0.26 * 0.27);
    $('#MsgBoxDiv ul li').eq(1).css('line-height', mh * 0.26 * 0.27 + 'px');
    $('#msgcontp').css('margin-top', mh * 0.26 * 0.3);
    $('#MsgBoxDiv ul').css('margin-top', mh * 0.25);

    $('#MsgBoxDiv2').width(mw).height(mh);
    $('#MsgBoxDiv2 ul').width(mw * 0.84).height(mh * 0.26);
    $('#MsgBoxDiv2 ul li').eq(0).width(mw * 0.84).height(mh * 0.26 * 0.73);
    $('#MsgBoxDiv2 ul li').eq(1).width(mw * 0.84).height(mh * 0.26 * 0.27);
    $('#MsgBoxDiv2 ul li').eq(1).css('line-height', mh * 0.26 * 0.27 + 'px');
    $('#msgcontp2').css('margin-top', mh * 0.26 * 0.3);
    $('#MsgBoxDiv2 ul').css('margin-top', mh * 0.25);
    $('#MsgBoxDiv2 ul li .modifyPhone').css("height", mh * 0.26 * 0.73 * 0.5);
    $('#MsgBoxDiv2 ul li .modifyPhone').css("padding-top", mh * 0.26 * 0.73 * 0.3);
    $('#MsgBoxDiv2 ul li .modifyPhone #modifyPhoneNum').css("height", mh * 0.26 * 0.73 * 0.4);
    $('#MsgBoxDiv2 ul li .modifyPhone #modifyPhoneNum').css("width", mw * 0.8);
};

//消息弹窗类
var MsgOpt = {
    msgt: null,
    href: null,
    showMsgBox: function (msg, btnword, href) {
        var mythis = this;
        $('#msgcontp').html(msg);
        if (btnword)
            $('#btnli').html(btnword);
        $('#MsgBoxDiv').fadeIn(200);
        mythis.msgt = setTimeout(function () {
            MsgOpt.hideMsgBox();
        }, 5000);
        mythis.href = href;
    },
    hideMsgBox: function () {
        var mythis = this;
        clearTimeout(mythis.msgt);
        $('#MsgBoxDiv').fadeOut(400);
        $('#msgcontp').html('');
        if (mythis.href)
            window.location.href = mythis.href;
    }
};

//消息弹窗类2
var MsgOpt2 = {
    showMsgBox: function (msgOpt) {
        $('#msgcontp2').html(msgOpt.msg);
        $('#btnli21').html(msgOpt.firstText);
        $('#btnli21').bind('click', msgOpt.firstBind);
        $('#btnli22').html(msgOpt.secondText);
        $('#btnli22').bind('click', msgOpt.secondBind);
        $('#MsgBoxDiv2').fadeIn(200);
    },
    hideMsgBox: function () {
        $('#MsgBoxDiv2').fadeOut(400);
        $('#btnli21').unbind('click');
        $('#btnli22').unbind('click');
        $('#msgcontp2').html('');
        $('#btnli21').html('');
        $('#btnli22').html('');
    }
};

//jQuery请求公共方法
function sendRequest(url, method, data, callback, errorCallback, async) {
    var options = {
        url: url,
        type: method,
        timeout: 10000,
        error: function () {
            var msg = '网络连接错误或超时';
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword);
            if (data && typeof data == 'function') {
                if (callback && typeof callback == 'function') {
                    callback();
                }
            } else if (errorCallback && typeof errorCallback == 'function') {
                errorCallback();
            }
        }
    };
    var callbackHandler = null;
    if (data && typeof data == 'function') {
        callbackHandler = data;
    } else {
        options.data = data;
        callbackHandler = callback;
    }
    if (callbackHandler) {
        options.success = callbackHandler;
    }
    if (typeof async != 'undefined') {
        options.async = async;
    }
    $.ajax(options);
}

//StringBuilder用于字符串拼接，提高效率
function StringBuilder() {
    this.data = Array("");
}
StringBuilder.prototype.append = function () {
    this.data.push(arguments[0]);
};
StringBuilder.prototype.toString = function () {
    return this.data.join("");
};

function toMain() {
    window.location.href = "main.htm";
}

function toPersonal() {
    window.location.href = "toPersonal.htm";
}

function goto(url) {
    window.location.href = url;
}

//字符在数组中的索引
function arraySearch(array, str) {
    if (typeof array !== 'object') {
        return -1;
    } else {
        var index = -1;
        for (var i in array) {
            if (array[i] == str) {
                index = i;
                break;
            }
        }
        return index;
    }
}

//字符是否在数组中存在
function strInArray(array, str) {
    for (var i = 0; i < array.length; i++) {
        if (array[i] == str)
            return true;
    }
    return false;
}

//处理显示空字符串
function displayNullValue(str) {
    if(!str)
        return "";
    return str;
}

//检查手机号码
function checkphone(mobile) {
    var myreg = /^[1][34578]\d{9}$/;
    if (myreg.test(mobile)) {
        return true;
    }
    return false;
}

//检查身份证号
function checkIdCard(idCard) {
    var resultStr = "";
    if (idCard.length == 15 || idCard.length == 18) {
        var resultStr = "";
        sendRequest("validateIdCard.htm?idCard=" + idCard, "GET", null, function (result) {
            resultStr = result;
        }, null, false);
    }
    return resultStr;
}

//判断日期格式为yyyy-mm-dd
function checkDate(str) {
    var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
    if (r == null) return false;
    var d = new Date(r[1], r[3] - 1, r[4]);
    return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4]);
}