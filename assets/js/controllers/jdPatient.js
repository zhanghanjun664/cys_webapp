'use strict';

app.controller("PatientParentCtrl", function($scope) {
	$scope.$on("patientSelectChange", function (event, msg) {
		$scope.$broadcast("patientOrderHistory", msg);
		$scope.$broadcast("patientOffline", msg);
		$scope.$broadcast("patientContacts", msg);
	 });
});
app.controller('JdPatientCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window, $localStorage, Admin_Constant,$rootScope,cysIndexedDB) {
	$scope.resultPage = {totalCount:0};
	$scope.data = []; //当前页面的结果集
	$scope.selections = []; //当前页面选中的行
	$scope.jdDistricts = []; //地区信息
	$scope.jdDistrictAreas = []; //地区信息

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
	$scope.getAttachInfos = function () {
        //获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
        //获得市辖区信息
        $scope.jdDistrictAreas = $localStorage[Admin_Constant.LocalStorage.DistrictAreas];
        if(!$scope.jdDistrictAreas) {
            $http.get(REST_PREFIX + "jdDistrictArea/list").success(function (result) {
                $scope.jdDistrictAreas = result.districtAreaList;
                $localStorage[Admin_Constant.LocalStorage.DistrictAreas] = $scope.jdDistrictAreas;
            });
        }
	};

	$scope.getAttachInfos();

	//根据地区ID显示地区的名称
	$scope.displayDistrictName = function (districtId) {
		for(var i = 0; i < $scope.jdDistricts.length; i++) {
			if($scope.jdDistricts[i].uuid == districtId)
				return $scope.jdDistricts[i].name;
		}
	};

	$scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
			commonResetSelection($scope);
			$scope.searchInfos.pageIndex = params.page();
			$scope.searchInfos.pageSize = params.count();
			$scope.searchInfos.masterOnly = true;
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
			var requestUrl = REST_PREFIX+"patient/list"+$scope.queryString;
			$http.get(requestUrl).success(function (result) {
				$scope.resultPage = result.resultPage;
				params.total($scope.resultPage.totalCount);
				params.page($scope.resultPage.nowPage);
				$scope.data = $scope.resultPage.result;
				$defer.resolve($scope.data);

				if($scope.resultPage.result[0]) {
					$scope.selectUuid = $scope.resultPage.result[0].uuid;
				} else {
					$scope.selectUuid = "";
				}
				$scope.$emit("patientSelectChange", $scope.selectUuid);
			});
        }
    });

	$scope.loadOrderHistory = function(patientId) {
		if($scope.selectUuid == patientId)
			return;
		$(".tr_patient").removeClass("info");
		$scope.selectUuid = patientId;
		$scope.$emit("patientSelectChange", $scope.selectUuid);
	};

    //新增
    $scope.edit = function (jdPatient) {
    	var modalInstance = $modal.open({
            templateUrl: 'editJdPatient.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editJdPatientCtrl',
    		resolve: {
    			jdPatient : function() {
    				return jdPatient;
    			},
				jdDistricts : function() {
					return $scope.jdDistricts;
				},
                jdDistrictAreas: function () {
                    return $scope.jdDistrictAreas;
                }
            }
        });
    	modalInstance.result.then(function (result) {
			$scope.tableParams.reload();
        });
    };

    //删除操作
    $scope.deleteItem = function(id) {
        SweetAlert.swal({
            title: "确定删除吗？",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
				$http.delete(REST_PREFIX+"patient/"+id).success(function (result) {
					if(result.result != 0){
						toaster.pop("error","提示",result.description);
					}else{
						$scope.tableParams.reload();
					}
				});
            }
        });

    };

    //改变当前选中的行
    $scope.changeSelection = function(index) {
    	commonChangeSelection($scope, index);
	};

	//全选/全不选
	$scope.selectAll = function() {
		commonSelectAll($scope);
	};

    //点击删除按钮
    $scope.deleteAll = function() {
    	commonDeleteButtonClick(toaster, $scope);
	};

    //点击编辑按钮
    $scope.update = function () {
    	commonEditButtonClick(toaster, $scope);
    };

	//点击查询按钮
	$scope.searchInfos = {districtId:null,districtAreaId:null,createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,qrcodeList:null,location:null};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchJdPatient.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchJdPatientCtrl',
			resolve: {
				searchInfos : function() {
					return $scope.searchInfos;
				},
				jdDistricts : function() {
					return $scope.jdDistricts;
				},
                jdDistrictAreas: function () {
                    return $scope.jdDistrictAreas;
                },
				jdQrcodeList : function() {
					return $scope.jdQrcodeList;
				}
			}
		});
		modalInstance.result.then(function (searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.tableParams.reload();
		});
	};
	//点击导出按钮
	$scope.export = function() {
		var requestUrl = REST_PREFIX+"patient/download"+$scope.queryString;
		$window.open(requestUrl);
	};
});
app.controller('searchJdPatientCtrl', function ($scope, $modalInstance, jdDistricts,jdDistrictAreas, searchInfos, jdQrcodeList,$rootScope,cysIndexedDB,$http) {
    $scope.jdDistricts = [];
    $scope.jdDistrictAreas = [];
	//获取渠道列表
	var qrcodeList = [];
	$scope.jdQrcodeList = qrcodeList;

    $scope.jdDistricts = jdDistricts.filter(function(districts){
        if(districts.isProvince){
            return districts;
        }
    });


    //根据地区Id得到市辖区信息
    $scope.changeDistrictAreas = function (districtId){
        $scope.jdDistrictAreas = [];
        $scope.searchInfos.districtAreaId = "";
        jdDistrictAreas.forEach(function(item){
            if (item.jdDistrictId == districtId && item.isCity)
                $scope.jdDistrictAreas.push(item);
        });
    };


    $scope.setDistrictArea = function (){
        for (var i=0; i<jdDistrictAreas.length; i++){
            if (jdDistrictAreas[i].jdDistrictId == searchInfos.districtId){
                $scope.jdDistrictAreas.push(jdDistrictAreas[i]);
            }
        }
    };
    $scope.setDistrictArea();

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
			$scope.getMultipleData(cysIndexedDB.db,'qrCode',address,'name');
		}
	};


	//恢复上一次的查询条件
	$rootScope.searchInfos = searchInfos;
	$("#createTimeEnd").val($scope.searchInfos.createTimeEnd);
	$("#createTimeStart").val($scope.searchInfos.createTimeStart);
	var screenQrcodeList = [];
	if($scope.searchInfos.qrcodeList) {

		$scope.searchInfos.qrcodeList.forEach(function(sqrcode) {
			//console.log(sqrcode);
			$scope.jdQrcodeList.forEach(function(qrcode) {
				if(qrcode.uuid === sqrcode.uuid){
					//console.log(qrcode);
					screenQrcodeList.push(qrcode);
				}
			});
		});
		$scope.searchInfos.qrcodeList = screenQrcodeList;
	}

	//点击确定的方法
	$scope.ok = function (e) {
		$scope.searchInfos.createTimeStart = $("#createTimeStart").val();
		$scope.searchInfos.createTimeEnd = $("#createTimeEnd").val();
		//地区 - 省份
        $scope.searchInfos.province = "";
        $scope.searchInfos.city = "";
        if($("#districtId").find("option:selected").text() != null
			&& $("#districtId").find("option:selected").text() != ''
			&& $("#districtId").find("option:selected").text() != '全部'){
            var province = $("#districtId").find("option:selected").text();
			$scope.searchInfos.province = province.replace("省","");
		}
        if($("#districtAreaId").find("option:selected").text() != null
            && $("#districtAreaId").find("option:selected").text() != ''
            && $("#districtAreaId").find("option:selected").text() != '全部'){
            var city = $("#districtAreaId").find("option:selected").text();
            $scope.searchInfos.city = city.replace("市","");
		}
		$modalInstance.close($scope.searchInfos);
	};
	//点击取消的方法
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	//点击清除的方法
	$scope.clear = function () {
		$scope.searchInfos = {districtId:null,districtAreaId:null,createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,qrcodeList:null,location:null};
	};
});
app.controller('editJdPatientCtrl', function ($scope, $http, $modalInstance, toaster, jdDistricts, jdPatient) {
	$scope.submitFlag = false; //为防止表单重复提交
	$scope.jdDistricts = jdDistricts;
	$scope.jdPatientInfo = {};
	if(jdPatient) {
		$scope.jdPatientInfo.jdDistrictId = jdPatient.jdDistrictId;
		$scope.jdPatientInfo.uuid = jdPatient.uuid;
		$scope.jdPatientInfo.name = jdPatient.name;
		$scope.jdPatientInfo.phoneNumber = jdPatient.phoneNumber;
		$scope.jdPatientInfo.age = jdPatient.age;
		$scope.jdPatientInfo.recommandCode = jdPatient.recommandCode;
		$scope.jdPatientInfo.recommandReward = jdPatient.recommandReward;
	}
	$scope.ok = function (e) {
		if(!validateFiledNullMax(toaster, $scope.jdPatientInfo.jdDistrictId, "地区", true, 0)
			|| !validateFiledNullMax(toaster, $scope.jdPatientInfo.name, "姓名", true, 0)
				|| !validateTelephone(toaster, $scope.jdPatientInfo.phoneNumber, "手机号码")
					|| !validateFiledNullMax(toaster, $scope.jdPatientInfo.recommandReward, "邀请奖励", true, 0))
			return;
		var recommandReward = parseInt($scope.jdPatientInfo.recommandReward);
		if(recommandReward instanceof isNaN) {
			toaster.pop("error", "提示", "【邀请奖励】输入不正确");
			return;
		} else if(recommandReward > 20) {
			toaster.pop("error", "提示", "【邀请奖励】范围是0-20");
			return;
		}
		//提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			if(jdPatient) {
				$http.put(REST_PREFIX+"patient", $scope.jdPatientInfo).success(function(result) {
					if (result.result == 1) {
						$scope.submitFlag = false;
						toaster.pop("error", "提示", "手机号码【"+$scope.jdPatientInfo.phoneNumber+"】已经存在");
					} else if(result.result == 2) {
						$scope.submitFlag = false;
						toaster.pop("error", "提示", "邀请码【"+$scope.jdPatientInfo.recommandCode+"】已经存在");
					} else {
						$modalInstance.close("success");
					}
				});
			}
		}
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
});

