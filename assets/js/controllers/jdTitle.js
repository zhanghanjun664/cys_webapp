'use strict';
app.controller('JdTitleCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $localStorage, Admin_Constant) {
	$scope.resultData = []; //后台返回总的结果集
	$scope.data = []; //当前页面的结果集
	$scope.selections = []; //当前页面选中的行

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
	
	//获取JdTitle列表数据
    $scope.getData = function() {
		$http.get(REST_PREFIX+"jdTitle/list").success(function (result) {
			$scope.resultData = result.titleList;
			$scope.tableParams.reload();
			$localStorage[Admin_Constant.LocalStorage.Titles] = result.titleList;
		});
    };
    $scope.getData();
    
    //新增
    $scope.edit = function (jdTitle) {
    	var modalInstance = $modal.open({
            templateUrl: 'editJdTitle.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdTitleCtrl',
    		resolve: {
    			jdTitle : function() {
    				return jdTitle;
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
				$http.delete(REST_PREFIX+"jdTitle/"+id).success(function (result) {
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
app.controller('editJdTitleCtrl', function ($scope, $http, $modalInstance, toaster, jdTitle) {
    	$scope.submitFlag = false; //为防止表单重复提交
    	$scope.jdTitleInfo = {};
    	if(jdTitle) {
    		$scope.jdTitleInfo.uuid = jdTitle.uuid;
    		$scope.jdTitleInfo.name = jdTitle.name;
			$scope.jdTitleInfo.couponLimit = jdTitle.couponLimit;
			$scope.jdTitleInfo.couponCountLimit = jdTitle.couponCountLimit;
    	}
        $scope.ok = function (e) {
        	if(!validateFiledNullMax(toaster, $scope.jdTitleInfo.name, "职称名称", true, 64)
				|| !validateFiledInteger(toaster, $scope.jdTitleInfo.couponLimit, "优惠券限额", false, true)
				 || !validateFiledInteger(toaster, $scope.jdTitleInfo.couponCountLimit, "邀请券数量限额", false, true))
        		return;
        	//提交
			if(!$scope.submitFlag) {
				$scope.submitFlag = true;
				if(jdTitle) {
					$http.put(REST_PREFIX+"jdTitle", $scope.jdTitleInfo).success(function(result) {
						if (!result) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "职称【"+$scope.jdTitleInfo.name+"】已经存在");
						} else {
							$modalInstance.close("success");
						}
					});
				} else {
					$http.post(REST_PREFIX+"jdTitle", $scope.jdTitleInfo).success(function(result) {
						if (!result) {
							$scope.submitFlag = false;
							toaster.pop("error", "提示", "职称【"+$scope.jdTitleInfo.name+"】已经存在");
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