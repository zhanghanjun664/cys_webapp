'use strict';
app.controller('JdOrderCtrl', function ($scope, $http, $modal, ngTableParams, $window, $localStorage, Admin_Constant, SweetAlert,cysIndexedDB,$rootScope) {
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
            var requestUrl = REST_PREFIX+"order/list"+$scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $defer.resolve($scope.resultPage.result);
            });
        }
    });

    $scope.getAttachInfos = function () {
        //获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
        //获取渠道信息
        //$scope.jdQrcodeList = angular.copy($localStorage[Admin_Constant.LocalStorage.QrCodes]);
        //if(!$scope.jdQrcodeList) {
        //    $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
        //        $scope.jdQrcodeList = result.jdQrcodeList;
        //        $localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
        //        $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
        //    });
        //} else {
        //    $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
        //}

        //判断版本号是否存在
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
                        $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
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
                    $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
                });

            });
        }




    };
    $scope.getAttachInfos();

    //根据订单状态的值显示对应的描述
    $scope.showOrderStatus = function(status) {
        return showOrderStatus(status);
    };
    $scope.showOrderSource = function(status) {
        return showOrderSource(status);
    };

    //点击查询按钮
    $scope.searchInfos = {orderNumber:null,status:null,districtId:null,oppointmentTimeStart:null,oppointmentTimeEnd:null,
        createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,doctor:null,bdName:null,exceed:'',qrcodeList:null};
    $scope.search = function() {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdOrder.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdOrderCtrl',
            resolve: {
                searchInfos : function() {
                    return $scope.searchInfos;
                },
                districts : function() {
                    return $scope.jdDistricts;
                },
                jdQrcodeList : function() {
                    return $scope.jdQrcodeList;
                },
                orderSourceType : function() {
                    return gOrderSources;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    };

    $scope.export = function() {
        var requestUrl = REST_PREFIX+"order/download"+$scope.queryString;
        $window.open(requestUrl);
    };

    $scope.exportPayment = function() {
        var requestUrl = REST_PREFIX+"order/downloadPayment"+$scope.queryString;
        $window.open(requestUrl);
    };

    //更多
    $scope.more = function (order) {
        var modalInstance = $modal.open({
            templateUrl: 'moreOrderInfo.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'moreOrderInfoCtrl',
            resolve: {
                order : function() {
                    return order;
                }
            }
        });
    };

    //编辑
    $scope.editBtnCode = "ORDER_EDIT";
    $scope.exportBtnCode = "ORDER_EXPORT";
    $scope.edit = function (jdOrder) {
        var modalInstance = $modal.open({
            templateUrl: 'editOrder.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editOrderCtrl',
            resolve: {
                jdOrder : function() {
                    return jdOrder;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };
    $scope.change39Order= function (jdOrder) {
        if(jdOrder.source == "SANJIU" && jdOrder.status != "WAITTO_PAY" && jdOrder.status != "NO_PAY"){
            SweetAlert.swal({
                title: "提示",
                text: "你确定要修改订单",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "确定",
                cancelButtonText: "取消"
            },function(isConfirm){
                if(isConfirm){
                    $http.get(REST_PREFIX+"order/chang39OrderStatus?orderId="+jdOrder.uuid).success(
                        function(result){
                            if(result.result != 0) {
                                toaster.pop("error", "提示", result.description);
                            } else {
                                $scope.tableParams.reload();
                            }
                        }
                    );
                }
            });
        }else{
            SweetAlert.swal({
                title: "提示",
                text: "该订单不是39订单或者状态不可被修改",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "确定",
                cancelButtonText: "取消"
            });
        }
    }
});
app.controller('searchJdOrderCtrl', function ($scope, $modalInstance, searchInfos, districts, jdQrcodeList,$rootScope,cysIndexedDB,orderSourceType) {
    //获取渠道列表
    var qrcodeList = [];

    //jdQrcodeList.forEach(function(qrcode) {
    //    qrcodeList.push({uuid:qrcode.uuid, name:qrcode.name});
    //});
    $scope.jdQrcodeList = qrcodeList;
    $scope.districts = districts;
    $scope.orderSourceType = orderSourceType;

    //恢复上一次的查询条件
    $scope.searchInfos = searchInfos;
    $scope.orderStatus = patientOrderStatus; //订单状态
    $("#oppointmentTimeEnd").val($scope.searchInfos.oppointmentTimeEnd);
    $("#oppointmentTimeStart").val($scope.searchInfos.oppointmentTimeStart);
    $("#createTimeEnd").val($scope.searchInfos.createTimeEnd);
    $("#createTimeStart").val($scope.searchInfos.createTimeStart);
    var screenQrcodeList = [];
    if($scope.searchInfos.qrcodeList) {
        $scope.searchInfos.qrcodeList.forEach(function(sqrcode) {
            $scope.jdQrcodeList.forEach(function(qrcode) {
                if(qrcode.uuid === sqrcode.uuid)
                    screenQrcodeList.push(qrcode);
            });
        });
        $scope.searchInfos.qrcodeList = screenQrcodeList;
    }

    $scope.getMultipleData=function(db,storeName,searchTerm,index){
        console.log(searchTerm);
        var transaction=db.transaction(storeName);
        var store=transaction.objectStore(storeName);
        var index = store.index(index);
        var request=index.openCursor(IDBKeyRange.bound(searchTerm,searchTerm+'\uffff'));
        var arr=[];
        request.onsuccess=function(e){
            var cursor=e.target.result;
            if(cursor){
                var object={uuid:cursor.value.uuid, name:cursor.value.name};
                console.log(object);
                arr.push(object);
                $scope.jdQrcodeList=arr;
                cursor.continue();
            }
        }
    };


    $scope.refreshAddresses=function(address){
        if(address!==""){
            $scope.getMultipleData(cysIndexedDB.db,'qrCode',address,'name');
        }
    };
    
    $scope.ok = function (e) {
        $scope.searchInfos.oppointmentTimeStart = $("#oppointmentTimeStart").val();
        $scope.searchInfos.oppointmentTimeEnd = $("#oppointmentTimeEnd").val();
        $scope.searchInfos.createTimeStart = $("#createTimeStart").val();
        $scope.searchInfos.createTimeEnd = $("#createTimeEnd").val();
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {orderNumber:null,status:null,districtId:null,oppointmentTimeStart:null,oppointmentTimeEnd:null,
            createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,doctor:null,bdName:null,exceed:'',qrcodeList:null};
    };
});
app.controller('moreOrderInfoCtrl', function ($scope, $http, $modalInstance, order) {
    $scope.orderInfo = order;
    console.log("orderInfo =",JSON.stringify($scope.orderInfo,null,4));
    $http.get(REST_PREFIX+"doctor/getOrderSickByOrderId/"+$scope.orderInfo.uuid).success(function (result) {
		var sickArray=[];
    	if(result){
			result.forEach(function (sick){
				sickArray.push(sick.name);
			});
		}
    	 $scope.orderInfo.sicks=sickArray.join(",");
    });
    
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});
app.controller('editOrderCtrl', function ($scope, $http,$modal, $modalInstance, toaster, jdOrder) {
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.jdOrderInfo = {};
	$scope.data = {};
	$scope.data.selectedSicks = [];
	$scope.data.allSickList= [];
	$scope.orderSicks= [];
	$scope.selectSickResult=[];
	
    if(jdOrder) {
        $scope.jdOrder = jdOrder;
        $scope.jdOrderInfo.uuid = jdOrder.uuid;
        $scope.jdOrderInfo.orderNumber = jdOrder.orderNumber;
        $scope.jdOrderInfo.name = jdOrder.name;
        $scope.jdOrderInfo.phoneNumber = jdOrder.phoneNumber;
        $scope.jdOrderInfo.age = jdOrder.age;
        $scope.jdOrderInfo.sickDescription = jdOrder.sickDescription;
        $scope.jdOrderInfo.status = jdOrder.status;
        $scope.jdOrderInfo.remark = jdOrder.remark;
        $scope.jdOrderInfo.totalFee = jdOrder.totalFee;
        $scope.jdOrderInfo.idCard = jdOrder.idCard;
		$scope.jdOrderInfo.diagnosis = jdOrder.diagnosis;
		$scope.jdOrderInfo.sickRemark = jdOrder.sickRemark;
		
		$http.get(REST_PREFIX+"doctor/getOrderSickByOrderId/"+$scope.jdOrderInfo.uuid).success(function (result) {
			$scope.orderSicks = result;
			console.log("$scope.orderSicks=",JSON.stringify($scope.data.orderSicks,null,4));
			
			$scope.data.allSickList=$scope.orderSicks;
			
			//上面注释的等价于下面的，初始化更新$scope.data.selectedSicks的值
			if($scope.orderSicks){ 
				  $scope.data.selectedSicks=[];//要先置空
				  $scope.data.allSickList.forEach(function(sick){
			          $scope.orderSicks.forEach(function(selected){
				           if(sick.name ==selected.name) {
					          $scope.data.selectedSicks.push(sick); 
					       } 
				     }); 
			  }); 
			}
			console.log("init $scope.data.allSickList=",JSON.stringify($scope.data.allSickList,null,4));
			console.log("init $scope.data.selectedSicks=",JSON.stringify($scope.data.selectedSicks,null,4));
		});
		
		
    }
    if($scope.jdOrderInfo.status == "WAITTO_DIAGNOSE") {
        $scope.orderStatus = [
            {value:"WAITTO_DIAGNOSE",name:"待出诊"},
            {value:"WAITTO_COMMENT",name:"已出诊"},
            {value:"CANCEL_WITHIN",name:"取消(一小时内)"},
            {value:"CANCEL_OVERTIME",name:"取消(一小时后)"},
            {value:"CANCEL_DOCTOR",name:"医生取消"},
            {value:"PATIENT_MISS",name:"患者爽约"}
        ];
    } else if($scope.jdOrderInfo.status == "WAITTO_CONFIRM") {
        $scope.orderStatus = [
            {value:"WAITTO_CONFIRM",name:"待确认"},
            {value:"WAITTO_COMMENT",name:"已出诊"},
            {value:"CANCEL_WITHIN",name:"取消(一小时内)"},
            {value:"CANCEL_OVERTIME",name:"取消(一小时后)"},
            {value:"CANCEL_DOCTOR",name:"医生取消"},
            {value:"PATIENT_MISS",name:"患者爽约"}
        ];
    }
    $scope.ok = function (e) {
		var sickIds="";
		var sickArray=[];
		if($scope.data.selectedSicks){
			$scope.data.selectedSicks.forEach(function(sick){
				sickArray.push(sick.uuid);
			});
		}
		sickIds=sickArray.join(",");
		console.log("sickIds =",sickIds);
		
		$scope.jdOrderInfo.sickIds=sickIds;
		console.log("$scope.jdOrderInfo.sickIds =",$scope.jdOrderInfo.sickIds);
		console.log("$scope.jdOrderInfo.diagnosis =",$scope.jdOrderInfo.diagnosis);
		console.log("$scope.jdOrderInfo.status =",$scope.jdOrderInfo.status);
		
		if($scope.jdOrderInfo.status=='WAITTO_COMMENT'){
			if(!validateFiledNullMax(toaster, $scope.jdOrderInfo.diagnosis, "诊断结果", true, 0))
				return;
			if($scope.jdOrderInfo.diagnosis =='可以确诊' || $scope.jdOrderInfo.diagnosis =='疑似诊断'){
				if(!validateFiledNullMax(toaster, $scope.jdOrderInfo.sickIds, "诊断为", true, 0))
					return;
				if(!validateFiledNullMax(toaster, $scope.jdOrderInfo.sickRemark, "疾病备注", true, 0))
					return;
			}
		}
		

		
        //提交
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            $http.put(REST_PREFIX+"doctor/order", $scope.jdOrderInfo).success(function() {
                jdOrder.remark = $scope.jdOrderInfo.remark;
                jdOrder.status = $scope.jdOrderInfo.status;
                $modalInstance.close("success");
            }).error(function(error,status){
				console.log("status ={},error={}",status,error);
				toaster.pop("error", "提示", "服务器错误，稍后重试");
			});
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    //根据订单状态的值显示对应的描述
    $scope.showOrderStatus = function(status) {
        return showOrderStatus(status, true);
    };
    
	$scope.allDiagnosiss =['可以确诊','疑似诊断','无需诊断'];
	
	$scope.selectSick=function(){
        var modalInstance = $modal.open({
            templateUrl: 'selectSick.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectSickCtrl',
            size:"lg",
            resolve: {
            }
        });
        modalInstance.result.then(function (result) {
        	console.log("result=",result);
        	$scope.selectSickResult=result;
        	
        	console.log("$scope=",$scope);
        	$scope.change();
        });
    };
	$scope.change=function(){
		
		 var result=$scope.selectSickResult;
		 console.log("change result=",result);
		 
		 if(result){
			$scope.newSeletedSicks =[];
     		result.forEach(function(sick){
     			console.log("sick=",JSON.stringify(sick,null,4));
 				
     			  //更新所有疾病
				  var allSickListExistThisSick=false;
				  $scope.data.allSickList.forEach(function(selected){ 
					  if(sick.name==selected.name) { 
						  console.log("allSickList已存在sick=",sick);
				          allSickListExistThisSick=true; 
				       } 
				  });
				  if(!allSickListExistThisSick){
					     console.log("add ",sick);
				         $scope.data.allSickList.push(sick);
				  }
     		      //更新选择的疾病
				  var selectedSicksExistThisSick=false;
				  $scope.data.selectedSicks.forEach(function(selected){ 
					  if(sick.name ==selected.name) { 
						  console.log("selectedSicks已存在sick=",sick);
				         selectedSicksExistThisSick=true; 
				      } 
				  });
				  if(!selectedSicksExistThisSick){
				       $scope.data.selectedSicks.push(sick);
				   }
			 
     		});//result选择的疾病循环结束
     		
     		//更新$scope.data.selectedSicks为$scope.data.allSickList中对应的值
     		var selecteds = [];
			$scope.data.allSickList.forEach(function(sick){
				$scope.data.selectedSicks.forEach(function(selected){
					if(sick.name == selected.name) {
						selecteds.push(sick);
					}
				});
			});
			$scope.data.selectedSicks=selecteds;
     		
     	}
	 };
		
});

app.controller('selectSickCtrl', function ($scope, $http, $modalInstance,ngTableParams,toaster, $localStorage, Admin_Constant,$rootScope){
    $scope.justopen = true;
   
    $scope.resultPage = {totalCount:0};
    $scope.data = []; // 当前页面的结果集
    $scope.selections = []; // 当前页面选中的行
    $scope.searchInfo = {pageIndex:1,pageSize:10};
    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            if($scope.justopen) {
                $scope.justopen = false;
            } else {
                commonResetSelection($scope);
                $scope.searchInfo.pageIndex = params.page();
                $scope.searchInfo.pageSize = params.count();
                $scope.queryString = getQueryString($scope.searchInfo);
                var requestUrl = REST_PREFIX+"jdSick/list"+$scope.queryString;
                $http.get(requestUrl).success(function (result) {
                	console.log("result=",result);
                    $scope.resultPage = result.body.result;
                    params.total($scope.resultPage.totalRecords);
                    // params.page($scope.resultPage.nowPage);
                    $scope.data = $scope.resultPage.content;
                    $defer.resolve($scope.data);
                });
            }
        }
    });

    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };

    $scope.query=function(){
        $scope.tableParams.reload();
    };

    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };

    $scope.ok = function (e) {
        if ($scope.selections.length == 0) {
            toaster.pop("warning", "", "请选择一条记录", "1000");
        } else {
        	console.log("$scope=",$scope);
            var rowObject = new Object();
            // rowObject.name = $scope.selections[0].name;
            // rowObject.uuid = $scope.selections[0].uuid;
            rowObject=$scope.selections;
            $modalInstance.close(rowObject);
        }
    }

    $scope.clear=function(e){
        var rowObject = new Object();
        rowObject.name ="";
        rowObject.jdDoctorId ="";
        $modalInstance.close(rowObject);
    }
});

