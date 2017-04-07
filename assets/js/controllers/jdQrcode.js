'use strict';
app.controller('JdQrcodeCtrl', function ($window, $scope, $http, $modal, ngTableParams, toaster, $localStorage, Admin_Constant) {
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
            var requestUrl = REST_PREFIX + "jdQrcode/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);
            });
        }
    });

    //显示红包金额
    $scope.displayRedpack = function (redpack) {
        if (!redpack) {
            return "否";
        } else {
            return "是（" + redpack + "元）";
        }
    };

    //显示内容设置为自定义或默认
    $scope.displayContentType = function (content) {
        if (content) {
            return "自定义";
        } else {
            return "默认";
        }
    };

    //显示现金券配置为自定义或默认
    $scope.displayCoupon = function (coupon) {
        if (coupon) {
            return coupon;
        } else {
            return "默认";
        }
    };

    //刷新JdQrcode缓存数据
    //$scope.refreshCash = function () {
    //    $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
    //        $localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
    //    });
    //};
    //$scope.refreshCash();


    //新增
    $scope.edit = function (jdQrcode) {
        var modalInstance = $modal.open({
            templateUrl: 'editJdQrcode.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdQrcodeCtrl',
            resolve: {
                jdQrcode: function () {
                    return jdQrcode;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
            $scope.refreshCash();
        });
    };

    //点击编辑按钮
    $scope.update = function () {
        commonEditButtonClick(toaster, $scope);
    };

    $scope.showQrcode = function (url) {
        $window.open(url);
    };

    //点击查询按钮
    $scope.searchInfos = {name: null,sceneStr: null,give: "",push: "",coupon: ""};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdQrcode.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdQrcodeCtrl',
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
app.controller('searchJdQrcodeCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;
    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {name: null,sceneStr: null,give: "",push: "",coupon: ""};
    };
});
app.controller('editJdQrcodeCtrl', function ($scope, $http, $modalInstance, toaster, jdQrcode) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.jdQrcodeInfo = {};
    $scope.flag = "false"; //用于是否显示推送红包
    $scope.signInfo = {contentSign:"false"}; //推送内容设置
    $scope.couponSign = "false"; //现金券配置
    $scope.typeSign = false; //是否可以自定义推送内容
    $scope.disabled = false; //编辑时是否不允许修改
    if (jdQrcode) {
        $scope.disabled = true;
        $scope.jdQrcodeInfo.uuid = jdQrcode.uuid;
        $scope.jdQrcodeInfo.name = jdQrcode.name;
        $scope.jdQrcodeInfo.sceneStr = jdQrcode.sceneStr;
        $scope.jdQrcodeInfo.redpack = jdQrcode.redpack;
        $scope.jdQrcodeInfo.url = jdQrcode.url;
        $scope.jdQrcodeInfo.content = jdQrcode.content;
        $scope.jdQrcodeInfo.coupon = jdQrcode.coupon;
        if (jdQrcode.redpack > 0) $scope.flag = "true";
        if (jdQrcode.content != null) $scope.signInfo.contentSign = "true";
        if (jdQrcode.coupon != null) $scope.couponSign = "true";
        if (jdQrcode.type != null) $scope.typeSign = true;
    }

    //当选择否时重置红包金额为0
    $scope.setRedpack = function () {
        $scope.jdQrcodeInfo.redpack = 0;
    };

    //关注推送选择默认时重置推送内容为空
    $scope.setContent = function () {
        $scope.jdQrcodeInfo.content = null;
    };

    //现金券配置选择默认时重置配置内容为空
    $scope.setCoupon = function () {
        $scope.jdQrcodeInfo.coupon = null;
    };

    $scope.ok = function (e) {
        if (!validateFiledNullMax(toaster, $scope.jdQrcodeInfo.name, "推广渠道", true, 32)
            || !validateFiledNullMax(toaster, $scope.jdQrcodeInfo.sceneStr, "渠道编码", true, 64))
            return;
        if ($scope.flag == "true" && $scope.jdQrcodeInfo.redpack != null && !validateFiledInteger(toaster, $scope.jdQrcodeInfo.redpack, "赠送金额", false, false))
            return;
        if ($scope.signInfo.contentSign == "true" && !validateFiledNullMax(toaster, $scope.jdQrcodeInfo.content, "推送内容", true, 0))
            return;
        if ($scope.couponSign == "true") {
            var reg = /^\d+;\d+$/;
            if(!reg.test($scope.jdQrcodeInfo.coupon)) {
                toaster.pop("error", "提示", "【配置内容】输入不正确", "1000");
                return;
            }
        }

        //提交
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            if (jdQrcode) {
                $http.put(REST_PREFIX + "jdQrcode", $scope.jdQrcodeInfo).success(function (result) {
                    if (result.result == 1) {
                        $scope.submitFlag = false;
                        toaster.pop("error","提示","推广渠道【" + $scope.jdQrcodeInfo.name + "】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            } else {
                toaster.pop("warning", "提示", "生成二维码需要一段时间，请耐心等待");
                $http.post(REST_PREFIX + "jdQrcode", $scope.jdQrcodeInfo).success(function (result) {
                    if (result.result == 1) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "推广渠道【" + $scope.jdQrcodeInfo.name + "】已经存在");
                    } else if (result.result == 2) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "渠道编码【" + $scope.jdQrcodeInfo.sceneStr + "】已经存在");
                    } else if (result.result == 3) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", result.description);
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