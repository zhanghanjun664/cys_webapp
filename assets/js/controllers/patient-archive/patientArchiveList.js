'use strict';

// 最外层控制器
app.controller("PatientArchiveParentCtrl", function($scope) {
    $scope.$on("rowSelectChange", function(event, msg) {
    });
});

function clearSearchInfos($scope) {
    $scope.searchInfos = {
        ageStart : null,
        ageEnd : null,
        name : null,
        phoneNumber : null,
        masterPhoneNumber : null,
        gender : null,
        useOperation : null,
        hasOrder : null,
        diseaseCategories : null,
    };
}

// 医生列表信息控制器
app.controller('PatientArchiveListCtrl', function($scope, $http, $modal,
        ngTableParams, toaster, $localStorage, Admin_Constant,
        cysIndexedDB, $rootScope, $window) {
    $scope.resultPage = {
        totalCount : 0
    };
    $scope.data = []; // 当前页面的数据
    $scope.selections = []; // 当前页面选中的行
    // 获取地区信息
    $scope.jdDistricts = loadJdDistricts($http, Admin_Constant, $localStorage);

    // 获得市辖区信息
    $scope.jdDistrictAreas = loadJdDistrictAreas($http, Admin_Constant,
            $localStorage);

    // 根据地区ID显示地区的名称
    $scope.displayDistrictName = function(districtId) {
        for (var i = 0; i < $scope.jdDistricts.length; i++) {
            if ($scope.jdDistricts[i].uuid == districtId)
                return $scope.jdDistricts[i].name;
        }
    };

    // 显示录入时间
    $scope.displayCreateDate = function(time) {
        if (time) {
            return time.split(" ")[0];
        } else {
            return "";
        }
    };
    
    $scope.showBooleanInChinese = function (b) {
    	return showBooleanInChinese(b);
    }
    
    $scope.showGender = function (genderCode) {
    	return showGender(genderCode);
    }

    $scope.tableParams = new ngTableParams({
        page : 1,
        count : 10
    }, {
        total : $scope.resultPage.totalCount,
        getData : function($defer, params) {
            commonResetSelection($scope);
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "archive/list" + $scope.queryString;
            $http.get(requestUrl).success(function(result) {
                $scope.resultPage = result.resultPage;
                if (!$scope.resultPage) {
                    toaster.pop("error", "提示", "没有符合条件的数据");
                }
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);

                if ($scope.resultPage.result[0]) {
                    $scope.selectUuid = $scope.resultPage.result[0].uuid;
                } else {
                    $scope.selectUuid = "";
                }
                $scope.$emit("rowSelectChange", $scope.selectUuid);
            });
        }
    });

    $scope.add = function(archive) {
        var modalInstance = $modal.open({
            templateUrl : 'addPatientArchive.html',
            backdrop : 'static',
            keyboard : false,
            size : 'lg',
            controller : 'addPatientArchiveCtrl',
            resolve : {}
        });
        modalInstance.result.then(function(result) {
            $scope.tableParams.reload();
        });
    };

    // 改变当前选中的行(checkbox)
    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };

    // 全选/全不选
    $scope.selectAll = function() {
        commonSelectAll($scope);
    };

    // 点击删除按钮
    $scope.deleteAll = function() {
        commonDeleteButtonClick(toaster, $scope);
    };

    // 点击编辑按钮
    $scope.update = function() {
        commonEditButtonClick(toaster, $scope);
    };
    
    clearSearchInfos($scope);

    $scope.search = function() {
        clearSearchInfos($scope);
        var modalInstance = $modal.open({
            templateUrl : 'searchPatientArchive.html',
            backdrop : 'static',
            keyboard : false,
            controller : 'searchPatientArchiveCtrl',
            resolve : {
                searchInfos : function() {
                    return $scope.searchInfos;
                }
            }
        });
        modalInstance.result.then(function(searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    }
    
    $scope.edit = function(archive) {
        window.open('/assets/views/patient-archive/patientArchiveEditor.html?id=' + archive.id + '#panel-1');
    }
    
	//点击导出按钮
	$scope.export = function() {
		var requestUrl = REST_PREFIX+"archive/download"+$scope.queryString;
		$window.open(requestUrl);
	};

});

