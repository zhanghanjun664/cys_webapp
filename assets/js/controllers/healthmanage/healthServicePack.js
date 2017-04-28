'use strict';




app.controller('healthServicePackCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant, $sce) {
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
		editModalResolve : function($scope) {
			return {
				obj : function() {
					// 必须用深拷贝复制1个新对象出来,否则Edit的修改会影响到父的对象
					var newObj = angular.copy($scope.obj);
					filterField(newObj, "auditable,selected");
					return newObj;
				},
				healthServicePackDefs:function(){
					return healthServicePackDef.healthServicePackDefList;
				}
			}
		},
		searchTemplateUrl : 'searchHealthServicePack.html',
		searchController : 'searchHealthServicePackCtrl',
		editTemplateUrl : 'editHealthServicePack.html',
		editController : 'editHealthServicePackCtrl',
		editModalConfig : {
			windowClass : "viewBloodPressure",
			size : "md"
		},
		tableQueryUrl : "healthManage/healthServicePack/all/page",
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

app.controller('searchHealthServicePackCtrl', function($scope, $modalInstance, searchInfos,healthServicePackDefs) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			//healthServicePackDef.initScopeData($scope);
		}
	});
	$scope.healthServicePackDefList=healthServicePackDefs;
	if($scope.healthServicePackDefList){
		$scope.healthServicePackDefList.forEach(function(item){
			item.detailName=item.name+","+item.price+"元,"+item.periodOfValidity+"天"
		});
	}
	console.log("$scope.healthServicePackDefList=",$scope.healthServicePackDefList);
	$scope.cysBoolStatus = cysBoolStatus;
	
	
});




app.controller('editHealthServicePackCtrl', function($scope, $http, $modalInstance, toaster, obj,healthServicePackDefs) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};
	$scope.selected = [] ;
	var services;
	// debugger;
	if (obj) {
		$scope.obj = obj;
		booleanToString($scope.obj);
	} else {
		// 默认值设置
		$scope.obj.isDelivered="false";
		$scope.obj.isActivated="false";
	}
	$scope.healthServicePackDefList=healthServicePackDefs;
	if($scope.healthServicePackDefList){
		$scope.healthServicePackDefList.forEach(function(item){
			console.log("item",item);
			item.detailName=item.name+","+item.price+"元,"+item.periodOfValidity+"天"
		});
	}
	console.log("$scope.healthServicePackDefList=",$scope.healthServicePackDefList);
	$scope.cysBoolStatus = cysBoolStatus;
	
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	
	initEdit({
		//initScopeData : healthServicePack.initScopeData,
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});
	
	
	$scope.ok = function(e) {
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.code,$scope.obj.healthServicePackDefId, $scope.obj.exchangeExpiredDate], ["兑换码不能为空", "请选择服务包名称", "兑换码有效期不能为空"]))
			return;
		/*if(!validateFiledIntegerNorP(toaster, $scope.obj.price, "服务包定价", false)){
			return;
		}*/
		$scope.obj.services=null;
		if($scope.selected){
			$scope.selected.forEach(function(item){
				$scope.obj.services+=item;	
			});
		}
		console.log("$scope.obj.services=",$scope.obj.services);

		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			filterField($scope.obj,"properties");
			filterField($scope.obj,"services");
			filterField($scope.obj,"serviceExpiredDate");
			$scope.dateBeginShowStr=$('#dateBeginShowStr').val();
			$scope.obj.exchangeExpiredDate = new Date($scope.dateBeginShowStr);
			
			$http.post(REST_PREFIX + "healthManage/updateHealthServicePack", $scope.obj).success(function(result) {
				console.log("result=",JSON.stringify(result,null,4));
				if(result.body.code=='46004'){
					toaster.pop("error", "提示", result.body.desc);
				}
				resultProcess($scope, result, $modalInstance, toaster, function(paramObj) {
					var $modalInstance = paramObj.$modalInstance;
					var obj = paramObj.$scope.obj;
					var result = paramObj.result;
					// 将id赋给obj,解决首次保存返回obj无id的情况
					obj.id = result.body.result.id;
					$modalInstance.close(obj);
				});
			});
		}
	};
});

