'use strict';

var jdHealthExamination = {
	// 初始化页面数据与方法
	sourceList : null,
	initSourceList : function() {
		var list = [];
		list.push({
			name : '手工录入',
			value : 'MANUAL'
		});
		list.push({
			name : '血压计录入',
			value : 'DEVICE'
		});
		return list;
	},
	initScopeData : function($scope) {
		jdHealthExamination.sourceList = ($scope.sourceList = jdHealthExamination.sourceList ? jdHealthExamination.sourceList : jdHealthExamination
				.initSourceList());
	},
	getSourceName:function(value){
		if(value){
			if(value=='MANUAL')
				return '手工录入';
			else
				return '血压计录入';
		}else{
			return '手工录入';
		}
		
	}
}
app.controller('JdHealthExaminationCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    $scope.getItemName = getItemName;
    $scope.getSourceName=jdHealthExamination.getSourceName;
    jdHealthExamination.initScopeData($scope);
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
            var requestUrl = REST_PREFIX + "jdHealthExamination/bloodPressure/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result
                $defer.resolve($scope.data);
            });
        }
    });

    //新增
    $scope.edit = function (jdHealthExamination) {
        var modalInstance = $modal.open({
            templateUrl: 'editJdHealthExamination.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdHealthExaminationCtrl',
            resolve: {
                jdHealthExamination: function () {
                    return jdHealthExamination;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };

    //删除操作
    $scope.deleteItem = function (id) {
        SweetAlert.swal({
            title: "确定删除吗?",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
                $http.delete(REST_PREFIX + "jdHealthExamination/" + id).success(function (result) {
                    if (result.result != 0) {
                        toaster.pop("error", "提示", "健康测量【" + result.description + "】已被引用，不能删除");
                    } else {
                        $scope.tableParams.reload();
                    }
                });
            }
        });
    };

    //改变当前选中的行
    $scope.changeSelection = function (index) {
        commonChangeSelection($scope, index);
    };

    //全选/全不选
    $scope.selectAll = function () {
        commonSelectAll($scope);
    };

    //点击删除按钮
    $scope.deleteAll = function () {
        commonDeleteButtonClick(toaster, $scope);
    };

    //点击编辑按钮
    $scope.update = function () {
        commonEditButtonClick(toaster, $scope);
    };

    $scope.searchInfos = {patientName: null, phoneNumber: null, examDateStart: null, examDateEnd: null};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdHealthExamination.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdHealthExaminationCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    }
});
app.controller('searchJdHealthExaminationCtrl', function ($scope, $modalInstance, $modal, searchInfos) {
	$scope.searchInfos = searchInfos;   //查询条件
	jdHealthExamination.initScopeData($scope);

    $("#examDateStart_ex").val($scope.searchInfos.examDateStart);    //测量时间开始
    $("#examDateEnd_ex").val($scope.searchInfos.examDateEnd);    //测量时间开始

    $scope.ok = function (e) {
        $scope.searchInfos.examDateStart = $("#examDateStart_ex").val();
        $scope.searchInfos.examDateEnd = $("#examDateEnd_ex").val();
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    //清空查询条件
    $scope.clear = function () {
        $scope.searchInfos = {patientName: null, phoneNumber: null, examDateStart: null, examDateEnd: null};
        $("#examDateStart_ex").val();
        $("#examDateEnd_ex").val();
    };
});
app.controller('selectPatientCtrl', function ($scope, $http, $modalInstance, ngTableParams, toaster, $localStorage, Admin_Constant) {
    $scope.justopen = true;

    $scope.resultPage = {totalCount: 0};
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行
    var jdDistricts = []; //地区信息
    var jdDistrictAreas = []; //地区信息

    $scope.getAttachInfos = function () {
        //获取地区信息
        jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(jdDistricts.length == 0) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = jdDistricts;
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
                jdDistrictAreas = result.districtAreaList;
                $localStorage[Admin_Constant.LocalStorage.DistrictAreas] = jdDistrictAreas;
            });
        }

        // $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        // if (!$scope.jdDistricts) {
        //     $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
        //         $scope.jdDistricts = result.districtList;
        //         $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
        //     });
        // }
        //console.log("呵呵好");
        //获取渠道信息
        //$scope.jdQrcodeList = angular.copy($localStorage[Admin_Constant.LocalStorage.QrCodes]);
        //if(!$scope.jdQrcodeList) {
        //    $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
        //        $scope.jdQrcodeList = result.jdQrcodeList;
        //        $localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
        //        $scope.jdQrcodeList.push({"uuid": "0", "name": "无"});
        //    });
        //} else {
        //    $scope.jdQrcodeList.push({"uuid": "0", "name": "无"});
        //}
    };
    $scope.getAttachInfos();

    //根据地区ID显示地区的名称
    $scope.displayDistrictName = function (districtId) {
        for (var i = 0; i < $scope.jdDistricts.length; i++) {
            if ($scope.jdDistricts[i].uuid == districtId)
                return $scope.jdDistricts[i].name;
        }
    };

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
                $scope.patientInfos.pageIndex = params.page();
                $scope.patientInfos.pageSize = params.count();
                $scope.patientInfos.masterOnly = true;
                $scope.queryString = getQueryString($scope.patientInfos);
                var requestUrl = REST_PREFIX + "patient/list" + $scope.queryString;
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

    //改变当前选中的行
    $scope.changeSelection = function (index) {
        commonChangeSelection($scope, index);
    };

    $scope.patientInfos = {
        districtId: null,
        createTimeStart: null,
        createTimeEnd: null,
        name: null,
        phoneNumber: null,
        qrcodeId: null
    };
    $("#createTimeEnd").val($scope.patientInfos.createTimeEnd);
    $("#createTimeStart").val($scope.patientInfos.createTimeStart);

    //查询
    $scope.query = function () {
        $scope.patientInfos.createTimeStart = $("#createTimeStart").val();
        $scope.patientInfos.createTimeEnd = $("#createTimeEnd").val();
        $scope.searchInfos.province = "";
        $scope.searchInfos.city = "";
        if($("#districtId").find("option:selected").text() != null
            && $("#districtId").find("option:selected").text() != ''
            && $("#districtId").find("option:selected").text() != '全部'){
            var province = $("#districtId").find("option:selected").text();
            $scope.patientInfos.province =province.replace("省","");

        }
        if($("#districtAreaId").find("option:selected").text() != null
            && $("#districtAreaId").find("option:selected").text() != ''
            && $("#districtAreaId").find("option:selected").text() != '全部'){
            var city = $("#districtAreaId").find("option:selected").text();
            $scope.patientInfos.city = city.replace("市","");
        }
        $scope.tableParams.reload();
    };
    $scope.ok = function (e) {
        if ($scope.selections.length == 0) {
            toaster.pop("warning", "", "请选择一条记录", "1000");
        } else if ($scope.selections.length > 1) {
            toaster.pop("warning", "", "请只选择一条记录", "1000");
        } else {
            var rowObject = new Object();
            rowObject.jdPatientId = $scope.selections[0].uuid;
            rowObject.name = $scope.selections[0].name;
            $modalInstance.close(rowObject);
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        commonResetSelection($scope);
        $scope.patientInfos = {
            districtId: null,
            createTimeStart: null,
            createTimeEnd: null,
            name: null,
            phoneNumber: null,
            qrcodeId: null
        };
    };
});
app.controller('editJdHealthExaminationCtrl', function ($scope, $http, $modal, $modalInstance, ngTableParams, toaster, SweetAlert, jdHealthExamination) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.jdHealthExaminationInfo = {};   //现金券信息
    $scope.patient = {}; //获得一位用户信息

    if (jdHealthExamination) {
        $scope.jdHealthExaminationInfo.uuid = jdHealthExamination.uuid;
        $scope.patient.jdPatientId = jdHealthExamination.jdPatientId;
        $scope.patient.name = jdHealthExamination.patientName;
        $scope.jdHealthExaminationInfo.examDateAsString = jdHealthExamination.examDate;
        $scope.jdHealthExaminationInfo.diastolicPressure = jdHealthExamination.diastolicPressure;
        $scope.jdHealthExaminationInfo.systolicPressure = jdHealthExamination.systolicPressure;
        $scope.jdHealthExaminationInfo.heartRate = jdHealthExamination.heartRate;
    }
    //选择用户
    $scope.selectPatient = function () {
        var modalInstance = $modal.open({
            templateUrl: 'selectPatient.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectPatientCtrl',
            size: "lg",
            resolve: {}
        });
        modalInstance.result.then(function (result) {
            for (var k in result) {
                $scope.patient[k] = result[k];
            }
        });
    };
    $("#examDateAsString").val($scope.jdHealthExaminationInfo.examDateAsString);    //测量时间

    $scope.ok = function (e) {
        if ($scope.patient) {
            $scope.jdHealthExaminationInfo.jdPatientId = $scope.patient.jdPatientId;
            $scope.jdHealthExaminationInfo.patientName = $scope.patient.name;
        }
        $scope.jdHealthExaminationInfo.examDateAsString = $("#examDateAsString").val();
        if (!validateFiledNullMax(toaster, $scope.jdHealthExaminationInfo.jdPatientId, "用户", true, 0)
            || !validateFiledNullMax(toaster, $scope.jdHealthExaminationInfo.examDateAsString, "测量时间", true, 0)
            || !validateFiledInteger(toaster, $scope.jdHealthExaminationInfo.diastolicPressure, "舒张压", false, false)
            || !validateFiledInteger(toaster, $scope.jdHealthExaminationInfo.systolicPressure, "收缩压", false, false)
            || !validateFiledInteger(toaster, $scope.jdHealthExaminationInfo.heartRate, "心率", false, false)) {
            return;
        }
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            if (jdHealthExamination) {
                $http.put(REST_PREFIX + "jdHealthExamination", $scope.jdHealthExaminationInfo).success(function (result) {
                    if (result.result == 1) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "用户【" + $scope.jdHealthExaminationInfo.patientName + "】在【"+ $scope.jdHealthExaminationInfo.examDateAsString + "】记录已存在");
                    } else {
                        toaster.pop("success", "提示", "保存成功");
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX + "jdHealthExamination", $scope.jdHealthExaminationInfo).success(function (result) {
                    if (result.result == 1) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "用户【" + $scope.jdHealthExaminationInfo.patientName + "】在【"+ $scope.jdHealthExaminationInfo.examDateAsString + "】记录已存在");
                    } else {
                        toaster.pop("success", "提示", "保存成功");
                        $modalInstance.close("success");
                    }
                });
            }
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});
app.controller('JdBloodGlucoseCtrl', function ($scope, $http, $modal, ngTableParams) {
    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
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
            var requestUrl = REST_PREFIX + "jdHealthExamination/bloodGlucose/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result
                $defer.resolve($scope.data);
            });
        }
    });

    $scope.searchInfos = {patientName: null, phoneNumber: null, examDateStart: null, examDateEnd: null};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdBloodGlucose.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdBloodGlucoseCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    }
});
app.controller('searchJdBloodGlucoseCtrl', function ($scope, $modalInstance, $modal, searchInfos) {
    $scope.searchInfos = searchInfos;   //查询条件

    $("#examDateStart").val($scope.searchInfos.examDateStart);    //测量时间开始
    $("#examDateEnd").val($scope.searchInfos.examDateEnd);    //测量时间开始

    $scope.ok = function (e) {
        $scope.searchInfos.examDateStart = $("#examDateStart").val();
        $scope.searchInfos.examDateEnd = $("#examDateEnd").val();
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    //清空查询条件
    $scope.clear = function () {
        $scope.searchInfos = {patientName: null, phoneNumber: null, examDateStart: null, examDateEnd: null};
        $("#examDateStart").val();
        $("#examDateEnd").val();
    };
});
