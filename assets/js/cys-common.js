var SERVICE_TYPE_IM = 0;
var SERVICE_TYPE_PHONE = 1;
var SERVICE_TYPE_MONTHLY_IM = 2;
var SERVICE_TYPE_OFFLINE = 4;


var SERVICE_ORDER_STATUS_CREATED = 0; // 创建
var SERVICE_ORDER_STATUS_PAID = 1; // 支付
var SERVICE_ORDER_STATUS_ONGOING = 2; // 已回复和回电
var SERVICE_ORDER_STATUS_AWAIT_SERVICE = 3; // 待就诊
var SERVICE_ORDER_STATUS_FULFILLED = 4; // 执行完成
var SERVICE_ORDER_STATUS_CANCELED_BY_PATIENT = 5; // 患者取消
var SERVICE_ORDER_STATUS_CANCELED_BY_DOCTOR = 6; // 医生取消
var SERVICE_ORDER_STATUS_CANCELED = 8; // 取消
var SERVICE_ORDER_STATUS_SERVICE_UNFULFILLED = 9; //通话失败（仅适用于电话咨询）
var SERVICE_ORDER_STATUS_EXPIRED = 16; //  服务到期
var SERVICE_ORDER_STATUS_PAYMENT_FAILED = 32; // 支付失败了
var SERVICE_ORDER_STATUS_TIMEOUT = 64; // 超时取消
var SERVICE_ORDER_STATUS_EXTENDED_BY_DOCTOR = 128; // 服务结束后医生赠予

/** start 公用常量 * */
// 订单状态
var patientOrderStatus = [
    {value: "WAITTO_PAY", name: "待付款"},
    {value: "NO_PAY", name: "未付款"},
    {value: "WAITTO_DIAGNOSE", name: "待就诊"},
    {value: "NO_DIAGNOSE", name: "未就诊"},
    {value: "PATIENT_MISS", name: "患者爽约"},
    {value: "CANCEL_WITHIN", name: "取消(一小时内)"},
    {value: "CANCEL_OVERTIME", name: "取消(一小时后)"},
    {value: "WAITTO_CONFIRM", name: "待确认"},
    {value: "WAITTO_COMMENT", name: "待评价"},
    {value: "WAITTO_SHARE", name: "待分享"},
    {value: "NO_COMMENT", name: "已完成但无评价"},
    {value: "NO_SHARE", name: "已完成但无分享"},
    {value: "FINISHED", name: "已完成"},
    {value: "CANCEL_DOCTOR", name: "医生取消"}
];
// 保险订单状态
var insuranceOrderStatus = [
    {value: "0", name: "待付款"},
    {value: "1", name: "已付款"},
    {value: "2", name: "待核保"},
    {value: "3", name: "核保失败"},
    {value: "4", name: "申请理赔"},
    {value: "6", name: "核保成功"},
    {value: "7", name: "保单取消"},
    {value: "16", name: "保单期满"},
    {value: "32", name: "支付失败"},
    {value: "64", name: "超时取消"}
];

//服务订单状态
var gServiceOrderStatuses = [
    {value: SERVICE_ORDER_STATUS_CREATED, name: "待付款"},
    {value: SERVICE_ORDER_STATUS_PAID, name: "已付款"},
    {value: SERVICE_ORDER_STATUS_AWAIT_SERVICE, name: "待就诊"},
    {value: SERVICE_ORDER_STATUS_FULFILLED, name: "咨询完成"},
    {value: SERVICE_ORDER_STATUS_CANCELED_BY_PATIENT, name: "患者取消"},
    {value: SERVICE_ORDER_STATUS_CANCELED_BY_DOCTOR, name: "医生取消"},
    {value: SERVICE_ORDER_STATUS_CANCELED, name: "已取消"},
    {value: SERVICE_ORDER_STATUS_SERVICE_UNFULFILLED, name: "通话失败"},
    {value: SERVICE_ORDER_STATUS_TIMEOUT, name: "超时取消"}
];

//订单来源
var gOrderSources = [
    {value : "REGULAR", name : "橙医生订单"},
    {value : "SANJIU" , name : "三九订单"},
    {value : "PATRON" , name : "老患者订单"},
    {value : "J1CN"   , name : "健医订单"},
    {value : "SIRUI"  , name : "思瑞订单"},
    {value : "ZHIDA"  , name : "快问app订单"},
    {value : "KUAIWEN_M"  , name : "快问wap订单"},
    {value : "LEXIN"  , name : "乐心订单"},
    {value : "YJK"    , name : "翼健康订单"},
    {value : "WAP"    , name : "WAP订单"},
    {value : "JIANKANGJIA100"    , name : "爱立方订单"}
];

