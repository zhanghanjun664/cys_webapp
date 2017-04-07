'use strict';
app.controller('thirdPartyPaymentHistoryCtrl', function($scope, $http, $modal,
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
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            console.log("$scope.queryString=", $scope.queryString);
            var requestUrl = REST_PREFIX + "thirdPartyPaymentHistory/allList"
                    + $scope.queryString;
            $http.get(requestUrl).success(function(result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $defer.resolve($scope.resultPage.result);
            });
        }
    });

    // 根据付款状态的值显示对应的描述
    $scope.showPaymentStatus = function(status) {
        return showPaymentStatus(status);
    };
    
    $scope.showOrderSource = function(status) {
        return showOrderSource(status);
    };

    $scope.showTransactionType = function(type) {
        if (type == "WITHDRAW")
            return "-";
        if (type == "REFUND")
            return "+";
        if (type == "SERVICE_REFUND")
            return "+";
        if (type == "INSURANCE_REFUND")
            return "+";
        if (type == "RED_ENVELOPE")
            return "+";
        if (type == "RECOMMEND")
            return "+";
        if (type == "BE_INVITED")
            return "+";
        if (type == "QRCODE_REWARD")
            return "+";
        if (type == "DOCTOR_CANCEL")
            return "+";
        if (type == "WX_CHARGE")
            return "+";
        if (type == "ALIPAY_CHARGE")
            return "+";
        if (type == "PAY_BOND")
            return "-";
        if (type == "PAY_ORDER")
            return "-";
        if (type == "RETURN_BOND")
            return "+";
        if (type == "PAY_SERVICE")
            return "-";
        if (type == "PAY_INSURANCE")
            return "-";
        if (type == "ACTIVITY_OYO")
            return "-";
    };

    $scope.showOrderType = function(type) {
        if (type == null || type == '') {
            return "线下订单"
        }
        if (type == "0")
            return "图文订单";
        if (type == "1")
            return "电话订单";
        if (type == "2")
            return "包月订单";
    };

    // 点击查询按钮
    $scope.searchInfos = {
        createTimeStart : null,
        createTimeEnd : null,
        userName : null,
        phoneNumber : null,
        paymentTypes : null,
        deposit : true,
        expense : true
    };
    $scope.search = function() {
        var modalInstance = $modal.open({
            templateUrl : 'searchPatientAllPayment.html',
            backdrop : 'static',
            keyboard : false,
            controller : 'searchPatientAllPaymentjCtrl',
            resolve : {
                searchInfos : function() {
                    return $scope.searchInfos;
                },
                orderSourceType : function() {
                    return [ {value : "JIANKANGJIA100"    , name : "爱立方订单"}];
                }
            }
        });
        modalInstance.result.then(function(searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    }
    $scope.exportPaymentHistory = function() {
        var requestUrl = REST_PREFIX + "thirdPartyPaymentHistory/downloadHistory"
                + $scope.queryString;
        $window.open(requestUrl);
    }
    $scope.exportStatement = function() {
        var requestUrl = REST_PREFIX
                + "thirdPartyPaymentHistory/downloadStatement"
                + $scope.queryString;
        $window.open(requestUrl);
    }
});

app.controller('searchPatientAllPaymentjCtrl', function($scope, $modalInstance,
        searchInfos,orderSourceType) {
    $scope.searchInfos = searchInfos;
    $scope.orderSourceType = orderSourceType;
    $scope.paymentTypes = [{
        value : "PAY_BOND",
        name : "支付保证金"
    }, {
        value : "PAY_ORDER",
        name : "支付诊金"
    }, {
        value : "RETURN_BOND",
        name : "退回保证金"
    }, {
        value : "REFUND",
        name : "退回诊金"
    } ]; // 订单状态
    $scope.ok = function(e) {
        $scope.searchInfos.createTimeStart = $("#createTimeStart").val();
        $scope.searchInfos.createTimeEnd = $("#createTimeEnd").val();
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function(e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function() {
        $scope.searchInfos = {
            createTimeStart : null,
            createTimeEnd : null,
            userName : null,
            phoneNumber : null,
            paymentTypes : null
        };
    };
});
