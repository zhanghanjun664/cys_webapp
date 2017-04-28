var pathName = window.document.location.pathname;
var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
var REST_PREFIX = projectName + '/rest/';
var userMenuList = null;// 用户权限菜单HTML
var userSearchMenu = [];


// jQuery请求公共方法
function sendRequest(url, method, data, callback, async) {
    var options = {
        type: method,
        success: function (result) {
            callback(result);
        }
    };
    var requestUrl = projectName + '/rest/' + url;
    options.url = requestUrl;
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
    if (typeof async != 'undefined') {
        options.async = async;
    }
    $.ajax(options);
}

// StringBuilder用于字符串拼接，提高效率
function StringBuilder() {
    this.data = Array("");
}
StringBuilder.prototype.append = function () {
    this.data.push(arguments[0]);
};
StringBuilder.prototype.toString = function () {
    return this.data.join("");
};


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
// 重置页面当前选中和复选框状态
function commonResetSelection($scope) {
    $("#selectAllCheckbox").attr("checked", false);
    $scope.selections = [];
    $scope.data.forEach(function (item) {
        item.selected = false;
    });
}
// 改变当前选中的行
function commonChangeSelection($scope, index) {
    var selectedRow = $scope.data.length > 0 ? $scope.data[index] : null;
    if (selectedRow) {
        var selected = selectedRow.selected;
        if (selected) {
            $scope.selections.push(selectedRow);
        } else {
            var index = $scope.selections.indexOf(selectedRow);
            $scope.selections.splice(index, 1);
        }
    }
}
// 全选/全不选
function commonSelectAll($scope) {
    var checkAll = $("#selectAllCheckbox").is(":checked");
    $scope.selections = [];
    if ($scope.data.length > 0) {
        $scope.data.forEach(function (item) {
            item.selected = checkAll;
        });
        $scope.selections = checkAll ? $scope.selections.concat($scope.data) : [];
    }
}


// 点击编辑按钮
function commonEditButtonClick(toaster, $scope) {
    if ($scope.selections.length > 0) {
        var len = $scope.selections.length;
        if (len > 1) {
            showSelectOneTip(toaster);
            return;
        }
        $scope.edit($scope.selections[len - 1]);
    } else {
        showSelectOneTip(toaster);
    }
}
// 点击删除按钮
function commonDeleteButtonClick(toaster, $scope) {
    if ($scope.selections.length > 0) {
        var ids = getIdStringFromSelections($scope.selections);
        $scope.deleteItem(ids);
    } else {
        showSelectOneTip(toaster, "error");
    }
}
function showSelectOneTip(toaster, type) {
    if (type) {
        toaster.pop(type, "", "请选择一条记录", "1000");
    } else {
        toaster.pop("warning", "", "请选择一条记录", "1000");
    }
}
function getIdStringFromSelections(entities) {
    var result = null;
    entities.forEach(function (entity) {
        if (entity) {
            if (!result) {
                result = entity.uuid || entity.id;
            } else {
                result = result + "," + (entity.uuid || entity.id);
            }
        }
    });
    return result;
}
/** end 表格公用方法 * */

/** start 表单验证相关 * */
// 验证表单域正整数类型
function validateFiledInteger(toaster, value, name, canNull, canZero) {
    if (canNull && (value == null || value == "")) {
        return true;
    } else if (canZero && parseInt(value) == 0) {
        return true;
    } else if (value == null || value == "") {
        toaster.pop("error", "提示", "【" + name + "】不能为空", "1000");
        return false;
    }
    var reg = /^[1-9][0-9]*$/;
    if (!reg.test(value)) {
        toaster.pop("error", "提示", "【" + name + "】填写不正确", "1000");
        return false;
    }
    return true;
}
// 验证表单域整数类型
function validateFiledIntegerNorP(toaster, value, name, canNull) {
    if (canNull && (value == null || value == "")) {
        return true;
    } else if (parseInt(value) == 0) {
        return true;
    } else if (value == null || value == "") {
        toaster.pop("error", "提示", "【" + name + "】不能为空", "1000");
        return false;
    }
    var reg = /^-?[1-9][0-9]*$/;
    if (!reg.test(value)) {
        toaster.pop("error", "提示", "【" + name + "】请填写整数", "1000");
        return false;
    }
    return true;
}
// 验证表单域最大长度
function validateFiledMax(toaster, value, name, maxLength) {
    return validateFiledNullMax(toaster, value, name, false, maxLength);
}
// 验证表单域非空及最大长度
function validateFiledNullMax(toaster, value, name, notNull, maxLength) {
    return validateFiledNullMinMax(toaster, value, name, notNull, 0, maxLength);
}

