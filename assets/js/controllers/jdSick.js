'use strict';

var jdSick = {
	// 初始化页面数据与方法
	sickCategoryList : null,
	initScopeData : function($scope) {
		jdSick.sickCategoryList = ($scope.sickCategoryList = jdSick.sickCategoryList ? jdSick.sickCategoryList : jdSick
				.initSickCategoryList());
	},
	initSickCategoryList : function() {
		var list = [];
		ajax(REST_PREFIX + "jdSickCategary/all", function(result) {
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

app.controller('jdSickCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window) {
	initScope({
		initScopeData : jdSick.initScopeData,
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
		getCustomQueryString : function() {
			if ($scope.searchInfos.jdSickCategaryId && $scope.searchInfos.jdSickCategaryId.length > 0) {
				$scope.searchInfos.jdSickCategaryId = $scope.searchInfos.jdSickCategaryId[0];
			} else {
				$scope.searchInfos.jdSickCategaryId = "";
			}
			return getQueryString($scope.searchInfos);
		},
		searchTemplateUrl : 'searchJdSick.html',
		searchController : 'searchJdSickCtrl',
		editTemplateUrl : 'editJdSick.html',
		editController : 'editJdSickCtrl',
		tableQueryUrl : "jdSick/list",
		deleteUrl : "jdSick/",
		$scope : $scope,
		$http : $http,
		$modal : $modal,
		ngTableParams : ngTableParams,
		toaster : toaster,
		SweetAlert : SweetAlert,
	});

	// 导出按钮操作
	$scope.export = function() {
		var requestUrl = REST_PREFIX + "jdSick/export" + $scope.queryString;
		$window.open(requestUrl);
	};

});

app.controller('searchJdSickCtrl', function($scope, $modalInstance, toaster, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function() {
			jdSick.initScopeData($scope);
			$scope.searchInfos.jdSickCategaryId = [ searchInfos.jdSickCategaryId ];
		}
	});
	$scope.sickCategorysSelect = function(obj) {
		if (obj.$select.selected.length > 1) {
			toaster.pop("error", "提示", "只能选择一项疾病大类");
			obj.$select.selected = obj.$select.selected.slice(0, 1);
		}
	}
});

app.controller('editJdSickCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false;
	$scope.obj = {};

	if (obj) {
		$scope.obj = obj;
		$scope.obj.jdSickCategaryId = [ obj.jdSickCategaryId ];
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster,
		initScopeData : jdSick.initScopeData
	});

	$scope.sickCategorysSelect = function(obj) {
		if (obj.$select.selected.length > 1) {
			toaster.pop("error", "提示", "只能选择一项疾病大类");
			obj.$select.selected = obj.$select.selected.slice(0, 1);
		}
	}

	$scope.ok = function(e) {
		// 提交
		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.put(REST_PREFIX + "jdSick", {
				jdSickCategaryId : $scope.obj.jdSickCategaryId[0],
				uuid : $scope.obj.uuid
			}).success(function(result) {
				resultProcess($scope , result, $modalInstance, toaster);
			});
		}
	};
});
