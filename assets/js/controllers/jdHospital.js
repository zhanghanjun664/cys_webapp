'use strict';
app.controller('JdHospitalCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $localStorage, Admin_Constant,cysIndexedDB,$rootScope) {
    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    $scope.getAttachInfos = function () {
        //获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if (!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
        //获得市辖区信息
        $scope.jdDistrictAreas = $localStorage[Admin_Constant.LocalStorage.DistrictAreas];
        if(!$scope.jdDistrictAreas) {
            $http.get(REST_PREFIX + "jdDistrictArea/list").success(function (result) {
                $scope.jdDistrictAreas = result.districtAreaList;
                $localStorage[Admin_Constant.LocalStorage.DistrictAreas] = $scope.jdDistrictAreas;
            });
        }
    };
    $scope.getAttachInfos();

    //根据地区ID显示地区的名称
    $scope.displayDistrictName = function (districtId) {
        for (var i = 0; i < $scope.jdDistricts.length; i++) {
            if ($scope.jdDistricts[i].uuid == districtId)
                return $scope.jdDistricts[i].name;
        }
    };

    //根据市辖区ID显示市辖区信息
    $scope.dispalyDistrictAreaName = function (item) {
        for (var i = 0; i < $scope.jdDistrictAreas.length; i++) {
            if ($scope.jdDistrictAreas[i].uuid == item)
                return $scope.jdDistrictAreas[i].name;
        }
    };

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
            var requestUrl = REST_PREFIX + "jdHospital/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);
            });
        }
    });

    //刷新JdHospital缓存数据
    //$scope.refreshCash = function () {
    //    $http.get(REST_PREFIX + "jdHospital/list").success(function (result) {
    //        //$localStorage[Admin_Constant.LocalStorage.Hospitals] = result.hospitalList;
    //    });
    //};
    //$scope.refreshCash();

    //新增
    $scope.edit = function (jdHospital) {
        var modalInstance = $modal.open({
            templateUrl: 'editJdHospital.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdHospitalCtrl',
            resolve: {
                jdHospital: function () {
                    return jdHospital;
                },
                jdDistrictAreas: function () {
                    return $scope.jdDistrictAreas;
                },
                jdDistricts: function () {
                    return $scope.jdDistricts;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
            $scope.refreshCash();
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
                $http.delete(REST_PREFIX + "jdHospital/" + id).success(function (result) {
                    if(result.result != 0) {
                        toaster.pop("error", "提示", result.description);
                    } else {
                        $scope.tableParams.reload();
                        $scope.refreshCash();
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

    //点击查询按钮
    $scope.searchInfos = {districtId: null, name: null, districtAreaId: null};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdHospital.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdHospitalCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                },
                jdDistrictAreas: function () {
                    return $scope.jdDistrictAreas;
                },
                jdDistricts: function () {
                    return $scope.jdDistricts;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    }

});
app.controller('searchJdHospitalCtrl', function ($scope, $modalInstance, jdDistricts, jdDistrictAreas, searchInfos) {
    $scope.jdDistricts = jdDistricts;
    $scope.jdDistrictAreas = [];
    $scope.searchInfos = searchInfos;

    //根据地区Id得到市辖区信息
    $scope.changeDistrictAreas = function (districtId){
        $scope.jdDistrictAreas = [];
        $scope.searchInfos.districtAreaId = "";
        jdDistrictAreas.forEach(function(item){
            if (item.jdDistrictId == districtId)
                $scope.jdDistrictAreas.push(item);
        });
    };

    //初始化市辖区信息
    $scope.setDistrictArea = function (){
        for (var i=0; i<jdDistrictAreas.length; i++){
            if (jdDistrictAreas[i].jdDistrictId == $scope.searchInfos.districtId){
                $scope.jdDistrictAreas.push(jdDistrictAreas[i]);
            }
        }
    };
    $scope.setDistrictArea();

    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function (e) {
        $scope.searchInfos = {districtId: null, name: null, districtAreaId: null};
    }
});
app.controller('editJdHospitalCtrl', function ($scope, $http, $modalInstance, toaster, jdDistricts,jdDistrictAreas, jdHospital) {
	$scope.obj = new Flow(); //头像文件对象
    $scope.uploadUrl = REST_PREFIX + "jdHospital/uploadLogo";
    $scope.removeImage = function () {
        $scope.noImage = true;
    };
    //图片上传成功回调函数
    $scope.uploadSuccess = function(file, message) {
        var result = JSON.parse(message);
        if(result.result == 0) {
            $scope.jdHospitalInfo.logoUrl = result.uploadUrl;
            if (jdHospital) {
                $scope.jdHospitalInfo.uuid = jdHospital.uuid;
                $http.put(REST_PREFIX + "jdHospital", $scope.jdHospitalInfo).success(function (result) {
                    $modalInstance.close("success");
                });
            } else {
                $http.post(REST_PREFIX + "jdHospital", $scope.jdHospitalInfo).success(function (result) {
                    $modalInstance.close("success");
                });
            }
        } else {
            toaster.pop("error", "提示", "上传图片失败，请联系管理员!");
            $scope.submitFlag = false;
        }
    };

    $scope.submitFlag = false; //为防止表单重复提交
    $scope.jdDistricts = jdDistricts;
    $scope.jdDistrictAreas = []; //市辖区信息
    $scope.jdHospitalInfo = {};

    //根据地区Id得到市辖区信息
    $scope.changeDistrictAreas = function (districtId){
        $scope.jdDistrictAreas = [];
        jdDistrictAreas.forEach(function(item){
            if (item.jdDistrictId == districtId)
                $scope.jdDistrictAreas.push(item);
        });
    };

    if (jdHospital) {
        $scope.jdHospitalInfo.uuid = jdHospital.hospitalId;
        $scope.jdHospitalInfo.name = jdHospital.name;
        $scope.jdHospitalInfo.jdDistrictId = jdHospital.jdDistrictId;
        $scope.jdHospitalInfo.jdDistrictAreaId = jdHospital.jdDistrictAreaId;
        $scope.jdHospitalInfo.address = jdHospital.address;
        $scope.jdHospitalInfo.seq = jdHospital.seq;
        $scope.jdHospitalInfo.logoUrl = jdHospital.logoUrl;
        if(!$scope.jdHospitalInfo.logoUrl) {
            $scope.noImage = true;
        }
        $scope.jdHospitalInfo.isShow = jdHospital.isShow+"";
        $scope.jdHospitalInfo.openToParner = jdHospital.openToParner+"";
    } else {
        $scope.noImage = true;
        $scope.jdHospitalInfo.isShow = "true";
    }

    //初始化市辖区信息
    $scope.setDistrictArea = function (){
        for (var i=0; i<jdDistrictAreas.length; i++){
            if (jdDistrictAreas[i].jdDistrictId == $scope.jdHospitalInfo.jdDistrictId){
                $scope.jdDistrictAreas.push(jdDistrictAreas[i]);
            }
        }
    };
    $scope.setDistrictArea();

    $scope.ok = function (e) {
        if($scope.jdHospitalInfo.logoUrl == undefined && !$scope.obj.flow.files[0]) {
            toaster.pop("error", "提示", "请上传医院图标");
            return;
        } else if($scope.obj.flow.files[0]) {
            if($scope.obj.flow.files[0].file.size > 1024*1024*5) {
                toaster.pop("error", "提示", "上传图片不能大于5M");
                return;
            }
        }
        if (!validateFiledNullMax(toaster, $scope.jdHospitalInfo.jdDistrictId, "地区", true, 0)
            || !validateFiledNullMax(toaster,$scope.jdHospitalInfo.jdDistrictAreaId, "市辖区", true, 0)
            || !validateFiledNullMax(toaster, $scope.jdHospitalInfo.name, "名称", true, 64)
            || !validateFiledInteger(toaster, $scope.jdHospitalInfo.seq, "排序序号", true)
            || !validateFiledMax(toaster, $scope.jdHospitalInfo.address, "地址", 250))
            return;
        //提交
        //if (!$scope.submitFlag) {
        //    $scope.submitFlag = true;
            //$http.post(REST_PREFIX + "jdHospital/validate", $scope.jdHospitalInfo).success(function (result) {
            //    if (!result) {
            //        $scope.submitFlag = false;
            //        toaster.pop("error", "提示", "名称【" + $scope.jdHospitalInfo.name + "】已经存在");
            //    } else {
                    if($scope.obj.flow.files[0]) {
                        $scope.obj.flow.upload();
                    } else {
                        if (jdHospital) {
                            $scope.jdHospitalInfo.uuid = jdHospital.uuid;
                            $http.put(REST_PREFIX + "jdHospital", $scope.jdHospitalInfo).success(function (result) {
                                $modalInstance.close("success");
                            });
                        } else {
                            $http.post(REST_PREFIX + "jdHospital", $scope.jdHospitalInfo).success(function (result) {
                                $modalInstance.close("success");
                            });
                        }
                    }
            //    }
            //});
        //}
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});