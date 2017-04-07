'use strict';
app.controller('NoTimeViewCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert,cysIndexedDB,$rootScope) {
    $scope.resultPage = {totalCount:0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    $scope.rowObject={};

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            commonResetSelection($scope);
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            if($scope.rowObject.jdDoctorId!=undefined && $scope.rowObject.jdDoctorId!="" &&$scope.rowObject.jdDoctorId!=null)
                $scope.searchInfos.jd_doctor_id = $scope.rowObject.jdDoctorId;
            $scope.searchInfos.name = $scope.rowObject.name;
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "noAvailableTime/getDistinctList" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result
                $defer.resolve($scope.data);
            });
        }
    });

    $scope.displayDay = function(dateTime) {
        return dateTime.split(" ")[0];
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

    //新增
    $scope.edit = function (dateModel) {
        var modalInstance = $modal.open({
            templateUrl: 'noTimeViewEditCtrl.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'noTimeViewEditCtrl',
            size:"lg",
            resolve: {
                dateModel : function() {
                    return dateModel;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
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
    $scope.searchInfos = {jd_doctor_id:null,name:null};
    $scope.search=function(){
        var modalInstance = $modal.open({
            templateUrl: 'selectDoctor.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectDoctorCtrl',
            size:"lg",
            resolve: {
            }
        });
        modalInstance.result.then(function (result) {
            for(var k in result){
                $scope.rowObject[k]=result[k];
            }
            $scope.tableParams.reload();
        });
    }
});

app.controller('noTimeViewEditCtrl', function ($scope, $http, $modalInstance,$modal, toaster, dateModel){
    $scope.minDate = new Date();
    $scope.rowObject={};
    if(dateModel) {
        $scope.datastate = "update";
        $scope.rowObject.name=dateModel.name;
        $scope.rowObject.jdDoctorId=dateModel.jdDoctorId;
        var date=new Date(Date.parse(dateModel.dateTime));
        $scope.rowObject.dateTime=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
    }else{
        $scope.datastate="insert";
        $scope.rowObject.name="";
        $scope.rowObject.jdDoctorId="";
        $scope.rowObject.dateTime="";
    }
    $scope.timeModel=[
        {label0:"8:00",label1:"8:30",label2:"9:00",label3:"9:30"},
        {label0:"10:00",label1:"10:30",label2:"11:00",label3:"11:30"},
        {label0:"12:00",label1:"12:30",label2:"13:00",label3:"13:30"},
        {label0:"14:00",label1:"14:30",label2:"15:00",label3:"15:30"},
        {label0:"16:00",label1:"16:30",label2:"17:00",label3:"17:30"},
        {label0:"18:00",label1:"18:30",label2:"19:00",label3:"19:30"}
    ];

    $scope.selectDoctor=function(){
        var modalInstance = $modal.open({
            templateUrl: 'selectDoctor.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectDoctorCtrl',
            size:"lg",
            resolve: {
            }
        });
        modalInstance.result.then(function (result) {
            for(var k in result){
                $scope.rowObject[k]=result[k];
            }
            $scope.change();
        });
    }

    $scope.open = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope.opened = !$scope.opened;
    };

    $scope.getData = function() {
        var url="noAvailableTime/getNoAvailableTimes?";
        var date=$scope.getDateString();
        url=url+"doctorId="+$scope.rowObject.jdDoctorId+"&availableDate="+date;
        $http.get(REST_PREFIX+url).success(function (result) {
            for(var i=0;i<$scope.timeModel.length;i++){
                var model=$scope.timeModel[i];
                for(var j=0;j<4;j++){
                    model["selected"+j]=false;
                    model["uuid"+j]="";
                }
            }
            var list=result.noAvailableTimeList;
            for(var i=0;i<list.length;i++){
                var date=new Date(Date.parse(list[i].dateTime));
                var label=date.getHours()+":"+(date.getMinutes()==0?"00":date.getMinutes());
                for(var j=0;j<$scope.timeModel.length;j++){
                    var model=$scope.timeModel[j];
                    for(var k=0;k<4;k++){
                        if(model["label"+k]==label) {
                            model["selected" + k] = true;
                            model["uuid"+k]=list[i].uuid;
                        }
                    }
                }
            }
            $scope.checkChange();
        });
    };

    $scope.timeViewDTOList=[];

    $scope.getDateString=function(){
        var date;
        if(typeof($scope.rowObject.dateTime)=="string"){
            date=$scope.rowObject.dateTime;
        }else {
            date = $scope.rowObject.dateTime.getFullYear() + "-" + ($scope.rowObject.dateTime.getMonth() + 1) + "-" + $scope.rowObject.dateTime.getDate();
        }
        return date;
    };

    $scope.checkChange=function() {
        var datetime = $scope.rowObject.dateTime;
        var jdDoctorId = $scope.rowObject.jdDoctorId;
        if (datetime == null || datetime == "" || jdDoctorId == null || jdDoctorId == "") {
            return;
        }
        var dateString = $scope.getDateString();
        var timeViewDTO;
        for (var i = 0; i < $scope.timeViewDTOList.length; i++) {
            var dto = $scope.timeViewDTOList[i];
            if (dto.doctorID == jdDoctorId && dto.dateAsString == dateString) {
                timeViewDTO = dto;
                break;
            }
        }
        if (timeViewDTO == null) {
            timeViewDTO = new Object();
            timeViewDTO.doctorID = jdDoctorId;
            timeViewDTO.dateAsString = dateString;
            $scope.timeViewDTOList.push(timeViewDTO);
            $scope.getData();
            return;
        };

        var timeList = [];
        timeViewDTO.availableTimes = timeList;

        for (var i = 0; i < $scope.timeModel.length; i++) {
            var row = $scope.timeModel[i];
            for (var j = 0; j <= 7; j++) {
                if (row["selected" + j] == true) {
                    var object = new Object();
                    object.jdDoctorId = timeViewDTO.doctorID;
                    object.sDateTime = row["label" + j];
                    object.jd_noavailable_time_id = row["uuid" + j];
                    timeList.push(object);
                }
            }
        }
    }

    if ($scope.datastate == "update") {
        $scope.timeViewDTOList.length = 0;
        $scope.checkChange();
    }

    $scope.change = function () {
        var datetime = $scope.rowObject.dateTime;
        var jdDoctorId = $scope.rowObject.jdDoctorId;
        if (datetime == null || datetime == "" || jdDoctorId == null || jdDoctorId == "") {
            return;
        }
        var dateString = $scope.getDateString();
        var timeViewDTO;
        for (var i = 0; i < $scope.timeViewDTOList.length; i++) {
            var dto = $scope.timeViewDTOList[i];
            if (dto.doctorID == jdDoctorId && dto.dateAsString == dateString) {
                timeViewDTO = dto;
                break;
            }
        }
        if (timeViewDTO == null) {
            timeViewDTO = new Object();
            timeViewDTO.doctorID = jdDoctorId;
            timeViewDTO.dateAsString = dateString;
            $scope.timeViewDTOList.push(timeViewDTO);
            $scope.getData();
        } else {
            for (var i = 0; i < $scope.timeModel.length; i++) {
                var model = $scope.timeModel[i];
                for (var j = 0; j < 8; j++) {
                    model["selected" + j] = false;
                    model["uuid" +j]="";
                }
            }

            var list = timeViewDTO.availableTimes;
            for (var i = 0; i < list.length; i++) {
                var item = list[i];
                for (var j = 0; j < $scope.timeModel.length; j++) {
                    var model = $scope.timeModel[j];
                    for (var k = 0; k < 8; k++) {
                        if (model["label" + k] == item.sDateTime) {
                            model["selected" + k] = true;
                            model["uuid" + k] = item.jd_noavailable_time_id;
                        }
                    }
                }
            }
        }
    };


    $scope.ok = function (e) {
        if($scope.timeViewDTOList.length==0){
            toaster.pop("error", "提示","医生或日期不能为空");
            return;
        }
        for(var i=0;i<$scope.timeViewDTOList.length;i++){
            var timeViewDTO=$scope.timeViewDTOList[i];
            if(timeViewDTO.doctorID==undefined ||timeViewDTO.doctorID==""||
                timeViewDTO.dateAsString==undefined||timeViewDTO.dateAsString==""){
                toaster.pop("error", "提示","医生或日期不能为空");
                return;
            }
        }
        if ($scope.datastate == "update") {
            $http.put(REST_PREFIX + "noAvailableTime/update", $scope.timeViewDTOList).success(function (result) {
                toaster.pop("success", "提示", result.description);
                if (result.result == 0) {
                    $modalInstance.close("success");
                }
            });
        } else {
            $http.post(REST_PREFIX + "noAvailableTime/insert", $scope.timeViewDTOList).success(function (result) {
                toaster.pop("success", "提示", result.description);
                if (result.result == 0) {
                    $modalInstance.close("success");
                }
            });
        }
    }

    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    }
});

app.controller('selectDoctorCtrl', function ($scope, $http, $modalInstance,ngTableParams,toaster, $localStorage, Admin_Constant,$rootScope) {
    $scope.justopen = true;
    $scope.jdDistricts = []; //地区信息;
    $scope.jdHospitals = []; //医院信息;
    $scope.jdDepartments=[];//部门信息;
    $scope.jdTitles=[];//职称;

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

    $scope.getDepartmentInfos=function(){
        $scope.jdDepartments = $localStorage[Admin_Constant.LocalStorage.Departments];
        if(!$scope.jdDepartments) {
            $http.get(REST_PREFIX + "jdDepartment/list").success(function (result) {
                $scope.jdDepartments = result.departmentList;
                $localStorage[Admin_Constant.LocalStorage.Departments] = $scope.jdDepartments;
            });
        }
    };
    $scope.getDepartmentInfos();

    $scope.getTitleInfos=function(){
        $scope.jdTitles = $localStorage[Admin_Constant.LocalStorage.Titles];
        if(!$scope.jdTitles) {
            $http.get(REST_PREFIX + "jdTitle/list").success(function (result) {
                $scope.jdTitles = result.titleList;
                $localStorage[Admin_Constant.LocalStorage.Titles] = $scope.jdTitles;
            });
        }
    };
    $scope.getTitleInfos();

    $scope.resultPage = {totalCount:0};
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行
    $scope.searchInfo={pageIndex:1,pageSize:10};
    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            if($scope.justopen) {
                $scope.justopen = false;
            } else {
                commonResetSelection($scope);
                $scope.searchInfo.pageIndex = params.page();
                $scope.searchInfo.pageSize = params.count();
                $scope.queryString = getQueryString($scope.searchInfo);
                var requestUrl = REST_PREFIX+"doctor/list"+$scope.queryString;
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

    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };

    $scope.query=function(){
        $scope.tableParams.reload();
    };

    //根据地区获得医院结果集
    $scope.onDistrictChange=function(districtId){
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

    $scope.clear=function(e){
        var rowObject = new Object();
        rowObject.name ="";
        rowObject.jdDoctorId ="";
        $modalInstance.close(rowObject);
    }
});