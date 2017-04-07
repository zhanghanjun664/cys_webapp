app.controller('patientHospitalizationRecordCtrl',['$scope','$http','$modal','ngTableParams', function($scope,$http,$modal,ngTableParams){
    var archiveItem = "hospitalizationrecord";
    $scope.$on("archiveInfoLoaded", function (event, msg) {
        $scope.patientId = msg.patientId;
        loadArchiveItemData($http, $scope, archiveItem);
    });
    
    $scope.edit = function (record) {
        editArchiveItemRecord ($scope, $modal, 'editHospitalizationRecordCtrl', record, 'editHospitalizationRecord.html');
    };
    
    // 删除操作
    $scope.deleteItem = function(id) {
        deleteArchiveItem($http, $scope, archiveItem, id);
    } 
    
    $scope.resultData = []; //后台返回总的结果集
    $scope.showData = []; //当前选中类型的结果集
    $scope.records = []; //当前页面的结果集

    $scope.tableParams = getNgTableParams($http, $scope, archiveItem, ngTableParams);
}]);

app.controller('editHospitalizationRecordCtrl', function ($scope, $modal, $http, $modalInstance, record) {
    if(record) {
    	$scope.record = angular.copy(record);
    }
    
	$scope.selectSick = function(){
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
        	$scope.record.surgery = result[0].name;
        });
    };
    
    $scope.ok = function (e) {
    	$scope.record.endDate = undefined;
    	$scope.record.startDate = undefined;
    	$scope.record.endDateInString = $("#end_date").val();
    	$scope.record.startDateInString = $("#start_date").val();
        saveArchiveItem ($http, $scope, $modalInstance, "hospitalizationrecord", $scope.record);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});

app.controller('patientMedicationUsageCtrl',['$scope','$http','$modal','ngTableParams', function($scope,$http,$modal,ngTableParams){
    var archiveItem = "medicationusage";
    $scope.$on("archiveInfoLoaded", function (event, msg) {
        $scope.patientId = msg.patientId;
        loadArchiveItemData($http, $scope, archiveItem);
    });
    
    $scope.edit = function (record) {
        editArchiveItemRecord ($scope, $modal, 'editMedicationUsageCtrl', record, 'editMedicationUsage.html');
    };
    
    // 删除操作
    $scope.deleteItem = function(id) {
        deleteArchiveItem($http, $scope, archiveItem, id);
    } 
    
    $scope.resultData = []; //后台返回总的结果集
    $scope.showData = []; //当前选中类型的结果集
    $scope.records = []; //当前页面的结果集

    $scope.tableParams = getNgTableParams($http, $scope, archiveItem, ngTableParams);
}]);

app.controller('editMedicationUsageCtrl', function ($scope, $http, $modalInstance, record) {
    if(record) {
    	$scope.record = angular.copy(record);
    }
    
    $scope.matchingMedicationList = {};
    
    $scope.ok = function (e) {
    	$scope.record.endDate = undefined;
    	$scope.record.startDate = undefined;
    	$scope.record.endDateInString = $("#end_date").val();
    	$scope.record.startDateInString = $("#start_date").val();
        saveArchiveItem ($http, $scope, $modalInstance, "medicationusage", $scope.record);
    };
    
    $scope.refreshMedications = function (keyword) {
    	searchMedicationByName($http, $scope, keyword);
    }
    
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});