'use strict';

var sickCategorySet = {
	// 初始化页面数据与方法
	isShowOnPatientList : null,
	initScopeData : function($scope) {
		sickCategorySet.isShowOnPatientList = ($scope.isShowOnPatientList = sickCategorySet.isShowOnPatientList ? sickCategorySet.isShowOnPatientList
				: sickCategorySet.initIsShowOnPatientList());
	},
	initIsShowOnPatientList : function() {
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
	},
}

app.controller('sickCategorySetCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant) {
	initScope({
		initScopeData : sickCategorySet.initScopeData,
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
		searchTemplateUrl : 'searchSickCategorySet.html',
		searchController : 'searchSickCategorySetCtrl',
		editTemplateUrl : 'editSickCategorySet.html',
		editController : 'editSickCategorySetCtrl',
		tableQueryUrl : "sickCategorySet/list",
		deleteUrl : "sickCategorySet/",
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

});

app.controller('searchSickCategorySetCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			sickCategorySet.initScopeData($scope);
		}
	});
});

app.controller('editSickCategorySetCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	if (obj) {
		$scope.obj = obj;
		booleanToString($scope.obj);
	} else {
		// 默认值设置
		$scope.obj.isShowOnPatient = true + "";
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});

	$scope.ok = function(e) {
		// 校验相关
		if (!validateMulNull(toaster, $scope.obj.name, "疾病名称", true, 0))
			return;
		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX + "sickCategorySet", $scope.obj).success(function(result) {
				resultProcess($scope , result, $modalInstance, toaster);
			});
		}
	};

});
