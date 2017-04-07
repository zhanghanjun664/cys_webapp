'use strict';
app.controller('PatientPaymentHistoryCtrl', function ($scope, $http, $modal, ngTableParams, SweetAlert, $window) {
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
            var requestUrl = REST_PREFIX+"patientPaymentHistory/list"+$scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $defer.resolve($scope.resultPage.result);
            });
        }
    });

    //根据付款状态的值显示对应的描述
    $scope.showPaymentStatus = function(status) {
        return showPaymentStatus(status);
    };

    //修改
    $scope.audit = function (payment) {
        SweetAlert.swal({
            title: "确定审核通过吗?",
            text: "记录审核通过后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
                $http.put(REST_PREFIX+"patientPaymentHistory/audit/"+payment.uuid).success(function() {
                    $scope.tableParams.reload();
                });
            }
        });
    };

    //点击查询按钮
    $scope.searchInfos = {status:null,phoneNumber:null};
    $scope.search = function() {
        var modalInstance = $modal.open({
            templateUrl: 'searchPatientPayment.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchPatientPaymentjCtrl',
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
    $scope.exportPaymentHistory = function(){
        var requestUrl = REST_PREFIX+"patientPaymentHistory/downloadPayment"+$scope.queryString;
        $window.open(requestUrl);
    }

});
app.controller('searchPatientPaymentjCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;
    $scope.paymentStatus = paymentStatus; //订单状态
    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {status:null,phoneNumber:null};
    };
});