app.controller('addPatientArchiveCtrl', function($scope, $http, $modal,
        $modalInstance, toaster, SweetAlert) {
    $scope.submitFlag = false; // 为防止表单重复提交
    $scope.archiveInfo = {};
    $scope.ok = function(e) {
        if (!validateFiledNullMax(toaster, $scope.archiveInfo.name, "患者姓名", true, 64)
                || !validateFiledInteger(toaster, $scope.archiveInfo.phoneNumber, "患者手机号", false, true)
                || !validateFiledNullMax(toaster, $scope.archiveInfo.source, "患者来源", true, 64))
            return;
        // 提交
        if (!$scope.submitFlag) {
            var confirmed = true;
        	if ($scope.archiveInfo.masterPatientId === undefined) { // 未指定主账号
        	    var requestUrl = REST_PREFIX + "patient/list?phoneNumber=" + $scope.archiveInfo.phoneNumber;
			    $http.get(requestUrl).success(function (result) {
			    	if (result.resultPage.totalCount > 0) {
			    		alert("本手机号已存在，请选择主账号后再新增患者!");
			    	} else {
			    		if(window.confirm('新增患者档案后，系统会帮用户注册一个相同手机号的账号，确认新增吗？')){
			    			console.log('choose ok');
		    				sendArchiveCreationRequest();
			    	    }
			    	}
			    });
        	} else {
            	sendArchiveCreationRequest();
        	}
        }
    };
    
    function sendArchiveCreationRequest() {
        $scope.archiveInfo.patientId = $scope.archiveInfo.uuid;
        $scope.archiveInfo.uuid = undefined;
        $http.post(REST_PREFIX + "archive", $scope.archiveInfo).success(
            function(result) {
                if (result.result != 0) {
                    $scope.submitFlag = false;
                    toaster.pop("error", "提示", "患者档案已经存在");
                } else {
                    $modalInstance.close("success");
                }
            }
        );
    }

    $scope.selectPatient = function() {
        var modalInstance = $modal.open({
            templateUrl : 'selectPatient.html',
            backdrop : 'static',
            keyboard : false,
            controller : 'selectPatientCtrl',
            size : "lg",
            resolve : {}
        });
        modalInstance.result.then(function(result) {
            $scope.selectedMasterName = result.name;
            $scope.archiveInfo.masterPatientId = result.uuid;
            $("#master_name").prop("readonly", true);
        });
    }

    $scope.cancel = function(e) {
        $modalInstance.dismiss();
    };
});

