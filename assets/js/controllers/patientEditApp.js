var REST_PREFIX = projectName + '/rest/';
var app = angular.module('app',[
    'ngStorage',
    'ngSanitize',
    'ngTouch',
    'ui.router',
    'ui.bootstrap'
]);
function getQueryString(searchInfos) {
    var queryString = "";
    for (var propName in searchInfos) {
        if (searchInfos[propName] && !(searchInfos[propName] instanceof Array)) {
            if (queryString) {
                queryString = queryString + '&' + propName + '=' + searchInfos[propName];
            }
            else {
                queryString = "?" + propName + '=' + searchInfos[propName];
            }
        }
    }
    return queryString;
}
//
// app.controller('editHealthRecord',['$scope','$http','$modalInstance',function ($scope, $http,$modalInstance) {
//     //打开选择疾病分类
//     $scope.okHealthRecord = function (e) {
//         $http.post(REST_PREFIX+"/healthRecord/save/"+jdPatientId,$scope.formData).success(function (result) {
//             if(result.body.code == 2000) {
//                 $modalInstance.close("success");
//             }
//             if(result.body.code != 2000) {
//                 toaster.pop("error", "提示", "服务器失败");
//             }
//         })
//     };
//     $scope.cancelHealthRecord = function (e) {
//         console.log($modalInstance);
//         $modalInstance.dismiss();
//     };
// }]);
// app.controller('editSymptomCtrl',['$scope','$http','$modalInstance',function ($scope, $http,$modalInstance) {
//     $scope.okSymptom = function (e) {
//         $http.post(REST_PREFIX+"/symptom/save/"+jdPatientId,$scope.formData).success(function (result) {
//             if(result.body.code == 2000) {
//                 $modalInstance.close("success");
//             }
//             if(result.body.code != 2000) {
//                 toaster.pop("error", "提示", "服务器失败");
//             }
//         })
//     };
//     $scope.cancelSymptom = function (e) {
//         $modalInstance.dismiss();
//     };
// }]);
//
// app.controller('editHospitalizationRecordCtrl',['$scope','$http','$modalInstance',function ($scope, $http,$modalInstance) {
//     $scope.okHospitalizationRecord = function (e) {
//         $http.post(REST_PREFIX+"/hospitalizationRecord/save/"+jdPatientId,$scope.formData).success(function (result) {
//             if(result.body.code == 2000) {
//                 $modalInstance.close("success");
//             }
//             if(result.body.code != 2000) {
//                 toaster.pop("error", "提示", "服务器失败");
//             }
//         })
//     };
//     $scope.cancelHospitalizationRecord = function (e) {
//         console.log($modalInstance);
//         $modalInstance.dismiss();
//     };
// }]);
// app.controller('editDrugCtrl',['$scope','$http','$modalInstance',function ($scope, $http,$modalInstance) {
//     $scope.cancelDrug = function (e) {
//         $modalInstance.dismiss();
//     };
// }]);
// app.controller('editInspectCtrl',['$scope','$http','$modalInstance',function ($scope, $http,$modalInstance) {
//     $scope.cancelInspect = function (e) {
//         $modalInstance.dismiss();
//     };
// }]);
//
//
// app.config(['$locationProvider', function($locationProvider) {
//     $locationProvider.html5Mode({
//         enabled: true,
//         requireBase: false//必须配置为false，否则<base href=''>这种格式带base链接的地址才能解析
//     });
// }]);
// app.controller('patientEditCtrl',['$scope','$http','$modal','$location',function($scope,$http,$modal,$location){
//     if ($location.search().id) {
//         $scope.id = $location.search().id;//获取到
//     }
//     //新增疾病
//     $scope.addRecord = function () {
//         var modalInstance = $modal.open({
//             templateUrl: '../views/patient/editHealthRecord.html',
//             backdrop: 'static',
//             keyboard: false,
//             controller: 'editHealthRecordCtrl',
//             resolve: {
//             }
//         });
//         modalInstance.result.then(function(result) {
//             console.log(result);
//         }, function(reason) {
//             console.log(reason);
//         });
//     };
//     //新增症状
//     $scope.addSymptom = function () {
//         var modalInstance = $modal.open({
//             templateUrl: '../views/patient/editSymptom.html',
//             backdrop: 'static',
//             keyboard: false,
//             controller: 'editSymptomCtrl',
//             resolve: {
//             }
//         });
//         modalInstance.result.then(function(result) {
//             console.log(result);
//         }, function(reason) {
//             console.log(reason);
//         });
//     };
//     //新建治疗
//     $scope.addHospitalizationRecord = function () {
//         var modalInstance = $modal.open({
//             templateUrl: '../views/patient/editHospitalizationRecord.html',
//             backdrop: 'static',
//             keyboard: false,
//             controller: 'editHospitalizationRecordCtrl',
//             resolve: {
//             }
//         });
//         modalInstance.result.then(function(result) {
//             console.log(result);
//         }, function(reason) {
//             console.log(reason);
//         });
//     };
//     //新建药品治疗情况
//     $scope.addDrug = function () {
//         var modalInstance = $modal.open({
//             templateUrl: '../views/patient/editDrug.html',
//             backdrop: 'static',
//             keyboard: false,
//             controller: 'editDrugCtrl',
//             resolve: {
//             }
//         });
//         modalInstance.result.then(function(result) {
//             console.log(result);
//         }, function(reason) {
//             console.log(reason);
//         });
//     };
//     //新建检查结果
//     $scope.addInspect = function () {
//         var modalInstance = $modal.open({
//             templateUrl: '../views/patient/editHealthCheck.html',
//             backdrop: 'static',
//             keyboard: false,
//             controller: 'editInspectCtrl',
//             resolve: {
//             }
//         });
//         modalInstance.result.then(function(result) {
//             console.log(result);
//         }, function(reason) {
//             console.log(reason);
//         });
//     };
//     //新建身体基本状况
//     $scope.addPhysicalCondition = function () {
//         var modalInstance = $modal.open({
//             templateUrl: '../views/patient/editPhysical.html',
//             backdrop: 'static',
//             keyboard: false,
//             controller: 'editPhysicalCtrl',
//             size:"lg",
//             resolve: {
//             }
//         });
//         modalInstance.result.then(function(result) {
//             console.log(result);
//         }, function(reason) {
//             console.log(reason);
//         });
//     };
//
// }]);
//