//订单来源
var gUserChannels = [
    {value : "REGULAR", name : "橙医生"},
    {value : "SANJIU" , name : "三九"},
    {value : "J1CN"   , name : "健医"},
    {value : "SIRUI"  , name : "思瑞"},
    {value : "ZHIDA"  , name : "快问app订单"},
    {value : "KUAIWEN_M"  , name : "快问wap订单"},
    {value : "LEXIN"  , name : "乐心"},
    {value : "YJK"    , name : "翼健康"},
    {value : "JIANKANGJIA100"    , name : "爱立方"}
];

// 保险订单可操作的状态
function nextInsuranceOrderStatus(status) {
    if(status == "1"){//已付款
        return [{value: "2", name: "待核保"}]; 
    }
    if (status == "2") {//待核保
        return [{value: "3", name: "核保失败"}, {value: "6", name: "核保成功"}];
        
    } else if (status == "6") {//核保成功
        return [{value: "4", name: "申请理赔"}];
        
    } else if (status == "3") {//核保失败
        return [{value: "7", name: "保单取消"}, {value: "2", name: "待核保"}];
    } 
}
// 获取订单状态对应描述
function showOrderStatus(status, isDoctor) {
    if (status == "WAITTO_PAY") return "待付款";
    if (status == "NO_PAY") return "未付款";
    if (status == "NO_DIAGNOSE") return "未就诊";
    if (status == "PATIENT_MISS") return "患者爽约";
    if (status == "CANCEL_DOCTOR") return "医生取消";
    if (status == "CANCEL_WITHIN") return "取消(一小时内)";
    if (status == "CANCEL_OVERTIME") return "取消(一小时后)";
    if (status == "WAITTO_DIAGNOSE") {
        if (isDoctor) return "待出诊";
        else return "待就诊";
    }
    if (status == "WAITTO_CONFIRM") {
        if (isDoctor) return "待出诊";
        else return "待确认";
    }
    if (status == "WAITTO_COMMENT") {
        if (isDoctor) return "已出诊";
        else return "待评价";
    }
    if (status == "WAITTO_SHARE") {
        if (isDoctor) return "已出诊";
        else return "待分享";
    }
    if (status == "FINISHED") {
        if (isDoctor) return "已出诊";
        else return "已完成";
    }
    if (status == "NO_COMMENT") {
        if (isDoctor) return "已出诊";
        else return "已完成但无评价";
    }
    if (status == "NO_SHARE") {
        if (isDoctor) return "已出诊";
        else return "已完成但无分享";
    }
}

function showServiceOrderStatus(status) {
    if (status === 0 ) return "待付款";
    if (status === 1 ) return "已付款";
    if (status === 2 ) return "已回复和回电";
    if (status === 3 ) return "待就诊";
    if (status === 4 ) return "咨询完成";
    if (status === 5 ) return "患者取消";
    if (status === 6 ) return "医生取消";
    if (status === 8 ) return "已取消";
    if (status === 9 ) return "通话失败";
    if (status === 16) return "服务到期";
    if (status === 64) return "超时取消";
    if (status === 128) return "医生免费延长服务中";
}

function showOrderSource(source) {
    if (source === "REGULAR") return "橙医生";
    if (source === "PATRON" ) return "老患者";
    if (source === "SANJIU" ) return "三九";
    if (source === "J1CN"   ) return "健医";
    if (source === "SIRUI"  ) return "思瑞";
    if (source === "ZHIDA"  ) return "快问app";
    if (source === "LEXIN"  ) return "乐心";
    if (source === "YJK"    ) return "翼健康";
    if (source === "WAP"    ) return "WAP";
    if (source === "KUAIWEN_M") return "快问wap";
    if (source === "JIANKANGJIA100") return "爱立方";
}

function showUserChannel(source) {
    if (source === "AUTO") return "橙医生";
    if (source === "REGULAR") return "橙医生";
    if (source === "PATRON" ) return "老患者";
    if (source === "SANJIU" ) return "三九";
    if (source === "J1CN"   ) return "健医";
    if (source === "SIRUI"  ) return "思瑞";
    if (source === "ZHIDA"  ) return "快问app";
    if (source === "LEXIN"  ) return "乐心";
    if (source === "YJK"    ) return "翼健康";
    if (source === "WAP"    ) return "WAP";
    if (source === "KUAIWEN_M") return "快问wap";
    if (source === "JIANKANGJIA100") return "爱立方";
    if (source === "ARCHIVE_CREATION") return "建档";
}