/** start 预约历史TAB **/
app.controller('PatientOrderHistoryCtrl', function ($scope, $http, $modal, ngTableParams) {
	$scope.$on("patientOrderHistory", function (event, msg) {
		if(msg)
			$scope.getData(msg);
		else {
			$scope.resultData = [];
			$scope.showData = [];
			$scope.data = [];
			$scope.orderHistoryTableParams.reload();
		}
	});

	$scope.resultData = []; //后台返回总的结果集
	$scope.showData = []; //当前选中类型的结果集
	$scope.data = []; //当前页面的结果集

	$scope.orderHistoryTableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.showData.length,
		getData: function ($defer, params) {
			params.total($scope.showData.length);
			$scope.data = $scope.showData.slice((params.page() - 1) * params.count(), params.page() * params.count());
			if($scope.data.length == 0 && params.page() > 1) { //删除操作后如果当前页没有数据，自动跳转到前一页
				params.page(params.page() - 1);
				$scope.orderHistoryTableParams.reload();
			}
			$defer.resolve($scope.data);
		}
	});

	//获取预约历史列表数据
	$scope.getData = function(patientId) {
		$http.get(REST_PREFIX+"patient/orderHistory/"+patientId).success(function (result) {
			$scope.resultData = result.orderList;
			$scope.getShowData();
			$(".tr_patient").removeClass("info");
			$("#tr"+patientId).addClass("info");
		});
	};

	//根据订单状态的值显示对应的描述
	$scope.showOrderStatus = function(status) {
		return showOrderStatus(status);
	};

	$scope.currentStatus = "ALL";
	//查看不同状态的数据
	$scope.statusChange = function(status) {
		if($scope.currentStatus == status)
			return;
		$("#btn_"+$scope.currentStatus).removeClass("btn-primary").addClass("btn-default");
		$("#btn_"+status).removeClass("btn-default").addClass("btn-primary");
		$scope.currentStatus = status;
		$scope.getShowData();
	};

	//获取选中类型的结果集
	$scope.getShowData = function() {
		$scope.showData = [];
		if($scope.currentStatus == "ALL") {
			$scope.showData = $scope.resultData;
		} else {
			$scope.resultData.forEach(function(order){
				if(order.status == $scope.currentStatus) {
					$scope.showData.push(order);
				}
			});
		}
		$scope.orderHistoryTableParams.reload();
	};
 });
