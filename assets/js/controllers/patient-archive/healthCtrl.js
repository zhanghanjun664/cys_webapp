app.controller('patientHealthRecordCtrl',['$scope','$http','$modal','ngTableParams', function($scope,$http,$modal,ngTableParams){
    var archiveItem = "healthrecord";
    $scope.$on("archiveInfoLoaded", function (event, msg) {
    	$scope.patientId = msg.patientId;
        loadArchiveItemData($http, $scope, archiveItem);
    });
    
    $scope.edit = function (record) {
        editArchiveItemRecord ($scope, $modal, 'editHealthRecordCtrl', record, 'editHealthRecord.html');
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

app.controller('editHealthRecordCtrl', function ($scope, $http, $modal, $modalInstance, record) {
    if(record) {
        $scope.record = angular.copy(record);
    }
    $scope.hospitalObj = {};
    
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
        	$scope.record.disease = result[0].name;
        	$scope.record.diseaseCategory = result[0].categaryName;
        });
    };
    
    $scope.refreshHospitals = function (keyword) {
    	searchHospitalByName($http, $scope, keyword);
    }
    
    $scope.ok = function (e) {
    	$scope.record.endDate = undefined;
    	$scope.record.startDate = undefined;
        $scope.record.endDateInString = $("#end_date").val();
        $scope.record.startDateInString = $("#start_date").val();
        saveArchiveItem ($http, $scope, $modalInstance, "healthrecord", $scope.record);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});

app.controller('patientSymptomCtrl',['$scope','$http','$modal','ngTableParams', function($scope,$http,$modal,ngTableParams){
    var archiveItem = "symptom";
    $scope.$on("archiveInfoLoaded", function (event, msg) {
        $scope.patientId = msg.patientId;
        loadArchiveItemData($http, $scope, archiveItem);
    });
    
    $scope.edit = function (record) {
        editArchiveItemRecord ($scope, $modal, 'editSymptomCtrl', record, 'editSymptom.html');
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

app.controller('editSymptomCtrl', function ($scope, $http, $modalInstance, record) {
    if(record) {
    	$scope.record = angular.copy(record);
    }
    $scope.ok = function (e) {
    	$scope.record.onsetTime = undefined;
    	$scope.record.onsetTimeInString = $("#onset_time").val();
        saveArchiveItem ($http, $scope, $modalInstance, "symptom", $scope.record);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});

app.controller('patientHealthConditionCtrl', function ($scope, $http) {
    var archiveItem = "healthcondition";
    $scope.$on("archiveInfoLoaded", function (event, msg) {
        $scope.patientId = msg.patientId;
        loadArchiveItemData($http, $scope, archiveItem);
    });
    
    $scope.ok = function (e) {
        saveArchiveItem ($http, $scope, null, archiveItem, $scope.records[0]);
    };
});