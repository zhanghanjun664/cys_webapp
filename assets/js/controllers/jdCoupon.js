'use strict';
app.controller('JdCouponCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert,$rootScope,cysIndexedDB) {

    if(window.localStorage.getItem('qrCodeVersionKey')){
        console.log('can found version!');
        var oldKey=window.localStorage.getItem('qrCodeVersionKey');
        if(oldKey===null||oldKey===""||oldKey===undefined){
            return false;
        }
        cysIndexedDB.openDB();
        $http.get(REST_PREFIX + "jdQrcode/dataset_info").success(function (result) {

            var newKey=result.lastModifiedTime+result.count;
            if(newKey!==oldKey){

                $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                    $scope.jdQrcodeList = result.jdQrcodeList;
                    cysIndexedDB.addData(cysIndexedDB.db,'qrCode',result.jdQrcodeList);
                    window.localStorage.setItem('qrCodeVersionKey',newKey);
                    $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
                });

            }else{
                setTimeout(function(){
                    $scope.jdQrcodeList=$rootScope.jdQrcodeList;
                },1000);
            }
        });
    }else {
        $http.get(REST_PREFIX + "jdQrcode/dataset_info").success(function (result) {
            var key=result.lastModifiedTime+result.count;
            cysIndexedDB.openDB();

            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                $scope.jdQrcodeList = result.jdQrcodeList;
                cysIndexedDB.addData(cysIndexedDB.db,'qrCode',result.jdQrcodeList);
                window.localStorage.setItem('qrCodeVersionKey',key);
                $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
            });

        });
    }



    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行
    $scope.jdCouponCategorys = []; //现金券类型信息

    //获取现金券类型信息
    $scope.getCouponCategoryInfos = function () {
        $http.get(REST_PREFIX + "jdCouponCategory/list").success(function (result) {
            $scope.jdCouponCategorys = result.couponCategoryList;
        });
    };
    $scope.getCouponCategoryInfos();

    //根据现金券类型ID显示现金券类型的名称
    $scope.displayCouponCategoryName = function (jdCouponCategoryId) {
        for (var i = 0; i < $scope.jdCouponCategorys.length; i++) {
            if ($scope.jdCouponCategorys[i].uuid == jdCouponCategoryId)
                return $scope.jdCouponCategorys[i].name;
        }
        return "无";
    };

    //显示到期时间，以天计算
    $scope.displayExpiredDate = function (item) {
        return item.split(" ")[0];
    };

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            commonResetSelection($scope);
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "jdCoupon/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);
            });
        }
    });

    //新增
    $scope.edit = function (jdCoupon) {
        var modalInstance = $modal.open({
            templateUrl: 'editJdCoupon.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdCouponCtrl',
            resolve: {
                jdCoupon: function () {
                    return jdCoupon;
                },
                jdCouponCategorys: function () {
                    return $scope.jdCouponCategorys;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };

    //删除操作
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
                $http.delete(REST_PREFIX + "jdCoupon/" + id).success(function (result) {
                    if (result.result != 0) {
                        toaster.pop("error", "提示", "现金券【" + result.description + "】已被引用，不能删除");
                    } else {
                        $scope.tableParams.reload();
                    }
                });
            }
        });
    };

    //根据现金券状态显示对应描述
    $scope.showCouponStatus = function (status) {
        return showCouponStatus(status);
    };

    //根据支付渠道状态显示对应描述
    $scope.showPaymentChannel = function (paymentChannel) {
        return showPaymentChannel(paymentChannel);
    };

    //改变当前选中的行
    $scope.changeSelection = function (index) {
        commonChangeSelection($scope, index);
    };

    //全选/全不选
    $scope.selectAll = function () {
        commonSelectAll($scope);
    };

    //点击删除按钮
    $scope.deleteAll = function () {
        commonDeleteButtonClick(toaster, $scope);
    };

    //点击编辑按钮
    $scope.update = function () {
        commonEditButtonClick(toaster, $scope);
    };

    $scope.searchInfos = {
        jdPatientId: null,
        code: null,
        jdCouponCategoryId: null,
        paymentChannel: null,
        expiredDateStart: null,
        expiredDateEnd: null,
        effectiveDateStart: null,
        effectiveDateEnd: null,
        status: null
    };
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdCoupon.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdCouponCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                },
                jdCouponCategorys: function () {
                    return $scope.jdCouponCategorys;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    };

    //生成现金券
    $scope.create = function () {
        var modalInstance = $modal.open({
            templateUrl: 'createCoupon.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'createCouponCtrl',
            resolve: {
                jdCouponCategorys: function () {
                    return $scope.jdCouponCategorys;
                }
            }
        });
        modalInstance.result.then(function (){
            $scope.tableParams.reload();
        });
    }
});
app.controller('searchJdCouponCtrl', function ($scope, $modalInstance, $modal, searchInfos, jdCouponCategorys) {
    $scope.searchInfos = searchInfos;   //查询条件
    $scope.paymentChannelS = paymentChannelStatus;  //支付渠道
    $scope.couponStatus = couponStatus;     //现金券状态
    $scope.jdCouponCategorys = angular.copy(jdCouponCategorys);   //现金券类型
    $scope.jdCouponCategorys.push({"uuid":"0","name":"无"});

    $("#s_expiredDateStart").val($scope.searchInfos.expiredDateStart);    //到期时间段开始
    $("#s_expiredDateEnd").val($scope.searchInfos.expiredDateEnd);    //到期时间段结束
    $("#s_effectiveDateStart").val($scope.searchInfos.effectiveDateStart);    //开始有效时间段开始
    $("#s_effectiveDateEnd").val($scope.searchInfos.effectiveDateEnd);    //开始有效时间段结束

    $scope.patient = {}; //获得一位用户信息
    $scope.patient.jdPatientId = $scope.searchInfos.jdPatientId;
    $scope.patient.name = $scope.searchInfos.patientName;
    //选择用户
    $scope.selectPatient = function () {
        var modalInstance = $modal.open({
            templateUrl: 'selectPatient.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectPatientCtrl',
            size:"lg",
            resolve: {}
        });
        modalInstance.result.then(function (result) {
            for (var k in result) {
                $scope.patient[k] = result[k];
            }
        });
    };

    $scope.ok = function (e) {
        if ($scope.patient) {
            $scope.searchInfos.jdPatientId = $scope.patient.jdPatientId;
            $scope.searchInfos.patientName = $scope.patient.name;
        }
        $scope.searchInfos.expiredDateStart = $("#s_expiredDateStart").val();
        $scope.searchInfos.expiredDateEnd = $("#s_expiredDateEnd").val();
        $scope.searchInfos.effectiveDateStart = $("#s_effectiveDateStart").val();
        $scope.searchInfos.effectiveDateEnd = $("#s_effectiveDateEnd").val();

        $scope.jdCouponCategorys.pop();

        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    //清空查询条件
    $scope.clear = function () {
        $scope.searchInfos = {
            jdPatientId: null,
            jdCouponCategoryId: null,
            paymentChannel: null,
            expiredDateStart: null,
            expiredDateEnd: null,
            effectiveDateStart: null,
            effectiveDateEnd: null,
            status: null
        };
        $scope.patient = {};
        $("#s_expiredDateStart").val();
        $("#s_expiredDateEnd").val();
        $("#s_effectiveDateStart").val();
        $("#s_effectiveDateEnd").val();
    };
});
app.controller('selectPatientCtrl', function ($scope, $http, $modalInstance, ngTableParams, toaster,$localStorage,Admin_Constant,$rootScope){
    $scope.justopen = true;

    $scope.resultPage = {totalCount:0};
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行
    var jdDistricts = []; //地区信息
    var jdDistrictAreas = []; //地区信息

    $scope.getAttachInfos = function () {
        //获取地区信息
        jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!jdDistricts || jdDistricts.length == 0) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = jdDistricts;
            });
        }
        $scope.jdDistricts = jdDistricts.filter(function(districts){
            if(districts.isProvince){
                return districts;
            }
        });
        //获得市辖区信息
        jdDistrictAreas = $localStorage[Admin_Constant.LocalStorage.DistrictAreas];
        if(!jdDistrictAreas) {
            $http.get(REST_PREFIX + "jdDistrictArea/list").success(function (result) {
                jdDistrictAreas = result.districtAreaList;
                $localStorage[Admin_Constant.LocalStorage.DistrictAreas] = jdDistrictAreas;
            });
        }
        //获取渠道信息
        //$scope.jdQrcodeList = angular.copy($localStorage[Admin_Constant.LocalStorage.QrCodes]);
        if(!$rootScope.jdQrcodeList) {
            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                $scope.jdQrcodeList = result.jdQrcodeList;
                //$localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
                $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
            });
        } else {
            $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
        }
    };
    $scope.getAttachInfos();



    //根据地区ID显示地区的名称
    $scope.displayDistrictName = function (districtId) {
        for(var i = 0; i < $scope.jdDistricts.length; i++) {
            if($scope.jdDistricts[i].uuid == districtId)
                return $scope.jdDistricts[i].name;
        }
    };

    //根据地区Id得到市辖区信息
    $scope.changeDistrictAreas = function (districtId){
        $scope.jdDistrictAreas = [];
        $scope.searchInfos.districtAreaId = "";
        jdDistrictAreas.forEach(function(item){
            if (item.jdDistrictId == districtId && item.isCity)
                $scope.jdDistrictAreas.push(item);
        });
    };

    $scope.setDistrictArea = function (){
        if($scope.searchInfos != undefined && $scope.searchInfos != null){
            $scope.jdDistrictAreas =[];
            for (var i=0; i<jdDistrictAreas.length; i++){
                if (jdDistrictAreas[i].jdDistrictId == $scope.searchInfos.districtId){
                    $scope.jdDistrictAreas.push(jdDistrictAreas[i]);
                }
            }
        }
    };
    $scope.setDistrictArea();

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            if ($scope.justopen) {
                $scope.justopen = false;
            } else {
                commonResetSelection($scope);
                $scope.patientInfos.pageIndex = params.page();
                $scope.patientInfos.pageSize = params.count();
                $scope.patientInfos.masterOnly = true;
                $scope.queryString = getQueryString($scope.patientInfos);

                var requestUrl = REST_PREFIX + "patient/list" + $scope.queryString;
                $http.get(requestUrl).success(function (result) {
                    $scope.resultPage = result.resultPage;
                    params.total($scope.resultPage.totalCount);
                    params.page($scope.resultPage.nowPage);
                    $scope.data = $scope.resultPage.result;
                    $defer.resolve($scope.data);
                });
            }
        }
    });

    //改变当前选中的行
    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };

    $scope.patientInfos = {districtId:null,districtAreaId:null,createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,qrcodeId:null};
    $("#createTimeEnd").val($scope.patientInfos.createTimeEnd);
    $("#createTimeStart").val($scope.patientInfos.createTimeStart);

    //查询
    $scope.query = function () {
        $scope.patientInfos.createTimeStart = $("#createTimeStart").val();
        $scope.patientInfos.createTimeEnd = $("#createTimeEnd").val();
        if($("#districtId").find("option:selected").text() != null
            && $("#districtId").find("option:selected").text() != ''
            && $("#districtId").find("option:selected").text() != '全部'){
            var province = $("#districtId").find("option:selected").text();
            $scope.searchInfos.province =province.replace("省");
        }
        if($("#districtAreaId").find("option:selected").text() != null
            && $("#districtAreaId").find("option:selected").text() != ''
            && $("#districtAreaId").find("option:selected").text() != '全部'){
            var city = $("#districtAreaId").find("option:selected").text();
            $scope.patientInfos.city = city.replace("市","");
        }
        $scope.tableParams.reload();
    };
    $scope.ok = function (e) {
        if ($scope.selections.length == 0) {
            toaster.pop("warning", "", "请选择一条记录", "1000");
        } else if ($scope.selections.length > 1) {
            toaster.pop("warning", "", "请只选择一条记录", "1000");
        } else {
            var rowObject = new Object();
            rowObject.jdPatientId = $scope.selections[0].uuid;
            rowObject.name = $scope.selections[0].name;
            $modalInstance.close(rowObject);
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        commonResetSelection($scope);
        $scope.patientInfos = {districtId:null,districtAreaId:null,createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,qrcodeId:null};
    };
});
app.controller('editJdCouponCtrl', function ($scope, $http, $modal, $modalInstance, ngTableParams, toaster, SweetAlert, jdCoupon, jdCouponCategorys){
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.paymentChannelS = paymentChannelStatus;  //支付渠道
    $scope.couponStatus = couponStatus;     //现金券状态
    $scope.jdCouponCategorys = jdCouponCategorys;   //现金券类型
    $scope.jdCouponInfo = {};   //现金券信息
    $scope.patient = {}; //获得一位用户信息

    if (jdCoupon) {
        $scope.jdCouponInfo.uuid = jdCoupon.uuid;
        $scope.jdCouponInfo.code = jdCoupon.code;
        $scope.patient.jdPatientId = jdCoupon.jdPatientId;
        $scope.patient.name = jdCoupon.patientName;
        $scope.jdCouponInfo.jdCouponCategoryId = jdCoupon.jdCouponCategoryId;
        $scope.jdCouponInfo.status = jdCoupon.status;
        $scope.jdCouponInfo.value = jdCoupon.value;
        $scope.jdCouponInfo.limitAmount = jdCoupon.limitAmount;
        $scope.jdCouponInfo.expiredDateAsString = jdCoupon.expiredDate.split(" ")[0];
        $scope.jdCouponInfo.paymentChannel = jdCoupon.paymentChannel;
    }
    //选择用户
    $scope.selectPatient = function () {
        var modalInstance = $modal.open({
            templateUrl: 'selectPatient.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectPatientCtrl',
            size:"lg",
            resolve: {}
        });
        modalInstance.result.then(function (result) {
            for (var k in result) {
                $scope.patient[k] = result[k];
            }
        });
    };
    $("#expiredDateAsString").val($scope.jdCouponInfo.expiredDateAsString);    //开始有效时间段结束

    $scope.ok = function (e) {
        if ($scope.patient){
            $scope.jdCouponInfo.jdPatientId = $scope.patient.jdPatientId;
            $scope.jdCouponInfo.patientName = $scope.patient.name;
        }
        $scope.jdCouponInfo.expiredDateAsString = $("#expiredDateAsString").val();
        if (!validateFiledNullMax(toaster, $scope.jdCouponInfo.code, "编码", true, 20)
            || !validateFiledNullMax(toaster, $scope.jdCouponInfo.jdCouponCategoryId, "现金券类型", true, 0)
            || !validateFiledNullMax(toaster, $scope.jdCouponInfo.status, "状态", true, 20)
            || !validateFiledInteger(toaster, $scope.jdCouponInfo.value, "金额", false, false)
            || !validateFiledNullMax(toaster, $scope.jdCouponInfo.paymentChannel, "支付渠道", true, 20)
            || !validateFiledNullMax(toaster, $scope.jdCouponInfo.expiredDateAsString, "到期时间", true, 0)) {
            return;
        }
        if ($scope.jdCouponInfo.limitAmount!=undefined && $scope.jdCouponInfo.limitAmount!= null && $scope.jdCouponInfo.limitAmount!="")
            if (!validateFiledInteger(toaster, $scope.jdCouponInfo.limitAmount, "最小使用金额",false,false)){
                return;
            }

        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            if (jdCoupon) {
                $http.put(REST_PREFIX + "jdCoupon", $scope.jdCouponInfo).success(function (result) {
                    if (result.result == 1) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "现金券编码【" + $scope.jdCouponInfo.code + "】已经存在");
                    } else {
                        toaster.pop("success", "提示", "保存成功");
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX + "jdCoupon", $scope.jdCouponInfo).success(function (result) {
                    if (result.result == 1) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "现金券编码【" + $scope.jdCouponInfo.code + "】已经存在");
                    } else {
                        toaster.pop("success", "提示", "保存成功");
                        $modalInstance.close("success");
                    }
                });
            }
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});
app.controller('createCouponCtrl', function ($scope, $http, $modal, $modalInstance, toaster, $localStorage, Admin_Constant, jdCouponCategorys,$rootScope){
    $scope.getAttachInfos = function () {
        //获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
        //获取渠道信息
        //$scope.jdQrcodeList = $localStorage[Admin_Constant.LocalStorage.QrCodes];
        if(!$rootScope.jdQrcodeList) {
            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                $scope.jdQrcodeList = result.jdQrcodeList;
                //$localStorage[Admin_Constant.LocalStorage.QrCodes] = $scope.jdQrcodeList;
            });
        }
    };
    $scope.getAttachInfos();

    $scope.submitFlag = false;  //防止表单重复提交
    $scope.paymentChannelS = paymentChannelStatus;  //支付渠道
    $scope.couponStatus = couponStatus;     //现金券状态
    $scope.jdCouponCategorys = jdCouponCategorys;   //现金券类型
    $scope.createCouponInfo = {};
    $scope.createCouponInfo.selectUserFlag = "false"; //是否指定用户
    $scope.targetNumber = 0; //目标用户数

    $scope.ok = function (e) {
        $scope.createCouponInfo.expiredDateAsString = $("#c_expiredDateAsString").val();
        $scope.createCouponInfo.status = $scope.couponStatus[0].value;
        if($scope.createCouponInfo.selectUserFlag == "false" &&
            !validateFiledInteger(toaster, $scope.createCouponInfo.createNumber,"数量",false,false)) {
            return;
        }
        if($scope.createCouponInfo.selectUserFlag == "true" && $scope.targetNumber == 0) {
            toaster.pop("error", "提示", "目标用户数必须大于0", "1000");
            return;
        }
        if (!validateFiledNullMax(toaster, $scope.createCouponInfo.jdCouponCategoryId, "现金券类型", true, 0)
            || !validateFiledNullMax(toaster, $scope.createCouponInfo.paymentChannel, "支付渠道", true, 0)
            || !validateFiledInteger(toaster, $scope.createCouponInfo.value, "金额", false, false)
            || !validateFiledNullMax(toaster, $scope.createCouponInfo.expiredDateAsString, "到期时间", true, 0)
            || !validateFiledNullMax(toaster, $scope.createCouponInfo.status, "状态", true, 0)){
            return;
        }
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            $("#cancelBtn").attr("disabled", true);
            $("#confirmBtn").attr("disabled", true).html("生成中...");
            $scope.createCouponInfo.districtList = $scope.screenCondi.districtList;
            $scope.createCouponInfo.effectiveDateStart = $scope.screenCondi.effectiveDateStart;
            $scope.createCouponInfo.effectiveDateEnd = $scope.screenCondi.effectiveDateEnd;
            $scope.createCouponInfo.name = $scope.screenCondi.name;
            $scope.createCouponInfo.phoneNumber = $scope.screenCondi.phoneNumber;
            $scope.createCouponInfo.qrcodeList = $scope.screenCondi.qrcodeList;
            $scope.createCouponInfo.hasOrdered = $scope.screenCondi.hasOrdered;
            $scope.createCouponInfo.hasFreeOrder = $scope.screenCondi.hasFreeOrder;
            $scope.createCouponInfo.hasPayOrder = $scope.screenCondi.hasPayOrder;
            toaster.pop("success", "提示", "正在自动生成现金券...");
            $http.post(REST_PREFIX + "jdCoupon/createCoupon", $scope.createCouponInfo).success(function (result) {
                if (result.result == 0) {
                    toaster.pop("success", "提示", "生成现金券成功");
                    $modalInstance.close("success");
                } else {
                    $scope.submitFlag = false;
                    $("#cancelBtn").attr("disabled", false);
                    $("#confirmBtn").attr("disabled", false).html("确定");
                    toaster.pop("error", "提示", result.description);
                }
            });
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };

    //设置条件
    $scope.screenCondi = {districtList:null,effectiveDateStart:null,effectiveDateEnd:null,name:null,
        phoneNumber:null,qrcodeList:null,hasOrdered:"",hasPayOrder:false,hasFreeOrder:false};
    $scope.setScreenCondi = function () {
        var modalInstance = $modal.open({
            templateUrl: 'setScreenCondi.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'setScreenCondiCtrl',
            resolve: {
                screenCondi : function () {
                    return $scope.screenCondi;
                },
                jdDistricts : function () {
                    return $scope.jdDistricts;
                },
                jdQrcodeList : function() {
                    return $scope.jdQrcodeList;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.targetNumber = result.targetNumber;
            $scope.screenCondi = result.screenCondi;
        });
    };
});
app.controller('setScreenCondiCtrl', function ($scope, $http, $modalInstance, toaster, screenCondi, jdDistricts, jdQrcodeList){
    var districtList = [];
    jdDistricts.forEach(function(district) {
        districtList.push({uuid:district.uuid, name:district.name});
    });
    $scope.jdDistricts = districtList;
    var qrcodeList = [];
    jdQrcodeList.forEach(function(qrcode) {
        qrcodeList.push({uuid:qrcode.uuid, name:qrcode.name});
    });
    $scope.jdQrcodeList = qrcodeList;

    $scope.screenCondi = screenCondi;
    var screenDistrictList = [];
    if($scope.screenCondi.districtList) {
        $scope.screenCondi.districtList.forEach(function(sdistrict) {
            $scope.jdDistricts.forEach(function(district) {
                if(district.uuid === sdistrict.uuid)
                    screenDistrictList.push(district);
            });
        });
        $scope.screenCondi.districtList = screenDistrictList;
    }
    var screenQrcodeList = [];
    if($scope.screenCondi.qrcodeList) {
        $scope.screenCondi.qrcodeList.forEach(function(sqrcode) {
            $scope.jdQrcodeList.forEach(function(qrcode) {
                if(qrcode.uuid === sqrcode.uuid)
                    screenQrcodeList.push(qrcode);
            });
        });
        $scope.screenCondi.qrcodeList = screenQrcodeList;
    }

    $("#condi_createTimeStart").val($scope.screenCondi.effectiveDateStart);
    $("#condi_createTimeEnd").val($scope.screenCondi.effectiveDateEnd);

    $scope.ok = function () {
        $scope.screenCondi.effectiveDateStart = $("#condi_createTimeStart").val();
        $scope.screenCondi.effectiveDateEnd = $("#condi_createTimeEnd").val();
        $http.post(REST_PREFIX + "jdCoupon/screenTargetUser", $scope.screenCondi).success(function (result) {
            if(result.result == 0) {
                var result = {
                    "targetNumber" : result.number,
                    "screenCondi" : $scope.screenCondi
                };
                $modalInstance.close(result);
            } else {
                toaster.pop("error", "提示", result.description);
            }
        });
    };

    $scope.cancel = function () {
        $modalInstance.dismiss();
    };
});