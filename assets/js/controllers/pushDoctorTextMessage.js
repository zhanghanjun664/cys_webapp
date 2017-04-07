'use strict';
app.controller('PushDoctorTextMessageCtrl', function ($scope, $http, $modal, toaster, SweetAlert, $localStorage, Admin_Constant,cysIndexedDB,$rootScope) {
    $scope.jdDistricts = [];    //地区信息
    $scope.jdHospitals = [];    //医院信息
    $scope.jdDepartments=[];    //部门信息
    $scope.jdTitles=[]; //职称信息
    $scope.content="";  //发送内容
    $scope.deviceType="MO"; //发送方式

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


    //获得地区信息
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
    //获得医院信息
    $scope.getHospitalInfos = function () {

        //$scope.jdHospitals = $localStorage[Admin_Constant.LocalStorage.Hospitals];

        if(!$rootScope.jdHospitals) {
            $http.get(REST_PREFIX + "jdHospital/list").success(function (result) {
                $scope.jdHospitals = result.hospitalList;
                //$localStorage[Admin_Constant.LocalStorage.Hospitals] = $scope.jdHospitals;
            });
        }
    };
    $scope.getHospitalInfos();
    //获得部门信息
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
    //获得职称信息
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

    $scope.personselect=function(){
        if(!$scope.content) {
            toaster.pop("warning", "", "请先输入发送内容", "1000");
        } else {
            var modalInstance = $modal.open({
                templateUrl: 'personselect.html',
                backdrop: 'static',
                keyboard: false,
                controller: 'PushDoctorPersonSelectCtrl',
                size:"lg",
                resolve: {
                    jdDistricts : function() {
                        return $scope.jdDistricts;
                    },
                    jdHospitals:function(){
                        return $rootScope.jdHospitals;
                    },
                    jdDepartments:function(){
                        return $scope.jdDepartments;
                    },
                    jdTitles:function(){
                        return $scope.jdTitles;
                    },
                    content:function(){
                        return $scope.content;
                    },
                    deviceType:function(){
                        return $scope.deviceType;
                    }
                }
            });
        }
    }
});

