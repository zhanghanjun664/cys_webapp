/**
 * Created by Administrator on 2015-05-15.
 */
'use strict';
app.controller('DoctorWithdrawalingCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert,$window,cysIndexedDB,$rootScope) {

    $scope.resultData = []; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultData.length,
        getData: function ($defer, params) {
            params.total($scope.resultData.length);
            commonResetSelection($scope);
            $scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
            if($scope.data.length == 0 && params.page() > 1) { //删除操作后如果当前页没有数据，自动跳转到前一页
                params.page(params.page() - 1);
                $scope.tableParams.reload();
            }
            $defer.resolve($scope.data);
        }
    });

    //获取JdTitle列表数据
    $scope.getData = function() {
        $http.get(REST_PREFIX+"withdrawaling/list").success(function (result) {
            $scope.resultData = result.withdrawalHistoryQueryModelList;
            $scope.tableParams.reload();
        });
    };
    $scope.getData();

    $scope.getStatusString=function(status){
        if(status=="REQUSTING"){
            return "待转账";
        }
        return status;
    };

    //新增
    $scope.edit = function (item) {
        var modalInstance = $modal.open({
            templateUrl: 'editWithdrawaling.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editWithdrawalingCtrl',
            resolve: {
                item : function() {
                    return item;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.getData();
        });
    };



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

app.controller('editWithdrawalingCtrl', function ($scope, $http, $modalInstance,ngTableParams,toaster,$modal){
    $scope.rowObject={};

    $scope.ok=function(e){
        if($scope.rowObject.jdDoctorId==undefined||$scope.rowObject.jdDoctorId=="" ){
            toaster.pop("error", "提示","医生不能为空");
            return;
        }
        if($scope.rowObject.amount==undefined ||$scope.rowObject.amount==""){
            toaster.pop("error", "提示","金额不能为空");
            return;
        }
        if($scope.rowObject.amount<=0){
            toaster.pop("error", "提示","请输入正确的金额");
            return;
        }
        var data={};
        data.amount=$scope.rowObject.amount;
        data.jdDoctorId=$scope.rowObject.jdDoctorId;
        $http.post(REST_PREFIX+"withdrawaling",data).success(function (result) {
            var ret=result.result;
            var description=result.description;
            if(ret==0){
                toaster.pop("success", "提示",description);
                $modalInstance.close("success");
            }else{
                toaster.pop("error", "提示",description);
            }
        });
    };

    $scope.cancel=function(e){
        $modalInstance.dismiss();
    };

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
        });
    };
});

app.controller('selectDoctorCtrl', function ($scope, $http, $modalInstance,ngTableParams,toaster,$localStorage,Admin_Constant,$rootScope){
    $scope.justopen = true;
    $scope.jdDistricts = []; //地区信息;
    $scope.jdHospitals = []; //医院信息;
    $scope.jdDepartments=[];//部门信息;
    $scope.jdTitles=[];//职称;

    $scope.getAttachInfos = function () {
        //获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
        //获取部门信息
        $scope.jdDepartments = $localStorage[Admin_Constant.LocalStorage.Departments];
        if(!$scope.jdDepartments) {
            $http.get(REST_PREFIX + "jdDepartment/list").success(function (result) {
                $scope.jdDepartments = result.departmentList;
                $localStorage[Admin_Constant.LocalStorage.Departments] = $scope.jdDepartments;
            });
        }
        //获取职称信息
        $scope.jdTitles = $localStorage[Admin_Constant.LocalStorage.Titles];
        if(!$scope.jdTitles) {
            $http.get(REST_PREFIX + "jdTitle/list").success(function (result) {
                $scope.jdTitles = result.titleList;
                $localStorage[Admin_Constant.LocalStorage.Titles] = $scope.jdTitles;
            });
        }
    };
    $scope.getAttachInfos();

    $scope.resultPage = {totalCount:0};
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行
    $scope.searchInfo = {};

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


        if(!$rootScope.jdHospitals) {
            var url = REST_PREFIX + "jdHospital/search?jd_district_id=" + districtId;
            $http.get(url).success(function (result) {
                $scope.jdHospitals = result.hospitalList;
            });
        } else{
            var temp = [];
            console.log(1);
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
})
