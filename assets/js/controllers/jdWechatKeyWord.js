'use strict';
app.controller('JdWechatKeyWordCtrl', function ($rootScope, $scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
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
            var requestUrl = REST_PREFIX + "jdWechatKeyWord/list" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);
            });
        }
    });

    //新增
    $scope.edit = function (jdWechatKeyWord) {
        var modalInstance = $modal.open({
            templateUrl: 'editJdWechatKeyWord.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdWechatKeyWordCtrl',
            resolve: {
                jdWechatKeyWord: function () {
                    return jdWechatKeyWord;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };

    //删除
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
                $http.delete(REST_PREFIX + "jdWechatKeyWord/" + id).success(function (result) {
                    if (result.result != 0) {
                        toaster.pop("error", "提示", result.description);
                    } else {
                        $scope.tableParams.reload();
                    }
                });
            }
        });
    };

    //全选/全不选
    $scope.selectAll = function () {
        commonSelectAll($scope);
    };

    //改变当前选中的行
    $scope.changeSelection = function (index) {
        commonChangeSelection($scope, index);
    };

    //点击删除按钮
    $scope.deleteAll = function () {
        commonDeleteButtonClick(toaster, $scope);
    };

    //点击编辑按钮
    $scope.update = function () {
        commonEditButtonClick(toaster, $scope);
    };

    //点击查询按钮
    $scope.searchInfos = {keyWord: null};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdWechatKeyWord.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdWechatKeyWordCtrl',
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

app.controller('searchJdWechatKeyWordCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;
    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {keyWord: null};
    };
});

app.controller('editJdWechatKeyWordCtrl', function ($scope, $http, $modalInstance, toaster, jdWechatKeyWord) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.jdWechatKeyWordInfo = {};
    if (jdWechatKeyWord) {
        $scope.jdWechatKeyWordInfo.uuid = jdWechatKeyWord.uuid;
        $scope.jdWechatKeyWordInfo.keyWord = jdWechatKeyWord.keyWord;
        $scope.jdWechatKeyWordInfo.description = jdWechatKeyWord.description;
    }
    $scope.ok = function (e) {
        if (!validateFiledNullMax(toaster, $scope.jdWechatKeyWordInfo.keyWord, "关键字", true, 0)
            || !validateFiledNullMax(toaster, $scope.jdWechatKeyWordInfo.description, "按钮描述", true, 0))
            return;
        //提交
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            if (jdWechatKeyWord) {
                $http.put(REST_PREFIX + "jdWechatKeyWord", $scope.jdWechatKeyWordInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "关键字【" + $scope.jdWechatKeyWordInfo.keyWord + "】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX + "jdWechatKeyWord", $scope.jdWechatKeyWordInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "关键字【" + $scope.jdWechatKeyWordInfo.keyWord + "】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            }
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    }
});