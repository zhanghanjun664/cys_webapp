/**
 * Created by Administrator on 2015-05-15.
 */
'use strict';
app.controller('PaymentCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert,$window) {
    $scope.resultData = []; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultData.length,
        getData: function ($defer, params) {
            params.total($scope.resultData.length);
            commonResetSelection($scope);
            $scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
            if($scope.data.length == 0 && params.page() > 1) { //删除操作后如果当前页没有数据，自动跳转到前一页
                params.page(params.page() - 1);
                $scope.tableParams.reload();
            }
            $defer.resolve($scope.data);
        }
    });

    //获取payment列表数据
    $scope.getData = function() {
        $http.get(REST_PREFIX+"payment/list").success(function (result) {
            $scope.resultData = result.paymentQueryModelList;
            $scope.tableParams.reload();
        });
    };
    $scope.getData();

    //新增
    $scope.edit = function (payment) {
        var modalInstance = $modal.open({
            templateUrl: 'editPayment.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editPaymentCtrl',
            size:"lg",
            resolve: {
                jdpayment : function() {
                    return payment;
                },
                paymethodArray:function(){
                    return $scope.paymethodArray;
                },
                statusArray:function(){
                    return $scope.statusArray;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.getData();
        });
    };

    //改变当前选中的行
    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };

    //全选/全不选
    $scope.selectAll = function() {
        commonSelectAll($scope);
    };

    //点击删除按钮
    $scope.deleteAll = function() {
        commonDeleteButtonClick(toaster, $scope);
    };

    //点击编辑按钮
    $scope.update = function () {
        commonEditButtonClick(toaster, $scope);
    };

    $scope.paymethodArray=[
      //  {value:"ALIPAY",label:"阿里"},
     //   {value:"WECHAT",label:"微信"},
        {value:"BANKCARD",label:"银行卡"}
    ];
    $scope.statusArray=[
        {value:"PAYED",label:"已支付"},
        {value:"DRAFT",label:"草稿"},
        {value:"PAYING",label:"支付中"},
        {value:"VOID",label:"作废"}
    ];

    $scope.getPaymentMethodLabel=function(value){
        for(var i=0;i<$scope.paymethodArray.length;i++){
            var object=$scope.paymethodArray[i];
            if(object.value==value){
                return object.label;
            }
        }
        return "";
    };

    $scope.getStatusLabel=function(value){
        for(var i=0;i<$scope.statusArray.length;i++){
            var object=$scope.statusArray[i];
            if(object.value==value){
                return object.label;
            }
        }
        return "";
    };

    $scope.download=function(uuid){
        $window.open("rest/payment/download?uuid="+uuid);
    }
});
app.controller('editPaymentCtrl', function ($scope, $http, $modalInstance, toaster, jdpayment,paymethodArray,statusArray) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.payment = {};
    $scope.paymethodArray=paymethodArray;
    $scope.statusArray=statusArray;

    if(jdpayment) {
        $scope.payment.uuid = jdpayment.uuid;
        $scope.payment.documentNo = jdpayment.documentNo;
        $scope.payment.name = jdpayment.name;
        $scope.payment.paymentMethod = jdpayment.paymentMethod;
        $scope.payment.status = jdpayment.status;
        $scope.payment.count = jdpayment.count;
        $scope.payment.amount = jdpayment.amount;
        $scope.payment.startDate = jdpayment.startDate;
        $scope.payment.endDate = jdpayment.endDate;
    }else{
        $scope.payment.paymentMethod="BANKCARD";
            $scope.payment.status="DRAFT";
    }
    $scope.ok = function (e) {
        if(!validateFiledNullMax(toaster, $scope.payment.name, "名称", true, 0))
            return;
        if(!validateFiledNullMax(toaster, $scope.payment.paymentMethod, "支付方式", true, 0))
            return;
        if(!validateFiledNullMax(toaster, $scope.payment.status, "状态", true, 0))
            return;
        //提交
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            if(jdpayment) {
                $http.put(REST_PREFIX+"payment", $scope.payment).success(function(result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "名称【"+$scope.payment.name+"】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX+"payment", $scope.payment).success(function(result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "名称【"+$scope.payment.name+"】已经存在");
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
