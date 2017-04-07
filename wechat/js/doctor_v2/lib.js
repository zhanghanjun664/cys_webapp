//jQuery请求公共方法
function sendRequest(url, method, data, callback, errorCallback, async) {
    var options = {
        url: url,
        type: method,
        timeout: 10000,
        error: function () {
            layer.alert('网络连接错误或超时', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
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

function backToHome() {
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

//============================
//    检查手机号码
//============================
function checkMobile(mobile) {
    var myreg = /^[1][34578]\d{9}$/;
    if (myreg.test(mobile)) {
        return true;
    }
    return false;
}

//============================
//    截取输入框首尾空白字符
//============================
function trim(ostr){
    return $.trim(ostr);
}

//============================
//    判断值是否为空
//============================
function isEmpty(ele){
    var val = trim($(ele).val());
    if(val.length == 0){
        return true;
    }else{
        return false;
    }
}

//============================
//    tab
//============================
function clickTab(tab, con) {
    $(tab).each(function (i) {
        $(this).click(function () {
            $(this).addClass("active").siblings(tab).removeClass("active");
            $(con).eq(i).show().siblings(con).hide();
            return false;
        })
    })
}

//============================
//    6位支付密码
//============================
function payPwd(ele){
    $(ele).on('keyup', function(){
        var pwdVal = $(this).val();
        var len = pwdVal.length;
        if(len == 0){
            $(this).next().find('i').css('visibility', 'hidden');
        }
        for(var i=0; i<len; i++){
            $(this).next().find('i:eq('+ i +')').css('visibility', 'visible');
            $(this).next().find('i:gt('+ i +')').css('visibility', 'hidden');
        }
    });
}