app.controller('PushDoctorPersonSelectCtrl', function ($scope, $http, $modal, $modalInstance,ngTableParams,toaster, SweetAlert,$localStorage,Admin_Constant,jdDistricts,jdHospitals,jdDepartments,jdTitles,content,deviceType,$rootScope) {
    $scope.justopen = true;
    $scope.sendFlag = false;
    $scope.jdDistricts = jdDistricts;
    $scope.jdHospitals=[];
    $scope.jdDepartments=jdDepartments;
    $scope.jdTitles=jdTitles;
    $scope.content=content;
    $scope.deviceType=deviceType;
    $scope.searchInfos = {
        districtId:null,
        hospitalId:null,
        departmentId:null,
        titleId:null,
        name:null,
        phoneNumber: null
    };

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

    $scope.resultPage = {totalCount: 0};    //后台返回总结果集，从医生jdDoctor中获取
    $scope.data = [];       //医生列表当前页面的结果集

    //重置当前选择按钮为false
    $scope.resetDataSelected = function ($scope) {
        $("#selectAllCheckbox").prop("checked", false);
        $scope.data.forEach(function (item) {
            item.selected = false;
        });
    };

    //根据已选医生列表设置医生列表是否已选
    $scope.setDataSelected = function ($scope) {
        for (var i = 0; i < $scope.data.length; i++) {
            for (var j = 0; j < $scope.personList.length; j++) {
                if ($scope.data[i].uuid == $scope.personList[j].uuid) {
                    $scope.data[i].selected = true;
                }
            }
        }
        $scope.isSelectAll();
    };

    //判断当前页面是否已经全选
    $scope.isSelectAll = function () {
        var i = 0;
        var j = 0;
        for (; i < $scope.data.length; i++) {
            if ($scope.data[i].selected == true) {
                j++;
            }
        }
        if (j == i && i!=0) {
            $("#selectAllCheckbox").prop("checked", true);
        } else {
            $("#selectAllCheckbox").prop("checked", false);
        }
    };

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            if($scope.justopen) {
                $scope.justopen = false;
            } else {
                $scope.resetDataSelected($scope);
                $scope.searchInfos.pageIndex = params.page();
                $scope.searchInfos.pageSize = params.count();
                $scope.queryString = getQueryString($scope.searchInfos);
                var requestUrl = REST_PREFIX+"doctor/list"+$scope.queryString;
                $http.get(requestUrl).success(function (result) {
                    $scope.resultPage = result.resultPage;
                    params.total($scope.resultPage.totalCount);
                    params.page($scope.resultPage.nowPage);
                    $scope.data = $scope.resultPage.result;
                    $scope.setDataSelected($scope);
                    $defer.resolve($scope.data);
                });
            }
        }
    });

    $scope.personList = [];     //已选医生列，对象是jdDoctorQueryModel类型，(openid，发送方式，消息内容)这三个属性点击发送时添加

    //向已选医生列表添加一个医生
    $scope.addPerson = function (item) {
        var flag = true;
        for (var i = 0; i < $scope.personList.length; i++) {
            if (item.uuid == $scope.personList[i].uuid) {
                flag = false;
                break;
            }
        }
        if (flag) $scope.personList.push(item);
    };

    //向已选医生列表删除一个医生
    $scope.deletePerson = function (item) {
        for (var i = 0; i < $scope.personList.length; i++) {
            if (item.uuid == $scope.personList[i].uuid) {
                $scope.personList.splice(i, 1);
                break;
            }
        }
        for (var j = 0; j < $scope.data.length; j++) {
            if (item.uuid == $scope.data[j].uuid) {
                $scope.data[j].selected = false;
                break;
            }
        }
    };

    //改变当前选中的行
    $scope.changeSelection = function (index) {
        var item = $scope.data.length > 0 ? $scope.data[index] : null;
        if (item) {
            var selected = item.selected;
            if (selected) {
                $scope.addPerson(item);
            } else {
                $scope.deletePerson(item);
            }
        }
        $scope.isSelectAll();
    };

    //全选/全不选
    $scope.selectAll = function () {
        var checkAll = $("#selectAllCheckbox").is(":checked");
        if ($scope.data.length > 0) {
            $scope.data.forEach(function (item) {
                item.selected = checkAll;
            });
            if (checkAll) {
                for (var i = 0; i < $scope.data.length; i++) {
                    $scope.addPerson($scope.data[i]);
                }
            } else {
                for (var i = 0; i < $scope.data.length; i++) {
                    $scope.deletePerson($scope.data[i]);
                }
            }
        }
    };

    //删除
    $scope.delete = function (item) {
        $scope.deletePerson(item);
        item.selected = false;
        $scope.isSelectAll();
    };

    $scope.sendPersons = [];    //发送的医生对象队列
    $scope.person = {name: null, openid:null,phoneNumber: null, content: null, deviceType: null};//发送的医生对象封装

    //获得要发送信息的医生对象队列
    $scope.getSendPersons = function () {
        $scope.personList.forEach(function (item) {
            $scope.person.name = item.name;
            $scope.person.jdDoctorId = item.uuid;
            $scope.person.openid = item.openid;
            $scope.person.phoneNumber = item.officePhoneNumber;
            $scope.person.content = content;
            $scope.person.deviceType = deviceType;
            $scope.sendPersons.push($scope.person);
        });
    };

    //清空查询条件
    $scope.clear = function () {
        $scope.searchInfos = {
            districtId:null,
            hospitalId:null,
            departmentId:null,
            titleId:null,
            name:null,
            phoneNumber: null
        };
    };

    $scope.query=function(){
        $scope.tableParams.reload();
    };

    $scope.ok = function (e) {
        $modalInstance.close("success");
    };

    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };

    $scope.send=function(e){
        if ($scope.data.length == 0) {
            toaster.pop("warning", "", "请先查询出结果", "1000");
        } else {
            if (!$scope.sendFlag) {
                if ($scope.personList.length > 0) {
                    $scope.sendFlag = true;
                    $scope.getSendPersons();
                    $http.post(REST_PREFIX+"jdTextMessagePush/pushDoctorTextMessage",$scope.sendPersons).success(function(result) {
                        if (result.result == 1){
                            $scope.sendFlag = false;
                            toaster.pop("error","提示", result.description);
                        } else {
                            var description=result.description;
                            toaster.pop("发送成功", "", description, "1000");
                            $modalInstance.close("success");
                        }
                    });
                } else {
                    toaster.pop("warning","","至少选择一名医生！");
                }
            }
        }
    }

    $scope.sendAll = function (e) {
        $modalInstance.dismiss();
        SweetAlert.swal({
            title: "提示",
            text: "你确定要给所有医生发送消息么?",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        },function(){
            if ($scope.data.length == 0) {
                toaster.pop("warning", "", "请先查询出结果", "1000");
            }else{
                $scope.searchInfos.devicetype = deviceType;
                $scope.searchInfos.content = content;
                $scope.querySendAllString = getQueryString($scope.searchInfos);
                var requestUrl = REST_PREFIX + "jdTextMessagePush/pushAllDoctorMessage" + $scope.querySendAllString;
                $http.post(requestUrl).success(function (result) {
                    if (result.result != 0){
                        $scope.sendFlag = false;
                        toaster.pop("error","提示",result.description);
                    } else {
                        var description = result.description;
                        toaster.pop("发送成功", "", description, "1000");
                        $modalInstance.close("success");
                    }
                });
            }
        });
    }
});