'use strict';
app.controller('JdCommentCtrl', function ($scope, $http, $modal, toaster, ngTableParams, $localStorage, Admin_Constant,$rootScope,cysIndexedDB) {
	$scope.jdDistricts = []; //地区信息
	$scope.jdHospitals = []; //医院信息
	$scope.resultPage = {totalCount:0};
    var jdDistricts = []; //省份-地区信息
    var jdDistrictAreas = []; //市区-地区信息

	$scope.getAttachInfos = function () {
        //获取地区信息
        jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(jdDistricts.length == 0) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] =jdDistricts;
            });
        }
        $scope.jdDistricts = jdDistricts.filter(function(districts){
            if(districts.isProvince){
                return districts;
            }
        });
        //获得市辖区信息
        jdDistrictAreas = $localStorage[Admin_Constant.LocalStorage.DistrictAreas];
        if(!jdDistrictAreas) {
            $http.get(REST_PREFIX + "jdDistrictArea/list").success(function (result) {
                $scope.jdDistrictAreas = result.districtAreaList;
                $localStorage[Admin_Constant.LocalStorage.DistrictAreas] = $scope.jdDistrictAreas;
            });
        }


		//判断是否存在版本号
		if(window.localStorage.getItem('hospitalVersionKey')){

			var oldKey=window.localStorage.getItem('hospitalVersionKey');

			if(oldKey===null||oldKey===""||oldKey===undefined){
				return false;
			}

			cysIndexedDB.openDB();
			$http.get(REST_PREFIX + "jdHospital/dataset_info").success(function (result) {
				var newKey=result.lastModifiedTime+result.count;

				if(newKey!==oldKey){
					$http.get(REST_PREFIX + "jdHospital/list").success(function (result) {
						$scope.jdHospitals = result.hospitalList;
						cysIndexedDB.addData(cysIndexedDB.db,'hospital',result.hospitalList);
						window.localStorage.setItem('hospitalVersionKey',newKey);
					});
				}else{
					setTimeout(function(){
						$scope.jdHospitals=$rootScope.jdHospitals;
					},1000);
				}

			});


		}else {

			//获取最新的版本号
			$http.get(REST_PREFIX + "jdHospital/dataset_info").success(function (result) {
				var key=result.lastModifiedTime+result.count;
				cysIndexedDB.openDB();
				//请求数据
				$http.get(REST_PREFIX + "jdHospital/list").success(function (result) {
					$scope.jdHospitals = result.hospitalList;
					cysIndexedDB.addData(cysIndexedDB.db,'hospital',result.hospitalList);
					window.localStorage.setItem('hospitalVersionKey',key);
				});

			});

		}
	};

	$scope.getAttachInfos();

	$scope.districtChange = function(districtId) {
		$scope.jdHospitals = [];
		$scope.searchInfos.hospitalId = "";
		jdHospitals.forEach(function(jdHospital) {
			if(jdHospital.jdDistrictId == districtId)
				$scope.jdHospitals.push(jdHospital);
		});
	};

	//根据地区ID显示地区的名称
	$scope.displayDistrictName = function (districtId) {
		for(var i = 0; i < $scope.jdDistricts.length; i++) {
			if($scope.jdDistricts[i].uuid == districtId)
				return $scope.jdDistricts[i].name;
		}
	};
	//根据医院ID显示医院的名称
	$scope.displayHospitalName = function (hospitalId) {
		for(var i = 0; i < $scope.jdHospitals.length; i++) {
			if($scope.jdHospitals[i].hospitalId == hospitalId)
				return $scope.jdHospitals[i].name;
		}
	};

	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultPage.totalCount,
		getData: function ($defer, params) {
			$scope.searchInfos.pageIndex = params.page();
			$scope.searchInfos.pageSize = params.count();
			$scope.queryString = getQueryString($scope.searchInfos);
			var requestUrl = REST_PREFIX+"comment/list"+$scope.queryString;
			$http.get(requestUrl).success(function (result) {
				$scope.resultPage = result.resultPage;
				params.total($scope.resultPage.totalCount);
				params.page($scope.resultPage.nowPage);
				$defer.resolve($scope.resultPage.result);
			});
		}
	});

	//显示等待时间描述
	$scope.showWaitTime = function(waitTime) {
		if(waitTime == 0)
			return "无等待";
		else if(waitTime == 10)
			return "5-30分钟";
		else if(waitTime == 20)
			return ">30分钟";
		else
			return "";
	};

	$scope.hide = function(jdComment) {
		var comment = {};
		comment.uuid = jdComment.uuid;
		$http.put(REST_PREFIX+"comment/hide", comment).success(function() {
			toaster.pop("success", "提示", "操作成功");
			$scope.tableParams.reload();
		});
	};

	$scope.show = function(jdComment) {
		var comment = {};
		comment.uuid = jdComment.uuid;
		$http.put(REST_PREFIX+"comment/show", comment).success(function() {
			toaster.pop("success", "提示", "操作成功");
			$scope.tableParams.reload();
		});
	};

	//点击查询按钮
	$scope.searchInfos = {orderNumber:null,stars:"",phoneNumber:null,districtId:null,hospitalId:null,doctorName:null,patientName:null,availableStartTime:null,availableEndTime:null};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchJdComment.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchJdCommentCtrl',
			resolve: {
				searchInfos : function() {
					return $scope.searchInfos;
				},
				jdDistricts : function() {
					return $scope.jdDistricts;
				},
                jdDistrictAreas : function() {
                    return $scope.jdDistrictAreas;
                },
				jdHospitals : function() {
					return $scope.jdHospitals;
				}
			}
		});
		modalInstance.result.then(function (searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.tableParams.reload();
		});
	};

});
app.controller('searchJdCommentCtrl', function ($scope, $modalInstance, searchInfos, jdDistricts, jdHospitals,jdDistrictAreas) {
	$scope.jdDistricts = jdDistricts;
	$scope.jdDistrictAreas = jdDistrictAreas;
	$scope.searchInfos = searchInfos;
	$scope.jdHospitals = [];
	//根据选择的地区加载医院列表
	$scope.districtChange = function(districtId) {
		$scope.jdHospitals = [];
		$scope.searchInfos.hospitalId = "";
		jdHospitals.forEach(function(jdHospital) {
			if(jdHospital.jdDistrictId == districtId)
				$scope.jdHospitals.push(jdHospital);
		});
	};
	if($scope.searchInfos.districtId) {
		jdHospitals.forEach(function(jdHospital) {
			if(jdHospital.jdDistrictId == $scope.searchInfos.districtId)
				$scope.jdHospitals.push(jdHospital);
		});
	}
    //根据地区Id得到市辖区信息
    $scope.changeDistrictAreas = function (districtId){
        $scope.jdDistrictAreas = [];
        $scope.searchInfos.districtAreaId = "";
        jdDistrictAreas.forEach(function(item){
            if (item.jdDistrictId == districtId && item.isCity)
                $scope.jdDistrictAreas.push(item);
        });
    };

    $scope.setDistrictArea = function (){
        if($scope.searchInfos != undefined && $scope.searchInfos != null){
            for (var i=0; i<jdDistrictAreas.length; i++){
                if (jdDistrictAreas[i].jdDistrictId == $scope.searchInfos.districtId){
                    $scope.jdDistrictAreas.push(jdDistrictAreas[i]);
                }
            }
        }
    };
	$scope.ok = function (e) {
        $scope.searchInfos.availableStartTime = $("#availableStartTime").val();
        $scope.searchInfos.availableEndTime = $("#availableEndTime").val();
        $scope.searchInfos.province = "";
        $scope.searchInfos.city = "";
        if($("#districtId").find("option:selected").text() != null
            && $("#districtId").find("option:selected").text() != ''
            && $("#districtId").find("option:selected").text() != '全部'){
            var province = $("#districtId").find("option:selected").text();
            $scope.searchInfos.province =province.replace("省","");
        }
        if($("#districtAreaId").find("option:selected").text() != null
            && $("#districtAreaId").find("option:selected").text() != ''
            && $("#districtAreaId").find("option:selected").text() != '全部'){
            var city = $("#districtAreaId").find("option:selected").text();
            $scope.searchInfos.city = city.replace("市","");
        }
		$modalInstance.close($scope.searchInfos);
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	$scope.clear = function () {
		$scope.searchInfos = {orderNumber:null,stars:"",phoneNumber:null,districtId:null,hospitalId:null,
			doctorName:null,patientName:null,availableStartTime:null,availableEndTime:null,
            province:null,city:null,districtAreaId:null};
	};
});