/**
 * 验证多个表单控件不为空
 * 
 * @param toaster
 * @param value
 * @param name
 */
function validateMulNull(toaster, value, name) {
    for (var i = 0; i < value.length; i++) {
        var ele = value[i];
        if (ele == null || ele == "") {
            toaster.pop("error", "提示", "【" + name[i] + "】不能为空", "1000");
            return false;
        }
    }
    return true;
}

// 验证表单域非空，最小长度及最大长度
function validateFiledNullMinMax(toaster, value, name, notNull, minLength, maxLength) {
    if (notNull) {
        if (value == null || value == "") {
            toaster.pop("error", "提示", "【" + name + "】不能为空", "1000");
            return false;
        }
    }
    if (minLength > 0) {
        if (value == null || value == "") {
            toaster.pop("error", "提示", "【" + name + "】长度不能小于" + minLength, "1000");
            return false;
        }
        var length = value.length;
        if (length < minLength) {
            toaster.pop("error", "提示", "【" + name + "】长度不能小于" + minLength, "1000");
            return false;
        }
    }
    if (maxLength > 0) {
        if (value == null || value == "") {
            return true;
        }
        var length = value.length;
        if (length > maxLength) {
            toaster.pop("error", "提示", "【" + name + "】长度不能超过" + maxLength, "1000");
            return false;
        }
    }
    return true;
}
/**
 * 验证手机号码
 */
function validateTelephone(toaster, value, name, canNull) {
    if (canNull && (value == null || value == ""))
        return true;
    var reg = /^1[3|4|5|7|8][0-9]\d{8}$/;
    if (reg.test(value)) {
        return true;
    } else {
        toaster.pop("error", "提示", "【" + name + "】输入不正确", "1000");
        return false;
    }
}
/**
 * 验证座机号码
 */
function validatePhonenumber(toaster, value, name) {
    var reg = /^([0-9]{3,4}-)?[0-9]{7,8}$/;
    if (reg.test(value)) {
        return true;
    } else {
        toaster.pop("error", "提示", "【" + name + "】输入不正确", "1000");
        return false;
    }
}
/**
 * 验证联系电话(座机，手机)
 */
function validateContact(toaster, value, name) {
    var reg = /^([0-9]{3,4}-)?[0-9]{7,8}$/;
    var reg1 = /^0?1[3|4|5|8][0-9]\d{8}$/;
    if (reg.test(value) || reg1.test(value)) {
        return true;
    } else {
        toaster.pop("error", "提示", "【" + name + "】输入不正确", "1000");
        return false;
    }
}
/**
 * 验证url地址
 */
function validateUrl(toaster, value, name) {
    var strRegex = "^((https|http|ftp|rtsp|mms)://)?[a-z0-9A-Z]{0,3}\.[a-z0-9A-Z][a-z0-9A-Z\.]{0,61}?[a-z0-9A-Z]\.com|net|cn|cc(:s[0-9]{1-4})?/$";
    var reg = new RegExp(strRegex);
    if (reg.test(value)) {
        return true;
    } else {
        toaster.pop("error", "提示", "【" + name + "】不合法，请确认", "1000");
        return false;
    }
}
/**
 * 验证邮箱格式
 */
