'use strict';
app.controller('loginLogCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant) {
	$scope.resultPage = {
		totalCount : 0
	};
	$scope.data = []; // 当前页面的结果集

	// 初始化页面数据与方法
	$scope.deviceList = initDeviceList();
	$scope.channelList = initChannelList();

	$scope.getDeviceStr = function(value) {
		for ( var i in $scope.deviceList) {
			var obj = $scope.deviceList[i];
			if (value == obj.value) {
				return obj.name;
			}
		}
	}

	$scope.getChannelStr = function(value) {
		for ( var i in $scope.channelList) {
			var obj = $scope.channelList[i];
			if (value == obj.value) {
				return obj.name;
			}
		}
	}

	$scope.tableParams = new ngTableParams({
		page : 1,
		count : 10
	}, {
		total : $scope.resultPage.totalCount,
		getData : function($defer, params) {
			commonResetSelection($scope);// 重置查询框
			$scope.searchInfos.pageIndex = params.page();// params为ngTableParams对象的第一个参数
			$scope.searchInfos.pageSize = params.count();
			$scope.queryString = getQueryString($scope.searchInfos);
			var requestUrl = REST_PREFIX + "loginlog/list" + $scope.queryString;
			$http.get(requestUrl).success(function(result) {
				$scope.resultPage = result;
				params.total(result.totalRecords);

				$scope.data = result.content;
				$defer.resolve($scope.data);
			});
		}
	});

	// 改变当前选中的行
	$scope.changeSelection = function(index) {
		commonChangeSelection($scope, index);
	};

	// 全选/全不选
	$scope.selectAll = function() {
		commonSelectAll($scope);
	};

	// 点击查询按钮
	$scope.searchInfos = {};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl : 'searchLoginLog.html',
			backdrop : 'static',
			keyboard : false,
			controller : 'searchLoginLogCtrl',
			resolve : {
				searchInfos : function() {
					return $scope.searchInfos;
				},
				doctorSkills : function() {
					return $scope.doctorSkills;
				}
			}
		});
		modalInstance.result.then(function(searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.tableParams.reload();
		});
	};
});

app.controller('searchLoginLogCtrl', function($scope, $modalInstance, searchInfos) {
	// 恢复上一次的查询条件
	$scope.searchInfos = searchInfos;
	// 初始化页面数据
	$scope.deviceList = initDeviceList();
	$scope.channelList = initChannelList();
	$("#createTimeEnd").val($scope.searchInfos.createTimeEnd);
	$("#createTimeStart").val($scope.searchInfos.createTimeStart);
	
	$scope.ok = function(e) {
		$scope.searchInfos.createTimeStart = $("#createTimeStart").val();
		$scope.searchInfos.createTimeEnd = $("#createTimeEnd").val();
		$modalInstance.close($scope.searchInfos);
	};
	$scope.cancel = function(e) {
		$modalInstance.dismiss();
	};
	$scope.clear = function() {
		$scope.searchInfos = {};
	};
});

var initDeviceList = function() {
	var list = [];
	list.push({
		name : '微信',
		value : 'wechat'
	});
	list.push({
		name : 'APP',
		value : 'app'
	});
	list.push({
		name : '网站',
		value : 'web'
	});
	list.push({
		name : '未知',
		value : 'unknow'
	});
	return list;
};

var initChannelList = function() {
	var list = [];
	list.push({
		name : '自有',
		value : 'OWN'
	});
	list.push({
		name : '思瑞',
		value : 'SIRUI'
	});
	list.push({
		name : '康康',
		value : 'KANGKANG'
	});
	list.push({
		name : '健一',
		value : '91CN'
	});
	list.push({
		name : '39',
		value : 'SANJIU'
	});
	return list;
};
