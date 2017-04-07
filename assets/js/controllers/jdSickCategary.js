'use strict';

var jdSickCategary = {
	// 初始化页面数据与方法
	sickCategoryTypeList : null,
	initScopeData : function($scope) {
		jdSickCategary.sickCategoryTypeList = ($scope.sickCategoryTypeList = jdSickCategary.sickCategoryTypeList ? jdSickCategary.sickCategoryTypeList
				: jdSickCategary.initSickCategoryTypeList());
	},
	initSickCategoryTypeList : function() {
		var list = [];
		ajax(REST_PREFIX + "jdSickCategary/sickTypeList", function(result) {
			if (result.body && result.body.code == 2000) {
				var data = result.body.result;
				for (var i = 0; i < data.length; i++) {
					list.push({
						name : data[i].name,
						value : data[i].uuid
					});
				}
			}
		});
		return list;
	}
}

app.controller('JdSickCategaryCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window) {
	initScope({
		initScopeData : jdSickCategary.initScopeData,
		searchModalResolve : function($scope) {
			return {
				searchInfos : function() {
					return $scope.searchInfos;
				}
			}
		},
		editModalResolve : function($scope) {
			return {
				obj : function() {
					// 必须用深拷贝复制1个新对象出来,否则Edit的修改会影响到父的对象
					var newObj = angular.copy($scope.obj);
					filterField(newObj, "selected,updateDate,createDate");
					return newObj;
				}
			}
		},
		searchTemplateUrl : 'searchJdSickCategary.html',
		searchController : 'searchJdSickCategaryCtrl',
		editTemplateUrl : 'editJdSickCategary.html',
		editController : 'editJdSickCategaryCtrl',
		tableQueryUrl : "jdSickCategary/list",
		deleteUrl : "jdSickCategary/",
		$scope : $scope,
		$http : $http,
		$modal : $modal,
		ngTableParams : ngTableParams,
		toaster : toaster,
		SweetAlert : SweetAlert,
	});

	// 导出按钮操作
	$scope.export = function() {
		var requestUrl = REST_PREFIX + "jdSickCategary/export" + $scope.queryString;
		$window.open(requestUrl);
	};
});
app.controller('editJdSickCategaryCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	if (obj) {
		$scope.obj = obj;
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster,
		initScopeData : jdSickCategary.initScopeData
	});

	$scope.ok = function(e) {
		if (!validateFiledNullMax(toaster, $scope.obj.name, "疾病大类", true, 64)
				|| !validateFiledInteger(toaster, $scope.obj.seq, "排序序号"))
			return;

		// 提交
		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			if (obj) {
				$http.put(REST_PREFIX + "jdSickCategary", $scope.obj).success(function(result) {
					resultProcess($scope , result, $modalInstance, toaster);
				});
			} else {
				$http.post(REST_PREFIX + "jdSickCategary", $scope.obj).success(function(result) {
					resultProcess($scope , result, $modalInstance, toaster);
				});
			}
		}
	};
});

app.controller('searchJdSickCategaryCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			jdSickCategary.initScopeData($scope);
		}
	});
});
