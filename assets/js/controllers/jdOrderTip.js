'use strict';
app.controller('JdOrderTipCtrl', function ($scope, $http, toaster, SweetAlert) {
	$scope.jdOrderTip = {};

    $scope.getData = function() {
		$http.get(REST_PREFIX+"jdOrderTip/list").success(function (result) {
			var jdOrderTip = result.jdOrderTipList[0];
			$scope.jdOrderTip.uuid = jdOrderTip.uuid;
			$scope.jdOrderTip.tip = jdOrderTip.tip;
		});
    };
    $scope.getData();
    
    //修改
    $scope.edit = function () {
		if(!validateFiledNullMax(toaster, $scope.jdOrderTip.tip, "内容", true, 0))
			return;
		$http.put(REST_PREFIX+"jdOrderTip", $scope.jdOrderTip).success(function() {
			SweetAlert.swal({
				title: "保存成功!",
				type: "success",
				confirmButtonColor: "#007AFF",
				confirmButtonText: "确定"
			});
		});
    };
    
});