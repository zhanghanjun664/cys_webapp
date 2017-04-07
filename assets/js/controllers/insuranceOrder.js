'use strict';
app.controller('insuranceOrderCtrl', function ($scope, $http, $modal, ngTableParams,toaster, $window, $localStorage, Admin_Constant, SweetAlert,cysIndexedDB,$rootScope) {
    var requestUrl = REST_PREFIX+"insuranceOrder/vendor/list";
    $http.get(requestUrl).success(function (result) {
        var vendors = [];
        result.vendors.forEach(function(vendor) {
            vendors.push({value:vendor,name:vendor});
        });
        $scope.vendors = vendors;
    });
    
    
    $scope.orderStatus = insuranceOrderStatus; //订单状态
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
            if($scope.searchInfos.qrcodeList) {
                var str = new StringBuilder();
                var first = true;
                $scope.searchInfos.qrcodeList.forEach(function(sqrcode) {
                    if(first) {
                        first = false;
                        str.append(sqrcode.uuid);
                    } else {
                        str.append(";" + sqrcode.uuid);
                    }
                });
                $scope.queryString += "&qrcodeList=" + str.toString();
            }
            var requestUrl = REST_PREFIX+"insuranceOrder/list"+$scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                // params.count($scope.resultPage.pageShow);
                $defer.resolve($scope.resultPage.result);
            });
        }
    });

    //根据订单状态的值显示对应的描述
    $scope.showOrderStatus = function(status) {
        return showOrderStatus(status);
    };

    //点击查询按钮
    $scope.searchInfos = {contactName:null,insuredName:null,doctorName:null,orderId:null,status:null,
        dateCreatedEnd:null,dateCreatedStart:null,vendor:null};
    $scope.search = function() {
        $scope.searchInfos.contactName = $("#search_contactName").val();
        $scope.searchInfos.insuredName = $("#search_insuredName").val();
        $scope.searchInfos.doctorName = $("#search_doctorName").val();
        $scope.searchInfos.orderId = $("#search_orderId").val();
        if($("#search_order_status").val() != ""){
            $scope.searchInfos.orderStatus = insuranceOrderStatus[$("#search_order_status").val()].value;
        }
        $scope.searchInfos.dateCreatedEnd = $("#search_dateCreatedEnd").val();
        $scope.searchInfos.dateCreatedStart = $("#search_dateCreatedStart").val();
        if($("#search_vendor").val() != ""){
            $scope.searchInfos.vendor = $scope.vendors[$("#search_vendor").val()].name;
        }
        $scope.tableParams.reload();
    };
    $scope.clear = function() {
        $scope.searchInfos = {contactName:null,insuredName:null,doctorName:null,orderId:null,status:null,
            dateCreatedEnd:null,dateCreatedStart:null,vendor:null};
    };
    $scope.export = function() {
        var requestUrl = REST_PREFIX+"insuranceOrder/download"+$scope.queryString;
        $window.open(requestUrl);
    };

    //更多
    $scope.more = function (order) {
        var requestUrl = REST_PREFIX+"insuranceOrder/insuranceOrderLog?orderId="+order.id;
        $http.get(requestUrl).success(function (result) {
            var orderlogPage = result.resultPage;
            var modalInstance = $modal.open({
                templateUrl: 'moreOrderInfo.html',
                backdrop: 'static',
                keyboard: false,
                size:"lg",
                controller: 'moreOrderInfoCtrl',
                resolve: {
                    orderInfo : function() {
                        return {"order":order,"orderlogPage":orderlogPage,"tableParams":$scope.tableParams};
                    }
                }
            });
            modalInstance.result.then(function (result) {
                $scope.tableParams.reload();
            });
        });
    };
});
app.controller('changeStatusOrderCtrl', function ($scope, $http, $modalInstance, toaster, order) {
    $scope.orderInfo = order.orderInfo;
    $scope.nextStatus = order.nextStatus;
    $scope.tableParams = order.tableParams;
    $scope.isShowEdit = false ;
    $scope.isShowEditOrderNum = false ;
    $scope.obj = new Flow(); // 头像文件对象
    $scope.uploadUrl = REST_PREFIX + "insuranceOrder/upload_idcard_icon";
    $scope.noImage = true;
    if($scope.orderInfo.insuredIdcardImage){
        $scope.noImage = false;
    }
    $scope.removeImage = function () {
        $scope.noImage = true;
    };
    // 图片上传成功回调函数
    $scope.uploadSuccess = function(file, message) {
        var result = JSON.parse(message);
        console.log("result="+result);
        if(result.result == 0) {
            $scope.orderInfo.insuredIdcardImageUrl= result.uploadUrl;
            $scope.orderInfo.insuredIdcardImage= result.relativeUrl;
            console.log("orderInfo.insuredIdcardImage="+result.uploadUrl);
            submitInsuranceOrder()
        } else {
            toaster.pop("error", "提示", "上传图片失败，请联系管理员!");
            $scope.submitFlag = false;
        }
    };
    $scope.changeStatus = function(e){
        var orderStatus = $("#editorder_status").val();
        if(orderStatus == '2' && $scope.orderInfo.status != '1'){
            $scope.isShowEdit = true ;
        }else {
            $scope.isShowEdit = false ;
        }

        if(orderStatus == '6'){
            $scope.isShowEditOrderNum = true;
        }else{
            $scope.isShowEditOrderNum = false;
        }
    };
    $scope.cancelStatus = function (e) {
        $modalInstance.dismiss();
    };
    $scope.okStatus = function (e) {
        var orderStatus = $("#editorder_status").val();
        var remark = $("#remark").val();
        $scope.orderInfo.remark = remark;


        
        if(!validateFiledNullMax(toaster, $scope.orderInfo.remark, "备注", true, 64)
            || !validateFiledNullMax(toaster, orderStatus, "状态", true, 2)){
            return;
        }
        if(orderStatus == '2' && $scope.orderInfo.status != '1'){
            if(!validateFiledNullMax(toaster, $scope.orderInfo.contactName, "投保人姓名", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.contactPhone, "投保人手机", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.insuredName, "被保人姓名", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.insuredPhone, "被保人手机", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.insuredIdcard, "被保人身份证", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.insuredAge, "被保人年龄", true, 2)
                || !validateFiledNullMax(toaster, $scope.orderInfo.hospitalName, "医院", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.doctorName, "主刀医生", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.doctorTitle, "医生职称", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.operation, "手术方案", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.operationTime, "手术时间", true, 40)
                || !validateFiledNullMax(toaster, $scope.orderInfo.contactIdcard, "投保人身份证", true, 40)
            ){
                return;
            }
        }
        if(orderStatus == '6'){
            if(!validateFiledNullMax(toaster, $scope.orderInfo.orderNum, "保险公司核保单号", true, 40)){
                return;
            }
        }

        $scope.orderInfo.status = orderStatus;

        if($scope.obj.flow.files[0]) {
            $scope.obj.flow.upload();
        } else {
            submitInsuranceOrder();
        }
    };
    function submitInsuranceOrder() {
        $http.post(REST_PREFIX+"insuranceOrder/updateInsuranceOrder", $scope.orderInfo).success(function() {
            $modalInstance.close("success");
            //关闭窗口
            order.moreOrderWin.dismiss();
            order.tableParams.reload();//刷新列表
        });
    }
});

