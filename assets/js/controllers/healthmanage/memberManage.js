'use strict';



app.controller('memberManageCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
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
		searchTemplateUrl : 'searchMemberManage.html',
		searchController : 'searchMemberManageCtrl',
		editTemplateUrl : 'editMemberManage.html',
		editController : 'editMemberManageCtrl',
		editModalConfig : {
			windowClass : "viewBloodPressure",
			size : "md"
		},
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

	 $scope.add = function (obj) {
	    $scope.obj = obj;
        var defaultEditModalConfig={
                templateUrl: 'addMemberManage.html',
                backdrop: 'static',
                size:"lg",
                keyboard: false,
                controller: 'addMemberManageCtrl',
                resolve: {
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
            };
        var options = $.extend({}, defaultEditModalConfig);
        var modalInstance = $modal.open(options);
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
	 };
});

app.controller('searchMemberManageCtrl', function($scope, $modalInstance,$modal, searchInfos,healthServicePackDefs) {
	initSearch({
		$scope : $scope,
		$modalInstance : $modalInstance,
		searchInfos : searchInfos,
		initScopeData : function($scope) {
			//healthServicePackDef.initScopeData($scope);
		}
	});
	$scope.healthServicePackDefList=healthServicePackDefs;
	console.log("$scope.healthServicePackDefList=",$scope.healthServicePackDefList);
	$scope.cysBoolStatus = cysBoolStatus;
	
	$scope.patient = {}; //获得一位用户信息
	  //选择用户
    $scope.selectPatient = function () {
        var modalInstance = $modal.open({
            templateUrl: '../../../assets/views/common/selectPatient.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectPatientCtrl',
            size:"lg",
            resolve: {}
        });
        modalInstance.result.then(function (result) {
            for (var k in result) {
                $scope.patient[k] = result[k];
            }
        });
    };
    

    $scope.ok = function (e) {
        if ($scope.patient) {
            $scope.searchInfos.masterPatientId = $scope.patient.jdPatientId;
        }
    	//if($("#s_activeDateEnd").val()!=''&&$("#s_activeDateEnd").val()!=null){
    		$scope.searchInfos.activeDateEnd = $("#s_activeDateEnd").val();
    	//}
    	//if($("#s_activeDateStart").val()!=''&&$("#s_activeDateStart").val()!=null){
    		$scope.searchInfos.activeDateStart = $("#s_activeDateStart").val();
    	//}
    	//if($("#s_serviceExpiredStart").val()!=''&&$("#s_serviceExpiredStart").val()!=null){
    		$scope.searchInfos.serviceExpiredStart = $("#s_serviceExpiredStart").val();
    	//}
    	//if($("#s_serviceExpiredEnd").val()!=''&&$("#s_serviceExpiredEnd").val()!=null){
    		$scope.searchInfos.serviceExpiredEnd = $("#s_serviceExpiredEnd").val();
    	//}

        $modalInstance.close($scope.searchInfos);
    };
});


app.controller('editMemberManageCtrl', function($scope, $http, $modalInstance,$modal, toaster, obj,healthServicePackDefs) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};
	 
	if (obj) {
		$scope.obj = obj;
	} else {
	}
	console.log("$scope.obj=",$scope.obj);
	
	initEdit({
		//initScopeData : healthServicePack.initScopeData,
		$scope : $scope,
		$modalInstance : $modalInstance,
		toaster : toaster
	});
    
    
	$scope.ok = function(e) {
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.obj.serviceExpiredDate], ["结束时间不能为空"]))
			return;
		

		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			filterField($scope.obj,"properties");
			filterField($scope.obj,"services");
			filterField($scope.obj,"exchangeExpiredDate");
			filterField($scope.obj,"activeDate");
			$scope.serviceExpiredDateStr=$('#serviceExpiredDateStr').val();
			$scope.obj.serviceExpiredDate = new Date($scope.serviceExpiredDateStr);
			
			$http.post(REST_PREFIX + "healthManage/updateHealthServicePackToMember", $scope.obj).success(function(result) {
				console.log("result=",JSON.stringify(result,null,4));
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





app.controller('addMemberManageCtrl', function($scope, $http, $modalInstance,$modal, toaster, obj,healthServicePackDefs) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};
	$scope.selected = [] ;
	var services;
	$scope.patient = {}; //获得一位用户信息
	$scope.healthServicePack = {}; //获得一位用户信息
	 
	 
	if (obj) {
		/*$scope.obj = obj;
		booleanToString($scope.obj);
		$scope.patient.jdPatientId = obj.masterPatientId;
	    $scope.patient.name = obj.patientName;*/
	} else {
		// 默认值设置
		$scope.obj.isDelivered="false";
		$scope.obj.isActivated="false";
	}
	$scope.healthServicePackDefList=healthServicePackDefs;
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
	
	console.log("$scope 1",$scope);
    //选择兑换码
    $scope.selectHealthServicePack = function () {
        var modalInstance = $modal.open({
            templateUrl: '../../../assets/views/common/selectHealthServicePack.html',
        	//templateUrl: 'selectHealthServicePack.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectHealthServicePackCtrl',
            size:"lg",
            resolve: {}
        });
        modalInstance.result.then(function (result) {
        	console.log("selectHealthServicePack result=",result);
            for (var k in result) {
                $scope.healthServicePack [k] = result[k];
            }
            console.log("selectHealthServicePack healthServicePack=",$scope.healthServicePack);
        });
    };
    
    //选择用户
    $scope.selectPatient = function () {
        var modalInstance = $modal.open({
            templateUrl: '../../../assets/views/common/selectPatient.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectPatientCtrl',
            size:"lg",
            resolve: {}
        });
        modalInstance.result.then(function (result) {
            for (var k in result) {
                $scope.patient[k] = result[k];
            }
        });
    };
    
    
	$scope.ok = function(e) {
        if ($scope.patient){
            $scope.obj.masterPatientId = $scope.patient.jdPatientId;
        }
        console.log("$scope.patient:",$scope.patient);
		// 校验相关
		if (!validateMulNull(toaster, [ $scope.healthServicePack.code,$scope.patient.name], ["兑换码不能为空",  "注册用户不能为空"]))
			return;
		

		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			filterField($scope.obj,"properties");
			filterField($scope.obj,"services");
			$scope.obj.masterPatientId = $scope.patient.jdPatientId;
			$scope.obj.code = $scope.healthServicePack.code;
			
			$http.post(REST_PREFIX + "healthManage/addHealthServicePackToMember", $scope.obj).success(function(result) {
				console.log("result=",JSON.stringify(result,null,4));
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


