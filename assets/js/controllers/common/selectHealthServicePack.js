app.controller('selectHealthServicePackCtrl', function ($scope, $http, $modalInstance,$modal, $window,ngTableParams, toaster,SweetAlert,$localStorage,Admin_Constant,$rootScope){
	initScope({
		initScopeData : healthServicePackDef.initScopeData,
		searchModalResolve : function($scope) {
			return {
				searchInfos : function() {
					//$scope.searchInfos.healthServicePackDefId=null;
					return $scope.searchInfos;
				},
				healthServicePackDefs:function(){
					return healthServicePackDef.healthServicePackDefList;
				}
			}
		},
		searchTemplateUrl : 'searchHealthServicePack.html',
		searchController : 'searchHealthServicePackCtrl',
		editModalConfig : {
			windowClass : "viewBloodPressure",
			size : "md"
		},
		tableQueryUrl : "healthManage/unActivedAndUnExpiredHealthServicePack/page",//
		$scope : $scope,
		$http : $http,
		$modal : $modal,
		ngTableParams : ngTableParams,
		toaster : toaster,
		SweetAlert : SweetAlert,
		$window : $window,
		$localStorage : $localStorage,
		Admin_Constant : Admin_Constant
	});

	$scope.showServiceContent=function(healServices){
		var healServiceName="";
		if(healServices){
			healServices.forEach(function(item){
				healServiceName+=item.name+",";
			});
		}
	    healServiceName=healServiceName.substring(0,healServiceName.length-1);
		return healServiceName;
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
    
});