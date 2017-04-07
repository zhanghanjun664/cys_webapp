'use strict';
//最外层控制器
app.controller("DoctorParentCtrl", function($scope) {
	$scope.$on("doctorSelectChange", function (event, msg) {
		$scope.$broadcast("teamDoctorList", msg);
		
	});
});
//医生列表信息控制器
app.controller('DoctorTeamCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $localStorage, Admin_Constant) {
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
			var requestUrl = REST_PREFIX+"doctor_team/list"+$scope.queryString;
			$http.get(requestUrl).success(function (result) {
				$scope.resultPage = result.resultPage;
				params.total($scope.resultPage.totalRecords);
				//params.page($scope.resultPage.nowPage);
				$scope.data = $scope.resultPage.content;
				$defer.resolve($scope.data);

				if($scope.resultPage.content[0]) {
					$scope.selectTeamid = $scope.resultPage.content[0].id;
				} else {
					$scope.selectTeamid = "";
				}
				$scope.$emit("doctorSelectChange", $scope.selectTeamid);
			});
        }
    });
	
    
    //改变当前选中的行(checkbox)
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

	//点击行加载子tab内容
	$scope.doctorSelectChange = function(teamid) {
		if($scope.selectTeamid == teamid)
			return;
		$(".tr_doctor").removeClass("info");
		$scope.selectTeamid = teamid;
		$scope.$emit("doctorSelectChange", $scope.selectTeamid);
	};

	//点击查询按钮
	$scope.searchInfos = {createTimeStart:null,createTimeEnd:null,districtId:null,hospitalId:null,departmentId:null,titleId:null,statusId:null,name:null,phoneNumber:null};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchJdDoctor.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchJdDoctorCtrl',
			resolve: {
				searchInfos : function() {
					return $scope.searchInfos;
				},
				jdDistricts : function() {
					return $scope.jdDistricts;
				},
				jdHospitals : function() {
					return $scope.jdHospitals;
				},
				jdDepartments : function() {
					return $scope.jdDepartments;
				},
				jdTitles : function() {
					return $scope.jdTitles;
				}
			}
		});
		modalInstance.result.then(function (searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.tableParams.reload();
		});
	}

});