function validateEmail(toaster, email, name) {
    var reg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
    if (reg.test(email)) {
        return true;
    } else {
        toaster.pop("error", "提示", "【" + name + "】不合法，请确认", "1000");
        return false;
    }
}
/** end 表单验证相关 * */

/**
 * 克隆对象
 */
function clone(myObj) {
    if (typeof(myObj) != 'object') return myObj;
    if (myObj == null) return myObj;
    var myNewObj = new Object();
    for (var i in myObj)
        myNewObj[i] = clone(myObj[i]);
    return myNewObj;
}

/**
 * 验证银行卡号
 */
function validateCardNo(cardNo) {
    var bankno = cardNo.replace(/[ ]/g, "");
    if (bankno.length < 16 || bankno.length > 19) {
        return false;
    }
    var num = /^\d*$/;
    if (!num.exec(bankno)) {
        return false;
    }
    var strBin = "10,18,30,35,37,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,58,60,62,65,68,69,84,87,88,94,95,98,99";
    if (strBin.indexOf(bankno.substring(0, 2)) == -1) {
        return false;
    }
    return true;
    // var lastNum=bankno.substr(bankno.length-1,1);
    // var first15Num=bankno.substr(0,bankno.length-1);
    // var newArr=new Array();
    // for(var i=first15Num.length-1;i>-1;i--){
    // newArr.push(first15Num.substr(i,1));
    // }
    // var arrJiShu=new Array();
    // var arrJiShu2=new Array();
    // var arrOuShu=new Array();
    // for(var j=0;j<newArr.length;j++){
    // if((j+1)%2==1){
    // if(parseInt(newArr[j])*2<9)
    // arrJiShu.push(parseInt(newArr[j])*2);
    // else
    // arrJiShu2.push(parseInt(newArr[j])*2);
    // }
    // else
    // arrOuShu.push(newArr[j]);
    // }
    // var jishu_child1=new Array();
    // var jishu_child2=new Array();
    // for(var h=0;h<arrJiShu2.length;h++){
    // jishu_child1.push(parseInt(arrJiShu2[h])%10);
    // jishu_child2.push(parseInt(arrJiShu2[h])/10);
    // }
    // var sumJiShu=0;
    // var sumOuShu=0;
    // var sumJiShuChild1=0;
    // var sumJiShuChild2=0;
    // var sumTotal=0;
    // for(var m=0;m<arrJiShu.length;m++){
    // sumJiShu=sumJiShu+parseInt(arrJiShu[m]);
    // }
    // for(var n=0;n<arrOuShu.length;n++){
    // sumOuShu=sumOuShu+parseInt(arrOuShu[n]);
    // }
    // for(var p=0;p<jishu_child1.length;p++){
    // sumJiShuChild1=sumJiShuChild1+parseInt(jishu_child1[p]);
    // sumJiShuChild2=sumJiShuChild2+parseInt(jishu_child2[p]);
    // }
    // sumTotal=parseInt(sumJiShu)+parseInt(sumOuShu)+parseInt(sumJiShuChild1)+parseInt(sumJiShuChild2);
    // var k= parseInt(sumTotal)%10==0?10:parseInt(sumTotal)%10;
    // var luhm= 10-k;
    // if(lastNum==luhm) {
    // return true;
    // } else {
    // return false;
    // }
}

/**
 * 获取日期对应字符串
 */
function getDateStr(date) {
    if (date instanceof Date) {
        var month = date.getMonth() + 1;
        if (month < 10) month = "0" + month;
        var day = date.getDate();
        if (day < 10) day = "0" + day;
        return date.getFullYear() + "-" + month + '-' + day;
    }
    return "";
}

/**
 * 获取日期对应字符串如：2016-06-23 10:34:46
 */
