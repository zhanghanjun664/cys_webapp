'use strict';
app.controller('JdOrderPlusCtrl', function ($window,$scope, $http, $modal, ngTableParams, toaster, SweetAlert, $localStorage, Admin_Constant) {
	$scope.resultPage = {totalCount:0};
	$scope.data = []; //当前页面的结果集
	//预约状态
	$scope.orderPlusStatus = [
		{value:"WAITTO_PAY",name:"待付款"},
		{value:"NO_PAY",name:"未付款"},
		{value:"WAITTO_COMFIRM",name:"待确认"},
		{value:"APPLYING",name:"申请中"},
		{value:"FINISHED",name:"已完成"},
		{value:"CANCELED",name:"用户取消"},
		{value:"DOCTOR_ALLOCATE",name:"医生已放号"}
	];
	
	$scope.orderSourceType = gOrderSources;
	

	//获取预约状态对应描述
	$scope.showOrderPlusStatus = function(status) {
		return showOrderPlusStatus(status);
	};
	$scope.showOrderSourceType = showOrderSource;
	
	
	$scope.getAttachInfos = function () {
		//获取地区信息
		$scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
		if(!$scope.jdDistricts) {
			$http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
				$scope.jdDistricts = result.districtList;
				$localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
			});
		}
	};
	$scope.getAttachInfos();
	$scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
			$scope.searchInfos.pageIndex = params.page();
			$scope.searchInfos.pageSize = params.count();
			$scope.queryString = getQueryString($scope.searchInfos);
			var requestUrl = REST_PREFIX+"jdOrderPlus/list"+$scope.queryString;
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
    $scope.edit = function (jdOrderPlus) {
    	var modalInstance = $modal.open({
            templateUrl: 'editJdOrderPlus.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdOrderPlusCtrl',
    		resolve: {
    			jdOrderPlus : function() {
    				return jdOrderPlus;
    			}
            }
        });
    	modalInstance.result.then(function (result) {
    		$scope.tableParams.reload();
        });
    };
    
    //点击查询按钮
	$scope.searchInfos = {name:null,phoneNumber:null,idCard:null,status:null,oppointmentTimeStart:null,oppointmentTimeEnd:null,
		createTimeStart:null,createTimeEnd:null,doctor:null,districtId:null,bdName:null};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchJdOrderPlus.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchJdOrderPlusCtrl',
			resolve: {
				searchInfos : function() {
					return $scope.searchInfos;
				},
				districts : function() {
					return $scope.jdDistricts;
				},
				orderPlusStatus : function(){
					return $scope.orderPlusStatus;
				},
				orderSourceType:function () {
					return $scope.orderSourceType;
				}
			}
		});
		modalInstance.result.then(function (searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.tableParams.reload();
		});
	};
	$scope.export = function () {
		var requestUrl = REST_PREFIX + "jdOrderPlus/download" + getQueryString($scope.searchInfos);
		$window.open(requestUrl);
	};
});
app.controller('searchJdOrderPlusCtrl', function ($scope, $modalInstance, searchInfos, districts, orderPlusStatus,orderSourceType) {
	$scope.orderPlusStatus = orderPlusStatus;
	$scope.orderSourceType = orderSourceType;
	$scope.searchInfos = searchInfos;
	$scope.districts = districts;
	$scope.ok = function (e) {
		$scope.searchInfos.oppointmentTimeStart = $("#oppointmentTimeStart").val();
		$scope.searchInfos.oppointmentTimeEnd = $("#oppointmentTimeEnd").val();
		$scope.searchInfos.createTimeStart = $("#createTimeStart").val();
		$scope.searchInfos.createTimeEnd = $("#createTimeEnd").val();
		$modalInstance.close($scope.searchInfos);
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	$scope.clear = function () {
		$scope.searchInfos = {name:null,phoneNumber:null,idCard:null,status:null,oppointmentTimeStart:null,oppointmentTimeEnd:null,
			createTimeStart:null,createTimeEnd:null,doctor:null,districtId:null,bdName:null};
	};
});
app.controller('editJdOrderPlusCtrl', function ($scope, $http, $modalInstance, toaster, jdOrderPlus) {
	//预约状态
	$scope.orderPlusStatus = [
		{value:"WAITTO_COMFIRM",name:"待确认"},
		{value:"APPLYING",name:"申请中"},
		{value:"FINISHED",name:"已完成"},
		{value:"CANCELED",name:"用户取消"},
		{value:"DOCTOR_ALLOCATE",name:"医生已放号"}
	];
	$scope.submitFlag = false; //为防止表单重复提交
	$scope.jdOrderPlusInfo = {};
	$scope.jdOrderPlusInfo2 = {};
	if(jdOrderPlus) {
		$scope.jdOrderPlusInfo.uuid = jdOrderPlus.uuid;
		$scope.jdOrderPlusInfo.name = jdOrderPlus.name;
		$scope.jdOrderPlusInfo.gender = jdOrderPlus.gender;
		$scope.jdOrderPlusInfo.phoneNumber = jdOrderPlus.phoneNumber;
		$scope.jdOrderPlusInfo.idCard = jdOrderPlus.idCard;
		$scope.jdOrderPlusInfo.age = jdOrderPlus.age;
		$scope.jdOrderPlusInfo.jdDoctorId = jdOrderPlus.jdDoctorId;
		$scope.jdOrderPlusInfo2.orderDate = jdOrderPlus.orderDate;
		$scope.jdOrderPlusInfo.sickDescription = jdOrderPlus.sickDescription;
		$scope.jdOrderPlusInfo.status = jdOrderPlus.status;
		$scope.jdOrderPlusInfo.remark = jdOrderPlus.remark;
		$scope.jdOrderPlusInfo2.refund = jdOrderPlus.refund;
		if(!jdOrderPlus.refund)
			$scope.jdOrderPlusInfo.refund = "N";
		else
			$scope.jdOrderPlusInfo.refund = jdOrderPlus.refund;
	}
	$scope.ok = function (e) {
		//提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			if(jdOrderPlus) {
				$http.put(REST_PREFIX+"jdOrderPlus", $scope.jdOrderPlusInfo).success(function(result) {
					$modalInstance.close("success");
				});
			}
		}
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
});