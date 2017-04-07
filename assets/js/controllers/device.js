'use strict';

var device = {
	// 初始化页面数据与方法
	isConfigWifiList : null,
	isBindWechatList : null,
	isConfigSNList : null,
	brandList : null,
	typeList : null,
	initBrandList : function() {
		var list = [];
		ajax(REST_PREFIX + "device/findBrandList", function(result) {
			if (result.body && result.body.code == 2000) {
				var data = result.body.result;
				for (var i = 0; i < data.length; i++) {
					list.push({
						name : data[i].name,
						value : data[i].key
					});
				}
			}
		});
		console.info(list);
		return list;
	},
	initTypeList : function() {
		var list = [];
		ajax(REST_PREFIX + "device/findTypeList", function(result) {
			if (result.body && result.body.code == 2000) {
				var data = result.body.result;
				for (var i = 0; i < data.length; i++) {
					list.push({
						name : data[i].name,
						value : data[i].key
					});
				}
			}
		});
		return list;
	},
	initScopeData : function($scope) {
		device.isConfigSNList = ($scope.isConfigSNList = device.isConfigSNList ? device.isConfigSNList : initBoolList());
		device.isConfigWifiList = ($scope.isConfigWifiList = device.isConfigWifiList ? device.isConfigWifiList
				: initBoolList());
		device.isBindWechatList = ($scope.isBindWechatList = device.isBindWechatList ? device.isBindWechatList
				: initBoolList());
		device.brandList = ($scope.brandList = device.brandList ? device.brandList : device.initBrandList());
		device.typeList = ($scope.typeList = device.typeList ? device.typeList : device.initTypeList());
	}
}

app.controller('deviceCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant) {
	initScope({
		initScopeData : device.initScopeData,
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
		searchTemplateUrl : 'searchDevice.html',
		searchController : 'searchDeviceCtrl',
		editTemplateUrl : 'editDevice.html',
		editController : 'editDeviceCtrl',
		tableQueryUrl : "device/list",
		deleteUrl : "device/",
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

	$scope.generateDeviceQrcode = function() {
		var modalInstance = $modal.open({
			templateUrl : 'generateDeviceQrcode.html',
			backdrop : 'static',
			keyboard : false,
			controller : 'generateDeviceQrcodeCtrl'
		});

		modalInstance.result.then(function(result) {
			$scope.tableParams.reload();
		});
	};

	$scope.downloadQrcode = function() {
		if ($scope.selections.length > 0) {
			var ids = getIdStringFromSelections($scope.selections);
			SweetAlert.swal({
				title : "确定下载吗?",
				text : "建议不超过100个,否则生成时间过长",
				showCancelButton : true,
				confirmButtonColor : "#DD6B55",
				confirmButtonText : "下载",
				cancelButtonText : "取消"
			}, function(isConfirm) {
				if (isConfirm) {
					$window.open(REST_PREFIX + 'device/downloadQrcode/' + ids);
					$scope.tableParams.reload();
				}
			});
		} else {
			showSelectOneTip(toaster, "error");
		}
	}
});

app.controller('searchDeviceCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			device.initScopeData($scope);
		}
	});
});

app.controller('editDeviceCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	if (obj) {
		$scope.obj = obj;

		$scope.obj = retainField($scope.obj, "id,serialNumInDevice,partnerQrcodeTicket,cysQrcodeShowUrl,cysDeviceId");
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
		if (!$scope.obj.cysDeviceId) {
			toaster.pop("error", "提示", "非本平台二维码生成设备,无法编辑");
			return;
		}
		
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.serialNumInDevice, $scope.obj.partnerQrcodeTicket ], [ "第三方SN",
				"第三方二维码内含url" ], true, 0))
			return;

		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.put(REST_PREFIX + "device", $scope.obj).success(function(result) {
				resultProcess($scope, result, $modalInstance, toaster);
			});
		}
	};

});

app.controller('generateDeviceQrcodeCtrl', function($scope, $http, $modalInstance, toaster) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	initEdit({
		initScopeData : device.initScopeData,
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});

	$scope.ok = function(e) {
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.brand, $scope.obj.type, $scope.obj.number ], [ "设备品牌", "设备类型",
				"生成个数" ], true, 0))
			return;
		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX + "device/generateDeviceQrcode", $scope.obj).success(function(result) {
				var data;
				if (result.body) {
					data = result.body;
				} else {
					data = result;
				}

				if (data && data.code == 2000) {
					toaster.pop("success", "提示", "系统正在生成二维码中,请5分钟后刷新页面,检查二维码数量是否正确");
					if ($modalInstance)
						$modalInstance.close("success");
				} else {
					$scope.submitFlag = false;
					toaster.pop("error", "提示", "操作失败");
				}
			});
		}
	};

});
