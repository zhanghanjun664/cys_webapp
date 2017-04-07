'use strict';

app.controller('NavbarCtrl', function ($scope, $http, $modal, SweetAlert) {

    $scope.changePassword = function() {
        var modalInstance = $modal.open({
            templateUrl: 'editPassword.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editPasswordCtrl'
        });
        modalInstance.result.then(function (result) {
            SweetAlert.swal({
                title: "修改密码成功!",
                type: "success",
                confirmButtonColor: "#007AFF",
                confirmButtonText: "确定"
            });
        });
    }
});
app.controller('editPasswordCtrl', function ($scope, $http, $modalInstance, toaster) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.userInfo = {};
    $scope.ok = function (e) {
        if(!validateFiledNullMax(toaster, $scope.userInfo.oldPassword, "原密码", true, 32)
            || !validateFiledNullMax(toaster, $scope.userInfo.newPassword, "新密码", true, 32))
            return;
        var confirmPassword = $("#confirmPassword").val();
        if($scope.userInfo.newPassword != confirmPassword) {
            toaster.pop("error", "提示", "确认密码不一致");
            return;
        }
        //提交
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            $http.put(REST_PREFIX+"user/password", $scope.userInfo).success(function(result) {
                if(result == null) {
                    $scope.submitFlag = false;
                    toaster.pop("error", "提示", "修改密码失败，请联系管理员");
                } else if (!result) {
                    $scope.submitFlag = false;
                    toaster.pop("error", "提示", "【原密码】不正确");
                } else {
                    $modalInstance.close("success");
                }
            });
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});
