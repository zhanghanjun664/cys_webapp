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
//统计页面访问常量
var Page_Constant = {
    Home_Hospital : "homeHospital", /**首页-医院**/ Home_Disease : "homeDisease", /**首页-疾病**/
    Home_Time : "homeTime", /**首页-时间**/ Home_Focus : "homeFocus", /**首页-关注**/
    Mine : "mine", /**我的**/ FamilyContact : "familyContact", /**家庭联系人**/
    FollowDoctor : "followDoctor", /**关注的医生**/ MyOrder : "myOrder", /**我的预约**/
    MedicalManagement : "medicalManagement", /**病历管理**/ HealthMeasurment : "healthMeasurment", /**健康测量**/
    CashCoupon : "cashCoupon", /**现金券**/ Message : "message", /**消息**/
    Setting : "setting", /**设置**/ DoctorHomePage : "doctorHomePage", /**医生主页**/
    FillOperationOrder : "fillOperationOrder", Operation : "operation", OperationOrderList : "operationOrderList",
    CommentOrderDetail : "commentOrderDetail", OrderDetail : "orderDetail", AccountRecord : "accountRecord",
    AddFamilyContact : "addFamilyContact", DoctorList : "doctorList", EditHealthMeasurment : "editHealthMeasurment",
    FillOrder : "fillOrder", FillOrderPlus : "fillOrderPlus", ForgetPwd : "forgetPwd", ForgetPwdOk : "forgetPwdOk",
    Login : "login", MedicalRecord : "medicalRecord", MyWallet : "myWallet", OrderPayOk : "orderPayOk",
    PayOrder : "payOrder", PersonalInfo : "personalInfo", Register : "register", RegisterOk : "registerOk",
    ResetPassword : "resetPassword", Withdrawl : "withdrawl", Invite : "invite", NowInvite : "nowInvite",
    DrawCoupon : "drawCoupon", PayOrderPlus : "payOrderPlus", ChangeMobile : "changeMobile", CouponError : "couponError",
    UseNow : "useNow"
};

var static_page_tag =[
{"key":"addFamily.html","value":"addFamily"},
{"key":"appointment.html","value":"appointment"},
{"key":"consultationSever.html","value":"consultationSever"},
{"key":"doctor.htm","value":"doctorDetail"},
{"key":"doctorHomePage.html","value":"doctorHomePage"},
{"key":"doctorList.html","value":"doctorList"},
{"key":"doctorTeam.html","value":"doctorTeam"},
{"key":"family.html","value":"family"},
{"key":"fillCase.html","value":"fillCase"},
{"key":"fillOrder.html","value":"fillOrder"},
{"key":"followUpDetails.html","value":"followUpDetails"},
{"key":"followUpPlanDetails.html","value":"followUpPlanDetails"},
{"key":"hospital.html","value":"hospital"},
{"key":"index.html","value":"index"},
{"key":"monthOrder.html","value":"monthOrder"},
{"key":"monthOrderDetail.html","value":"monthOrderDetail"},
{"key":"myDoctor.html","value":"myDoctor"},
{"key":"myReservation.html","value":"myReservation"},
{"key":"offlineOrder.html","value":"offlineOrder"},
{"key":"offlineOrderDetail.html","value":"offlineOrderDetail"},
{"key":"paySuccess.html","value":"paySuccess"},
{"key":"personal.html","value":"personal"},
{"key":"phoneOrder.html","value":"phoneOrder"},
{"key":"phoneOrderDetail.html","value":"phoneOrderDetail"},
{"key":"picOrder.html","value":"picOrder"},
{"key":"picOrderDetail.html","value":"picOrderDetail"},
{"key":"realName.html","value":"realName"},
{"key":"teachingMaterial.html","value":"teachingMaterial"},
{"key":"updataFamily.html","value":"updataFamily"},
{"key":"healthExamination.htm","value":"healthExamination"},
{"key":"toMyWallet.htm","value":"myWallet"},
{"key":"toWithdrawl.htm","value":"withdrawl"},
{"key":"toAccountRecord.htm","value":"accountRecord"},
{"key":"toCouponList.htm","value":"couponList"},
{"key":"toInvite.htm","value":"invite"},
{"key":"toNowInvite.htm","value":"nowInvite"},
{"key":"toOperation.htm","value":"operation"},
{"key":"toMessageCenter.htm","value":"messageCenterList"},
{"key":"modifyPassword.jsp","value":"modifyPassword"},
{"key":"toModifyPassword.htm","value":"login"},
{"key":"register.htm","value":"register"},
{"key":"forget.htm","value":"forget"},
{"key":"toPersonalInfo.htm","value":"personalInfo"}
];
//记录页面访问
function sendPageVisit(page, isLogin) {
    // //统计页面访问常量
    // var cys_page_pathname = window.location.pathname;
    // //截取字符串
    // for(var o in static_page_tag){
    //     var pageKey =  static_page_tag[o].key;
    //     if(cys_page_pathname.indexOf(pageKey) > 1){
    //         var visit_page = static_page_tag[o].value;
    //         var url = "behavior/pageVisit.htm?type=wechat&page="+visit_page;
    //         $.ajax({url : url});
    //         return;
    //     }
    // }
}
function addCookie(objName,objValue,objDays){ //添加cookie
    var str = objName + "=" + escape(objValue);
    if(objDays > 0){ //为0时不设定过期时间，浏览器关闭时cookie自动消失
        var date = new Date();
        var ms = objDays*24*3600*1000;
        date.setTime(date.getTime() + ms);
        str += "; expires=" + date.toGMTString();
    }
    document.cookie = str;
}
function getCookie(objName){ //获取指定名称的cookie的值
    var arrStr = document.cookie.split("; ");
    for(var i = 0;i < arrStr.length;i ++){
        var temp = arrStr[i].split("=");
        if(temp[0] == objName) return unescape(temp[1]);
    }
    return "";
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
    //window.location.href = "main.htm";
    window.location.href = "/wechat_web/wap_wechat_patient/html/index.html";
}

function toPersonal() {
    window.location.href = "/wechat_web/wap_wechat_patient/html/personal.html";
    //window.location.href = "toPersonal.htm";
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

//处理显示空字符串
function displayNullValue(str) {
    if (!str)
        return "";
    return str;
}

//字符是否在数组中存在
function strInArray(array, str) {
    for (var i = 0; i < array.length; i++) {
        if (array[i] == str)
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