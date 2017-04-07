'use strict';
app.controller('JdPushArticleResultCtrl', function ($scope, $http, $modal, ngTableParams) {
	$scope.resultPage = {totalCount:0};
	$scope.data = []; //当前页面的结果集
	$scope.selections = []; //当前页面选中的行

	$scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
			$scope.searchInfos.pageIndex = params.page();
			$scope.searchInfos.pageSize = params.count();
			$scope.queryString = getQueryString($scope.searchInfos);
			var requestUrl = REST_PREFIX+"jdPushArticleResult/page"+$scope.queryString;
			$http.get(requestUrl).success(function (result) {
				$scope.resultPage = result.resultPage;
				params.total($scope.resultPage.totalCount);
				params.page($scope.resultPage.nowPage);
				$scope.data = $scope.resultPage.result;
				$defer.resolve($scope.data);
			});
        }
    });

    //点击查询按钮
	$scope.searchInfos = {patientName:null,doctorName:null,title:null,status:""};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchJdPushArticleResult.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchJdPushArticleResultCtrl',
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
	};

});
app.controller('searchJdPushArticleResultCtrl', function ($scope, $modalInstance, searchInfos) {
	$scope.searchInfos = searchInfos;
	$scope.ok = function (e) {
		$modalInstance.close($scope.searchInfos);
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	$scope.clear = function () {
		$scope.searchInfos = {patientName:null,doctorName:null,title:null,status:""};
	};
});