'use strict';

var examinationSharing = {
	// 初始化页面数据与方法
	statusList : null,
	notifEnabledList : null,
	relationList : null,
	initScopeData : function($scope) {
		examinationSharing.statusList = ($scope.statusList = examinationSharing.statusList ? examinationSharing.statusList : examinationSharing
				.initStatusList());
		examinationSharing.notifEnabledList = ($scope.notifEnabledList = examinationSharing.notifEnabledList ? examinationSharing.notifEnabledList
				: examinationSharing.initNotifEnabledList());
		examinationSharing.relationList = ($scope.relationList = examinationSharing.relationList ? examinationSharing.relationList
				: examinationSharing.initRelationList());
	},
	initStatusList : function() {
		var list = [];
		list.push({
			name : '已邀请但暂无回应',
			value : '0'
		});
		list.push({
			name : '邀请成功',
			value : '1'
		});
		list.push({
			name : '邀请者取消分享',
			value : '2'
		});
		list.push({
			name : '被邀请者取消接收',
			value : '3'
		});
		return list;
	},
	initNotifEnabledList : function() {
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
	}
}

app.controller('examinationSharingCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant) {
	initScope({
		initScopeData : examinationSharing.initScopeData,
		searchModalResolve : function($scope) {
			return {
				searchInfos : function() {
					return $scope.searchInfos;
				}
			}
		},
		searchTemplateUrl : 'searchExaminationSharing.html',
		searchController : 'searchExaminationSharingCtrl',
		tableQueryUrl : "examinationsharing/list",
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

app.controller('searchExaminationSharingCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			examinationSharing.initScopeData($scope);
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
