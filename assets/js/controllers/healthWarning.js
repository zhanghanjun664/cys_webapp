'use strict';

var healthWarning = {
	// 初始化页面数据与方法
	followupStatusList : null,
	warningTypeList : null,
	initScopeData : function($scope) {
		healthWarning.followupStatusList = ($scope.followupStatusList = healthWarning.followupStatusList ? healthWarning.followupStatusList
				: healthWarning.initFollowupStatusList());
		healthWarning.warningTypeList = ($scope.warningTypeList = healthWarning.warningTypeList ? healthWarning.warningTypeList
				: healthWarning.initWarningTypeList());
	},
	initFollowupStatusList : function() {
		var list = [];
		list.push({
			name : '待跟进',
			value : 1
		});
		list.push({
			name : '已跟进',
			value : 2
		});
		return list;
	},
	initWarningTypeList : function() {
		var list = [];
		list.push({
			name : '数据异常',
			value : 'DATA'
		});
		list.push({
			name : '操作异常',
			value : 'OPERATION'
		});
		return list;
	},
	getConfig : function(familyPatientId) {
		var obj;
		ajax(REST_PREFIX + "healthWarning/config/" + familyPatientId, function(result) {
			if (result.body && result.body.code == 2000) {
				obj = result.body.result;
			}
		});
		return obj;
	}
}

app.controller('bloodPressureCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant, $sce) {
	initScope({
		initScopeData : healthWarning.initScopeData,
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
		searchTemplateUrl : 'searchBloodPressure.html',
		searchController : 'searchBloodPressureCtrl',
		editTemplateUrl : 'viewBloodPressure.html',
		editController : 'viewBloodPressureCtrl',
		editModalConfig : {
			windowClass : "viewBloodPressure",
			size : "lg"
		},
		tableQueryUrl : "healthWarning/bloodPressure/all/page",
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

	$scope.levelViewColor = function(value) {
		if (value == '正常血压'||value == '正常稍高') {
			return $sce.trustAsHtml("<label >" + value + "</label>");
		} else {
			return $sce.trustAsHtml("<label style='color:red'>" + value + "</label>");
		}
	}
	$scope.followupStatusViewColor = function(value) {
		if (value == '待跟进') {
			return $sce.trustAsHtml("<label style='color:red'>" + value + "</label>");
		} else if (value == '已跟进') {
			return $sce.trustAsHtml("<label style='color:green'>" + value + "</label>");
		} else {
			return $sce.trustAsHtml("<label style='color:green'>" + "-" + "</label>");
		}
	}
});

app.controller('searchBloodPressureCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			healthWarning.initScopeData($scope);
		}
	});
});

app.controller('bloodGlucoseCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant) {
	initScope({
		initScopeData : healthWarning.initScopeData,
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
		searchTemplateUrl : 'searchBloodGlucose.html',
		searchController : 'searchBloodGlucoseCtrl',
		editTemplateUrl : 'viewBloodGlucose.html',
		editController : 'viewBloodGlucoseCtrl',
		editModalConfig : {
			windowClass : "viewBloodGlucose",
			size : "lg"
		},
		tableQueryUrl : "healthWarning/bloodGlucose/all/page",
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

app.controller('searchBloodGlucoseCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			healthWarning.initScopeData($scope);
		}
	});
});

app.controller('viewBloodPressureCtrl', function($scope, $http, $modalInstance, toaster, $modal, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	if (obj) {
		$scope.obj = obj;
		booleanToString($scope.obj);
	} else {
		// 默认值设置
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});

	$scope.obj.warningConfig = healthWarning.getConfig($scope.obj.familyPatientId);
	$scope.obj.warningConfig.patientId = $scope.obj.familyPatientId;
	$scope.obj.warningConfig.openId = $scope.obj.openId;
	$scope.goPatientMessageSendPage = function() {
		// 跳到给用户发消息页面
		var url = window.location.origin + window.location.pathname + "#" + "/app/message/pushPatientTextMessage";
		window.open(url);
	}

	$scope.warningConfigEdit = function(warningConfigObj) {
		var defaultEditModalConfig = {
			templateUrl : "editWaringConfig.html",
			backdrop : 'static',
			size : "sm",
			keyboard : false,
			controller : "editWaringConfigCtrl",
			windowClass : "editWaringConfig",
			resolve : {
				obj : function() {
					// 必须用深拷贝复制1个新对象出来,否则Edit的修改会影响到父的对象
					var newObj = angular.copy(warningConfigObj);
					filterField(newObj, "auditable,selected");
					return newObj;
				}
			}
		};

		var modalInstance = $modal.open(defaultEditModalConfig);
		modalInstance.result.then(function(result) {
			$scope.obj.warningConfig = result;
		});
	}
});

