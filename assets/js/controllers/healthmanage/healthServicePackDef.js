'use strict';

var healthServicePackDef = {
	// 初始化页面数据与方法
	healthServiceList:null,
	initScopeData : function($scope) {
		healthServicePackDef.healthServiceList = ($scope.healthServiceList = healthServicePackDef.healthServiceList ? healthServicePackDef.healthServiceList
				: healthServicePackDef.initHealthServiceList());
		console.log("healthServicePackDef.healthServiceList=",healthServicePackDef.healthServiceList);
		console.log("$scope.healthServiceList=",JSON.stringify($scope.healthServiceList,null,4));
	},
	initHealthServiceList:function(){
		var list = [];
		ajax(REST_PREFIX + "healthManage/healthService/all", function(result) {
			if (result.body && result.body.code == 2000) {
				var data = result.body.result;
				for (var i = 0; i < data.length; i++) {
					list.push({
						name : data[i].name,
						id : data[i].id,
						selected:false
					});
				}
			}
		});
		console.log("list=",list);
		return list;
	}
	
}

app.controller('healthServicePackDefCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant, $sce) {
	initScope({
		//initScopeData : healthServicePackDef.initScopeData,
		searchModalResolve : function($scope) {
			return {
				searchInfos : function() {
					return $scope.searchInfos;
				}
			}
		},
		editModalResolve : function($scope) {
			return {
				obj : function() {
					// 必须用深拷贝复制1个新对象出来,否则Edit的修改会影响到父的对象
					var newObj = angular.copy($scope.obj);
					filterField(newObj, "auditable,selected");
					return newObj;
				}
			}
		},
		searchTemplateUrl : 'searchHealthServicePackDef.html',
		searchController : 'searchHealthServicePackDefCtrl',
		editTemplateUrl : 'editHealthServicePackDef.html',
		editController : 'editHealthServicePackDefCtrl',
		editModalConfig : {
			windowClass : "viewBloodPressure"//,
			//size : "lg"
		},
		tableQueryUrl : "healthManage/healthServicePackDef/all/page",
		deleteUrl : "healthManage/healthServicePackDef/",
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

});

app.controller('searchHealthServicePackDefCtrl', function($scope, $modalInstance, searchInfos) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			healthServicePackDef.initScopeData($scope);
		}
	});

});




app.controller('editHealthServicePackDefCtrl', function($scope, $http, $modalInstance, toaster, obj) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};
	$scope.selected = [] ;
	var services;
	initEdit({
		initScopeData : healthServicePackDef.initScopeData,
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});
	
	if (obj) {
		$scope.obj = obj;
		booleanToString($scope.obj);
		if($scope.obj.services){
			services=$scope.obj.services.split(",");
		}
		console.log("services=",services);
		if(services){
			for(var i=0;i<services.length;i++){
				$scope.healthServiceList.forEach(function(item){
					//设置是否选中
					if(services[i]==item.id){
						item.selected=true;
						$scope.selected.push(item.id) ;
					}
				});
		   }
		   console.log("$scope.healthServiceList=",JSON.stringify($scope.healthServiceList,null,4));
		   console.log("$scope.selected=",JSON.stringify($scope.selected,null,4));
		}
	} else {
		$scope.selected = [] ;
		$scope.obj.periodOfValidity="9999";
		// 默认值设置
		$scope.healthServiceList.forEach(function(item){
				item.selected=false;
		});
	}

	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	
	$scope.isCheck = function (id) {
		console.log("id",id);
		if($scope.obj.services){
			if(services){
				for(var i=0;i<services.length;i++){
						if(services[i]==id){
							return true;
						}
			   }
			}
		}
	   return false;
	};
	
		
	$scope.updateSelection	=function($event,id){ 
        $scope.healthServiceList.forEach(function(item){
        	console.log("item=",item.id,id,item.selected);
			//设置是否选中
			if(id==item.id){
				if(!item.selected){
					item.selected=true;
					$scope.selected.push(item.id) ;
				}else{
					item.selected=false;
					var idx = $scope.selected.indexOf(id) ;  
					$scope.selected.splice(idx,1) ;  
				}
				
			}
		});
    	console.log("$scope.selected=",JSON.stringify($scope.selected,null,4));
    	console.log("$scope.healthServiceList=",JSON.stringify($scope.healthServiceList,null,4));
	}

	
	
	
	$scope.ok = function(e) {
		$scope.obj.services="";
		if($scope.selected){
			$scope.selected.forEach(function(item){
				$scope.obj.services+=item+",";	
			});
		}
		if($scope.obj.services){
			$scope.obj.services=$scope.obj.services.substring(0,$scope.obj.services.length-1);
		}
		
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.name, $scope.obj.price,$scope.obj.periodOfValidity,$scope.obj.services], [ "服务包名称", "服务包定价","服务时长","服务内容"]))
			return;
		if(!validateFiledIntegerNorP(toaster, $scope.obj.price, "服务包定价", false)){
			return;
		}
		if(!validateFiledIntegerNorP(toaster, $scope.obj.periodOfValidity,"服务时长", false)){
			return;
		}

		
		console.log("$scope.obj.services=",$scope.obj.services);
		
		filterField($scope.obj,"properties");
		
		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX + "healthManage/updateHealthServicePackDef", $scope.obj).success(function(result) {
				console.log("result=",JSON.stringify(result,null,4));
				if(result.body.code=='46003'){
					toaster.pop("error", "提示", result.body.desc);
				}
				resultProcess($scope, result, $modalInstance, toaster, function(paramObj) {
					var $modalInstance = paramObj.$modalInstance;
					var obj = paramObj.$scope.obj;
					var result = paramObj.result;
					// 将id赋给obj,解决首次保存返回obj无id的情况
					obj.id = result.body.result.id;
					$modalInstance.close(obj);
					$scope.tableParams.reload();
				});
			});
		}
	};
});