/** end 预约历史TAB **/

/** start 发展用户TAB **/
app.controller('PatientOfflineCtrl', function ($scope, $http, $modal, ngTableParams, $window) {
	$scope.resultPage = {totalCount:0};
	$scope.searchInfos = {};
	$scope.patientId = "";
	$scope.offlineTableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultPage.totalCount,
		getData: function ($defer, params) {
			if($scope.patientId) {
				$scope.searchInfos.pageIndex = params.page();
				$scope.searchInfos.pageSize = params.count();
				$scope.searchInfos.patientId = $scope.patientId;
				$scope.queryString = getQueryString($scope.searchInfos);
				var requestUrl = REST_PREFIX+"patient/offline"+$scope.queryString;
				$http.get(requestUrl).success(function (result) {
					$scope.resultPage = result.resultPage;
					params.total($scope.resultPage.totalCount);
					params.page($scope.resultPage.nowPage);
					$defer.resolve($scope.resultPage.result);
				});
			}
		}
	});

	$scope.$on("patientOffline", function (event, msg) {
		if(msg && msg != $scope.patientId) {
			$scope.patientId = msg;
			$scope.offlineTableParams.reload();
			$(".tr_patient").removeClass("info");
			$("#tr"+msg).addClass("info");
		}
	});

	$scope.exportOffline = function() {
		var requestUrl = REST_PREFIX+"patient/offline/download?patientId="+$scope.patientId;
		$window.open(requestUrl);
	};

});
/** end 发展用户TAB **/

