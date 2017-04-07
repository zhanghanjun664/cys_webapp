'use strict';
app.controller('JdPushArticleCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert,cysIndexedDB,$rootScope) {
	$scope.resultPage = {totalCount:0};
	$scope.data = []; //当前页面的结果集
	$scope.selections = []; //当前页面选中的行

	$scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
        	commonResetSelection($scope);
			$scope.searchInfos.pageIndex = params.page();
			$scope.searchInfos.pageSize = params.count();
			$scope.queryString = getQueryString($scope.searchInfos);
			var requestUrl = REST_PREFIX+"jdPushArticle/list"+$scope.queryString;
			$http.get(requestUrl).success(function (result) {
				$scope.resultPage = result.resultPage;
				params.total($scope.resultPage.totalCount);
				params.page($scope.resultPage.nowPage);
				$scope.data = $scope.resultPage.result;
				$defer.resolve($scope.data);
			});
        }
    });
    //发送
	$scope.send = function (id) {
		SweetAlert.swal({
			title: "确定发送吗?",
			text: "文章会推送给关注此医生的用户",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "确定",
			cancelButtonText: "取消"
		}, function (isConfirm) {
			if (isConfirm) {
				toaster.pop("success", "提示", "正在推送给关注此医生的用户...");
				$http.post(REST_PREFIX+"jdPushArticle/send?id="+id).success(function(result) {
					if(result.result == 0) {
						toaster.pop("success", "提示", "推送成功");
					} else {
						toaster.pop("success", "提示", result.description);
					}
				});
			}
		});
	};
    //新增
    $scope.edit = function (jdPushArticle) {
    	var modalInstance = $modal.open({
            templateUrl: 'editJdPushArticle.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdPushArticleCtrl',
    		resolve: {
    			jdPushArticle : function() {
    				return jdPushArticle;
    			}
            }
        });
    	modalInstance.result.then(function (result) {
    		$scope.tableParams.reload();
        });
    };
    
    //删除操作
    $scope.deleteItem = function(id) {
        SweetAlert.swal({
            title: "确定删除吗?",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
          		$http.delete(REST_PREFIX+"jdPushArticle/"+id).success(function (result) {
					$scope.tableParams.reload();
				});
            }
        });
    };
    
    //改变当前选中的行
    $scope.changeSelection = function(index) {
    	commonChangeSelection($scope, index);
	};
	
	//全选/全不选
	$scope.selectAll = function() {
		commonSelectAll($scope);
	};
	
    //点击删除按钮
    $scope.deleteAll = function() {
    	commonDeleteButtonClick(toaster, $scope);
	};
	
    //点击编辑按钮
    $scope.update = function () {
    	commonEditButtonClick(toaster, $scope);
    };

    //点击查询按钮
	$scope.searchInfos = {name:null};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchJdPushArticle.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchJdPushArticleCtrl',
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



});
app.controller('searchJdPushArticleCtrl', function ($scope, $modalInstance, searchInfos) {
	$scope.searchInfos = searchInfos;
	$scope.ok = function (e) {
		$modalInstance.close($scope.searchInfos);
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	$scope.clear = function () {
		$scope.searchInfos = {name:null};
	};
});
app.controller('editJdPushArticleCtrl', function ($scope, $http,$modal, $modalInstance, toaster, jdPushArticle) {
    	$scope.submitFlag = false; //为防止表单重复提交
    	$scope.jdPushArticleInfo = {};
	    $scope.doctorName = "";
    	if(jdPushArticle) {
    		$scope.doctorName = jdPushArticle.doctorName;
			$scope.jdPushArticleInfo.uuid = jdPushArticle.uuid;
			$scope.jdPushArticleInfo.jdDoctorId = jdPushArticle.jdDoctorId;
			$scope.jdPushArticleInfo.title = jdPushArticle.title;
			$scope.jdPushArticleInfo.summary = jdPushArticle.summary;
			$scope.jdPushArticleInfo.url = jdPushArticle.url;
    	}
	//选择医生
	$scope.selectDoctor = function () {
		var modalInstance = $modal.open({
			templateUrl: 'selectDoctor.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'selectDoctorCtrl',
			size: "lg"
		});
		modalInstance.result.then(function (result) {
			$scope.doctorName = result.name;
			$scope.jdPushArticleInfo.jdDoctorId = result.jdDoctorId;
		});
	};

        $scope.ok = function (e) {
			if(!$scope.jdPushArticleInfo.jdDoctorId) {
				toaster.pop("error", "", "请选择医生", "1000");
				return;
			}
			if (!validateFiledNullMax(toaster, $scope.jdPushArticleInfo.title, "文章标题", true, 0)
				|| !validateFiledNullMax(toaster, $scope.jdPushArticleInfo.summary, "文章摘要", true, 0)
				 || !validateFiledNullMax(toaster, $scope.jdPushArticleInfo.url, "文章链接", true, 0))
				return;
        	//提交
        	if(!$scope.submitFlag) {
        		$scope.submitFlag = true;
        		if(jdPushArticle) {
					$http.put(REST_PREFIX+"jdPushArticle", $scope.jdPushArticleInfo).success(function(result) {
						$modalInstance.close("success");
					});
				} else {
					$http.post(REST_PREFIX+"jdPushArticle", $scope.jdPushArticleInfo).success(function(result) {
						$modalInstance.close("success");
					});
				}
        	}
        };
        $scope.cancel = function (e) {
            $modalInstance.dismiss();
        };



});
app.controller('selectDoctorCtrl', function ($scope, $http, $modalInstance, ngTableParams, toaster, $localStorage, Admin_Constant,$rootScope) {
	$scope.justopen = true;
	$scope.jdDistricts = []; //地区信息;
	$scope.jdHospitals = []; //医院信息;
	$scope.jdDepartments = [];//部门信息;
	$scope.jdTitles = [];//职称;
	//获得地区信息
	$scope.getDistrictInfos = function () {
		$scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
		if (!$scope.jdDistricts) {
			$http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
				$scope.jdDistricts = result.districtList;
				$localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
			});
		}
	};
	$scope.getDistrictInfos();
	//获得部门信息
	$scope.getDepartmentInfos = function () {
		$scope.jdDepartments = $localStorage[Admin_Constant.LocalStorage.Departments];
		if (!$scope.jdDepartments) {
			$http.get(REST_PREFIX + "jdDepartment/list").success(function (result) {
				$scope.jdDepartments = result.departmentList;
				$localStorage[Admin_Constant.LocalStorage.Departments] = $scope.jdDepartments;
			});
		}
	};
	$scope.getDepartmentInfos();
	//获得职称信息
	$scope.getTitleInfos = function () {
		$scope.jdTitles = $localStorage[Admin_Constant.LocalStorage.Titles];
		if (!$scope.jdTitles) {
			$http.get(REST_PREFIX + "jdTitle/list").success(function (result) {
				$scope.jdTitles = result.titleList;
				$localStorage[Admin_Constant.LocalStorage.Titles] = $scope.jdTitles;
			});
		}
	};
	$scope.getTitleInfos();

	$scope.resultPage = {totalCount: 0};
	$scope.data = []; //当前页面的结果集
	$scope.selections = []; //当前页面选中的行
	$scope.searchInfo = {pageIndex: 1, pageSize: 10};
	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultPage.totalCount,
		getData: function ($defer, params) {
			if ($scope.justopen) {
				$scope.justopen = false;
			} else {
				commonResetSelection($scope);
				$scope.searchInfo.pageIndex = params.page();
				$scope.searchInfo.pageSize = params.count();
				$scope.queryString = getQueryString($scope.searchInfo);
				var requestUrl = REST_PREFIX + "doctor/list" + $scope.queryString;
				$http.get(requestUrl).success(function (result) {
					$scope.resultPage = result.resultPage;
					params.total($scope.resultPage.totalCount);
					params.page($scope.resultPage.nowPage);
					$scope.data = $scope.resultPage.result;
					$defer.resolve($scope.data);
				});
			}
		}
	});

	$scope.changeSelection = function (index) {
		commonChangeSelection($scope, index);
	};

	$scope.query = function () {
		$scope.tableParams.reload();
	};

	//根据地区获得医院结果集
	$scope.onDistrictChange = function (districtId) {





		if (!$rootScope.jdHospitals) {

			var url = REST_PREFIX + "jdHospital/search?jd_district_id=" + districtId;
			$http.get(url).success(function (result) {
				$scope.jdHospitals = result.hospitalList;
			});
		} else {
			var temp = [];
			$rootScope.jdHospitals.forEach(function (item) {
				if (item.jdDistrictId == districtId) {
					temp.push(item);
				}
			});
			$scope.jdHospitals = temp;
		}
	};

	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};

	$scope.ok = function (e) {
		if ($scope.selections.length == 0) {
			toaster.pop("warning", "", "请选择一条记录", "1000");
		} else if ($scope.selections.length > 1) {
			toaster.pop("warning", "", "请只选择一条记录", "1000");
		} else {
			var rowObject = new Object();
			rowObject.name = $scope.selections[0].name;
			rowObject.jdDoctorId = $scope.selections[0].uuid;
			$modalInstance.close(rowObject);
		}
	};

	$scope.clear = function (e) {
		var rowObject = new Object();
		rowObject.name = "";
		rowObject.jdDoctorId = "";
		$modalInstance.close(rowObject);
	};
});