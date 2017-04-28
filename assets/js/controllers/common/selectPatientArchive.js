app.controller('selectPatientArchiveCtrl', function($scope, $http,
		$modalInstance, $modal, $window, ngTableParams, toaster, SweetAlert,
		$localStorage, Admin_Constant, $rootScope,patient) {
	console.log("patient=",patient);
    $scope.justopen = false;
	$scope.resultPage = {
		totalCount : 0
	};
	$scope.data = []; // 当前页面的数据
	$scope.selections = []; // 当前页面选中的行
	$scope.searchInfos = {
		pageIndex : 1,
		pageSize : 10,
		masterPatientId:patient.masterPatientId
	};
	// 获取地区信息
	$scope.jdDistricts = loadJdDistricts($http, Admin_Constant, $localStorage);

	// 获得市辖区信息
	$scope.jdDistrictAreas = loadJdDistrictAreas($http, Admin_Constant,
			$localStorage);

	// 根据地区ID显示地区的名称
	$scope.displayDistrictName = function(districtId) {
		for (var i = 0; i < $scope.jdDistricts.length; i++) {
			if ($scope.jdDistricts[i].uuid == districtId)
				return $scope.jdDistricts[i].name;
		}
	};

	// 显示录入时间
	$scope.displayCreateDate = function(time) {
		if (time) {
			return time.split(" ")[0];
		} else {
			return "";
		}
	};

	$scope.showBooleanInChinese = function(b) {
		return showBooleanInChinese(b);
	}

	$scope.showGender = function(genderCode) {
		return showGender(genderCode);
	}

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
    			$scope.searchInfos.pageIndex = params.page();
    			$scope.searchInfos.pageSize = params.count();
    			$scope.queryString = getQueryString($scope.searchInfos);
    			var requestUrl = REST_PREFIX + "archive/list" + $scope.queryString;
    			$http.get(requestUrl).success(function(result) {
    				$scope.resultPage = result.resultPage;
    				if (!$scope.resultPage) {
    					toaster.pop("error", "提示", "没有符合条件的数据");
    				}
    				params.total($scope.resultPage.totalCount);
    				params.page($scope.resultPage.nowPage);
    				$scope.data = $scope.resultPage.result;
    				$defer.resolve($scope.data);

    				if ($scope.resultPage.result[0]) {
    					$scope.selectUuid = $scope.resultPage.result[0].uuid;
    				} else {
    					$scope.selectUuid = "";
    				}
    				$scope.$emit("rowSelectChange", $scope.selectUuid);
    			});
            }
		
		}
	});

	$scope.query = function() {

		$scope.tableParams.reload();
		console.log("data=", $scope.data);
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
			rowObject = $scope.selections[0];
			$modalInstance.close(rowObject);
		}
	}

	$scope.clear = function(e) {
		var rowObject = new Object();
		rowObject.name = "";
		rowObject.jdDoctorId = "";
		$modalInstance.close(rowObject);
	}

	//改变当前选中的行
	$scope.changeSelection = function(index) {
		commonChangeSelection($scope, index);
	};
	
    
    $scope.edit = function(archive) {
        window.open('/assets/views/patient-archive/patientArchiveEditor.html?id=' + archive.id + '#panel-1');
    }
    

});