/** start 联系人 **/
app.controller('PatientContactsCtrl', function ($scope, $http, $modal, ngTableParams){
	$scope.resultPage = {totalCount:0};
	$scope.searchInfos = {};
	$scope.parentId = "";
	$scope.contactsTableParams = new ngTableParams({
		page: 1,
		count: 10
	},{
		total: $scope.resultPage.totalCount,
		getData: function ($defer, params){
			if($scope.parentId) {
				$scope.searchInfos.pageIndex = params.page();
				$scope.searchInfos.pageSize = params.count();
				$scope.searchInfos.parentId = $scope.parentId;
				$scope.queryString = getQueryString($scope.searchInfos);
				var requestUrl = REST_PREFIX + "patient/contacts" + $scope.queryString;
				$http.get(requestUrl).success(function (result){
					$scope.resultPage = result.resultPage;
					params.total($scope.resultPage.totalCount);
					params.page($scope.resultPage.nowPage);
					$defer.resolve($scope.resultPage.result);
				});
			}
		}
	});

	$scope.$on("patientContacts", function (event, msg) {
		if(msg && msg != $scope.parentId) {
			$scope.parentId = msg;
			$scope.contactsTableParams.reload();
			$(".tr_patient").removeClass("info");
			$("#tr"+msg).addClass("info");
		}
	});

	//病史
	$scope.more = function (contacts) {
		var modalInstance = $modal.open({
			templateUrl: 'moreContactsInfo.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'moreContactsInfoCtrl',
			resolve: {
				contacts : function() {
					return contacts;
				}
			}
		});
	};
});
/** end 联系人 **/

app.controller('moreContactsInfoCtrl', function ($scope, $http, $modalInstance, contacts) {
	$scope.contactsInfo = contacts;
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
});