// 医生审核状态
var doctorAuditStatus = [
    new Object({value: "WAITTO_AUDIT", name: "待审核"}),
    new Object({value: "AUDIT_NOTOK", name: "审核不通过"}),
    new Object({value: "AUDIT_PASSED", name: "审核通过"})
];
var cysBoolStatus = [
    new Object({value: "true", name: "是"}),
    new Object({value: "false", name: "否"}),
];

var cysGenders = [
    new Object({value: "M", name: "男"}),
    new Object({value: "F", name: "女"}),
];

// 获取医生审核状态对应描述
function showDoctorAuditStatus(status) {
    if (status == "WAITTO_AUDIT")
        return "待审核";
    if (status == "AUDIT_NOTOK")
        return "审核不通过";
    if (status == "AUDIT_PASSED")
        return "审核通过";
}
// 付款状态
var paymentStatus = [
    {value: "DRAFT", name: "未到账"},
    {value: "PAYING", name: "支付中"},
    {value: "VOID", name: "挂起"},
    {value: "AUDIT", name: "审核通过"},
    {value: "PAYED", name: "已到账"},
    {value: "IGNORE", name: "刷单号忽略"}
];
// 获取付款状态对应描述
function showPaymentStatus(status) {
    if (status == "DRAFT") return "未到账";
    if (status == "PAYING") return "支付中";
    if (status == "VOID") return "挂起";
    if (status == "AUDIT") return "审核通过";
    if (status == "PAYED") return "已到账";
    if (status == "IGNORE") return "刷单号忽略";
};
// 患者流水类型
function showPatientPayemntType(type) {
    if (type == "WITHDRAW") return "用户提现";
    if (type == "REFUND") return "订单诊金退款";
    if (type == "SERVICE_REFUND") return "咨询服务退款";
    if (type == "RED_ENVELOPE") return "红包";
    if (type == "RECOMMEND") return "推荐奖金";
    if (type == "BE_INVITED") return "受邀奖金";
    if (type == "QRCODE_REWARD") return "推广渠道奖励";
    if (type == "WX_CHARGE") return "微信充值";
    if (type == "ALIPAY_CHARGE") return "支付宝充值";
    if (type == "PAY_BOND") return "支付保证金";
    if (type == "PAY_ORDER") return "支付订单";
    if (type == "RETURN_BOND") return "退回保证金";
    if (type == "PAY_SERVICE") return "咨询服务支付";
    if (type == "ACTIVITY_OYO") return "手术互助活动";
};
// 现金券状态
var couponStatus = [
    {value: "1_UNUSED", name: "未使用"},
    {value: "2_USED", name: "已使用"},
    {value: "3_EXPIRED", name: "已过期"}
];
// 获得现金券状态对应描述
function showCouponStatus(status) {
    if (status == "1_UNUSED") return '未使用';
    if (status == "2_USED") return '已使用';
    if (status == "3_EXPIRED") return '已过期';
}
// 支付渠道状态
var paymentChannelStatus = [
    {value: "WEIXIN", name: "微信支付"}
];
// 获得支付渠道状态对应描述
function showPaymentChannel(status) {
    if (status == "WEIXIN") return "微信支付";
}
// 病例审核状态
var medicalStatus = [
    {value: "AUDITPASS", name: "审核通过"},
    {value: "AUDITFAIL", name: "审核不通过"},
    {value: "NOTAUDIT", name: "待审核"}
];
// 获得病例审核状态对应描述
function displayMedicalPicStatus(status) {
    if (status == "AUDITPASS") return "审核通过";
    if (status == "AUDITFAIL") return "审核不通过";
    if (status == "NOTAUDIT") return "待审核";
}

function showGender(genderCode) {
    if (genderCode == 0 || genderCode == "M") return "男";
    if (genderCode == 1 || genderCode == "F") return "女";
    
    return genderCode;
}

function showBooleanInChinese(b) {
    if (b  && b == true) return "是";
    else return "否";
}
/** end 公用常量 * */


/** start 表格公用方法 * */
// 获取查询条件(过期方法,尽量不要使用,因为不处理数组,因过去逻辑使用,暂无法移除,推荐使用$.param)
function getQueryString(searchInfos) {
    var queryString = "";
    for (var propName in searchInfos) {
        if (searchInfos[propName] && !(searchInfos[propName] instanceof Array)) {
            if (queryString) {
                queryString = queryString + '&' + propName + '=' + searchInfos[propName];
            }
            else {
                queryString = "?" + propName + '=' + searchInfos[propName];
            }
        }
    }
    return queryString;
}

