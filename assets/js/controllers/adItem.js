'use strict';

var adItem = {
	// 初始化页面数据与方法
	statusList : null,
	initScopeData : function($scope) {
		adItem.statusList = ($scope.statusList = adItem.statusList ? adItem.statusList : adItem.initStatusList());
	},
	initStatusList : function() {
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
	initAdTag : function(itemId) {
		var obj;
		var itemId = itemId ? "/" + itemId : "";
		ajax(REST_PREFIX + "adItem/adTags" + itemId, function(result) {
			if (result.body && result.body.code == 2000) {
				obj = result.body.result;
			}
		});
		return obj;
	},
	// 绑定出诊疾病的panel展开收缩事件
	panelClick : function(event) {
		var $this = $(event.currentTarget);
		var panelBody = $this.next(".panel-body");
		if (panelBody.hasClass("collapse")) {
			panelBody.fadeOut();
			panelBody.removeClass("collapse");
			$("i", $this).removeClass("fa-angle-down").addClass("fa-angle-up");
		} else {
			panelBody.fadeIn();
			panelBody.addClass("collapse");
			$("i", $this).removeClass("fa-angle-up").addClass("fa-angle-down");
		}
	}
}

app.controller('adItemCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant) {
	initScope({
		initScopeData : adItem.initScopeData,
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
		getCustomQueryString : function() {
			if ($scope.searchInfos.selectedTagList) {
				$scope.searchInfos.tags = [];
				$scope.searchInfos.selectedTagList.forEach(function(item) {
					$scope.searchInfos.tags.push(item.id);
				});
			}
			return "?" + $.param($scope.searchInfos, true);
		},
		searchTemplateUrl : 'searchAdItem.html',
		searchController : 'searchAdItemCtrl',
		editTemplateUrl : 'editAdItem.html',
		editController : 'editAdItemCtrl',
		editModalConfig : {
			size : "lg"
		},
		searchModalConfig : {
			size : "lg"
		},
		tableQueryUrl : "adItem/list",
		deleteUrl : "adItem/",
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

app.controller('searchAdItemCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			adItem.initScopeData($scope);
			$scope.adTags = adItem.initAdTag(null);
			if (!$scope.searchInfos.selectedTagList) {
				$scope.searchInfos.selectedTagList = [];
			}
		}
	});

	// 页面渲染完才进行的操作
	setTimeout(function() {
		// 移除ng-tags-input的输入框(官方无api禁止出现,此为变通方法)
		$(".tag-list").next("input")[0].remove();
		if ($scope.searchInfos.selectedTagList) {
			// 设置已选项勾选
			$scope.searchInfos.selectedTagList.forEach(function(item) {
				$(":checkbox[value='" + item.id + "']").prop("checked", true);
			});
		}
	}, 0);

	$scope.checkTag = checkTag;
	$scope.removeTag = removeTag;
});

app.controller('editAdItemCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.upload = {};
	$scope.obj = {};
	$scope.adTags = adItem.initAdTag(obj ? obj.id : null);
	$scope.uploadUrl = REST_PREFIX + "generalinfo/upload";
	$scope.noImage = true;
	if (obj && obj.mediaCode) {
		$scope.noImage = false;
	}
	$scope.removeImage = function() {
		$scope.noImage = true;
	};

	if (obj) {
		$scope.obj = obj;
		booleanToString($scope.obj);
		$scope.obj.selectedTagList = $scope.adTags.selectedTagList;
		$scope.obj.tags = [];
	} else {
		// 默认值设置
		$scope.obj.status = true + "";
		$scope.obj.weight = 0;
		$scope.obj.positionId = "patient_education_article_bottom";
		$scope.obj.selectedTagList = [];
	}

	initEdit({
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});

	// 页面渲染完才进行的操作
	setTimeout(function() {
		// 移除ng-tags-input的输入框(官方无api禁止出现,此为变通方法)
		$(".tag-list").next("input")[0].remove();
	}, 0);

	$scope.checkTag = checkTag;
	$scope.removeTag = removeTag;

	// 图片上传成功回调函数
	$scope.uploadSuccess = function(file, message) {
		var data = parseJSON(message);
		if (data && data.body.result && data.body.result.resourceUrl) {
			$scope.obj.mediaCode = data.body.result.resourceUrl;
			$http.post(REST_PREFIX + "adItem", $scope.obj).success(function(result) {
				resultProcess($scope, result, $modalInstance, toaster);
			});
		} else {
			toaster.pop("error", "提示", "上传图片失败，请联系管理员!");
			$scope.submitFlag = false;
		}
	};

	$scope.ok = function(e) {
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.name, $scope.obj.link, $scope.obj.positionId, $scope.obj.status ], [
				"广告素材名", "跳转链接", "广告位id", "是否生效" ]))
			return;
		if ($scope.obj.weight < 0) {
			toaster.pop("error", "提示", "【 权重 】不能为小于0", "1000");
			return;
		}
		if (!$scope.upload.flow.files[0] && !$scope.obj.mediaCode) {
			toaster.pop("error", "提示", "【 图片素材 】不能为空", "1000");
			return;
		}

		$scope.obj.tags = [];
		$scope.obj.selectedTagList.forEach(function(item) {
			$scope.obj.tags.push(item.id);
		});

		filterField($scope.obj, "selectedTagList");
		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			if ($scope.upload.flow.files[0]) {
				// 若flow.files有值,说明修改过图片,则要重新上传再提交
				$scope.upload.flow.upload();
			} else {
				// 若没修改图片,则直接提交
				$http.post(REST_PREFIX + "adItem", $scope.obj).success(function(result) {
					resultProcess($scope, result, $modalInstance, toaster);
				});
			}

		}
	};

});
