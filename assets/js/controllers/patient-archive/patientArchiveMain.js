var app = angular.module('archiveEditorApp',[
    'ngStorage',
    'ngSanitize',
    'ngTouch',
    'ui.router',
    'ui.bootstrap',
    'ngTable',
    'ngRoute',
    'toaster',
    'ui.select',
    'oitozero.ngSweetAlert'
]);



var ARCHIVE_BASE_URL = "/rest/archive/";

function isRequestSuccessful(result) {
	return result.body.code == 2000;
}

app.controller('patientArchiveMainCtrl',['$scope','$http','$modal','$location',
                                                 function($scope,$http,$modal,$location,$localStorage){
    if ($location.search().id) {
        $scope.id = $location.search().id;// 获取到
    }
    
    $http.get(ARCHIVE_BASE_URL + 'general/' + $scope.id).success(function (result) {
        if (!isRequestSuccessful(result)) {
            alert("找不到档案数据");
        }
        $scope.patient = result.body.result;
        $scope.patient.auditable = undefined;
        
        var msg = { patientId: $scope.patient.patientId, 
        		    patientName: $scope.patient.name,
        		    masterId: $scope.patient.masterPatientId };
        $scope.$broadcast("archiveInfoLoaded", msg);
    });
}]);

function loadArchiveItemData ($http, $scope, archiveItem) {
    $http.get(ARCHIVE_BASE_URL + "item/" + archiveItem + "?patientId=" + $scope.patientId).success(function (result) {
        if (!isRequestSuccessful(result)) {
            // alert("数据不存在");
        }
        $scope.records = result.body.result;
    });
}


function saveArchiveItem ($http, $scope, $modalInstance, archiveItem, archiveItemData) {
    if(!$scope.submitFlag) {
        $scope.submitFlag = true;
        if(archiveItemData) {
            archiveItemData.auditable = undefined;
            if ($scope.patientId) {
            	archiveItemData.patientId = $scope.patientId;
            }
            $http.post(ARCHIVE_BASE_URL  + archiveItem, archiveItemData).success(function(result) {
                if (!isRequestSuccessful(result)) {
                    $scope.submitFlag = false;
                    alert("保存数据失败");
                } else {
                	if ($modalInstance) {
                        $modalInstance.close("success");
                	} else {
                		alert("保存成功");
                	}
                }
            });
        }
    }
};

function editArchiveItemRecord ($scope, $modal, controllerName, rec, templatePage) {
    var record = {};
    if (rec) {
        record = rec;
    }
    record.patientId = $scope.patientId;
    
    var modalInstance = $modal.open({
        templateUrl: templatePage,
        backdrop: 'static',
        keyboard: false,
        size: 'lg',
        controller: controllerName,
        resolve: {
            record: function() {
                return record;
            }
        }
    });
    modalInstance.result.then(function (result) {
        $scope.tableParams.reload();
    });
};

function deleteArchiveItem ($http, $scope, archiveItem, id) {
    if(window.confirm('确定删除吗?')){
        $http.delete(ARCHIVE_BASE_URL + "item/"+ archiveItem + "?id=" + id).success(function (result) {
            if(!isRequestSuccessful(result)) {
                alert("删除失败");
            } else {
                $scope.tableParams.reload();
            }
        });
     }
};

function getNgTableParams ($http, $scope, archiveItem, ngTableParams) {
	return new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.showData.length,
        getData: function ($defer, params) {
        	if ($scope.patientId) {
                loadArchiveItemData($http, $scope, archiveItem);
        	}
            // $defer.resolve($scope.records);
        }
    });
}

app.config(['$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode({
        enabled: true,
        requireBase: false// 必须配置为false，否则<base href=''>这种格式带base链接的地址才能解析
    });
}]);

// app.filter('propsFilter', function () {
// return function (items, props) {
// var out = [];
//
// if (angular.isArray(items)) {
// items.forEach(function (item) {
// var itemMatches = false;
//
// var keys = Object.keys(props);
// for (var i = 0; i < keys.length; i++) {
// var prop = keys[i];
// var text = props[prop].toLowerCase();
// if (item[prop].toString().toLowerCase().indexOf(text) !== -1) {
// itemMatches = true;
// break;
// }
// }
//
// if (itemMatches) {
// out.push(item);
// }
// });
// } else {
// // Let the output be the input untouched
// out = items;
// }
//
// return out;
// };
// });