//获得所有地区信息
function loadJdDistricts($http, Admin_Constant, $localStorage) {
    var jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
    if(!jdDistricts) {
        $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
            jdDistricts = result.districtList;
            $localStorage[Admin_Constant.LocalStorage.Districts] = jdDistricts;
        });
    }
    
    return jdDistricts;
};

//获得所有市辖区信息
function loadJdDistrictAreas($http, Admin_Constant, $localStorage) {
    var jdDistrictAreas = $localStorage[Admin_Constant.LocalStorage.DistrictAreas];
    if(!jdDistrictAreas) {
        $http.get(REST_PREFIX + "jdDistrictArea/list").success(function (result) {
            jdDistrictAreas = result.districtAreaList;
            $localStorage[Admin_Constant.LocalStorage.DistrictAreas] = jdDistrictAreas;
        });
    }
    
    return jdDistrictAreas;
}

// 获取所有疾病大类
function loadJdSickCategories($http, Admin_Constant, $localStorage){
    var jdSickCategories = $localStorage[Admin_Constant.LocalStorage.SickCategories];
    if(!jdSickCategories) {
        $http.get(REST_PREFIX + "jdSickCategary/all").success(function (result) {
            jdSickCategories = result.body.result;
            $localStorage[Admin_Constant.LocalStorage.SickCategories] = jdSickCategories;
        });
    }
    
    return jdSickCategories;
}

//获得渠道数据
function loadQrCodes($http, cysIndexedDB, $rootScope) {
    //判断版本号是否存在
    var jdQrcodeList;
    if(window.localStorage.getItem('qrCodeVersionKey')){
        console.log('can found version!');
        var oldKey=window.localStorage.getItem('qrCodeVersionKey');
        if(oldKey===null||oldKey===""||oldKey===undefined){
            return false;
        }
        cysIndexedDB.openDB();
        $http.get(REST_PREFIX + "jdQrcode/dataset_info").success(function (result) {
            var newKey = result.lastModifiedTime+result.count;
            if(newKey !== oldKey){
                $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                    jdQrcodeList = result.jdQrcodeList;
                    cysIndexedDB.addData(cysIndexedDB.db,'qrCode',result.jdQrcodeList);
                    window.localStorage.setItem('qrCodeVersionKey',newKey);
                    jdQrcodeList.push({"uuid":"0","name":"无"});
                });
            }else{
                setTimeout(function(){
                    jdQrcodeList = $rootScope.jdQrcodeList;
                }, 1000);
            }
        });
    } else {
        $http.get(REST_PREFIX + "jdQrcode/dataset_info").success(function (result) {
            var key=result.lastModifiedTime+result.count;
            cysIndexedDB.openDB();

            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                jdQrcodeList = result.jdQrcodeList;
                cysIndexedDB.addData(cysIndexedDB.db,'qrCode',result.jdQrcodeList);
                window.localStorage.setItem('qrCodeVersionKey',key);
                jdQrcodeList.push({"uuid":"0","name":"无"});
            });
        });
    }
    
    return jdQrcodeList;
}

function showOrderPlusStatus(status) {
	if (status == "WAITTO_COMFIRM") return "待确认";
	if (status == "APPLYING") return "申请中";
	if (status == "WAITTO_PAY") return "待付款";
	if (status == "NO_PAY") return "未付款";
	if (status == "FINISHED") return "已完成";
	if (status == "CANCELED") return "用户取消";
	if (status == "DOCTOR_ALLOCATE") return "医生已放号";
};

function searchHospitalByName ($http, $scope, searchTerm) {
    if (searchTerm != undefined && searchTerm != null && searchTerm != ""
            && searchTerm.length > 0) {
        $http.get("/rest/jdHospital/searchByName?name=" + searchTerm)
                .success(function(result) {
                    var cursor = result.hospitalList;
                    if (cursor.length > 0) {
                        var arr = [];
                        cursor.forEach(function(hsp) {
                            var object = {
                                uuid : hsp.hospitalId,
                                name : hsp.name
                            };
                            arr.push(object);
                        });
                        $scope.matchingHospitalList = arr;
                    }
         });
    }
};

function searchMedicationByName ($http, $scope, searchTerm) {
    if (searchTerm != undefined && searchTerm != null && searchTerm != ""
            && searchTerm.length > 0) {
        $http.get("/rest/medication/search?name=" + searchTerm)
                .success(function(response) {
                	$scope.matchingMedicationList = response.body.result;
         });
    }
};