function getNowDateStr(date) {
    if (date instanceof Date) {
        var now = new Date();
        var year = now.getFullYear();
        var month = (now.getMonth() + 1).toString();
        var day = (now.getDate()).toString();
        var hour = now.getHours().toString();
        var minute = now.getMinutes().toString();
        var second = now.getSeconds().toString();
        if (month.length == 1) {
            month = "0" + month;
        }
        if (day.length == 1) {
            day = "0" + day;
        }
        if (hour.length == 1) {
            hour = "0" + hour;
        }
        if (minute.length == 1) {
            minute = "0" + minute;
        }
        if (second.length == 1) {
            second = "0" + second;
        }
        var dateTime = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
        return dateTime;
    }
    return "";
}

/**
 * 从类似Map结构中,通过value获得name
 */
function getItemName(value, list) {
    for (var i in list) {
        var obj = list[i];
        if (value == obj.value) {
            return obj.name;
        }
    }
}

/**
 * 获得布尔值对应的中文"是"、"否"
 */
function getBoolString(value) {
	if(value&&(value==true||value=="true")){
		return "是";
	}else{
		return "否";
	}
}

var callbackFunction = function (fn, obj) {
    if (fn) {
        if (typeof fn == "function") {
            return fn.call(this, obj);
        } else {
            var fun = eval(fn);
            return fun.call(this, obj);
        }
    }
}

/* 判断是否为json,'{a:1}'这样的字符串不算 */
var isJson = function (obj) {
    var isjson = typeof (obj) == "object" && (Object.prototype.toString.call(obj).toLowerCase() == "[object object]" || Object.prototype.toString.call(obj).toLowerCase() == "[object array]");
    return isjson;
}

/* 将字符串转化为json,若本来就是json对象则直接返回,若转换出错,直接返回(可能是字符串) */
var parseJSON = function (obj) {
    try {
        var d = isJson(obj) ? obj : $.parseJSON(obj);
        return d;
    } catch (e) {
        return obj;
    }

}

/**
 * 函数参数重载方法
 * overload，对函数参数进行模式匹配。默认的dispatcher支持*和...以及?，"*"表示一个任意类型的参数，"..."表示多个任意类型的参数，"?"一般用在",?..."表示0个或任意多个参数
 * 
 * @method overload
 * @static
 * @optional {dispatcher} 用来匹配参数负责派发的函数
 * @param {func_maps}
 *            根据匹配接受调用的函数列表
 * @return {function} 已重载化的函数
 */
var FunctionH = {
    overload: function (dispatcher, func_maps) {
        if (!(dispatcher instanceof Function)) {
            func_maps = dispatcher;
            dispatcher = function (args) {
                var ret = [];
                return map(args, function (o) {
                    return typeof o
                }).join();
            }
        }

        return function () {
            var key = dispatcher([].slice.apply(arguments));
            for (var i in func_maps) {
                var pattern = new RegExp("^" + i.replace("*", "[^,]*").replace("...", ".*") + "$");
                if (pattern.test(key)) {
                    return func_maps[i].apply(this, arguments);
                }
            }
        }
    }
};


