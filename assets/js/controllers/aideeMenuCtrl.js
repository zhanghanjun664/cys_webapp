'use strict';
app.controller('AideeMenuCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
	$scope.resultData = []; //后台返回总的结果集
	$scope.data = []; //当前页面的结果集
	$scope.selections = []; //当前页面选中的行
	$scope.parentMenus = []; //所有父菜单

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
	
	//获取菜单列表数据
    $scope.getData = function() {
		$http.get(REST_PREFIX+"menu/list").success(function (result) {
			$scope.resultData = result.menuList;
			$scope.parentMenus = [];
			result.menuList.forEach(function(menu) {
				if(menu.parentMenu) {
					$scope.parentMenus.push(menu);
				}
			});
			$scope.tableParams.reload();
		});
    };
    $scope.getData();
    
    //新增
    $scope.edit = function (menu) {
    	var modalInstance = $modal.open({
            templateUrl: 'editMenu.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editMenuCtrl',
    		resolve: {
    			parentMenus: function () {
    				return $scope.parentMenus;
    			},
    			menu : function() {
    				return menu;
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
				$http.delete(REST_PREFIX+"menu/"+id).success(function (result) {
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
    
});
app.controller('editMenuCtrl', function ($scope, $http, $modalInstance, toaster, parentMenus, menu) {
    	$scope.submitFlag = false; //为防止表单重复提交
    	$scope.menuInfo = {};
    	$scope.parentMenus = parentMenus;
    	if(menu) {
    		$scope.menuInfo.uuid = menu.uuid;
    		$scope.menuInfo.parentId = menu.parentId;
    		$scope.menuInfo.name = menu.name;
    		$scope.menuInfo.translate = menu.translate;
    		$scope.menuInfo.seq = menu.seq;
    		$scope.menuInfo.parentMenu = menu.parentMenu+"";
    		$scope.menuInfo.parentPrefix = menu.parentPrefix;
    		$scope.menuInfo.iconClass = menu.iconClass;
    		$scope.menuInfo.uiSref = menu.uiSref;
			$scope.menuInfo.url = menu.url;
    	} else {
        	$scope.menuInfo.parentMenu = "true";
        	$scope.menuInfo.parentId = "";
    	}
        $scope.ok = function (e) {
        	if(!validateFiledNullMax(toaster, $scope.menuInfo.name, "菜单名称", true, 64)
        		  || !validateFiledNullMax(toaster, $scope.menuInfo.translate, "i18n字符串", true, 128)
        			|| !validateFiledInteger(toaster, $scope.menuInfo.seq, "显示序号"))
        		return;
        	if($scope.menuInfo.parentMenu == "true") { //父菜单
        		if(!validateFiledNullMax(toaster, $scope.menuInfo.parentPrefix, "父菜单前缀", true, 64)
        				|| !validateFiledNullMax(toaster, $scope.menuInfo.iconClass, "图标样式", true, 64)) {
        			return;
        		}
        	} else {
        		if(!validateFiledNullMax(toaster, $scope.menuInfo.parentId, "父菜单", true, 0)
        				|| !validateFiledNullMax(toaster, $scope.menuInfo.uiSref, "链接字符串", true, 128)
							|| !validateFiledNullMax(toaster, $scope.menuInfo.url, "对应的URL", true, 256)) {
                	return;
                }
        	}
        	//提交
			if(!$scope.submitFlag) {
				$scope.submitFlag = true;
				if(menu) {
					$http.put(REST_PREFIX+"menu", $scope.menuInfo).success(function(result) {
						if (!result) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "菜单【"+$scope.menuInfo.name+"】已经存在");
						} else {
							$modalInstance.close("success");
						}
					});
				} else {
					$http.post(REST_PREFIX+"menu", $scope.menuInfo).success(function(result) {
						if (!result) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "菜单【"+$scope.menuInfo.name+"】已经存在");
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