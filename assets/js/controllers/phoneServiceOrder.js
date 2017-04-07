'use strict';
app.controller('PhoneServiceOrderCtrl', function ($scope, $http, $modal, ngTableParams, $window, $localStorage, Admin_Constant, SweetAlert,cysIndexedDB,$rootScope) {
    $scope.resultPage = {totalCount:0};
    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            
            var requestUrl = REST_PREFIX+"serviceorder/" + SERVICE_TYPE_PHONE + "/list"+$scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $defer.resolve($scope.resultPage.result);
            });
        }
    });

    $scope.getAttachInfos = function () {
        // 获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
    };
    $scope.getAttachInfos();

    // 根据订单状态的值显示对应的描述
    $scope.showServiceOrderStatus = function(status) {
        return showServiceOrderStatus(status);
    };
    
    $scope.showUserChannel = function(channel) {
        return showUserChannel(channel);
    };

    $scope.showOrderSource = function(channel) {
        return showOrderSource(channel);
    };
    // 点击查询按钮
    $scope.searchInfos = {orderNumber:null,status:null,districtId:null,fulfilmentTimeStart:null,fulfilmentTimeEnd:null,
        createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,doctor:null,bdName:null};
    $scope.search = function() {
        var modalInstance = $modal.open({
            templateUrl: 'searchPhoneServiceOrder.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchPhoneServiceOrderCtrl',
            resolve: {
                searchInfos : function() {
                    return $scope.searchInfos;
                },
                districts : function() {
                    return $scope.jdDistricts;
                },
                jdQrcodeList : function() {
                    return $scope.jdQrcodeList;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    };

    $scope.export = function() {
        var requestUrl = REST_PREFIX+"order/download"+$scope.queryString;
        $window.open(requestUrl);
    };

    $scope.exportPayment = function() {
        var requestUrl = REST_PREFIX+"order/downloadPayment"+$scope.queryString;
        $window.open(requestUrl);
    };

    // 更多
    $scope.more = function (order) {
        var modalInstance = $modal.open({
            templateUrl: 'moreOrderInfo.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'moreOrderInfoCtrl',
            resolve: {
                order : function() {
                    return order;
                }
            }
        });
    };

    // 编辑
    $scope.editBtnCode = "ORDER_EDIT";
    $scope.exportBtnCode = "ORDER_EXPORT";
    $scope.edit = function (order) {
        var modalInstance = $modal.open({
            templateUrl: 'editOrder.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editOrderCtrl',
            resolve: {
                order : function() {
                    return order;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };

});
app.controller('searchPhoneServiceOrderCtrl', function ($scope, $modalInstance, searchInfos, districts, jdQrcodeList,$rootScope,cysIndexedDB) {
    // 获取渠道列表
    var qrcodeList = [];

    // jdQrcodeList.forEach(function(qrcode) {
    // qrcodeList.push({uuid:qrcode.uuid, name:qrcode.name});
    // });
    $scope.jdQrcodeList = qrcodeList;
    $scope.districts = districts;

    // 恢复上一次的查询条件
    $scope.searchInfos = searchInfos;
    $scope.orderStatuses = gServiceOrderStatuses; // 订单状态
    $scope.orderSources = gOrderSources; // 订单来源
    $scope.userChannels = gUserChannels; // 用户来源
    $("#fulfilmentTimeEnd").val($scope.searchInfos.fulfilmentTimeEnd);
    $("#fulfilmentTimeStart").val($scope.searchInfos.fulfilmentTimeStart);
    $("#createTimeEnd").val($scope.searchInfos.createTimeEnd);
    $("#createTimeStart").val($scope.searchInfos.createTimeStart);
    var screenQrcodeList = [];
    if($scope.searchInfos.qrcodeList) {
        $scope.searchInfos.qrcodeList.forEach(function(sqrcode) {
            $scope.jdQrcodeList.forEach(function(qrcode) {
                if(qrcode.uuid === sqrcode.uuid)
                    screenQrcodeList.push(qrcode);
            });
        });
        $scope.searchInfos.qrcodeList = screenQrcodeList;
    }

    $scope.getMultipleData=function(db,storeName,searchTerm,index){
        console.log(searchTerm);
        var transaction=db.transaction(storeName);
        var store=transaction.objectStore(storeName);
        var index = store.index(index);
        var request=index.openCursor(IDBKeyRange.bound(searchTerm,searchTerm+'\uffff'));
        var arr=[];
        request.onsuccess=function(e){
            var cursor=e.target.result;
            if(cursor){
                var object={uuid:cursor.value.uuid, name:cursor.value.name};
                console.log(object);
                arr.push(object);
                $scope.jdQrcodeList=arr;
                cursor.continue();
            }
        }
    };


    $scope.refreshAddresses=function(address){
        if(address!==""){
            $scope.getMultipleData(cysIndexedDB.db,'qrCode',address,'name');
        }
    };
    
    $scope.ok = function (e) {
        $scope.searchInfos.fulfilmentTimeStart = $("#fulfilmentTimeStart").val();
        $scope.searchInfos.fulfilmentTimeEnd = $("#fulfilmentTimeEnd").val();
        $scope.searchInfos.createTimeStart = $("#createTimeStart").val();
        $scope.searchInfos.createTimeEnd = $("#createTimeEnd").val();
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {orderNumber:null,status:null,districtId:null,fulfilmentTimeStart:null,fulfilmentTimeEnd:null,
            createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,doctor:null,bdName:null,exceed:'',qrcodeList:null};
    };
});
app.controller('moreOrderInfoCtrl', function ($scope, $http, $modalInstance, order) {
    $scope.orderInfo = order;
    
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});
app.controller('editOrderCtrl', function ($scope, $http, $modalInstance, toaster, order) {
    $scope.submitFlag = false; // 为防止表单重复提交
    $scope.orderInfo = {};
    
    $scope.SERVICE_ORDER_STATUS_CREATED = 0; // 创建
    $scope.SERVICE_ORDER_STATUS_PAID = 1; // 支付
    $scope.SERVICE_ORDER_STATUS_AWAIT_SERVICE = 3; // 待就诊
    $scope.SERVICE_ORDER_STATUS_FULFILLED = 4; // 执行完成
    $scope.SERVICE_ORDER_STATUS_CANCELED_BY_PATIENT = 5; // 患者取消
    $scope.SERVICE_ORDER_STATUS_CANCELED_BY_DOCTOR = 6; // 医生取消
    $scope.SERVICE_ORDER_STATUS_CANCELED = 8; // 取消
    $scope.SERVICE_ORDER_STATUS_SERVICE_UNFULFILLED = 9; // 通话失败（仅适用于电话咨询）
    $scope.SERVICE_ORDER_STATUS_PAYMENT_FAILED = 32; // 支付失败了
    $scope.SERVICE_ORDER_STATUS_TIMEOUT = 64; // 超时取消
    
    if(order) {
        $scope.order = order;
        $scope.orderInfo.id = order.id;
        $scope.orderInfo.masterName = order.masterName;
        $scope.orderInfo.masterPhoneNumber = order.masterPhoneNumber;
        $scope.orderInfo.patientName = order.patientName;
        $scope.orderInfo.patientPhoneNumber = order.patientPhoneNumber;
        $scope.orderInfo.age = order.age;
        $scope.orderInfo.sickDescription = order.sickDescription;
        $scope.orderInfo.status = order.status;
        $scope.originalStatus = order.status;
        $scope.orderInfo.remark = order.remark;
        $scope.orderInfo.totalAmount = order.totalAmount;
        $scope.orderInfo.callFailureReason = "";
        $scope.orderInfo.fulfilmentTimeStr = order.fulfilmentTime;
    }
    if($scope.orderInfo.status == SERVICE_ORDER_STATUS_PAID) {
        $scope.orderStatuses = [
             {value: SERVICE_ORDER_STATUS_PAID, name: "已付款"},
             {value: SERVICE_ORDER_STATUS_AWAIT_SERVICE, name: "待就诊"},
             {value: SERVICE_ORDER_STATUS_CANCELED_BY_PATIENT, name: "患者取消"},
             {value: SERVICE_ORDER_STATUS_CANCELED_BY_DOCTOR, name: "医生取消"}
        ];
    } else if($scope.orderInfo.status == SERVICE_ORDER_STATUS_AWAIT_SERVICE) {
        $scope.orderStatuses = [
             {value: SERVICE_ORDER_STATUS_AWAIT_SERVICE, name: "待就诊"},
             {value: SERVICE_ORDER_STATUS_FULFILLED, name: "咨询完成"},
             {value: SERVICE_ORDER_STATUS_SERVICE_UNFULFILLED, name: "通话失败"}
        ];
    }
    $scope.ok = function (e) {
        $scope.orderInfo.fulfilmentTimeStr = $("#fulfilmentTime").val();
        if($scope.orderInfo.status == SERVICE_ORDER_STATUS_AWAIT_SERVICE && $scope.orderInfo.fulfilmentTimeStr == "") {
            toaster.pop("error", "提示", "请选择通话时间");
            return;
        } else if($scope.orderInfo.status == SERVICE_ORDER_STATUS_SERVICE_UNFULFILLED 
                && $scope.orderInfo.callFailureReason == "") {
                toaster.pop("error", "提示", "请选择原因");
                return;
        } else if($scope.orderInfo.status == SERVICE_ORDER_STATUS_SERVICE_UNFULFILLED 
                && $scope.orderInfo.callFailureReason == "患者原因"
                && $scope.orderInfo.refundRequired == undefined) {
            toaster.pop("error", "提示", "患者原因，请选择是否退款");
            return;
        } 
        
        if ($scope.orderInfo.callFailureReason == "非患者原因") {
            $scope.orderInfo.refundRequired = 'true';
        }
        
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            
            $http.put(REST_PREFIX + "serviceorder/", $scope.orderInfo).success(function() {
                order.remark = $scope.orderInfo.remark;
                order.status = $scope.orderInfo.status;
                $modalInstance.close("success");
            });
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    // 根据订单状态的值显示对应的描述
    $scope.showServiceOrderStatus = function(status) {
        return showServiceOrderStatus(status);
    }
});