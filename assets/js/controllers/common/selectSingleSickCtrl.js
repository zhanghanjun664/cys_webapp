app.controller('selectSingleSickCtrl', function($scope, $http, $modalInstance,
		ngTableParams, toaster) {
	$scope.justopen = true;

	$scope.resultPage = {
		totalCount : 0
	};
	$scope.data = []; // 当前页面的结果集
	$scope.selections = []; // 当前页面选中的行
	$scope.searchInfo = {
		pageIndex : 1,
		pageSize : 10
	};
	$scope.tableParams = new ngTableParams({
		page : 1,
		count : 10
	}, {
		total : $scope.resultPage.totalCount,
		getData : function($defer, params) {
			if ($scope.justopen) {
				$scope.justopen = false;
			} else {
				commonResetSelection($scope);
				$scope.searchInfo.pageIndex = params.page();
				$scope.searchInfo.pageSize = params.count();
				$scope.queryString = getQueryString($scope.searchInfo);
				var requestUrl = "/rest/jdSick/list" + $scope.queryString;
				$http.get(requestUrl).success(function(result) {
					$scope.resultPage = result.body.result;
					params.total($scope.resultPage.totalRecords);
					// params.page($scope.resultPage.nowPage);
					$scope.data = $scope.resultPage.content;
					$defer.resolve($scope.data);
				});
			}
		}
	});

	$scope.changeSelection = function(index) {
		commonChangeSelection($scope, index);
	};

	$scope.query = function() {
		$scope.tableParams.reload();
	};

	$scope.cancel = function(e) {
		$modalInstance.dismiss();
	};

	$scope.ok = function(e) {
		if ($scope.selections.length == 0) {
			toaster.pop("warning", "", "请选择一条记录", "1000");
		} else if ($scope.selections.length > 1) {
			toaster.pop("warning", "", "请最多一条记录", "1000");
		} else {
			var rowObject = new Object();
			rowObject = $scope.selections;
			$modalInstance.close(rowObject);
		}
	}

	$scope.clear = function(e) {
		var rowObject = new Object();
		rowObject.name = "";
		rowObject.jdDoctorId = "";
		$modalInstance.close(rowObject);
	}
});