'use strict';
app.controller('categorySetCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert) {

    
    $http.get(REST_PREFIX+"jdSickCategary/list").success(function (result) {
        $scope.sickCategaryList = result.sickCategaryList;
    });

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

    //获取JdSickCategary列表数据
    $scope.getData = function() {
        $http.get(REST_PREFIX+"jdSickCategary/categorySetlists").success(function (result) {
            $scope.resultData = result.body.result;
            $scope.tableParams.reload();
        });
    };
    $scope.getData();

    $scope.showOnPatientType = function(isShowOnPatient) {
        if(isShowOnPatient == true) return "是";
        if(isShowOnPatient == false) return "否";
    };

    //新增
    $scope.edit = function (sickCategorySetQueryModel) {
        var modalInstance = $modal.open({
            templateUrl: 'editSickCategarySet.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editSickCategarySetCtrl',
            resolve: {
                sickCategorySetQueryModel : function() {
                    return sickCategorySetQueryModel;
                },
                sickCategaryList : function() {
                    return $scope.sickCategaryList;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.getData();
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
                $http.delete(REST_PREFIX+"jdSickCategary/"+id).success(function (result) {
                    if(result.result != 0) {
                        toaster.pop("error", "提示", "类型【"+result.description+"】已被引用，不能删除");
                    }
                    $scope.getData();
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

});
app.controller('editSickCategarySetCtrl', function ($scope, $http, $modalInstance, toaster, sickCategorySetQueryModel, sickCategaryList) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.sickCategorySetQueryModel = {};
    if(sickCategorySetQueryModel) {
        $scope.sickCategorySetQueryModel.id = sickCategorySetQueryModel.id;
        $scope.sickCategorySetQueryModel.name = sickCategorySetQueryModel.name;
        $scope.sickCategorySetQueryModel.sickCategoryid = sickCategorySetQueryModel.sickCategoryid;
        $scope.sickCategorySetQueryModel.isShowOnPatient = sickCategorySetQueryModel.isShowOnPatient+"";
    }
    $scope.sickCategaryList = sickCategaryList;
    $scope.ok = function (e) {
        //if(!validateFiledNullMax(toaster, $scope.sickCategorySetQueryModel.name, "类型名称", true, 64)
        //    || !validateFiledInteger(toaster, $scope.sickCategorySetQueryModel.seq, "排序序号"))
        //    return;
        //提交
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            //if(jdSickCategary) {
            $http.put(REST_PREFIX+"jdSickCategary/insertAndUpdateToSickCategorySet", $scope.sickCategorySetQueryModel).success(function(result) {
                if (!result) {
                    $scope.submitFlag = false;
                    toaster.pop("error", "提示", "名称【"+$scope.sickCategorySetQueryModel.name+"】已经存在");
                } else {
                    $modalInstance.close("success");
                }
            });
            //} else {
            //    $http.post(REST_PREFIX+"jdSickCategary", $scope.sickCategorySetQueryModel).success(function(result) {
            //        if (!result) {
            //            $scope.submitFlag = false;
            //            toaster.pop("error", "提示", "名称【"+$scope.sickCategorySetQueryModel.name+"】已经存在");
            //        } else {
            //            $modalInstance.close("success");
            //        }
            //    });
            //}
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});