app.controller('selectPatientCtrl', function($scope, $http, cysIndexedDB,
        $modalInstance, ngTableParams, toaster, $localStorage, Admin_Constant,
        $modal) {
    $scope.justopen = true;
    // 获得地区信息
    $scope.jdDistricts = loadJdDistricts($http, Admin_Constant, $localStorage);
    // 获取渠道列表
    var qrcodeList = [];
    $scope.jdQrcodeList = qrcodeList;

    $scope.getMultipleData = function(db, storeName, searchTerm, index) {
        if (searchTerm != undefined && searchTerm != null && searchTerm != ""
                && searchTerm.length > 0) {
            $http.get(REST_PREFIX + "jdQrcode/searchByName?name=" + searchTerm)
                    .success(function(result) {
                        var cursor = result.jdQrcodeList;
                        if (cursor.length > 0) {
                            var arr = [];
                            cursor.forEach(function(qrcode) {
                                var object = {
                                    uuid : qrcode.uuid,
                                    name : qrcode.name
                                };
                                arr.push(object);
                            });
                            $scope.jdQrcodeList = arr;
                       }
             });
        }
    };

    $scope.refreshAddresses = function(address) {
        if (address !== "") {
            $scope.getMultipleData(cysIndexedDB.db, 'qrCode', address, 'name');
        }
    };

    $scope.resultPage = {
        totalCount : 0
    };
    $scope.data = []; // 当前页面的结果集
    $scope.selections = []; // 当前页面选中的行
    $scope.searchInfo = {
        pageIndex : 1,
        pageSize : 10
    };
    $scope.tableParams = new ngTableParams({
        page : 1,
        count : 10
    }, {
        total : $scope.resultPage.totalCount,
        getData : function($defer, params) {
            if ($scope.justopen) {
                $scope.justopen = false;
            } else {
                commonResetSelection($scope);
                $scope.searchInfo.pageIndex = params.page();
                $scope.searchInfo.pageSize = params.count();
                $scope.searchInfo.createTimeStart = $("#createTimeStart").val();
                $scope.searchInfo.createTimeEnd = $("#createTimeEnd").val();
                $scope.searchInfo.masterOnly = true;
                $scope.queryString = getQueryString($scope.searchInfo);
                if ($scope.searchInfo.qrcodeList) {
                    var str = new StringBuilder();
                    var first = true;
                    $scope.searchInfo.qrcodeList.forEach(function(
                            sqrcode) {
                        if (first) {
                            first = false;
                            str.append(sqrcode.uuid);
                        } else {
                            str.append(";" + sqrcode.uuid);
                        }
                    });
                    $scope.queryString += "&qrcodeList="
                            + str.toString();
                }
                var requestUrl = REST_PREFIX + "patient/list"
                        + $scope.queryString;
                $http.get(requestUrl).success(function(result) {
                    if (result.resultPage.totalCount == 0) {
                        toaster.pop("error", "提示", "没有符合条件的数据");
                    }
                    $scope.resultPage = result.resultPage;
                    params.total($scope.resultPage.totalCount);
                    params.page($scope.resultPage.nowPage);
                    $scope.data = $scope.resultPage.result;
                    $defer.resolve($scope.data);
                });
            }
        }
    });

    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };

    $scope.query = function() {
        $scope.tableParams.reload();
    };

    $scope.cancel = function(e) {
        $modalInstance.dismiss();
    };

    $scope.ok = function(e) {
        if ($scope.selections.length == 0) {
            toaster.pop("warning", "", "请选择一条记录", "1000");
        } else if ($scope.selections.length > 1) {
            toaster.pop("warning", "", "请只选择一条记录", "1000");
        } else {
        	var jdPatient = new Object();
            jdPatient.name = $scope.selections[0].name;
            jdPatient.uuid = $scope.selections[0].uuid;
            jdPatient.phoneNumber = $scope.selections[0].phoneNumber;
        	$http.get(REST_PREFIX + "archive/contacts?masterPatientId=" + jdPatient.uuid)
            .success(function(result) {
                $scope.contacts = result.body.result;
                if ($scope.contacts.length > 0) {
                    var mi = $modal.open({
                        templateUrl : 'showContactsInfo.html',
                        backdrop : 'static',
                        keyboard : false,
                        controller : 'showContactsInfoCtrl',
                        size : "lg",
                        resolve : { 
                        	jdPatient : function () {
                        		return jdPatient;
                        	},
                        	contacts :  function() {
                                return $scope.contacts;
                            }
                        }
                    }); 
                    mi.result.then(function(result) {
                        $modalInstance.close(result);
                    });
                } else {
                    $modalInstance.close(jdPatient);
                }
            });
        }
    }

    $scope.clear = function(e) {
        var rowObject = new Object();
        jdPatient.name = "";
        jdPatient.uuid = "";
        $modalInstance.close(rowObject);
    }
});

app.controller('showContactsInfoCtrl', function($scope, $modalInstance, jdPatient, contacts) {
    $scope.contacts = contacts;
	$scope.cancel = function(e) {
        $modalInstance.dismiss();
    };
    
    $scope.showGender = function (genderCode) {
    	return showGender(genderCode);
    }
    
    $scope.showBooleanInChinese = function (b) {
    	return showBooleanInChinese(b);
    }

    $scope.ok = function(e) {
    	$modalInstance.close(jdPatient);
    }
});

