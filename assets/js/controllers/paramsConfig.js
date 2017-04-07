'use strict';
app.controller('ParamsConfigCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            commonResetSelection($scope);
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "paramsConfig/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result
                $defer.resolve($scope.data);
            });
        }
    });

    //新增
    $scope.edit = function (paramsConfig) {
        var modalInstance = $modal.open({
            templateUrl: 'editParamsConfig.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editParamsConfigCtrl',
            resolve: {
                paramsConfig: function () {
                    return paramsConfig;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };

    //删除操作
    $scope.deleteItem = function (id) {
        SweetAlert.swal({
            title: "确定删除吗?",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
                $http.delete(REST_PREFIX + "paramsConfig/" + id).success(function (result) {
                    $scope.tableParams.reload();
                });
            }
        });
    };

    //改变当前选中的行
    $scope.changeSelection = function (index) {
        commonChangeSelection($scope, index);
    };

    //全选/全不选
    $scope.selectAll = function () {
        commonSelectAll($scope);
    };

    //点击删除按钮
    $scope.deleteAll = function () {
        commonDeleteButtonClick(toaster, $scope);
    };

    //点击编辑按钮
    $scope.update = function () {
        commonEditButtonClick(toaster, $scope);
    };

    //查询
    $scope.searchInfos = {key: null, value: null, name: null}
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchParamsConfig.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchParamsConfigCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    }

});
app.controller('editParamsConfigCtrl', function ($scope, $http, $modalInstance, toaster, paramsConfig) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.paramsConfigInfo = {};
    if (paramsConfig) {
        $scope.paramsConfigInfo.uuid = paramsConfig.uuid;
        $scope.paramsConfigInfo.key = paramsConfig.key;
        $scope.paramsConfigInfo.value = paramsConfig.value;
        $scope.paramsConfigInfo.name = paramsConfig.name;
    }
    $scope.ok = function (e) {
        if (!validateFiledNullMax(toaster, $scope.paramsConfigInfo.key, "参数名称", true, 64)
            || !validateFiledNullMax(toaster, $scope.paramsConfigInfo.value, "参数值", true, 500)
            || !validateFiledNullMax(toaster, $scope.paramsConfigInfo.name, "参数描述", true, 250))
            return;
        //提交
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            if (paramsConfig) {
                $http.put(REST_PREFIX + "paramsConfig", $scope.paramsConfigInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "参数名称【" + $scope.paramsConfigInfo.key + "】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX + "paramsConfig", $scope.paramsConfigInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "参数名称【" + $scope.paramsConfigInfo.key + "】已经存在");
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
app.controller('searchParamsConfigCtrl', function ($scope, $modalInstance, $modal, searchInfos) {
    $scope.searchInfos = searchInfos;   //查询条件

    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    //清空查询条件
    $scope.clear = function () {
        $scope.searchInfos = {key: null, value: null, name: null}
    };
});
