app.controller('lifeStyleCtrl',
    ['$scope','$http','$modal','$location','ngTableParams','SweetAlert',
        function($scope,$http,$modal,$location,ngTableParams,SweetAlert){
            $scope.$on("archiveInfoLoaded", function (event, msg) {
                $scope.patientId = msg.patientId;
                $http.get(ARCHIVE_BASE_URL + "item/lifestyle?patientId=" + $scope.patientId).success(function (result) {
                    if (!isRequestSuccessful(result)) {
                        //alert("数据不存在");
                    }
                    if(result.body.result.length > 0){
                        $scope.saltIntake = result.body.result[0].saltIntake;
                        $scope.dietaryQuantify = result.body.result[0].dietaryQuantify == true ? "true" : "false";
                        $scope.highFatDiet = result.body.result[0].highFatDiet == true ? "true" : "false";
                        $scope.highMood = result.body.result[0].highMood == true ? "true" : "false";
                        $scope.smoking = result.body.result[0].smoking;
                        $scope.drinking = result.body.result[0].drinking;
                        $scope.exercise = result.body.result[0].exercise;
                    }
                });
            });
            //新建血压数据
            $scope.ok = function (e) {
                $scope.lifeStyle = {};
                $scope.lifeStyle.patientId = $scope.patientId;
                $scope.lifeStyle.saltIntake = $scope.saltIntake;
                $scope.lifeStyle.dietaryQuantify = $scope.dietaryQuantify;
                $scope.lifeStyle.highFatDiet = $scope.highFatDiet;
                $scope.lifeStyle.highMood = $scope.highMood;
                $scope.lifeStyle.smoking = $scope.smoking;
                $scope.lifeStyle.drinking = $scope.drinking;
                $scope.lifeStyle.exercise = $scope.exercise;
                $http.post(ARCHIVE_BASE_URL + "lifestyle/",$scope.lifeStyle).success(function (result) {
                    if(result.statusCode == 'OK' && result.body.code == 2000) {
                        alert("保存成功");
                        // toaster.pop("success", "提示", "保存成功");
                        // $modalInstance.close("success");
                    }
                    if(result.body.code != 2000) {
                        alert("保存失败");
                        // toaster.pop("error", "提示", "保存失败");
                    }
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
                        $http.delete(ARCHIVE_BASE_URL + "item/lifestyle?id=" + id).success(function (result) {
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
