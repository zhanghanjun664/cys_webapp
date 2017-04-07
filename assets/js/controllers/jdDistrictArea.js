'use strict';
app.controller('JdDistrictAreaCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $localStorage, Admin_Constant) {
    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行
    $scope.jdDistricts = []; //地区信息

    //获取地区信息
    $scope.getDistrictInfos = function () {
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
    };
    $scope.getDistrictInfos();

    //根据地区ID显示地区
    $scope.displayDistrictName = function (jdDistrictId) {
        for (var i = 0; i < $scope.jdDistricts.length; i++) {
            if ($scope.jdDistricts[i].uuid == jdDistrictId)
                return $scope.jdDistricts[i].name;
        }
    };

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
            var requestUrl = REST_PREFIX + "jdDistrictArea/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result
                $defer.resolve($scope.data);
            });
        }
    });

    //刷新JdDistrictArea缓存数据
    $scope.refreshCash = function () {
        $http.get(REST_PREFIX + "jdDistrictArea/list").success(function (result) {
            $localStorage[Admin_Constant.LocalStorage.DistrictAreas] = result.districtAreaList;
        });
    };
    $scope.refreshCash();

    //新增
    $scope.edit = function (jdDistrictArea) {
        var modalInstance = $modal.open({
            templateUrl: 'editJdDistrictArea.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdDistrictAreaCtrl',
            resolve: {
                jdDistrictArea: function () {
                    return jdDistrictArea;
                },
                jdDistricts: function () {
                    return $scope.jdDistricts;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.tableParams.reload();
            $scope.refreshCash();
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
                $http.delete(REST_PREFIX + "jdDistrictArea/" + id).success(function (result) {
                    if (result.result != 0) {
                        toaster.pop("error", "提示", "市辖区【" + result.description + "】已被引用，不能删除");
                    } else {
                        $scope.tableParams.reload();
                        $scope.refreshCash();
                    }
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

    $scope.searchInfos = {jdDistrictId: null, name: null};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdDistrictArea.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdDistrictAreaCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                },
                jdDistricts: function () {
                    return $scope.jdDistricts;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    }
});
app.controller('searchJdDistrictAreaCtrl', function ($scope, $modalInstance, searchInfos, jdDistricts) {
    $scope.searchInfos = searchInfos;
    $scope.jdDistricts = jdDistricts;
    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {jdDistrictId: null, name: null};
    };
});
app.controller('editJdDistrictAreaCtrl', function ($scope, $http, $modalInstance, toaster, jdDistricts, jdDistrictArea) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.jdDistricts = jdDistricts;
    $scope.jdDistrictAreaInfo = {};
    if (jdDistrictArea) {
        $scope.jdDistrictAreaInfo.uuid = jdDistrictArea.uuid;
        $scope.jdDistrictAreaInfo.name = jdDistrictArea.name;
        $scope.jdDistrictAreaInfo.jdDistrictId = jdDistrictArea.jdDistrictId;
    }
    $scope.ok = function (e) {
        if (!validateFiledNullMax(toaster, $scope.jdDistrictAreaInfo.jdDistrictId, "地区", true, 0)
            || !validateFiledNullMax(toaster, $scope.jdDistrictAreaInfo.name, "市辖区", true, 36))
            return;
        //提交
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            if (jdDistrictArea) {
                $http.put(REST_PREFIX + "jdDistrictArea", $scope.jdDistrictAreaInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "市辖区【" + $scope.jdDistrictAreaInfo.name + "】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX + "jdDistrictArea", $scope.jdDistrictAreaInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "市辖区【" + $scope.jdDistrictAreaInfo.name + "】已经存在");
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