var initScope = function (config) {
    var initScopeData = config.initScopeData;
    var getCustomQueryString = config.getCustomQueryString;
    var searchModalResolve = config.searchModalResolve;
    var searchTemplateUrl = config.searchTemplateUrl;
    var searchController = config.searchController;
    var editModalResolve = config.editModalResolve;
    var editTemplateUrl = config.editTemplateUrl;
    var editController = config.editController;
    var tableQueryUrl = config.tableQueryUrl;
    var deleteUrl = config.deleteUrl;
    var $scope = config.$scope;
    var $http = config.$http;
    var $modal = config.$modal;
    var ngTableParams = config.ngTableParams;
    var toaster = config.toaster;
    var SweetAlert = config.SweetAlert;
    var $window = config.$window;
    var $localStorage = config.$localStorage;
    var Admin_Constant = config.Admin_Constant;
    var editModalConfig = config.editModalConfig;
    var searchModalConfig = config.searchModalConfig;
    var loadDataOnInit=config.loadDataOnInit;
    callbackFunction(initScopeData, $scope);

    $scope.loadDataOnInit=(loadDataOnInit!=undefined)?loadDataOnInit:true;
    $scope.getItemName = getItemName;
    $scope.getBoolString = getBoolString;
    $scope.resultPage = {
        totalCount: 0
    };
    $scope.data = []; // 当前页面的结果集

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
        	if($scope.loadDataOnInit){
        		commonResetSelection($scope);// 重置查询框
                $scope.searchInfos.pageIndex = params.page();// params为ngTableParams对象的第一个参数
                $scope.searchInfos.pageSize = params.count();
                filterNullValueField($scope.searchInfos); // 过滤field值为null和undefined的
                $scope.queryString = getCustomQueryString != null ? getCustomQueryString($scope) : "?" + $.param($scope.searchInfos, true);
                var requestUrl = tableQueryUrl.indexOf(REST_PREFIX) > -1 ? tableQueryUrl : REST_PREFIX + tableQueryUrl
                + $scope.queryString;
                $http.get(requestUrl).success(function (result) {
                    if (result.body) {
                        $scope.resultPage = result.body.result;
                    } else {
                        $scope.resultPage = result;
                    }
                    params.total($scope.resultPage.totalRecords);
                    $scope.data = $scope.resultPage.content;
                    $defer.resolve($scope.data);
                });
        	}else{
        		$scope.loadDataOnInit=true;
        	}
        }
    });

    // 改变当前选中的行
    $scope.changeSelection = function (index) {
        commonChangeSelection($scope, index);
    };

    // 全选/全不选
    $scope.selectAll = function () {
        commonSelectAll($scope);
    };

    // 点击删除按钮
    $scope.deleteAll = function () {
        commonDeleteButtonClick(toaster, $scope);
    };

    // 点击编辑按钮
    $scope.update = function () {
        commonEditButtonClick(toaster, $scope);
    };

    // 点击查询按钮
    $scope.searchInfos = {};
    $scope.search = function () {
    	var defaultSearchModalConfig={
                templateUrl: searchTemplateUrl,
                backdrop: 'static',
                keyboard: false,
                controller: searchController,
                resolve: searchModalResolve($scope)
            };
    	var options = $.extend({}, defaultSearchModalConfig, searchModalConfig);
        var modalInstance = $modal.open(options);
        modalInstance.result.then(function (searchInfos) {
            var newObj = angular.copy(searchInfos);
            $scope.searchInfos = newObj;
            $scope.tableParams.reload();
        });
    };

    // 新增、编辑
    $scope.edit = function (obj) {
        $scope.obj = obj;
        var defaultEditModalConfig={
                templateUrl: editTemplateUrl,
                backdrop: 'static',
                size:"lg",
                keyboard: false,
                controller: editController,
                resolve: editModalResolve($scope)
            };
        var options = $.extend({}, defaultEditModalConfig, editModalConfig);
        var modalInstance = $modal.open(options);
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };

    // 删除操作
    $scope.deleteItem = function (id) {
        SweetAlert.swal({
            title: "确定删除吗?",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
                $http.delete(REST_PREFIX + deleteUrl + id).success(function (result) {
                    if (!(result && result.body && result.body.code == 2000)) {
                        toaster.pop("error", "提示", "删除失败");
                    } else {
                        toaster.pop("success", "提示", "删除成功");
                    }
                    $scope.tableParams.reload();
                });
            }
        });
    };

}

var initSearch = function (config) {
    var initScopeData = config.initScopeData;
    var $scope = config.$scope;
    var $modalInstance = config.$modalInstance;
    var searchInfos = config.searchInfos;
    var searchOk = config.searchOk;
    var searchCancel = config.searchCancel;
    var searchClear = config.searchClear;

    // 恢复上一次的查询条件
    $scope.searchInfos = searchInfos;
    callbackFunction(initScopeData, $scope);

    $scope.ok = function (e) {
        callbackFunction(searchOk, $scope);
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        callbackFunction(searchCancel, $scope);
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        callbackFunction(searchClear, $scope);
        $scope.searchInfos = {};
    };
}

