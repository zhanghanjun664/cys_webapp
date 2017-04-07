app.controller('healthCheckCtrl',
    ['$scope','$http','$modal','$location','ngTableParams','SweetAlert', 'toaster',
        function($scope,$http,$modal,$location,ngTableParams,SweetAlert,toaster){
            $scope.$on("archiveInfoLoaded", function (event, msg) {
                $scope.patientId = msg.patientId;
                $scope.tableParams = new ngTableParams({
                    page: 1,
                    count: 10
                }, {
                    getData: function ($defer) {
                        var requestUrl = ARCHIVE_BASE_URL + "item/healthcheck?patientId="+$scope.patientId;
                        $http.get(requestUrl).success(function (result) {
                            $scope.data = result.body.result;
                            $defer.resolve($scope.data);
                        });
                    }
                });
            });

            //新建血压数据
            $scope.add = function () {
                var modalInstance = $modal.open({
                    templateUrl: 'editHealthCheck.html',
                    backdrop: 'static',
                    keyboard: false,
                    controller: 'editHealthCheckCtrl',
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
                        $http.delete(ARCHIVE_BASE_URL + "item/healthcheck?id=" + id).success(function (result) {
                            if (result.statusCode == "OK" && result.body.code == 2000) {
                                $scope.tableParams.reload();
                            } else {
                                // alert("删除失败");
                                toaster.pop("error", "提示", "删除失败");
                            }
                        });
                    }
                });
            };
        }]);

app.controller('editHealthCheckCtrl', function ($scope, $http, $modal, $modalInstance,toaster, jdPatientId) {
    var patientId = jdPatientId;
    $scope.data = {};
    $scope.data.selectedSicks = [];
    $scope.data.allSickList= [];
    $scope.orderSicks= [];
    $scope.selectSickResult=[];
    $scope.ok = function (e) {
        $scope.healthCheck = {};
        $scope.healthCheck.patientId = patientId;
        $scope.healthCheck.name = $scope.name;
        $scope.healthCheck.checkTimeStr = $("#check_time").val();
        $scope.healthCheck.result = $scope.result;
        $http.post(ARCHIVE_BASE_URL + "healthcheck/",$scope.healthCheck).success(function (result) {
            if(result.statusCode == 'OK' && result.body.code == 2000) {
                // alert("保存成功");
                toaster.pop("success", "提示", "保存成功");
                $modalInstance.close("success");
            }
            if(result.body.code != 2000) {
                // alert("保存失败");
                toaster.pop("error", "提示", "保存失败");
            }
        })
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.selectSick=function(){
        var modalInstance = $modal.open({
            templateUrl: '../common/selectSick.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectSingleSickCtrl',
            size:"lg",
            resolve: {
            }
        });
        modalInstance.result.then(function (result) {
            $scope.name = result[0].name;
        });
    };
});