/** start 订单历史TAB **/
app.controller('TeamDoctorListCtrl', function ($scope, $http, $modal, ngTableParams) {
	$scope.$on("teamDoctorList", function (event, msg) {
		$scope.teamid = msg;
		if(msg)
			$scope.getData();
		else {
			$scope.resultData = [];
			$scope.showData = [];
			$scope.data = [];
			$scope.tableParams.reload();
		}
	});
	$scope.resultPage = {totalCount:0};
	$scope.resultData = []; //后台返回总的结果集
	$scope.showData = []; //当前选中类型的结果集
	$scope.data = []; //当前页面的结果集

	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.showData.length,
		getData: function ($defer, params) {
			params.total($scope.showData.length);
			commonResetSelection($scope);
			$scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
			if($scope.data.length == 0 && params.page() > 1) { //删除操作后如果当前页没有数据，自动跳转到前一页
				params.page(params.page() - 1);
				$scope.tableParams.reload();
			}
			$defer.resolve($scope.data);
		}
	});

	//获取预约历史列表数据
	$scope.getData = function() {
		$http.get(REST_PREFIX+"doctor_team/one_team_doctor_list/?teamid="+$scope.teamid).success(function (result) {
			$scope.resultPage = result.resultPage;
			$scope.resultData = $scope.resultPage.content;
			$scope.tableParams.reload();
			$(".tr_doctor").removeClass("info");
			$("#tr"+$scope.teamid).addClass("info");
		});
	};

	
	

	$scope.edit = function (jdOrder) {
		var modalInstance = $modal.open({
			templateUrl: 'editOrder.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'editOrderCtrl',
			resolve: {
				jdOrder : function() {
					return jdOrder;
				}
			}
		});
		modalInstance.result.then(function (result) {
			$scope.getData();
		});
	};

});
app.controller('editOrderCtrl', function ($scope, $http, $modalInstance, toaster, jdOrder) {
	$scope.submitFlag = false; //为防止表单重复提交
	$scope.jdOrderInfo = {};
	if(jdOrder) {
		$scope.jdOrder = jdOrder;
		$scope.jdOrderInfo.uuid = jdOrder.uuid;
		$scope.jdOrderInfo.orderNumber = jdOrder.orderNumber;
		$scope.jdOrderInfo.name = jdOrder.name;
		$scope.jdOrderInfo.phoneNumber = jdOrder.phoneNumber;
		$scope.jdOrderInfo.age = jdOrder.age;
		$scope.jdOrderInfo.sickDescription = jdOrder.sickDescription;
		$scope.jdOrderInfo.status = jdOrder.status;
	}
	if($scope.jdOrderInfo.status == "WAITTO_DIAGNOSE") {
		$scope.orderStatus = [
			{value:"WAITTO_DIAGNOSE",name:"待出诊"},
			{value:"WAITTO_COMMENT",name:"已出诊"},
			{value:"CANCEL_WITHIN",name:"取消(一小时内)"},
			{value:"CANCEL_OVERTIME",name:"取消(一小时后)"},
			{value:"CANCEL_DOCTOR",name:"医生取消"},
			{value:"PATIENT_MISS",name:"患者爽约"}
		];
	} else if($scope.jdOrderInfo.status == "WAITTO_CONFIRM") {
		$scope.orderStatus = [
			{value:"WAITTO_CONFIRM",name:"待确认"},
			{value:"WAITTO_COMMENT",name:"已出诊"},
			{value:"CANCEL_WITHIN",name:"取消(一小时内)"},
			{value:"CANCEL_OVERTIME",name:"取消(一小时后)"},
			{value:"CANCEL_DOCTOR",name:"医生取消"},
			{value:"PATIENT_MISS",name:"患者爽约"}
		];
	}
	$scope.ok = function (e) {
		//提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.put(REST_PREFIX+"doctor/order", $scope.jdOrderInfo).success(function() {
				$modalInstance.close("success");
			});
		}
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	//根据订单状态的值显示对应的描述
	$scope.showOrderStatus = function(status) {
		return showOrderStatus(status, true);
	}
});
/** end 订单历史TAB **/


app.controller('editDoctorServiceCtrl', function ($scope, $http, $modalInstance, toaster, doctorService, doctorId) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.doctorService = {};
    if(doctorService) {
        $scope.doctorService.id = doctorService.id;
        $scope.doctorService.price = doctorService.price;
        $scope.doctorService.serviceType = doctorService.serviceType;
        $scope.doctorService.serviceDesc = doctorService.serviceDesc;
        $scope.doctorService.providerType = doctorService.providerType;
        $scope.doctorService.providerId = doctorService.providerId;
        $scope.doctorService.status = doctorService.status;
        $scope.doctorService.statusDesc = doctorService.statusDesc;
        $scope.doctorService.freePeriod = doctorService.freePeriod;
    } else {
        $scope.doctorService.status = "false";
    }
    $scope.ok = function (e) {
        if(!validateFiledInteger(toaster, $scope.doctorService.price, "价格", false, true)) {
            return;
        }
        //提交
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            $http.post(REST_PREFIX + "doctor/service", $scope.doctorService).success(function(result) {
                if(result.body.code != 2000) {
                    $scope.submitFlag = false;
                    toaster.pop("error", "提示", "服务器不开心啦");
                } else {
                    $modalInstance.close("success");
                }
            });
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});



//图片查看控制器
app.controller('ImageViewCtrl', function ($scope, $modalInstance, jdDoctorInfo) {
    $scope.jdDoctorInfo = jdDoctorInfo;
    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    }
});

/** end 医生诊金TAB **/