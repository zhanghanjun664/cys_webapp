'use strict';
app.controller('PushPatientTextMessageCtrl', function ($scope, $http, $modal, toaster, SweetAlert, $localStorage, Admin_Constant) {
    $scope.jdDistricts = [];
    $scope.content="";
    $scope.deviceType={};
    $scope.deviceType="MO";
    var jdDistricts = []; //省份-地区信息
    var jdDistrictAreas = []; //市区-地区信息

    $scope.getDistrictInfos = function () {
        //获取地区信息
        jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!jdDistricts) {
            if(!$localStorage[Admin_Constant.LocalStorage.Districts]){
                $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                    $localStorage[Admin_Constant.LocalStorage.Districts] = result.districtList;
                });
            }
        }
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts].filter(function(districts){
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
    };
    $scope.getDistrictInfos();

    $scope.personselect=function(){
        if(!$scope.content) {
            toaster.pop("warning", "", "请先输入发送内容", "1000");
        } else {
            var modalInstance = $modal.open({
                templateUrl: 'personselect.html',
                backdrop: 'static',
                keyboard: false,
                controller: 'PushPatientPersonSelectCtrl',
                size:"lg",
                resolve: {
                    jdDistricts : function() {
                        return $scope.jdDistricts;
                    },
                    jdDistrictAreas : function() {
                        return jdDistrictAreas;
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

app.controller('PushPatientPersonSelectCtrl', function ($scope, $http, $modal, $modalInstance,ngTableParams,toaster, SweetAlert,jdDistricts,content,deviceType,jdDistrictAreas) {
    $scope.justopen = true;     //控制刚进入界面不立即查询
    $scope.sendFlag = false;
    $scope.jdDistricts = jdDistricts;   //获得地区列
    //初始化查询条件
    $scope.searchInfos = {
        districtId:null,
        name:null,
        phoneNumber:null
    };

    $scope.resultPage = {totalCount:0}; //后台返回总结果集，从用户jdPatient获得
    $scope.data = [];   //用户列表当前页面的结果集

    //根据地区Id得到市辖区信息
    $scope.changeDistrictAreas = function (districtId){
        $scope.jdDistrictAreas = [];
        $scope.searchInfos.districtAreaId = "";
        jdDistrictAreas.forEach(function(item){
            if (item.jdDistrictId == districtId && item.isCity)
                $scope.jdDistrictAreas.push(item);
        });
    };

    //重置当前选择按钮为false
    $scope.resetDataSelected = function ($scope) {
        $("#selectAllCheckbox").prop("checked", false);
        $scope.data.forEach(function (item) {
            item.selected = false;
        });
    };

    //根据已选用户列表设置用户列表是否已选
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
                $scope.searchInfos.masterOnly = true;
                $scope.queryString = getQueryString($scope.searchInfos);
                var requestUrl = REST_PREFIX+"patient/list"+$scope.queryString;
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

    //已选用户列，对象是jdPatientQueryModel类型，(openid，发送方式，消息内容)这三个属性点击发送时添加
    $scope.personList = [];

    //向已选用户列表添加一个用户
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

    //向已选用户列表删除一个用户
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

    $scope.sendPersons = [];    //发送的用户队列
    $scope.person = {name: null,openid:null, phoneNumber: null, content: null, deviceType: null};//发送的用户对象封装
    //获得要发送信息的用户对象队列
    $scope.getSendPersons = function () {
        $scope.personList.forEach(function (item) {
            $scope.person.name = item.name;
            $scope.person.jdPatientId = item.uuid;
            $scope.person.openid = item.openid;
            $scope.person.phoneNumber = item.phoneNumber;
            $scope.person.content = content;
            $scope.person.deviceType = deviceType;
            $scope.sendPersons.push($scope.person);
        });
    };

    //清空查询条件
    $scope.clear = function(){
        $scope.searchInfos = {
            districtId:null,
            name:null,
            phoneNumber:null
        };
    };

    $scope.query=function(){
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
            if (!$scope.sendFlag ) {
                if ($scope.personList.length >0) {
                    $scope.sendFlag = true;
                    $scope.getSendPersons();
                    $http.post(REST_PREFIX + "jdTextMessagePush/pushPatientTextMessage", $scope.sendPersons).success(function (result) {
                        if (result.result == 1) {
                            $scope.sendFlag = false;
                            toaster.pop("error", "提示", result.description);
                        } else {
                            var description = result.description;
                            toaster.pop("发送成功", "", description, "1000");
                            $modalInstance.close("success");
                        }
                    });
                } else{
                    toaster.pop("warning","","至少选择一位用户！");
                }
            }
        }
    }
    $scope.sendAll = function (e) {
        $modalInstance.dismiss();
        SweetAlert.swal({
            title: "提示",
            text: "你确定要给所有患者发送短信么?",
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
                var requestUrl = REST_PREFIX + "jdTextMessagePush/pushAllPatientMessage" + $scope.querySendAllString;
                $http.post(requestUrl).success(function (result) {
                    if (result.result == 1){
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
