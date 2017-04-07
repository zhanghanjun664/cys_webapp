'use strict';
app.controller('AideeUserCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
	$scope.resultData = []; //后台返回总的结果集
	$scope.data = []; //当前页面的结果集
	$scope.selections = []; //当前页面选中的行
	$scope.roles = []; //角色信息

	//获取角色列表信息
	$scope.getRoleInfos = function () {
		$http.get(REST_PREFIX+"role/list").success(function (result) {
			$scope.roles = result.roleList;
		});
	};
	$scope.getRoleInfos();

	//根据角色ID显示角色的名称
	$scope.displayRoleName = function (roleId) {
		for(var i = 0; i < $scope.roles.length; i++) {
			if($scope.roles[i].uuid == roleId)
				return $scope.roles[i].name;
		}
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
	
	//获取User列表数据
    $scope.getData = function() {
		$http.get(REST_PREFIX+"user/list").success(function (result) {
			$scope.resultData = result.userList;
			$scope.tableParams.reload();
		});
    };
    $scope.getData();
    
    //新增
    $scope.edit = function (user) {
    	var modalInstance = $modal.open({
            templateUrl: 'editUser.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editUserCtrl',
    		resolve: {
    			user : function() {
    				return user;
    			},
				roles : function() {
					return $scope.roles;
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
				$http.delete(REST_PREFIX+"user/"+id).success(function (result) {
					$scope.getData();
				});
            }
        });
    };

	$scope.resetPassword = function(id) {
		SweetAlert.swal({
			title: "确定重置密码吗?",
			text: "重置后用户密码将恢复为123456",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "确定",
			cancelButtonText: "取消"
		}, function (isConfirm) {
			if (isConfirm) {
				$http.put(REST_PREFIX+"user/"+id+"/password").success(function (result) {
					SweetAlert.swal("密码重置成功!", "用户密码已恢复为123456", "success");
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
app.controller('editUserCtrl', function ($scope, $http, $modalInstance, toaster, user, roles) {
    	$scope.submitFlag = false; //为防止表单重复提交
		$scope.roles = roles;
    	$scope.userInfo = {};
    	if(user) {
    		$scope.userInfo.uuid = user.uuid;
    		$scope.userInfo.username = user.username;
			$scope.userInfo.roleId = user.roleId;
			$scope.userInfo.enabled = user.enabled+"";
			$scope.userInfo.expireDateStr = user.expireDate;
			$scope.userInfo.description = user.description;
    	} else {
			$scope.userInfo.enabled = "true";
			$scope.userInfo.expireDateStr = "2099-01-01 00:00:00";
		}
        $scope.ok = function (e) {
			$scope.userInfo.expireDateStr = $("#expireDateStr").val();
        	if(!validateFiledNullMax(toaster, $scope.userInfo.username, "用户名", true, 64)
				 || !validateFiledNullMax(toaster, $scope.userInfo.roleId, "所属角色", true, 0)
				   || !validateFiledNullMax(toaster, $scope.userInfo.expireDateStr, "过期时间", true, 19)
        			|| !validateFiledMax(toaster, $scope.userInfo.description, "描述", 250))
        		return;
        	//提交
        	if(!$scope.submitFlag) {
        		$scope.submitFlag = true;
				if(user) {
					$http.put(REST_PREFIX+"user", $scope.userInfo).success(function(result) {
						if (!result) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "用户名【"+$scope.userInfo.username+"】已经存在");
						} else {
							$modalInstance.close("success");
						}
					});
				} else {
					$http.post(REST_PREFIX+"user", $scope.userInfo).success(function(result) {
						if (!result) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "用户名【"+$scope.userInfo.username+"】已经存在");
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