'use strict';
app.controller('JdBookingCtrl', function ($window, $scope, $http, $modal, ngTableParams, toaster, SweetAlert, $localStorage, Admin_Constant,cysIndexedDB,$rootScope) {
    $scope.bookingPage = {totalCount: 0};
    $scope.data = []; //当前页面的结果集
    $scope.jdHospitals = []; //医院信息
    $scope.jdDistricts = []; //地区信息

    //获取地区信息
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


    //获取医院信息
    //$scope.getJdHospitalList = function () {
    //    $scope.jdHospitals = $localStorage[Admin_Constant.LocalStorage.Hospitals];
    //    if (!$scope.jdHospitals) {
    //        $http.get(REST_PREFIX + "jdHospital/list").success(function (result) {
    //            $scope.jdHospitals = result.hospitalList;
    //            $localStorage[Admin_Constant.LocalStorage.Hospitals] = $scope.jdHospitals;
    //        });
    //    }
    //};
    //$scope.getJdHospitalList();

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



    //根据jdHospitalId显示医院名称
    $scope.displayHospitalName = function (jdHospitalId) {
        for (var i = 0; i < $scope.jdHospitals.length; i++) {
            if ($scope.jdHospitals[i].hospitalId == jdHospitalId)
                return $scope.jdHospitals[i].name;
        }
    };

    //根据hasBooked显示是否被约
    $scope.displayBooked = function (flag) {
        if (flag) {
            return "是";
        } else {
            return "否";
        }
    };

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.bookingPage.totalCount,
        getData: function ($defer, params) {
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "availableTime/getBookingPage" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.bookingPage = result.bookingPage;
                params.total($scope.bookingPage.totalCount);
                params.page($scope.bookingPage.nowPage);
                $scope.data = $scope.bookingPage.result
                $defer.resolve($scope.data);
            });
        }
    });

//点击查询按钮
    $scope.searchInfos = {
        name: null,
        districtId: null,
        jdHospitalId: null,
        startTime: null,
        endTime: null,
        hasBooked: null
    };
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdBooking.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdBookingCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                },
                jdDistricts: function () {
                    return $scope.jdDistricts;
                },
                jdHospitals: function () {
                    return $scope.jdHospitals;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    };

    $scope.export = function () {
        var requestUrl = REST_PREFIX + "availableTime/download" + getQueryString($scope.searchInfos);
        $window.open(requestUrl);
    };

});
app.controller('searchJdBookingCtrl', function ($scope, $modalInstance, searchInfos, jdHospitals, jdDistricts, $localStorage, Admin_Constant) {
    $scope.jdHospitals = [];
    $scope.jdDistricts = jdDistricts;
    $scope.searchInfos = searchInfos;
    $("#startTime").val($scope.searchInfos.startTime);
    $("#endTime").val($scope.searchInfos.endTime);

    $scope.bookeds = [{id: 1, name: "是"}, {id: 2, name: "否"}];

    //根据地区获得医院结果集
    $scope.onDistrictChange = function (districtId) {
        $scope.jdHospitals = [];
        jdHospitals.forEach(function (item) {
            if (item.jdDistrictId == districtId) {
                $scope.jdHospitals.push(item);
            }
        });
    };
    //初始设置医院
    if ($scope.searchInfos.districtId) {
        jdHospitals.forEach(function (jdHospital) {
            if (jdHospital.jdDistrictId == $scope.searchInfos.districtId)
                $scope.jdHospitals.push(jdHospital);
        });
    }
    //改变hasBook属性
    $scope.change = function () {
        $scope.searchInfos.hasBooked = !$scope.searchInfos.hasBooked;
    };


    $scope.ok = function (e) {
        $scope.searchInfos.startTime = $("#startTime").val();
        $scope.searchInfos.endTime = $("#endTime").val();
        $modalInstance.close($scope.searchInfos);
    };

    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };

    $scope.clear = function () {
        $("#startTime").val("");
        $("#endTime").val("");
        $scope.searchInfos = {name: null, jdHospitalId: null,districtId:null};
    };
});