app.controller('moreOrderInfoCtrl', function ($scope, $http,$modal, $modalInstance,toaster, orderInfo) {
    $scope.orderInfo = orderInfo.order;
    $scope.orderlogPage = orderInfo.orderlogPage;
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.changeStatus= function (e) {
        $scope.changOrderinfo = {};
        var nextStatus = nextInsuranceOrderStatus($scope.orderInfo.status);
        var modalInstance = $modal.open({
            templateUrl: 'changeStatusOrder.html',
            backdrop: 'static',
            keyboard: false,
            size:"lg",
            controller: 'changeStatusOrderCtrl',
            resolve: {
                order : function() {
                    $scope.changOrderinfo.orderInfo = $scope.orderInfo;
                    $scope.changOrderinfo.nextStatus = nextStatus;
                    $scope.changOrderinfo.tableParams = orderInfo.tableParams;
                    $scope.changOrderinfo.moreOrderWin = $modalInstance;
                    return $scope.changOrderinfo;
                }
            }
        });
    };
    $scope.selectIdcardImage = function (orderInfo) {
        if(orderInfo.insuredIdcardImageUrl == '' || orderInfo.insuredIdcardImageUrl == null || orderInfo.insuredIdcardImageUrl == undefined){
            toaster.pop("error", "提示", "身份证图片为空", "1000");
        }else{
            window.open(orderInfo.insuredIdcardImageUrl,'查看身份证照片','')
        }
    }
    $scope.selectOldOrder = function (orderOperation) {
        $modal.open({
            templateUrl: 'oldOrder.html',
            backdrop: 'static',
            keyboard: false,
            size:"secondary",
            controller: 'oldOrderCtrl',
            resolve: {
                order : function() {
                    return orderOperation.params;
                }
            }
        });
    }
});
app.controller('oldOrderCtrl', function ($scope, $http, $modalInstance, order) {
    $scope.orderInfo = order;
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});