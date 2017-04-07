'use strict';
app.controller('JdCouponCategoryCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
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
            var requestUrl = REST_PREFIX + "jdCouponCategory/page" + $scope.queryString;
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
    $scope.edit = function (jdCouponCategory) {
        var modalInstance = $modal.open({
            templateUrl: 'editJdCouponCategory.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdCouponCategoryCtrl',
            resolve: {
                jdCouponCategory: function () {
                    return jdCouponCategory;
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
                $http.delete(REST_PREFIX + "jdCouponCategory/" + id).success(function (result) {
                    if (result.result != 0) {
                        toaster.pop("error", "提示", "类型【" + result.description + "】已被引用，不能删除");
                    }
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
    $scope.searchInfos = {name: null};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdCouponCategory.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdCouponCategoryCtrl',
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
app.controller('searchJdCouponCategoryCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;
    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {name: null};
    };
});
app.controller('editJdCouponCategoryCtrl', function ($scope, $http, $modalInstance, toaster, jdCouponCategory) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.jdCouponCategoryInfo = {};
    if (jdCouponCategory) {
        $scope.jdCouponCategoryInfo.uuid = jdCouponCategory.uuid;
        $scope.jdCouponCategoryInfo.name = jdCouponCategory.name;
    }
    $scope.ok = function (e) {
        if (!validateFiledNullMax(toaster, $scope.jdCouponCategoryInfo.name, "类型名称", true, 20))
            return;
        //提交
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            if (jdCouponCategory) {
                $http.put(REST_PREFIX + "jdCouponCategory", $scope.jdCouponCategoryInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "名称【" + $scope.jdCouponCategoryInfo.name + "】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX + "jdCouponCategory", $scope.jdCouponCategoryInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "名称【" + $scope.jdCouponCategoryInfo.name + "】已经存在");
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
