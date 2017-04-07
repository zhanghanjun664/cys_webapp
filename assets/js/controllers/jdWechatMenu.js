'use strict';
app.controller('JdWechatMenuCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
	$scope.resultData = []; //后台返回总的结果集
	$scope.data = []; //当前页面的结果集
	$scope.selections = []; //当前页面选中的行

	$scope.showMenuLevel = function(level) {
		if(level == 1) return "一级";
		if(level == 2) return "二级";
		if(level == 3) return "无";
	};

	$scope.showMenuType = function(type) {
		if(type == "button") return "按钮";
		if(type == "article") return "图文";
		if(type == "web") return "网页";
		if(type == "group") return "父菜单";
	};

	$scope.showParentMenu = function(uuid) {
		if(uuid == undefined || uuid == "")
			return;
		var name = "";
		$scope.parentMenus.forEach(function(menu){
			if(menu.uuid == uuid) {
				name = menu.name;
				return;
			}
		});
		return name;
	};

	$scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultData.length,
        getData: function ($defer, params) {
        	params.total($scope.resultData.length);
        	commonResetSelection($scope);
        	$scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
        	if($scope.data.length == 0 && params.page() > 1) { //删除操作后如果当前页没有数据，自动跳转到前一页
        		params.page(params.page() - 1);
        		$scope.tableParams.reload();
        	}
            $defer.resolve($scope.data);
        }
    });
	
	//获取JdWechatMenu列表数据
    $scope.getData = function() {
		$http.get(REST_PREFIX+"jdWechatMenu/list").success(function (result) {
			$scope.resultData = result.jdWechatMenuList;
			$scope.parentMenus = [];
			result.jdWechatMenuList.forEach(function(menu) {
				if(menu.level==1) {
					$scope.parentMenus.push(menu);
				}
			});
			$scope.tableParams.reload();
		});
	};
    $scope.getData();
    
    //新增
    $scope.edit = function (jdWechatMenu) {
    	var modalInstance = $modal.open({
            templateUrl: 'editJdWechatMenu.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdWechatMenuCtrl',
    		resolve: {
				parentMenus: function () {
					return $scope.parentMenus;
				},
    			jdWechatMenu : function() {
    				return jdWechatMenu;
    			}
            }
        });
    	modalInstance.result.then(function (result) {
    		$scope.getData();
        });
    };
    
    //删除操作
    $scope.deleteItem = function(id) {
        SweetAlert.swal({
            title: "确定删除吗?",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
          		$http.delete(REST_PREFIX+"jdWechatMenu/"+id).success(function (result) {
					$scope.getData();
				});
            }
        });
    };
    
    //改变当前选中的行
    $scope.changeSelection = function(index) {
    	commonChangeSelection($scope, index);
	};
	
	//全选/全不选
	$scope.selectAll = function() {
		commonSelectAll($scope);
	};
	
    //点击删除按钮
    $scope.deleteAll = function() {
    	commonDeleteButtonClick(toaster, $scope);
	};
	
    //点击编辑按钮
    $scope.update = function () {
    	commonEditButtonClick(toaster, $scope);
    };

	$scope.generateMenu = function() {
		$http.post(REST_PREFIX+"jdWechatMenu/generate").success(function (result) {
			if(result.result != 0) {
				toaster.pop("error", "提示", result.description);
			} else {
				toaster.pop("success", "提示", "生成公众号菜单成功");
			}
		});
	};
});
app.controller('editJdWechatMenuCtrl', function ($scope, $http, $modalInstance, toaster, parentMenus, jdWechatMenu) {
    	$scope.submitFlag = false; //为防止表单重复提交
		$scope.parentMenus = parentMenus;
    	$scope.jdWechatMenuInfo = {};
    	if(jdWechatMenu) {
    		$scope.jdWechatMenuInfo.uuid = jdWechatMenu.uuid;
    		$scope.jdWechatMenuInfo.name = jdWechatMenu.name;
			$scope.jdWechatMenuInfo.level = jdWechatMenu.level;
			$scope.jdWechatMenuInfo.seq = jdWechatMenu.seq;
			$scope.jdWechatMenuInfo.type = jdWechatMenu.type;
			$scope.jdWechatMenuInfo.parentId = jdWechatMenu.parentId;
			$scope.jdWechatMenuInfo.value = jdWechatMenu.value;
			$scope.jdWechatMenuInfo.description = jdWechatMenu.description;
			$scope.jdWechatMenuInfo.title = jdWechatMenu.title;
			$scope.jdWechatMenuInfo.picUrl = jdWechatMenu.picUrl;
			$scope.jdWechatMenuInfo.webUrl = jdWechatMenu.webUrl;
    	} else {
			$scope.jdWechatMenuInfo.level = 1;
			$scope.jdWechatMenuInfo.type = "button";
		}
        $scope.ok = function (e) {
        	if(!validateFiledNullMax(toaster, $scope.jdWechatMenuInfo.name, "菜单名称", true, 64)
        		|| !validateFiledInteger(toaster, $scope.jdWechatMenuInfo.seq, "序号"))
        		return;
			if($scope.jdWechatMenuInfo.level == 2) {
				if(!validateFiledNullMax(toaster, $scope.jdWechatMenuInfo.parentId, "父菜单", true, 0))
					return;
			}
			if($scope.jdWechatMenuInfo.type != "group") {
				if(!validateFiledNullMax(toaster, $scope.jdWechatMenuInfo.value, "编码或url", true, 1250))
					return;
			}
			if($scope.jdWechatMenuInfo.type == "button") {
				if(!validateFiledNullMax(toaster, $scope.jdWechatMenuInfo.description, "内容", true, 250))
					return;
			}
			if($scope.jdWechatMenuInfo.type == "article") {
				if(!validateFiledNullMax(toaster, $scope.jdWechatMenuInfo.title, "标题", true, 32)
				    || !validateFiledNullMax(toaster, $scope.jdWechatMenuInfo.description, "内容", true, 250)
					 || !validateFiledNullMax(toaster, $scope.jdWechatMenuInfo.webUrl, "网页链接", true, 500))
					return;
			}
        	//提交
        	if(!$scope.submitFlag) {
        		$scope.submitFlag = true;
        		if(jdWechatMenu) {
					$http.put(REST_PREFIX+"jdWechatMenu", $scope.jdWechatMenuInfo).success(function(result) {
						if (result.result == 1) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "菜单名称【"+$scope.jdWechatMenuInfo.name+"】已经存在");
						} else if (result.result == 2) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "编码或url【"+$scope.jdWechatMenuInfo.value+"】已经存在");
						} else {
							$modalInstance.close("success");
						}
					});
				} else {
					$http.post(REST_PREFIX+"jdWechatMenu", $scope.jdWechatMenuInfo).success(function(result) {
						if (result.result == 1) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "菜单名称【"+$scope.jdWechatMenuInfo.name+"】已经存在");
						} else if (result.result == 2) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "编码或url【"+$scope.jdWechatMenuInfo.value+"】已经存在");
						} else {
							$modalInstance.close("success");
						}
					});
				}
        	}
        };
        $scope.cancel = function (e) {
            $modalInstance.dismiss();
        };
});