app.controller('editWaringConfigCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};
	// debugger;
	if (obj) {
		$scope.obj = obj;
		booleanToString($scope.obj);
	} else {
		// 默认值设置
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});

	$scope.ok = function(e) {
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.systolicPressureMax, $scope.obj.systolicPressureMin,
				$scope.obj.diastolicPressureMax, $scope.obj.diastolicPressureMin, $scope.obj.abnormalCount,
				$scope.obj.measureInterval, $scope.obj.warningSwitch ], [ "高压警示最大值", "高压警示最小值", "低压警示最大值", "低压警示最小值",
				"异常次数", "测量间隙", "告警开关" ]))
			return;

		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX + "healthWarning/updateConfig", $scope.obj).success(function(result) {
				resultProcess($scope, result, $modalInstance, toaster, function(paramObj) {
					var $modalInstance = paramObj.$modalInstance;
					var obj = paramObj.$scope.obj;
					var result = paramObj.result;
					// 将id赋给obj,解决首次保存返回obj无id的情况
					obj.id = result.body.result.id;
					$modalInstance.close(obj);
				});
			});
		}
	};
});

app.controller('bloodPressureHistoryCtrl', function($scope, $http, ngTableParams, toaster, SweetAlert, $sce) {
	initScope({
		tableQueryUrl : "healthWarning/bloodPressure/" + $scope.$parent.obj.familyPatientId + "/page",
		$scope : $scope,
		$http : $http,
		ngTableParams : ngTableParams,
		toaster : toaster,
		SweetAlert : SweetAlert
	});

	$scope.abnormalViewColor = function(value) {
		if (value) {
			return $sce.trustAsHtml("<label style='color:red'>异常</label>");
		} else {
			return $sce.trustAsHtml("<label >正常</label>");
		}
	}

	$scope.getSourceName = function(value) {
		if (value) {
			if (value == 'MANUAL')
				return '手工录入';
			else
				return '血压计录入';
		} else {
			return '手工录入';
		}
	}
});

app.controller('warningRecordHistoryCtrl', function($scope, $http, ngTableParams, toaster, SweetAlert, $modal, $sce) {
	initScope({
		initScopeData : healthWarning.initScopeData,
		tableQueryUrl : "healthWarning/record/" + $scope.$parent.obj.familyPatientId + "/page",
		$scope : $scope,
		$http : $http,
		ngTableParams : ngTableParams,
		toaster : toaster,
		SweetAlert : SweetAlert
	});

	$scope.followupStatusViewColor = function(value) {
		if (value == '待跟进') {
			return $sce.trustAsHtml("<label style='color:red'>" + value + "</label>");
		} else if (value == '已跟进') {
			return $sce.trustAsHtml("<label style='color:green'>" + value + "</label>");
		}
	};

	$scope.processWarningRecord = function(obj) {
		var defaultEditModalConfig = {
			templateUrl : "processWarningRecord.html",
			backdrop : 'static',
			size : "sm",
			keyboard : false,
			controller : "processWarningRecordCtrl",
			windowClass : "processWarningRecord",
			resolve : {
				obj : function() {
					// 必须用深拷贝复制1个新对象出来,否则Edit的修改会影响到父的对象
					var newObj = angular.copy(obj);
					filterField(newObj, "auditable,selected");
					return newObj;
				}
			}
		};

		var modalInstance = $modal.open(defaultEditModalConfig);
		modalInstance.result.then(function() {
			$scope.tableParams.reload();
		});
	}
});

app.controller('processWarningRecordCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};
	// debugger;
	if (obj) {
		$scope.obj = obj;
		booleanToString($scope.obj);
	} else {
		// 默认值设置
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});

	$scope.ok = function(e) {
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.followUpConclusion ], [ "跟进结果" ]))
			return;

		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX + "healthWarning/record/process/" + $scope.obj.id, $scope.obj.followUpConclusion)
					.success(function(result) {
						resultProcess($scope, result, $modalInstance, toaster);
					});
		}
	};
});

app.controller('viewBloodGlucoseCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	if (obj) {
		$scope.obj = obj;
		booleanToString($scope.obj);
	} else {
		// 默认值设置
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});
});

app.controller('bloodGlucoseHistoryCtrl', function($scope, $http, ngTableParams, toaster, SweetAlert) {
	initScope({
		tableQueryUrl : "healthWarning/bloodGlucose/" + $scope.$parent.obj.jdPatientId + "/page",
		$scope : $scope,
		$http : $http,
		ngTableParams : ngTableParams,
		toaster : toaster,
		SweetAlert : SweetAlert
	});
});