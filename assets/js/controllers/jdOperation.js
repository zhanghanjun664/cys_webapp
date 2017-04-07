'use strict';
app.controller('JdOperationCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
    //预约单状态
    $scope.operationStatus = [
        {value:"WAITTO_COMFIRM",name:"待确认"},
        {value:"APPLYING",name:"申请中"},
        {value:"WAITTO_PAY",name:"待付费"},
        {value:"WAITTO_DIAGNOSE",name:"待就诊"},
        {value:"FINISHED",name:"已完成"},
        {value:"CANCELED",name:"用户取消"},
        {value:"HAS_PAY",name:"已付款"},
        {value:"HAS_REFUND",name:"已退款"}
    ];
    //获取预约单状态对应描述
    $scope.showOperationStatus = function(status) {
        if (status == "WAITTO_COMFIRM") return "待确认";
        if (status == "APPLYING") return "申请中";
        if (status == "WAITTO_PAY") return "待付费";
        if (status == "WAITTO_DIAGNOSE") return "待就诊";
        if (status == "FINISHED") return "已完成";
        if (status == "CANCELED") return "用户取消";
        if (status == "HAS_PAY") return "已付款";
        if (status == "HAS_REFUND") return "已退款";
    };
    //预约单类型
    $scope.operationType = [
        {value:"住院",name:"住院"},
        {value:"手术",name:"手术"}
    ];

    $scope.resultPage = {totalCount:0};
    $scope.data = []; //当前页面的结果集

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
            var requestUrl = REST_PREFIX+"jdOperation/list"+$scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);
            });
        }
    });

    //编辑
    $scope.edit = function (jdOperation) {
        var modalInstance = $modal.open({
            templateUrl: 'editJdOperation.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdOperationCtrl',
            resolve: {
                jdOperation : function() {
                    return jdOperation;
                },
                operationStatus : function() {
                    return $scope.operationStatus;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };

    //编辑
    $scope.refund = function (jdOperation) {
	  $scope.jdOperationInfo = {};
	    if(jdOperation) {
	        $scope.jdOperationInfo.uuid = jdOperation.uuid;
	        $scope.jdOperationInfo.name = jdOperation.name;
	        $scope.jdOperationInfo.phoneNumber = jdOperation.phoneNumber;
	        $scope.jdOperationInfo.idCard = jdOperation.idCard;
	        $scope.jdOperationInfo.hospitalName = jdOperation.hospitalName;
	        $scope.jdOperationInfo.doctorName = jdOperation.doctorName;
	        $scope.jdOperationInfo.type = jdOperation.type;
	        $scope.jdOperationInfo.doctorName = jdOperation.doctorName;
	        $scope.jdOperationInfo.status = jdOperation.status;
	        $scope.jdOperationInfo.remark = jdOperation.remark;
	        $scope.jdOperationInfo.age = jdOperation.age;
	        $scope.jdOperationInfo.gender = jdOperation.gender;
	        $scope.jdOperationInfo.sickDescription = jdOperation.sickDescription;
	    }
        SweetAlert.swal({
            title: "是否退款",
            //text: "退款",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
                $http.put(REST_PREFIX+"jdOperation/refund", $scope.jdOperationInfo).success(function(result) {
                	console.log("result=",result);
                    if(!result){
						toaster.pop("error","提示",result.description);
					}else{
						$scope.tableParams.reload();
					}
                });
            }
        });
    };
    
    //点击查询按钮
    $scope.searchInfos = {name:null,phoneNumber:null,idCard:null,type:null,status:null};
    $scope.search = function() {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdOperation.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdOperationCtrl',
            resolve: {
                searchInfos : function() {
                    return $scope.searchInfos;
                },
                operationStatus : function() {
                    return $scope.operationStatus;
                },
                operationType : function() {
                    return $scope.operationType;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    };

});
app.controller('searchJdOperationCtrl', function ($scope, $modalInstance, searchInfos, operationStatus, operationType) {
    $scope.operationType = operationType;
    $scope.operationStatus = operationStatus;
    $scope.searchInfos = searchInfos;
    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {name:null,phoneNumber:null,idCard:null,type:null,status:null};
    };
});
app.controller('editJdOperationCtrl', function ($scope, $http, $modal, $modalInstance, toaster, jdOperation, operationStatus) {
    $scope.operationStatus = operationStatus;
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.jdOperationInfo = {};
    if(jdOperation) {
        $scope.jdOperationInfo.uuid = jdOperation.uuid;
        $scope.jdOperationInfo.name = jdOperation.name;
        $scope.jdOperationInfo.phoneNumber = jdOperation.phoneNumber;
        $scope.jdOperationInfo.idCard = jdOperation.idCard;
        $scope.jdOperationInfo.hospitalName = jdOperation.hospitalName;
        $scope.jdOperationInfo.doctorName = jdOperation.doctorName;
        $scope.jdOperationInfo.type = jdOperation.type;
        $scope.jdOperationInfo.doctorName = jdOperation.doctorName;
        $scope.jdOperationInfo.status = jdOperation.status;
        $scope.jdOperationInfo.remark = jdOperation.remark;
        $scope.jdOperationInfo.age = jdOperation.age;
        $scope.jdOperationInfo.gender = jdOperation.gender;
        $scope.jdOperationInfo.sickDescription = jdOperation.sickDescription;
        $scope.jdOperationInfo.sickImageList = jdOperation.sickImageList;
    }
    $scope.ok = function (e) {
        //提交
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            if(jdOperation) {
                $http.put(REST_PREFIX+"jdOperation", $scope.jdOperationInfo).success(function(result) {
                    $modalInstance.close("success");
                });
            }
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    // 图片放大弹出框
    $scope.open = function (orderInfo,index) {
        $modal.open({
            templateUrl: 'certificateImages.html',
            controller: 'ImageViewCtrl',
            size: 'lg',
            resolve: {
                orderInfo: function () {
                    return orderInfo;
                },
                index:function () {
                    return index;
                }
            }
        });
    };
});
// 图片查看控制器
app.controller('ImageViewCtrl', function ($scope, $modalInstance, orderInfo,index) {
    $scope.imageUrl = orderInfo.sickImageList[index];
    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    }
});