var initEdit = function (config) {
    var $scope = config.$scope;
    var $modalInstance = config.$modalInstance;
    var toaster = config.toaster;
    var initScopeData = config.initScopeData;

    callbackFunction(initScopeData, $scope);

    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
}

var booleanToString = function (obj) {
    if (obj) {
        for (var i in obj) {
            if (typeof (obj[i]) == "object") {
                booleanToString(obj[i]);
            }
            if (typeof (obj[i]) == "boolean") {
                obj[i] = obj[i] + "";
            }
        }
    }
    return obj;
}

/** 去除Obj的哪些属性 */
var filterField = function (obj, fields) {
    if (obj) {
        var array = fields.split(",");
        for (var i = 0; i < array.length; i++) {
            delete obj[array[i]];
        }
    }
    return obj;
}

/** 去除Obj的哪些属性 */
var filterNullValueField = function (obj) {
    if (obj) {
    	for (var i in obj) {
            if (obj[i] == null) {
            	delete obj[i];
            }
        }
    }
    return obj;
}

/** 保留Obj的哪些属性 */
var retainField = function (obj, fields) {
    var newObj = {};
    if (obj) {
        var array = fields.split(",");
        for (var i in obj) {
            for (var j = 0; j < array.length; j++) {
                var key = array[j];
                if (i && i == key) {
                    newObj[key] = obj[key];
                }
            }
        }
    }
    return newObj;
}

var resultProcess = function ($scope, result, $modalInstance, toaster,modalCloseFunction) {
    var data;
    if (result.body) {
        data = result.body;
    } else {
        data = result;
    }

    
    if (data && data.code == 2000) {
        toaster.pop("success", "提示", "操作成功");
        if ($modalInstance){
        	if(modalCloseFunction){
        		callbackFunction(modalCloseFunction,{
        			$modalInstance:$modalInstance,
        			$scope:$scope,
        			result:result
        		});
        	}else{
        		$modalInstance.close("success");
        	}
        }
    } else {
        $scope.submitFlag = false;
        toaster.pop("error", "提示", "操作失败");
    }
}

// 系统公用ajax方法
var ajax = function (url, callbackFun, jsonparam) {
    var defaultOptions = {
        async: false,
        cache: false,
        type: 'GET',
        dataType: 'json',
        url: url,// 请求的action路径
        error: function (XMLHttpRequest, textStatus, errorThrown) {
        },
        success: function (result) {
            var result = parseJSON(result);
            if (callbackFun) {
                if (typeof (callbackFun) == 'function') {
                    callbackFunction(callbackFun, result);
                }
            }
        }
    };
    var options = $.extend({}, defaultOptions, jsonparam);
    $.ajax(options);
}

/* 判断是否为json,'{a:1}'这样的字符串不算 */
var isJson = function (obj) {
    var isjson = typeof (obj) == "object" && (Object.prototype.toString.call(obj).toLowerCase() == "[object object]" || Object.prototype.toString.call(obj).toLowerCase() == "[object array]");
    return isjson;
}

/* 将字符串转化为json,若本来就是json对象则直接返回 */
var parseJSON = function (obj) {
    var d = isJson(obj) ? obj : $.parseJSON(obj);
    return d;
}

$.browser = {};
$.browser.mozilla = /firefox/.test(navigator.userAgent.toLowerCase());
$.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
$.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());
$.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
/*
 * var getImgWidthAndHeight=function(file, callback,$window) { var image; if
 * (file) { image = new Image(); image.onload = function () { if(typeof
 * callback==="function"){ callback(this.width, this.height); }
 * image.width=this.width; image.height=this.height; }; image.src =
 * $window.URL.createObjectURL(file); } return image; }
 */
