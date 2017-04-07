'use strict';
app.controller('PatientRedpackPaymentCtrl', function ($scope, $http, $modal, ngTableParams, SweetAlert) {
    $scope.resultPage = {totalCount:0};

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX+"patientPaymentHistory/redpack/list"+$scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $defer.resolve($scope.resultPage.result);
            });
        }
    });

    //点击查询按钮
    $scope.searchInfos = {phoneNumber:null,orderNumber:null};
    $scope.search = function() {
        var modalInstance = $modal.open({
            templateUrl: 'searchPatientRedpackPayment.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchPatientRedpackPaymentCtrl',
            resolve: {
                searchInfos : function() {
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
app.controller('searchPatientRedpackPaymentCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;
    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {phoneNumber:null,orderNumber:null};
    };
});
