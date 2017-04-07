'use strict';
app.controller('patientBalanceCtrl', function($scope, $http, $modal,
        ngTableParams, SweetAlert, $window) {
    $scope.resultPage = {
        totalCount : 0
    };

    $scope.tableParams = new ngTableParams({
        page : 1,
        count : 10
    }, {
        total : $scope.resultPage.totalRecords,
        getData : function($defer, params) {
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "patientbalance/list"
                    + $scope.queryString;
            $http.get(requestUrl).success(function(result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $defer.resolve($scope.resultPage.result);
            });
        }
    });

    // 点击查询按钮
    $scope.searchInfos = {
        userName : null,
        phoneNumber : null
    };
    $scope.search = function() {
        var modalInstance = $modal.open({
            templateUrl : 'searchPatientBalanceCtrl.html',
            backdrop : 'static',
            keyboard : false,
            controller : 'searchPatientBalanceCtrl',
            resolve : {
                searchInfos : function() {
                    return $scope.searchInfos;
                }
            }
        });
        modalInstance.result.then(function(searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    }
    $scope.exportBalance = function() {
        var requestUrl = REST_PREFIX + "patientbalance/export"
                + $scope.queryString;
        $window.open(requestUrl);
    }

});
app.controller('searchPatientBalanceCtrl', function($scope, $modalInstance,
        searchInfos) {
    $scope.searchInfos = searchInfos;
    $scope.paymentStatus = paymentStatus; // 订单状态
    $scope.ok = function(e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function(e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function() {
        $scope.searchInfos = {
            userName : null,
            phoneNumber : null
        };
    };
});

app.controller('summaryStatementCtrl', function($scope, $http, $modal,
        ngTableParams, SweetAlert, $window) {
    $scope.resultPage = {
        totalCount : 0
    };

    $scope.tableParams = new ngTableParams({
        page : 1,
        count : 10
    }, {
        total : $scope.resultPage.totalCount,
        getData : function($defer, params) {
            var requestUrl = REST_PREFIX + "patientbalance/summary";
            $http.get(requestUrl).success(function(result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $defer.resolve($scope.resultPage.result);                
            });
        }
    });
});
