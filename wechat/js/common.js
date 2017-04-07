(function () {
    var phoneWidth = parseInt(window.screen.width),
        phoneScale = phoneWidth / 640,
        ua = navigator.userAgent;

    if (/Android (\d+\.\d+)/.test(ua)) {
        var version = parseFloat(RegExp.$1);
        if (version > 2.3) {
            document.write('<meta name="viewport" content="width=640, minimum-scale = ' + phoneScale + ', maximum-scale = ' + phoneScale + ', target-densitydpi=device-dpi">');
        } else {
            document.write('<meta name="viewport" content="width=640, target-densitydpi=device-dpi">');
        }
    } else {
        document.write('<meta name="viewport" content="width=640, user-scalable=no, target-densitydpi=device-dpi">');
    }

})();

//StringBuilder用于字符串拼接，提高效率
function StringBuilder() {
    this.data = Array("");
}
StringBuilder.prototype.append = function() {
    this.data.push(arguments[0]);
};
StringBuilder.prototype.toString = function() {
    return this.data.join("");
};

//字符是否在数组中存在
function strInArray(array, str) {
    for(var i = 0; i < array.length; i++) {
        if(array[i] == str)
            return true;
    }
    return false;
}

//检查手机号码
function checkphone(mobile) {
    var myreg = /^[1][34578]\d{9}$/;
    if (myreg.test(mobile)) {
        return true;
    }
    return false;
}

function countdown($elem,diff){//倒计时 countdown($('#countIt'),'2015/06/06 20:11:12');调用方式
    count();
    function count(){
        if(diff<0)return;
        // 总秒数
        var xt = parseInt(diff);
        diff--;
        // 秒数
        var remain_sec = xt % 60;
        xt = parseInt(xt/60);
        // 分数
        var remain_minute = xt % 60;
        xt = parseInt(xt/60);
        // 小时数
        var remain_hour = xt % 24;
        xt = parseInt(xt/24);
        // 天数
        var remain_day = xt;

        if (remain_sec<10) {remain_sec='0'+remain_sec};
        if (remain_minute<10) {remain_minute='0'+remain_minute};
        if (remain_hour<10) {remain_hour='0'+remain_hour};
        $elem.html(remain_day+'天'+remain_hour+'小时'+remain_minute+'分'+remain_sec+'秒');
        window.setTimeout(count,1000);
    }
}

//消息弹窗类
var MsgOpt = {
    msgt:null,
    href:null,
    showMsgBox:function(msg, btnword, href){
        var mythis = this;
        if(href)
            mythis.href = href;
        $('#msgcontp').html(msg);
        $('#btnli').html(btnword);
        $('#MsgBoxDiv').fadeIn(200);
        mythis.msgt = setTimeout(function(){MsgOpt.hideMsgBox();},5000);
    },
    hideMsgBox:function(){
        var mythis = this;
        clearTimeout(mythis.msgt);
        $('#MsgBoxDiv').fadeOut(400);
        $('#msgcontp').html('');
        $('#btnli').html('');
        if(mythis.href)
            window.location.href = mythis.href;
    }
};
//jQuery请求公共方法
function sendRequest(url, method, data, callback, async) {
    var options = {
        url : url,
        type : method,
        success : function(result) {
            callback(result);
        },
        timeout: 10000,
        error:function(){
            var msg = '获取数据失败，请检查网络';
            var btnword = '确定';
            MsgOpt.showMsgBox(msg, btnword);
        }
    };
    var callbackHandler = null;
    if (data && typeof data == 'function') {
        callbackHandler = data;
    } else {
        if (data) {
            if (method.toUpperCase() == 'PUT' || method.toUpperCase() == 'POST') {
                options.data = JSON.stringify(data);
                options.dataType = 'json';
                options.contentType = 'application/json';
            }
        }
        callbackHandler = callback;
    }
    if (callbackHandler) {
        options.success = callbackHandler;
    }
    if(typeof async != 'undefined') {
        options.async = async;
    }
    $.ajax(options);
}