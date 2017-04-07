'use strict';

var deviceBound = {
	// 初始化页面数据与方法
	brandList : null,
	typeList : null,
	statusList : null,
	relationList : null,
	ownerTypes : null,
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
	initStatusList : function() {
		var list = [];
		list.push({
			name : '已绑定openid,未关联家人',
			value : '1'
		});
		list.push({
			name : '已绑定openid,并关联家人',
			value : '2'
		});
		list.push({
			name : '已取消关联该家人',
			value : '3'
		});
		list.push({
			name : '已解绑openid',
			value : '4'
		});
		return list;
	},
	initRelationList : function() {
		var list = [];
		list.push({
			name : '本人',
			value : '本人'
		});
		list.push({
			name : '我的家人',
			value : '我的家人'
		});
		list.push({
			name : '我的父母',
			value : '我的父母'
		});
		list.push({
			name : '我的朋友',
			value : '我的朋友'
		});
		return list;
	},
	initOwnerTypes : function() {
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
	initScopeData : function($scope) {
		deviceBound.statusList = ($scope.statusList = deviceBound.statusList ? deviceBound.statusList : deviceBound
				.initStatusList());
		deviceBound.relationList = ($scope.relationList = deviceBound.relationList ? deviceBound.relationList
				: deviceBound.initRelationList());
		deviceBound.brandList = ($scope.brandList = deviceBound.brandList ? deviceBound.brandList : deviceBound
				.initBrandList());
		deviceBound.ownerTypes = ($scope.ownerTypes = deviceBound.ownerTypes ? deviceBound.ownerTypes : deviceBound
                .initOwnerTypes());
		deviceBound.typeList = ($scope.typeList = deviceBound.typeList ? deviceBound.typeList : deviceBound
				.initTypeList());
	}
}

app.controller('deviceBoundCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant) {
	initScope({
		initScopeData : deviceBound.initScopeData,
		searchModalResolve : function($scope) {
			return {
				searchInfos : function() {
					return $scope.searchInfos;
				}
			}
		},
		searchTemplateUrl : 'searchDeviceBound.html',
		searchController : 'searchDeviceBoundCtrl',
		tableQueryUrl : "device/findDeviceBoundList",
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

app.controller('searchDeviceBoundCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			deviceBound.initScopeData($scope);
			$("#createTimeEnd").val($scope.searchInfos.createTimeEnd);
			$("#createTimeStart").val($scope.searchInfos.createTimeStart);
		},
		searchOk : function($scope) {
			if($("#createTimeStart").val()){
				$scope.searchInfos.createTimeStart = $("#createTimeStart").val();
			}
			if($("#createTimeEnd").val()){
				$scope.searchInfos.createTimeEnd = $("#createTimeEnd").val();
			}
		}
	});
});
