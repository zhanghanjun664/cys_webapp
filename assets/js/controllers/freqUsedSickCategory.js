'use strict';

var freqUsedSickCategory = {
	// 初始化页面数据与方法
	sickCategoryList : null,
	initScopeData : function($scope) {
		freqUsedSickCategory.sickCategoryList = ($scope.sickCategoryList = freqUsedSickCategory.sickCategoryList ? freqUsedSickCategory.sickCategoryList
				: freqUsedSickCategory.initSickCategoryList());
	},
	initSickCategoryList : function() {
		var list = [];
		ajax(REST_PREFIX + "freqUsedSickCategory/notFreqUsedSickCategories", function(result) {
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

app.controller('freqUsedSickCategoryCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
	initScope({
		initScopeData : freqUsedSickCategory.initScopeData,
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
					filterField(newObj, "selected,auditable");
					return newObj;
				}
			}
		},
		editTemplateUrl : 'editFreqUsedSickCategory.html',
		editController : 'editFreqUsedSickCategoryCtrl',
		tableQueryUrl : "freqUsedSickCategory/list",
		deleteUrl : "freqUsedSickCategory/",
		$scope : $scope,
		$http : $http,
		$modal : $modal,
		ngTableParams : ngTableParams,
		toaster : toaster,
		SweetAlert : SweetAlert
	});

	$scope.deleteAll = function() {
		if ($scope.selections.length > 0) {
			var result = null;
			$scope.selections.forEach(function(entity) {
				if (entity) {
					if (!result) {
						result = entity.jdSickCategaryId;
					} else {
						result = result + "," + (entity.jdSickCategaryId);
					}
				}
			});
			$scope.deleteItem(result);
		} else {
			showSelectOneTip(toaster, "error");
		}
	}

});
app.controller('editFreqUsedSickCategoryCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	if (obj) {
		$scope.obj = obj;
		$scope.obj.jdSickCategaryId = [ obj.jdSickCategaryId ];
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster,
		initScopeData : freqUsedSickCategory.initScopeData
	});

	// 初始化各方法
	$scope.sickCategorysSelect = function() {
		if ($scope.obj.jdSickCategaryId.length > 1) {
			toaster.pop("error", "提示", "只能选择一项疾病大类");
			$scope.obj.jdSickCategaryId = $scope.obj.jdSickCategaryId.slice(0, 1);
		}
	}

	$scope.ok = function(e) {
		if (!validateFiledNullMax(toaster, $scope.obj.jdSickCategaryId, "常见疾病", true, 0)
				|| !validateFiledInteger(toaster, $scope.obj.seq, "排序序号"))
			return;

		// 提交
		if (!$scope.submitFlag) {
			$scope.submitFlag = true;

			$scope.obj = retainField($scope.obj, "jdSickCategaryId,seq");
			$scope.obj.jdSickCategaryId = $scope.obj.jdSickCategaryId[0];

			if (obj) {
				$http.put(REST_PREFIX + "freqUsedSickCategory", $scope.obj).success(function(result) {
					resultProcess($scope , result, $modalInstance, toaster);
				});
			} else {
				$http.post(REST_PREFIX + "freqUsedSickCategory", $scope.obj).success(function(result) {
					resultProcess($scope , result, $modalInstance, toaster);
				});
			}
		}
	};
});
