var healthServicePack = {
	// 初始化页面数据与方法
	healthServiceList:null,
	initScopeData : function($scope) {
		healthServicePack.healthServiceList = ($scope.healthServiceList = healthServicePack.healthServiceList ? healthServicePack.healthServiceList
				: healthServicePack.initHealthServiceList());
		console.log("healthServicePack.healthServiceList=",healthServicePack.healthServiceList);
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
		console.log("initHealthServiceList list=",list);
		return list;
	}
	
}
var healthServicePackDef = {
		// 初始化页面数据与方法
		healthServicePackDefList:null,
		initScopeData : function($scope) {
			//debugger;
			healthServicePackDef.healthServicePackDefList = ($scope.healthServicePackDefList = healthServicePackDef.healthServicePackDefList ? healthServicePackDef.healthServicePackDefList
					: healthServicePackDef.initHealthServicePackDefList());
		},
		initHealthServicePackDefList:function(){
			var list = [];
			ajax(REST_PREFIX + "healthManage/healthServicePackDef/all", function(result) {
				if (result.body && result.body.code == 2000) {
					var data = result.body.result;
					for (var i = 0; i < data.length; i++) {
						list.push({
							name : data[i].name,
							id : data[i].id,
							price:data[i].price,
							periodOfValidity:data[i].periodOfValidity,
							selected:false
						});
					}
				}
			});
			console.log("healthServicePackDef list=",list);
			return list;
		}
		
	}


