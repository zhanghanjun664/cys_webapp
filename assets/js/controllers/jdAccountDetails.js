'use strict';
app.controller('JdAccountDetailsCtrl', function ($scope, $http, $modal, ngTableParams) {
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
        	$scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
        	if($scope.data.length == 0 && params.page() > 1) { //删除操作后如果当前页没有数据，自动跳转到前一页
        		params.page(params.page() - 1);
        		$scope.tableParams.reload();
        	}
            $defer.resolve($scope.data);
        }
    });
	
	//获取JdAccountDetails列表数据
	$scope.totalIncome = 0;
	$scope.totalExpand = 0;
    $scope.getData = function() {
		$http.get(REST_PREFIX+"jdAccountDetails/list").success(function (result) {
			$scope.resultData = result.accountDetailsList;
			$scope.resultData.forEach(function(accountDetails){
				$scope.totalIncome += accountDetails.accountIncome;
				$scope.totalExpand += accountDetails.accountExpand;
			});
			$scope.tableParams.reload();
		});
	};
    $scope.getData();
    
});