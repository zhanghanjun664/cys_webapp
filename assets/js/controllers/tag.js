'use strict';

var tag = {
	// 初始化页面数据与方法
	initScopeData : function($scope) {
		tag.businessTypeList = ($scope.businessTypeList = tag.businessTypeList ? tag.businessTypeList : tag
				.initBusinessTypeList());

		tag.tagTypeList = ($scope.tagTypeList = tag.tagTypeList ? tag.tagTypeList : tag.initTagTypeList());
	},
	initBusinessTypeList : function() {
		var obj;
		ajax(REST_PREFIX + "tag/findBusinessTypeList", function(result) {
			if (result.body && result.body.code == 2000) {
				obj = result.body.result;
			}
		});
		return obj;
	},
	initTagTypeList : function() {
		var obj;
		ajax(REST_PREFIX + "tag/findTagTypeList", function(result) {
			if (result.body && result.body.code == 2000) {
				obj = result.body.result;
			}
		});
		return obj;
	}
}

app.controller('tagCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window, $localStorage,
		Admin_Constant) {
	initScope({
		initScopeData : tag.initScopeData,
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
					filterField(newObj, "auditable,selected");
					return newObj;
				}
			}
		},
		searchTemplateUrl : 'searchTag.html',
		searchController : 'searchTagCtrl',
		editTemplateUrl : 'editTag.html',
		editController : 'editTagCtrl',
		tableQueryUrl : "tag/list",
		$scope : $scope,
		$http : $http,
		$modal : $modal,
		ngTableParams : ngTableParams,
		toaster : toaster,
		SweetAlert : SweetAlert,
		$window : $window,
		$localStorage : $localStorage,
		Admin_Constant : Admin_Constant
	});

	$scope.getTagNames = function(tagArrays) {
		return tagArrays.join(",");
	}
});

app.controller('searchTagCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			tag.initScopeData($scope);
		}
	});
});

app.controller('editTagCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	if (obj) {
		$scope.obj = obj;
	} else {
		// 默认值设置
		$scope.obj.businessTypeList = [];
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster,
		initScopeData : tag.initScopeData
	});

	$scope.ok = function(e) {
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.name, $scope.obj.type ], [ "标签名", "所属分组" ]))
			return;

		if ($scope.obj.businessTypeList.length <= 0) {
			toaster.pop("error", "提示", "【所属业务】不能为空，请确认", "1000");
			return;
		}

		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX + "tag", $scope.obj).success(function(result) {
				resultProcess($scope, result, $modalInstance, toaster);
			});
		}
	};

});
