'ues strict'
app.controller('noVisitedTimeCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert,cysIndexedDB,$rootScope) {
    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    $scope.rowObject = {};

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            commonResetSelection($scope);
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            if ($scope.rowObject.jdDoctorId != undefined && $scope.rowObject.jdDoctorId != "" && $scope.rowObject.jdDoctorId != null)
                $scope.searchInfos.jd_doctor_id = $scope.rowObject.jdDoctorId;
            $scope.searchInfos.name = $scope.rowObject.name;
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "noVisitedTime/List" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);
            });
        }
    });

    $scope.days = [
        {id: "0", day: "星期日"}, {id: "1", day: "星期一"}, {id: "2", day: "星期二"},
        {id: "3", day: "星期三"}, {id: "4", day: "星期四"}, {id: "5", day: "星期五"},
        {id: "6", day: "星期六"}
    ];

    //根据dateDay显示星期几
    $scope.displayDay = function (dateDay) {
        for (var i = 0; i < $scope.days.length; i++) {
            if ($scope.days[i].id == dateDay)
                return $scope.days[i].day;
        }
    };

    //新增
    $scope.edit = function (dateModel) {
        var modalInstance = $modal.open({
            templateUrl: 'noVisitedTimeEdit.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'noVisitedTimeEditCtrl',
            size: 'lg',
            resolve: {
                dateModel: function () {
                    return dateModel;
                },
                days: function () {
                    return $scope.days;
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
                $http.delete(REST_PREFIX + "noVisitedTime/" + id).success(function (result) {
                    $scope.tableParams.reload();
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

    $scope.searchInfos = {jd_doctor_id: null, name: null};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'selectDoctor.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectDoctorCtrl',
            size: 'lg',
            resolve: {}
        });
        modalInstance.result.then(function (result) {
            for (var k in result) {
                $scope.rowObject[k] = result[k];
            }
            $scope.tableParams.reload();
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


});

app.controller('noVisitedTimeEditCtrl', function ($scope, $http, $modalInstance, $modal, toaster, dateModel, days) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.rowObject = {};
    $scope.flag = false;
    if (dateModel) {
        //$scope.datastate = "update";
        $scope.rowObject.uuid = dateModel.uuid;
        $scope.rowObject.name = dateModel.name;
        $scope.rowObject.jdDoctorId = dateModel.jdDoctorId;
        $scope.rowObject.dateDay = dateModel.dateDay;
        $scope.rowObject.dateList = dateModel.dateList;
        $scope.flag = true;
    } else {
    }
    $scope.timeModel = [
        {label0: "07:00", label1: "07:30", label2: "08:00", label3: "08:30"},
        {label0: "09:00", label1: "09:30", label2: "10:00", label3: "10:30"},
        {label0: "11:00", label1: "11:30", label2: "12:00", label3: "12:30"},
        {label0: "13:00", label1: "13:30", label2: "14:00", label3: "14:30"},
        {label0: "15:00", label1: "15:30", label2: "16:00", label3: "16:30"},
        {label0: "17:00", label1: "17:30", label2: "18:00", label3: "18:30"},
        {label0: "19:00", label1: "19:30"}
    ];
    $scope.days = days;
    $scope.selectDoctor = function () {
        var modalInstance = $modal.open({
            templateUrl: 'selectDoctor.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectDoctorCtrl',
            size: "lg",
            resolve: {}
        });
        modalInstance.result.then(function (result) {
            for (var k in result) {
                $scope.rowObject[k] = result[k];
            }
            $scope.change();
        });
    };
    $scope.getDayName = function () {
        for (var i = 0; i < $scope.days.length; i++) {
            if ($scope.days[i].id == $scope.rowObject.dateDay)
                return $scope.days[i].day;
        }
    };
    $scope.getDate = function () {
        if (!$scope.rowObject.jdDoctorId) return;
        var url = "noVisitedTime/getNoVisitedTimes?";
        url = url + "jdDoctorId=" + $scope.rowObject.jdDoctorId + "&day=" + $scope.rowObject.dateDay;
        $http.get(REST_PREFIX + url).success(function (result) {
            for (var i = 0; i < $scope.timeModel.length; i++) {
                var model = $scope.timeModel[i];
                for (var j = 0; j < 4; j++) {
                    model["selected" + j] = false;
                }
            }
            if (result && result.noVisitedTimeQueryModel) {
                var list = result.noVisitedTimeQueryModel.dateList.split(",");
                for (var i = 0; i < list.length; i++) {
                    for (var j = 0; j < $scope.timeModel.length; j++) {
                        var model = $scope.timeModel[j];
                        for (var k = 0; k < 4; k++) {
                            if (model["label" + k] == list[i]) {
                                model["selected" + k] = true;
                            }
                        }
                    }
                }
            }
            $scope.checkChange();

        });
    };
    $scope.getDate();

    $scope.checkChange = function () {
        var day = $scope.rowObject.dateDay;
        var jdDoctorId = $scope.rowObject.jdDoctorId;
        if (jdDoctorId == null || jdDoctorId == "" || day == null || day == "") {
            return;
        }

        var timeList = "";
        for (var i = 0; i < $scope.timeModel.length; i++) {
            var row = $scope.timeModel[i];
            for (var j = 0; j <= 3; j++) {
                if (row["selected" + j] == true) {
                    if (timeList == "") {
                        timeList = row["label" + j];
                    } else {
                        timeList += "," + row["label" + j];
                    }
                }
            }
        }
        $scope.rowObject.dateList = timeList;

    };

    $scope.change = function () {
        var day = $scope.rowObject.dateDay;
        var jdDoctorId = $scope.rowObject.jdDoctorId;
        if (jdDoctorId == null || jdDoctorId == "" || day == null || day == "") {
            return;
        }
        $scope.getDate();
    };

    $scope.ok = function (e) {
        if (!validateFiledNullMax(toaster, $scope.rowObject.jdDoctorId, "医生", true, 0)
            || !validateFiledNullMax(toaster, $scope.rowObject.dateDay, "星期", true, 0)
            || !validateFiledNullMax(toaster, $scope.rowObject.dateList, "时间", true, 0)) {
            return;
        }
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;

            if (dateModel) {
                $http.put(REST_PREFIX + "noVisitedTime/update", $scope.rowObject).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "医生【" + $scope.rowObject.name + "】在" + $scope.getDayName() + "记录不存在，请选择新增");
                    } else {
                        toaster.pop("success", "提示", "保存成功");
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX + "noVisitedTime/insert", $scope.rowObject).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "医生【" + $scope.rowObject.name + "】在" + $scope.getDayName() + "记录已存在，请选择编辑");
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
    }
});

app.controller('selectDoctorCtrl', function ($scope, $http, $modalInstance, ngTableParams, toaster, $localStorage, Admin_Constant,$rootScope) {
    $scope.justopen = true;
    $scope.jdDistricts = []; //地区信息;
    $scope.jdHospitals = []; //医院信息;
    $scope.jdDepartments = [];//部门信息;
    $scope.jdTitles = [];//职称;

    //获取地区信息
    $scope.getDistrictInfos = function () {
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
    };
    $scope.getDistrictInfos();
    //获取部门信息
    $scope.getDepartmentInfos = function () {
        $scope.jdDepartments = $localStorage[Admin_Constant.LocalStorage.Departments];
        if(!$scope.jdDepartments) {
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
        if(!$scope.jdTitles) {
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
        //$scope.jdHospitals = $localStorage[Admin_Constant.LocalStorage.Hospitals];
        if(!$rootScope.jdHospitals) {
            var url = REST_PREFIX + "jdHospital/search?jd_district_id=" + districtId;
            $http.get(url).success(function (result) {
                $scope.jdHospitals = result.hospitalList;
            });
        } else{
            var temp = [];
            $rootScope.jdHospitals.forEach(function(item){
                if(item.jdDistrictId == districtId){
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
    }

    $scope.clear = function (e) {
        var rowObject = new Object();
        rowObject.name = "";
        rowObject.jdDoctorId = "";
        $modalInstance.close(rowObject);
    }
});