var getImgWidthAndHeight = function (file, callback, $window) {// 只能用回调，要不返回image，像上面注释的那样，返回的image也是没宽度和高度的
    var image;
    if (file) {
        image = new Image();
        image.onload = function () {
            if (typeof callback === "function") {
                callback(this.width, this.height);
            }
        };
        image.src = $window.URL.createObjectURL(file);
    }
}
var contains = function contains(arr, obj) {
    var i = arr.length;
    while (i--) {
        if (arr[i] === obj) {
            return true;
        }
    }
    return false;
};
var getImgNaturalDimensions = function (img, callback) {
    var nWidth, nHeight
    if (img.naturalWidth) { // 现代浏览器
        nWidth = img.naturalWidth;
        nHeight = img.naturalHeight;
    } else { // IE6/7/8
        var image = new Image();
        image.src = img.src;
        image.onload = function () {
            callback(image.width, image.height);
        }
    }
    return [nWidth, nHeight]
};

var getImgNaturalWidthAndHeight = function (imgSrc, callback) {
    var image = new Image();
    image.src = imgSrc;
    image.onload = function () {
        if (typeof callback === "function") {
            callback(image.width, image.height);
        }

    }
    return image;
};

var initBoolList =  function() {
	var list = [];
	list.push({
		name : '是',
		value : true
	});
	list.push({
		name : '否',
		value : false
	});
	return list;
};

var checkWord = function(obj, fun, speed) {
    // 部分ie中的onpropertychange事件并不能检测鼠标右键的删除和撤销等事件，opera的oninput事件不能检测直接拖动内容到textarea事件drop&&dragend，故这利用定时器解决
    if ($.browser.opera || $.browser.msie) {
        $(obj).focus(function() {
            setInterval(fun, speed);
        });
        $(obj).blur(function() {
            clearInterval(fun, speed);
        });
    }else {
    	// FF,Chrome,safari等浏览器可以利用oninput事件监听所有的事件，包括keydown,keyup,鼠标右键中的cut，paste和删除，撤销等所有事件，包括直接拖动drop等也支持
        $(obj).on("input",fun);
    }
}
/* 计算剩余字符,base.remainWord("#textarea",10,"#wordsNum"); */
var remainWord = function(textareaId, totalNum, remainId) {
    /*
	 * textareaId:代表textarea的ID; totalNum:代表可输入的总共的字符数; remainId:显示剩余字符数的ID;
	 */
    $(textareaId).each(function() {
        var self = $(this), remainObj = $(remainId), num = 0,currentNum=0;
        function fun() {
            num = totalNum - self.val().length;
            currentNum = self.val().length ;
            if (num >= 0) {
                remainObj.css("color", "#828181").html(currentNum+"/"+totalNum);
                self.removeClass("error");
            } else {
                remainObj.css("color", "#f00").html(totalNum+"/"+totalNum);
                self.addClass("error").val(self.val().substring(0, totalNum));
            }
            if (self.val() != "") {
                self.prev("label").html("");
            }
        }
        
        checkWord(self[0], fun, 100);
    });
}


/** 勾选checkbox事件 */
var checkTag = function($scope, $event) {
	var $this = $($event.currentTarget);
	var id = $scope.tag.id;
	var name = $scope.tag.name;
	var obj = $scope.obj ? $scope.obj : $scope.searchInfos;
	if ($this.is(":checked")) {

		// 选中
		obj.selectedTagList.push({
			id : id,
			name : name
		});
	} else {
		// 取消
		for (var i = 0; i < obj.selectedTagList.length; i++) {
			var item = obj.selectedTagList[i];
			if (item.id == id) {
				obj.selectedTagList.splice(i, 1);
			}
		}
	}
}

/** 删除tag事件 */
var removeTag = function($tag) {
	$(":checkbox[value='" + $tag.id + "']").prop("checked", false);
}

