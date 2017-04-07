'use strict';
app.controller('JdQrcodeSpreadCtrl', function ($window, $scope, $http, $modal, ngTableParams,cysIndexedDB,$rootScope) {

	$scope.resultPage = {totalCount:0};

	$scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
			$scope.searchInfos.pageIndex = params.page();
			$scope.searchInfos.pageSize = params.count();
			$scope.queryString = getQueryString($scope.searchInfos);
			if($scope.searchInfos.qrcodeList) {
				var str = new StringBuilder();
				var first = true;
				$scope.searchInfos.qrcodeList.forEach(function(sqrcode) {
					if(first) {
						first = false;
						str.append(sqrcode.uuid);
					} else {
						str.append(";" + sqrcode.uuid);
					}
				});
				$scope.queryString += "&qrcodeList=" + str.toString();
			}
			var requestUrl = REST_PREFIX+"jdQrcodeSpread/page"+$scope.queryString;
			$http.get(requestUrl).success(function (result) {
				$scope.resultPage = result.resultPage;
				params.total($scope.resultPage.totalCount);
				params.page($scope.resultPage.nowPage);
				$defer.resolve($scope.resultPage.result);
			});
        }
    });

	if(window.localStorage.getItem('qrCodeVersionKey')){
		console.log('can found version!');
		var oldKey=window.localStorage.getItem('qrCodeVersionKey');
		if(oldKey===null||oldKey===""||oldKey===undefined){
			return false;
		}
		cysIndexedDB.openDB();
		$http.get(REST_PREFIX + "jdQrcode/dataset_info").success(function (result) {

			var newKey=result.lastModifiedTime+result.count;
			if(newKey!==oldKey){

				$http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
					$scope.jdQrcodeList = result.jdQrcodeList;
					cysIndexedDB.addData(cysIndexedDB.db,'qrCode',result.jdQrcodeList);
					window.localStorage.setItem('qrCodeVersionKey',newKey);
					//$scope.jdQrcodeList.push({"uuid":"0","name":"无"});
				});

			}else{
				setTimeout(function(){
					$scope.jdQrcodeList=$rootScope.jdQrcodeList;
				},1000);
			}
		});
	}else {
		$http.get(REST_PREFIX + "jdQrcode/dataset_info").success(function (result) {
			var key=result.lastModifiedTime+result.count;
			cysIndexedDB.openDB();

			$http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
				$scope.jdQrcodeList = result.jdQrcodeList;
				cysIndexedDB.addData(cysIndexedDB.db,'qrCode',result.jdQrcodeList);
				window.localStorage.setItem('qrCodeVersionKey',key);
				//$scope.jdQrcodeList.push({"uuid":"0","name":"无"});
			});

		});
	}



	//点击查询按钮
	$scope.searchInfos = {qrcodeList:null,startTime:null,endTime:null};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchJdQrcodeSpread.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchJdQrcodeSpreadCtrl',
			resolve: {
				searchInfos : function() {
					return $scope.searchInfos;
				}
			}
		});
		modalInstance.result.then(function (searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.tableParams.reload();
		});
	};

	$scope.export = function() {
		var requestUrl = REST_PREFIX+"jdQrcodeSpread/download"+$scope.queryString;
		$window.open(requestUrl);
	};

});
app.controller('searchJdQrcodeSpreadCtrl', function ($scope, $modalInstance, searchInfos, $localStorage, Admin_Constant,$http,$rootScope,cysIndexedDB) {
	//获取渠道列表
	//$scope.jdQrcodeList = angular.copy($localStorage[Admin_Constant.LocalStorage.QrCodes]);
	if(!$rootScope.jdQrcodeList) {
		$http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
			$scope.jdQrcodeList = result.jdQrcodeList;
			//$localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
			$scope.jdQrcodeList.push({"uuid":"0","name":"无"});
		});
	} else {
		$scope.jdQrcodeList.push({"uuid":"0","name":"无"});
	}

	$scope.jdQrcodeList=[];
	//恢复上一次的查询条件
	$scope.searchInfos = searchInfos;
	$("#startTime").val($scope.searchInfos.startTime);
	$("#endTime").val($scope.searchInfos.endTime);

	$scope.getMultipleData=function(db,storeName,searchTerm,index){
		if(searchTerm != undefined && searchTerm != null && searchTerm != "" && searchTerm.length > 0)
        $http.get(REST_PREFIX + "jdQrcode/searchByName?name="+searchTerm).success(function (result) {
            // result.jdQrcodeList;
            var cursor=result.jdQrcodeList;
            	if(cursor.length > 0){
                    var arr=[];
                    cursor.forEach(function(qrcode) {
                        var object={uuid:qrcode.uuid, name:qrcode.name};
                        arr.push(object);
					});
                    $scope.jdQrcodeList=arr;
            	}
        });
	};


	$scope.refreshAddresses=function(address){
		if(address!==""){
			console.log(address);
			$scope.getMultipleData(cysIndexedDB.db,'qrCode',address,'name');
		}
	};

	$scope.ok = function (e) {
		$scope.searchInfos.startTime = $("#startTime").val();
		$scope.searchInfos.endTime = $("#endTime").val();
		$modalInstance.close($scope.searchInfos);
	};

	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};

	$scope.clear = function () {
		$("#startTime").val("");
		$("#endTime").val("");

		$scope.searchInfos = {qrcodeList:null};
	};
});