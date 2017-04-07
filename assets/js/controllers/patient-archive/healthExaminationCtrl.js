app.controller('healthExaminationCtrl',
    ['$scope','$http','$modal','$location','ngTableParams','SweetAlert',
        function($scope,$http,$modal,$location,ngTableParams,SweetAlert){
            $scope.$on("archiveInfoLoaded", function (event, msg) {
                $scope.patientId = msg.patientId;
                //查询血压数据
                $scope.tableParams = new ngTableParams({
                    page: 1,
                    count: 10
                }, {
                    getData: function ($defer) {
                        var requestUrl = "/rest/jdHealthExamination/list?jdPatientId="+$scope.patientId;
                        $http.get(requestUrl).success(function (result) {
                            $scope.data = result.healthExaminationList;
                            $defer.resolve($scope.data);
                        });
                    }
                });
            });
            //新建血压数据
            $scope.add = function () {
                var modalInstance = $modal.open({
                    templateUrl: 'editHealthExamination.html',
                    backdrop: 'static',
                    keyboard: false,
                    controller: 'edithealthExaminationCtrl',
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
                        $http.delete("/rest/jdHealthExamination/" + id).success(function (result) {
                            if (result.result != 0) {
                                // toaster.pop("error", "提示", "健康测量【" + result.description + "】已被引用，不能删除");
                                var description = "健康测量【" + result.description + "】已被引用，不能删除";
                                alert(description);
                            } else {
                                $scope.tableParams.reload();
                            }
                        });
                    }
                });
            };
        }]);

app.controller('edithealthExaminationCtrl', function ($scope, $http, $modalInstance,jdPatientId) {
    var patientId = jdPatientId;
    $scope.ok = function (e) {
        $scope.jdHealthExaminationInfo = {};
        $scope.jdHealthExaminationInfo.jdPatientId = patientId;
        $scope.jdHealthExaminationInfo.examDateAsString = $("#examDate").val();
        $scope.jdHealthExaminationInfo.diastolicPressure = $scope.diastolicPressure;
        $scope.jdHealthExaminationInfo.systolicPressure = $scope.systolicPressure;
        $scope.jdHealthExaminationInfo.heartRate = $scope.heartRate;
        $scope.jdHealthExaminationInfo.mode = "0";
        $http.post("/rest/jdHealthExamination/",$scope.jdHealthExaminationInfo).success(function (result) {
            if (result.result == 0) {
                alert("保存成功");
                // toaster.pop("success", "提示", "保存成功");
                $modalInstance.close("success");
            } else {
                alert("保存失败");
                // toaster.pop("error", "提示", "保存失败");
            }
        })
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});