app.controller('physicalIndexCtrl',
    ['$scope','$http','$modal','$location','ngTableParams','SweetAlert',
        function($scope,$http,$modal,$location,ngTableParams,SweetAlert){
            $scope.$on("archiveInfoLoaded", function (event, msg) {
                $scope.patientId = msg.patientId;
                $scope.tableParams = new ngTableParams({
                    page: 1,
                    count: 10
                }, {
                    getData: function ($defer) {
                        var requestUrl = ARCHIVE_BASE_URL+"item/physicalindex?patientId="+$scope.patientId;
                        $http.get(requestUrl).success(function (result) {
                            $scope.data = result.body.result;
                            $defer.resolve($scope.data);
                        });
                    }
                });
            });
            //新建
            $scope.add = function () {
                var modalInstance = $modal.open({
                    templateUrl: 'editPhysical.html',
                    backdrop: 'static',
                    keyboard: false,
                    controller: 'editPhysicalIndexCtrl',
                    size:"lg",
                    resolve: {
                        jdPatientId : function() {
                            return $scope.patientId;
                        }
                    }
                });
                modalInstance.result.then(function(result) {
                    $scope.tableParams.reload();
                }, function(reason) {
                    console.log(reason);
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
                        $http.delete(ARCHIVE_BASE_URL+"item/physicalindex?id=" + id).success(function (result) {
                            if (result.statusCode == "OK" && result.body.code == 2000) {
                                $scope.tableParams.reload();
                            } else {
                                alert("保存失败");
                            }
                        });
                    }
                });
            };
        }]);

app.controller('editPhysicalIndexCtrl', function ($scope, $http, $modalInstance,jdPatientId) {
    var patientId = jdPatientId;
    $scope.ok = function (e) {
        $scope.physicalIndexs = [];
        $scope.timeViewDTOList = [];

        $(".form-group").each(function () {
            var physical_index = $(this).find(".js_index").html();
            var physical_value = "";
            if(physical_index == "视网膜病变"){
                physical_value = $scope.retinopathy;
            }else{
                physical_value = $($(this).find(".js_value")).val();
            }

            var physical_time = $($(this).find(".js_time")).val();
            if(physical_index != "" && physical_value != ""){
                var physicalIndex = new Object();
                physicalIndex.patientId = patientId;
                physicalIndex.index = physical_index;
                physicalIndex.measureDateString = physical_time;
                physicalIndex.value = physical_value;
                $scope.physicalIndexs.push(physicalIndex);
            }

        });
        if($scope.physicalIndexs.length > 0){
            $http.post(ARCHIVE_BASE_URL+"physicalindex",$scope.physicalIndexs).success(function (result) {
                if(result.statusCode == 'OK' && result.body.code == 2000) {
                    alert("保存成功");
                    // toaster.pop("success", "提示", "保存成功");
                    $modalInstance.close("success");
                }
                if(result.body.code != 2000) {
                    alert("保存失败");
                    // toaster.pop("error", "提示", "保存失败");
                }
            });
        }else{
            alert("您没有输入各指标的值");
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});