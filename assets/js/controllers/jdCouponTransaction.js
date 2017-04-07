'use strict';
app.controller('JdCouponTransactionCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    //根据支付渠道状态显示名称
    $scope.displayPaymentChannelName = function (paymentChannel) {
        return showPaymentChannel(paymentChannel);
    }

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
            var requestUrl = REST_PREFIX + "jdCouponTransaction/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result
                $defer.resolve($scope.data);
            });
        }
    });

//点击查询按钮
    $scope.searchInfos = {
        orderNumber: null,
        name: null,
        phoneNumber: null,
        usedTimeStart: null,
        usedTimeEnd: null
    };
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdCouponTransaction.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdCouponTransactionCtrl',
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
    };
});
app.controller('searchJdCouponTransactionCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;
    $("#usedTimeStart").val($scope.searchInfos.usedTimeStart);
    $("#usedTimeEnd").val($scope.searchInfos.usedTimeEnd);

    $scope.ok = function (e) {
        $scope.searchInfos.usedTimeStart = $("#usedTimeStart").val();
        $scope.searchInfos.usedTimeEnd = $("#usedTimeEnd").val();
        $modalInstance.close($scope.searchInfos);
    };

    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };

    $scope.clear = function () {
        $("#usedTimeStart").val("");
        $("#usedTimeEnd").val("");
        $scope.searchInfos = {
            orderNumber: null,
            name: null,
            phoneNumber: null,
            usedTimeStart: null,
            usedTimeEnd: null
        };
    };
});