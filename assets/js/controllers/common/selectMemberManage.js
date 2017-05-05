app.controller('selectMemberManageCtrl', function ($scope, $http, $modalInstance,$modal, $window,ngTableParams, toaster,SweetAlert,$localStorage,Admin_Constant,$rootScope){
	initScope({
		loadDataOnInit:false,
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
		//searchTemplateUrl : 'searchMemberManage.html',
		//searchController : 'searchMemberManageCtrl',
		//editTemplateUrl : 'editMemberManage.html',
		//editController : 'editMemberManageCtrl',
		/*editModalConfig : {
			windowClass : "viewBloodPressure",
			size : "md"
		},*/
		tableQueryUrl : "healthManage/memberManage/all/page",
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
	$("#s_activeDateEnd").val($scope.searchInfos.activeDateEnd);
	$("#s_activeDateStart").val($scope.searchInfos.activeDateStart);

	
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
    	//if($("#s_activeDateEnd").val()!=''&&$("#s_activeDateEnd").val()!=null){
    		$scope.searchInfos.activeDateEnd = $("#s_activeDateEnd").val();
    	//}
    	//if($("#s_activeDateStart").val()!=''&&$("#s_activeDateStart").val()!=null){
    		$scope.searchInfos.activeDateStart = $("#s_activeDateStart").val();
    	//}
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
	       $scope.searchInfos = {phoneNumber:null,paitentName:null,
	    		   activeDateStart:null,activeDateEnd:null};
	}

	  //改变当前选中的行
    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };
    
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

	$scope.patientArchive = {};
	$scope.patient={};
	$scope.selectPatientArchive = function (masterPatientId) {
		openPatientArchiveModel(masterPatientId,$modal,$scope);
	}
  
});