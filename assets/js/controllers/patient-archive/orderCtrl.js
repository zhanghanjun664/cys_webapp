app.controller('patientOrderHistoryCtrl',['$scope','$http','$modal','ngTableParams', 
                                          function($scope, $http, $modal, ngTableParams){
    $scope.$on("archiveInfoLoaded", function (event, msg) {
        $scope.patientId = msg.patientId;
        $scope.masterId = msg.masterId;
        $scope.patientName = msg.patientName;
        
        $scope.offlineOrders = {};
        $scope.plusOrders = {};
        $scope.imOrders= {};
        $scope.phoneOrders= {};
        
        loadOfflineOrders();
        loadPlusOrders();
        loadImOrders();
        loadPhoneOrders();
        
    	// 根据订单状态的值显示对应的描述
    	$scope.showOrderStatus = function(status) {
    		return showOrderStatus(status, true);
    	};
    	
        $scope.showOrderSource = function(status) {
            return showOrderSource(status);
        };
        
    	$scope.showOrderPlusStatus = function(status) {
    		return showOrderPlusStatus(status);
    	};
    	
        $scope.showServiceOrderStatus = function(status) {
            return showServiceOrderStatus(status);
        };
    });
    
    function loadOfflineOrders() {
    	var queryConditions = {};
    	queryConditions.contactId = $scope.patientId;
    	
    	queryConditions.pageIndex = 0;
    	queryConditions.pageSize = 1000;
    	
    	$scope.queryString = getQueryString(queryConditions);
    	var requestUrl = "/rest/order/list" + $scope.queryString;
    	$http.get(requestUrl).success(function (result) {
    		$scope.offlineOrders = result.resultPage.result;
    	});
    }
    
    function loadPlusOrders() {
    	var queryConditions = {};
    	queryConditions.patientId = $scope.masterId;
    	queryConditions.name = $scope.patientName;
    	
    	queryConditions.pageIndex = 0;
    	queryConditions.pageSize = 1000;
    	
    	
    	$scope.queryString = getQueryString(queryConditions);
    	var requestUrl = "/rest/jdOrderPlus/list" + $scope.queryString;
    	$http.get(requestUrl).success(function (result) {
    		$scope.plusOrders = result.resultPage.result;
    	});
    }
    
    function loadImOrders() {
    	var queryConditions = {};
    	queryConditions.patientId = $scope.masterId;
    	queryConditions.contactId = $scope.patientId;
    	queryConditions.pageIndex = 0;
    	queryConditions.pageSize = 1000;
    	
    	
    	$scope.queryString = getQueryString(queryConditions);
    	var requestUrl = "/rest/serviceorder/" + SERVICE_TYPE_IM + "/list" + $scope.queryString;
    	$http.get(requestUrl).success(function (result) {
    		$scope.imOrders = result.resultPage.result;
    	});
    }
    
    function loadPhoneOrders() {
    	var queryConditions = {};
    	queryConditions.patientId = $scope.masterId;
    	queryConditions.contactId = $scope.patientId;
    	queryConditions.pageIndex = 0;
    	queryConditions.pageSize = 1000;
    	
    	
    	$scope.queryString = getQueryString(queryConditions);
    	var requestUrl = "/rest/serviceorder/" + SERVICE_TYPE_PHONE + "/list" + $scope.queryString;
    	$http.get(requestUrl).success(function (result) {
    		$scope.phoneOrders = result.resultPage.result;
    	});
    }
}]);