// 查询控制器
app.controller('searchPatientArchiveCtrl', function($http, $scope, $modal,
        $modalInstance, Admin_Constant, $localStorage, searchInfos) {
    $scope.cysBoolStatus = cysBoolStatus;
    $scope.searchInfos = searchInfos;
    $scope.cysGenders = cysGenders;
    $scope.datas = loadJdSickCategories($http, Admin_Constant, $localStorage);

    $scope.copiedSickCategoryList = $scope.datas;
    $scope.tempdatas = $scope.datas; // 下拉框选项副本

    $scope.hide_dropdown = true;// 选择框是否隐藏
    $scope.searchField = '';// 文本框数据
    // 将下拉选的数据值赋值给文本框
    $scope.changeSelection = function() {
        $scope.searchField = $scope.candidateList[0].name;
        $scope.searchInfos.diseaseCategory = $scope.candidateList[0].name;
        $scope.hidden = true;
    }
    // 获取的数据值与下拉选逐个比较，如果包含则放在临时变量副本，并用临时变量副本替换下拉选原先的数值，如果数据为空或找不到，就用初始下拉选项副本替换
    $scope.changeKeyValue = function(v) {

        var newDate = []; // 临时下拉选副本
        // 如果包含就添加
        angular.forEach($scope.datas, function(data, index, array) {
            if (data.name.indexOf(v) >= 0) {
                newDate.unshift(data);
            }
        });
        // 用下拉选副本替换原来的数据
        $scope.datas = newDate;
        // 下拉选展示
        $scope.hidden = false;
        // 如果不包含或者输入的是空字符串则用初始变量副本做替换
        if ($scope.datas.length == 0 || '' == v) {
            $scope.datas = $scope.tempdatas;
        }
        console.log($scope.datas);
    }

    $("#ageEnd").val($scope.searchInfos.ageEnd);
    $("#ageStart").val($scope.searchInfos.ageStart);

    $scope.ok = function(e) {
        $scope.searchInfos.ageStart = $("#ageStart").val();
        $scope.searchInfos.ageEnd = $("#ageEnd").val();
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function(e) {
        clearSearchInfos($scope);
        $modalInstance.dismiss();
    };
    $scope.clear = function() {
        clearSearchInfos($scope);
    };
    
});

app.controller('selectSickCtrl', function($scope, $http, $modalInstance,
        ngTableParams, toaster) {
    $scope.justopen = true;

    $scope.resultPage = {
        totalCount : 0
    };
    $scope.data = []; // 当前页面的结果集
    $scope.selections = []; // 当前页面选中的行
    $scope.searchInfo = {
        pageIndex : 1,
        pageSize : 10
    };
    $scope.tableParams = new ngTableParams({
        page : 1,
        count : 10
    }, {
        total : $scope.resultPage.totalCount,
        getData : function($defer, params) {
            if ($scope.justopen) {
                $scope.justopen = false;
            } else {
                commonResetSelection($scope);
                $scope.searchInfo.pageIndex = params.page();
                $scope.searchInfo.pageSize = params.count();
                $scope.queryString = getQueryString($scope.searchInfo);
                var requestUrl = REST_PREFIX + "jdSick/list"
                        + $scope.queryString;
                $http.get(requestUrl).success(function(result) {
                    console.log("result=", result);
                    $scope.resultPage = result.body.result;
                    params.total($scope.resultPage.totalRecords);
                    $scope.data = $scope.resultPage.content;
                    $defer.resolve($scope.data);
                });
            }
        }
    });

    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };

    $scope.query = function() {
        $scope.tableParams.reload();
    };

    $scope.cancel = function(e) {
        $modalInstance.dismiss();
    };

    $scope.ok = function(e) {
        if ($scope.selections.length == 0) {
            toaster.pop("warning", "", "请选择一条记录", "1000");
        } else if ($scope.selections.length > 1) {
            toaster.pop("warning", "", "请只选择一条记录", "1000");
        } else {
            var rowObject = new Object();
            rowObject = $scope.selections;
            $modalInstance.close(rowObject);
        }
    }

    $scope.clear = function(e) {
        var rowObject = new Object();
        rowObject.name = "";
        rowObject.id = "";
        $modalInstance.close(rowObject);
    }

});