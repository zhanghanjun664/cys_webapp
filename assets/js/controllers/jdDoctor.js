'use strict';

var jdDoctors={
	doctorSkills : null,
	initScopeData : function($scope) {
		// TODO
	},
	initDoctorSkills : function(jdDoctorId) {
		var obj ;
		
		// 获取医生出诊疾病
// $http.get(REST_PREFIX+"jdSickCategary/doctorSkills").success(function
// (result) {
// console.info(result.body.result);
// $scope.doctorSkills = result.body.result;
// });
		var jdDoctorId=jdDoctorId?"/"+jdDoctorId:"";
		ajax(REST_PREFIX + "jdSickCategary/doctorSkills"+jdDoctorId, function(result) {
			if (result.body && result.body.code == 2000) {
				obj = result.body.result;
			}
		});
		return obj;
	},
	/* 检测字数通用fun */
    checkWord:function(obj, fun, speed) {
        // 部分ie中的onpropertychange事件并不能检测鼠标右键的删除和撤销等事件，opera的oninput事件不能检测直接拖动内容到textarea事件drop&&dragend，故这利用定时器解决
        if ($.browser.opera || $.browser.msie) {
            $(obj).focus(function() {
                setInterval(fun, speed);
            });
            $(obj).blur(function() {
                clearInterval(fun, speed);
            });
        }else {
        	// FF,Chrome,safari等浏览器可以利用oninput事件监听所有的事件，包括keydown,keyup,鼠标右键中的cut，paste和删除，撤销等所有事件，包括直接拖动drop等也支持
            $(obj).on("input",fun);
        }
    },
    /* 计算剩余字符,base.remainWord("#textarea",10,"#wordsNum"); */
    remainWord:function(textareaId, totalNum, remainId) {
        /*
		 * textareaId:代表textarea的ID; totalNum:代表可输入的总共的字符数; remainId:显示剩余字符数的ID;
		 */
        $(textareaId).each(function() {
            var self = $(this), remainObj = $(remainId), num = 0,currentNum=0;
            function fun() {
                num = totalNum - self.val().length;
                currentNum = self.val().length ;
                if (num >= 0) {
                    remainObj.css("color", "#828181").html(currentNum+"/"+totalNum);
                    self.removeClass("error");
                } else {
                    remainObj.css("color", "#f00").html(totalNum+"/"+totalNum);
                    self.addClass("error").val(self.val().substring(0, totalNum));
                }
                if (self.val() != "") {
                    self.prev("label").html("");
                }
            }
            
            jdDoctors.checkWord(self[0], fun, 100);
        });
    }
};
// 最外层控制器
app.controller("DoctorParentCtrl", function($scope) {
	$scope.$on("doctorSelectChange", function (event, msg) {
		$scope.$broadcast("doctorOrderHistory", msg);
		$scope.$broadcast("doctorPatientDb", msg);
		$scope.$broadcast("doctorOffline", msg);
		$scope.$broadcast("doctorBankCard", msg);
		$scope.$broadcast("doctorAddress", msg);
		$scope.$broadcast("doctorFee", msg);
		$scope.$broadcast("doctorService", msg);
		$scope.$broadcast("doctorInsurance", msg);
	});
});

// 医生列表信息控制器
app.controller('JdDoctorCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $localStorage,Admin_Constant,cysIndexedDB,$rootScope) {
	$scope.resultPage = {totalCount:0};
	$scope.data = []; // 当前页面的结果集
	$scope.selections = []; // 当前页面选中的行
	$scope.jdDistricts = []; // 地区信息
	$scope.jdHospitals = []; // 医院信息
	$scope.jdDepartments = []; // 科室信息
	$scope.jdTitles = []; // 职称信息
	$scope.jdDoctorId=
	$scope.getAttachInfos = function () {

		// 获取地区信息
		$scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
		$http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
			$scope.jdDistricts = result.districtList;
			$localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
		});


		// 判断是否存在版本号
		if(window.localStorage.getItem('hospitalVersionKey')){

			var oldKey=window.localStorage.getItem('hospitalVersionKey');

			if(oldKey===null||oldKey===""||oldKey===undefined){
				return false;
			}

			cysIndexedDB.openDB();
			$http.get(REST_PREFIX + "jdHospital/dataset_info").success(function (result) {
				var newKey=result.lastModifiedTime+result.count;

				if(newKey!==oldKey||typeof($rootScope.jdHospitals)=='undefined'){
					$http.get(REST_PREFIX + "jdHospital/list").success(function (result) {
						$scope.jdHospitals = result.hospitalList;
						cysIndexedDB.addData(cysIndexedDB.db,'hospital',result.hospitalList);
						window.localStorage.setItem('hospitalVersionKey',newKey);
					});
				}else{
					setTimeout(function(){
						$scope.jdHospitals=$rootScope.jdHospitals;
					},1000);
				}

			});


		}else {

			// 获取最新的版本号
			$http.get(REST_PREFIX + "jdHospital/dataset_info").success(function (result) {
				var key=result.lastModifiedTime+result.count;
				cysIndexedDB.openDB();
				// 请求数据
				$http.get(REST_PREFIX + "jdHospital/list").success(function (result) {
					$scope.jdHospitals = result.hospitalList;
					cysIndexedDB.addData(cysIndexedDB.db,'hospital',result.hospitalList);
					window.localStorage.setItem('hospitalVersionKey',key);
				});

			});

		}

		// 获取医院信息
		// $scope.jdHospitals =
		// $localStorage[Admin_Constant.LocalStorage.Hospitals];
		// if(!$scope.jdHospitals) {
		// $http.get(REST_PREFIX + "jdHospital/list").success(function (result)
		// {
		// $scope.jdHospitals = result.hospitalList;
		// $localStorage[Admin_Constant.LocalStorage.Hospitals] =
		// $scope.jdHospitals;
		// });
		// }


		// 获取科室信息
		$scope.jdDepartments = $localStorage[Admin_Constant.LocalStorage.Departments];
		$http.get(REST_PREFIX + "jdDepartment/list").success(function (result) {
				$scope.jdDepartments = result.departmentList;
				$localStorage[Admin_Constant.LocalStorage.Departments] = $scope.jdDepartments;
		});
		// 获取职称信息
		$scope.jdTitles = $localStorage[Admin_Constant.LocalStorage.Titles];
			$http.get(REST_PREFIX + "jdTitle/list").success(function (result) {
				$scope.jdTitles = result.titleList;
				$localStorage[Admin_Constant.LocalStorage.Titles] = $scope.jdTitles;
			});
		
	};
	$scope.getAttachInfos();
	
	// 根据地区ID显示地区的名称
	$scope.displayDistrictName = function (districtId) {
		for(var i = 0; i < $scope.jdDistricts.length; i++) {
			if($scope.jdDistricts[i].uuid == districtId)
				return $scope.jdDistricts[i].name;
		}
	};
	// 根据医院ID显示医院的名称
	$scope.displayHospitalName = function (hospitalId) {
		for(var i = 0; i < $scope.jdHospitals.length; i++) {
			if($scope.jdHospitals[i].hospitalId == hospitalId)
				return $scope.jdHospitals[i].name;
		}
	};
	// 根据科室ID显示科室的名称
	$scope.displayDepartmentName = function (departmentId) {
		for(var i = 0; i < $scope.jdDepartments.length; i++) {
			if($scope.jdDepartments[i].uuid == departmentId)
				return $scope.jdDepartments[i].name;
		}
	};
	// 根据职称ID显示职称的名称
	$scope.displayTitleName = function (titleId) {
		for(var i = 0; i < $scope.jdTitles.length; i++) {
			if($scope.jdTitles[i].uuid == titleId)
				return $scope.jdTitles[i].name;
		}
	};
	// 根据审核状态的值显示对应的描述
	$scope.showDoctorAuditStatus = function(status) {
		return showDoctorAuditStatus(status);
	};

	// 显示录入时间
	$scope.displayCreateDate = function (time) {
		if (time) {
			return time.split(" ")[0];
		} else {
			return "";
		}
	};

	// 获得当天新增医生数
	$scope.getIncreaseCount = function(){
		$http.get(REST_PREFIX + "doctor/increase").success(function (result){
			$scope.increaseCount = result;
		});
	};
	$scope.getIncreaseCount();

	$scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
			commonResetSelection($scope);
			$scope.searchInfos.pageIndex = params.page();
			$scope.searchInfos.pageSize = params.count();
			$scope.queryString = getQueryString($scope.searchInfos);
			var requestUrl = REST_PREFIX+"doctor/list"+$scope.queryString;
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
				$scope.$emit("doctorSelectChange", $scope.selectUuid);
			});
        }
    });
	
    // 新增
    $scope.edit = function (jdDoctor) {
    	var modalInstance = $modal.open({
            templateUrl: 'editJdDoctor.html',
            backdrop: 'static',
            keyboard: false,
			size: 'lg',
            controller: 'editJdDoctorCtrl',
    		resolve: {
    			jdDoctor : function() {
    				return jdDoctor;
    			},
				jdDistricts : function() {
					return $scope.jdDistricts;
				},
				jdHospitals : function() {
					return $scope.jdHospitals;
				},
				jdDepartments : function() {
					return $scope.jdDepartments;
				},
				jdTitles : function() {
					return $scope.jdTitles;
				},
				doctorSkills : function() {
					return $scope.doctorSkills;
				}
            }
        });
    	modalInstance.result.then(function (result) {
			$scope.tableParams.reload();
        });
    };
    
    // 删除操作
    $scope.deleteItem = function(id) {
        SweetAlert.swal({
            title: "确定删除吗?",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
				$http.delete(REST_PREFIX+"doctor/"+id).success(function (result) {
					if(result.result != 0) {
						toaster.pop("error", "提示", result.description);
					} else {
						$scope.tableParams.reload();
					}
				});
            }
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
    $scope.update = function () {
    	commonEditButtonClick(toaster, $scope);
    };

	// 点击行加载子tab内容
	$scope.doctorSelectChange = function(doctorId) {
		if($scope.selectUuid == doctorId)
			return;
		$(".tr_doctor").removeClass("info");
		$scope.selectUuid = doctorId;
		$scope.$emit("doctorSelectChange", $scope.selectUuid);
	};

	// 点击查询按钮
	$scope.searchInfos = {createTimeStart:null,createTimeEnd:null,districtId:null,hospitalId:null,departmentId:null,titleId:null,statusId:null,name:null,phoneNumber:null};
	$scope.search = function() {
        $scope.searchInfos = {createTimeStart:null,createTimeEnd:null,districtId:null,hospitalId:null,departmentId:null,titleId:null,statusId:null,name:null,phoneNumber:null};
		var modalInstance = $modal.open({
			templateUrl: 'searchJdDoctor.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchJdDoctorCtrl',
			resolve: {
				searchInfos : function() {
					return $scope.searchInfos;
				},
				jdDistricts : function() {
					return $scope.jdDistricts;
				},
				jdHospitals : function() {
					return $scope.jdHospitals;
				},
				jdDepartments : function() {
					return $scope.jdDepartments;
				},
				jdTitles : function() {
					return $scope.jdTitles;
				}
			}
		});
		modalInstance.result.then(function (searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.tableParams.reload();
		});
	}

});
// 医生信息查询控制器
app.controller('searchJdDoctorCtrl', function ($scope, $modalInstance, jdDistricts, jdHospitals, jdDepartments, jdTitles, searchInfos) {
	$scope.jdDistricts = jdDistricts;
	$scope.jdHospitals = [];
	$scope.jdDepartments = jdDepartments;
	$scope.jdTitles = jdTitles;
	$scope.doctorAuditStatus = doctorAuditStatus;
	$scope.cysBoolStatus = cysBoolStatus;
	$scope.searchInfos = searchInfos;

    $scope.datas = []; //原数据
    $scope.tempdatas = []; //下拉框选项副本
	// 根据选择的地区加载医院列表
	$scope.districtChange = function(districtId) {
		$scope.jdHospitals = [];
		$scope.searchInfos.hospitalId = "";
		jdHospitals.forEach(function(jdHospital) {
			if(jdHospital.jdDistrictId == districtId)
				$scope.jdHospitals.push(jdHospital);
		});

        $scope.datas = $scope.jdHospitals; //原数据
        $scope.tempdatas = $scope.datas; //下拉框选项副本
	};
    $scope.hidden_search_doctor=true;//选择框是否隐藏
    $scope.searchField='';//文本框数据
    //将下拉选的数据值赋值给文本框
    $scope.changeHospital=function(){
        $scope.searchField=$scope.select_hospital[0].name;
        $scope.searchInfos.hospitalId=$scope.select_hospital[0].hospitalId;
        $scope.hidden=true;
    }
    //获取的数据值与下拉选逐个比较，如果包含则放在临时变量副本，并用临时变量副本替换下拉选原先的数值，如果数据为空或找不到，就用初始下拉选项副本替换
    $scope.changeKeyValue=function(v){

        var newDate=[];  //临时下拉选副本
        //如果包含就添加
        angular.forEach($scope.datas ,function(data,index,array){
            if(data.name.indexOf(v)>=0){
                newDate.unshift(data);
            }
        });
        //用下拉选副本替换原来的数据
        $scope.datas=newDate;
        //下拉选展示
        $scope.hidden=false;
        //如果不包含或者输入的是空字符串则用初始变量副本做替换
        if($scope.datas.length==0 || ''==v){
            $scope.datas=$scope.tempdatas;
        }
        console.log($scope.datas);
    }

	if($scope.searchInfos.districtId) {
		jdHospitals.forEach(function(jdHospital) {
			if(jdHospital.jdDistrictId == $scope.searchInfos.districtId)
				$scope.jdHospitals.push(jdHospital);
		});
	}
	$("#createTimeEnd").val($scope.searchInfos.createTimeEnd);
	$("#createTimeStart").val($scope.searchInfos.createTimeStart);

	$scope.ok = function (e) {
		$scope.searchInfos.createTimeStart = $("#createTimeStart").val();
		$scope.searchInfos.createTimeEnd = $("#createTimeEnd").val();
		$modalInstance.close($scope.searchInfos);
	};
	$scope.cancel = function (e) {
        $scope.searchInfos = {createTimeStart:null,createTimeEnd:null,districtId:null,hospitalId:null,departmentId:null,titleId:null,statusId:null,name:null,phoneNumber:null};
		$modalInstance.dismiss();
	};
	$scope.clear = function () {
		$scope.searchInfos = {createTimeStart:null,createTimeEnd:null,districtId:null,hospitalId:null,departmentId:null,titleId:null,statusId:null,name:null,phoneNumber:null};
	};
});
// 医生信息编辑控制器
app.controller('editJdDoctorCtrl', function ($scope, $http, $rootScope, $modalInstance, $modal, toaster, jdDistricts, jdHospitals, jdDepartments, jdTitles, doctorSkills,jdDoctor) {
		$scope.obj = new Flow(); // 头像文件对象
		$scope.uploadUrl = REST_PREFIX + "doctor/headPic";
		$scope.removeImage = function () {
			$scope.noImage = true;
		};
		
		// 绑定出诊疾病的panel展开收缩事件
		$scope.panelClick=function(event){
			var $this=$(event.currentTarget);
			var panelBody=$this.next(".panel-body");
			if(panelBody.hasClass("collapse")){
				panelBody.fadeOut();
				panelBody.removeClass("collapse");
				$("i",$this).removeClass("fa-angle-down").addClass("fa-angle-up");
			}else{
				panelBody.fadeIn();
				panelBody.addClass("collapse");
				$("i",$this).removeClass("fa-angle-up").addClass("fa-angle-down");
			}
		}
		// 图片上传成功回调函数
		$scope.uploadSuccess = function(file, message) {
			var result = JSON.parse(message);
			if(result.result == 0) {
				$scope.jdDoctorInfo.headPic = result.uploadUrl;
				if(jdDoctor) {
					$http.put(REST_PREFIX+"doctor", $scope.jdDoctorInfo).success(function(saveResult) {
						if(saveResult.result == 0) {
							$modalInstance.close("success");
						} else {
							toaster.pop("error", "提示", saveResult.description);
						}
					});
				} else {
					$http.post(REST_PREFIX+"doctor", $scope.jdDoctorInfo).success(function(saveResult) {
						if(saveResult.result == 0) {
							$modalInstance.close("success");
						} else {
							toaster.pop("error", "提示", saveResult.description);
						}
					});
				}
			} else {
				toaster.pop("error", "提示", "上传图片失败，请联系管理员!");
				$scope.submitFlag = false;
			}
		};

		$scope.jdDistricts = jdDistricts;
		$scope.jdHospitals = [];
		$scope.jdDepartments = jdDepartments;
		$scope.jdTitles = jdTitles;
		$scope.auditStatus = doctorAuditStatus; // 审核状态
		// 根据选择的地区加载医院列表
		$scope.districtChange = function(districtId) {
			$scope.jdHospitals = [];
			$scope.jdDoctorInfo.jdHospitalId = "";
			jdHospitals.forEach(function(jdHospital) {
				if(jdHospital.jdDistrictId == districtId)
					$scope.jdHospitals.push(jdHospital);
			});
		};
		/** 勾选checkbox事件 */
		$scope.checkSickCategory=function(data,$event){
			var $this=$($event.currentTarget);
			var uuid=data.sickCategory.uuid;
			var name=data.sickCategory.name;
			if($this.is(":checked")){
				// 选中
				$scope.jdDoctorInfo.selectedSickCategoryList.push({
					uuid:uuid,
					name:name
				});
			}else{
				// 取消
				for (var i=0;i<$scope.jdDoctorInfo.selectedSickCategoryList.length;i++){
					var item=$scope.jdDoctorInfo.selectedSickCategoryList[i];
					if(item.uuid==uuid){
						$scope.jdDoctorInfo.selectedSickCategoryList.splice(i,1);
					}
				}
			}
		};
		/** 删除tag事件 */
		$scope.removeTag=function($tag){
			$(":checkbox[value='"+$tag.uuid+"']").prop("checked",false);
		};
		
// $scope.doctorSkills = doctorSkills;
    	$scope.submitFlag = false; // 为防止表单重复提交
    	$scope.jdDoctorInfo = {};
    	$scope.doctorSkills = jdDoctors.initDoctorSkills(jdDoctor?jdDoctor.uuid:null);
    	if(jdDoctor) {

    		$scope.jdDoctorInfo.uuid = jdDoctor.uuid;
			$scope.jdDoctorInfo.headPic = jdDoctor.headPic;
			$scope.jdDoctorInfo.qrCodeImageUrl = jdDoctor.qrCodeImageUrl;
			if(!$scope.jdDoctorInfo.headPic) {
				$scope.noImage = true;
			}
			$scope.jdDoctorInfo.jdDistrictId = jdDoctor.jdDistrictId;
			jdHospitals.forEach(function(jdHospital) {
				if(jdHospital.jdDistrictId == jdDoctor.jdDistrictId)
					$scope.jdHospitals.push(jdHospital);
			});
			$scope.jdDoctorInfo.jdHospitalId = jdDoctor.jdHospitalId;
			$scope.jdDoctorInfo.jdDepartmentId = jdDoctor.jdDepartmentId;
			$scope.jdDoctorInfo.jdTitleId = jdDoctor.jdTitleId;
    		$scope.jdDoctorInfo.name = jdDoctor.name;
			$scope.jdDoctorInfo.status = jdDoctor.status;
			$scope.jdDoctorInfo.certificateNumber = jdDoctor.certificateNumber;
			$scope.jdDoctorInfo.startDateStr = jdDoctor.startDate?jdDoctor.startDate.substring(0,7):"";
			$scope.jdDoctorInfo.officePhoneNumber = jdDoctor.officePhoneNumber;
			$scope.jdDoctorInfo.bdName =jdDoctor.bdName;
			$scope.jdDoctorInfo.bdPhoneNumber =jdDoctor.bdPhoneNumber;
			$scope.jdDoctorInfo.description = jdDoctor.description;
			$scope.jdDoctorInfo.totalBalance = jdDoctor.totalBalance;
			$scope.jdDoctorInfo.accountBalance = jdDoctor.accountBalance;
			$scope.jdDoctorInfo.deposit = jdDoctor.deposit;
			$scope.jdDoctorInfo.seq = jdDoctor.seq;
			$scope.jdDoctorInfo.gender = jdDoctor.gender;
			$scope.jdDoctorInfo.recommandCode = jdDoctor.recommandCode;
			$scope.jdDoctorInfo.freeCount = jdDoctor.freeCount;
			$scope.jdDoctorInfo.subsidy = jdDoctor.subsidy;
			$scope.jdDoctorInfo.certificateImage = jdDoctor.certificateImage;
			$scope.jdDoctorInfo.popularity = jdDoctor.popularity;
			$scope.jdDoctorInfo.expertise = jdDoctor.expertise;
			$scope.jdDoctorInfo.selectedSickCategoryList=$scope.doctorSkills.selectedSickCategoryList;
			$scope.jdDoctorInfo.applyPlus=jdDoctor.applyPlus+"";

            $scope.jdDoctorInfo.operationAmount = jdDoctor.operationAmount;
            $scope.jdDoctorInfo.operationName = jdDoctor.operationName;
            $scope.jdDoctorInfo.operationNumber = jdDoctor.operationNumber;
            $scope.jdDoctorInfo.operationDay = jdDoctor.operationDay;
            $scope.jdDoctorInfo.operationAverageFee = jdDoctor.operationAverageFee;
            $scope.jdDoctorInfo.complicationNumber = jdDoctor.complicationNumber;
    	} else {
			$scope.noImage = true;
			$scope.jdDoctorInfo.gender = "m";
			$scope.jdDoctorInfo.freeCount = -1;
			// 设置人气 随机
			var random_popularity = Math.floor(Math.random()*(300-100+1)+100);
			$scope.jdDoctorInfo.popularity = random_popularity;
			$scope.jdDoctorInfo.selectedSickCategoryList=[];
		}
    	
    	// 页面渲染完才进行的操作
    	setTimeout(function(){
    		// 移除ng-tags-input的输入框(官方无api禁止出现,此为变通方法)
    		$(".tag-list").next("input")[0].remove();
    		// 绑定textarea各类监听事件
    		jdDoctors.remainWord("#description",500,"#description-remainWord");
        	jdDoctors.remainWord("#expertise",200,"#expertise-remainWord");
        	
        	// 触发原有内容显示字数
        	$("#description,#expertise").trigger("input");
    	},0);
    	
        $scope.ok = function (e) {
			if($scope.jdDoctorInfo.headPic == undefined && !$scope.obj.flow.files[0]) {
				toaster.pop("error", "提示", "请上传医生头像");
				return;
			} else if($scope.obj.flow.files[0]) {
				if($scope.obj.flow.files[0].file.size > 1024*1024*5) {
					toaster.pop("error", "提示", "上传图片不能大于5M");
					return;
				}
			}
			console.info($scope.jdDoctorInfo);
			console.info($scope.jdDoctorInfo.selectedSickCategoryList);
			$scope.jdDoctorInfo.startDateStr = $("#startDateStr").val();
        	if(!validateFiledNullMax(toaster, $scope.jdDoctorInfo.jdDistrictId, "地区", true, 0)
				|| !validateFiledNullMax(toaster, $scope.jdDoctorInfo.jdHospitalId, "医院", true, 0)
				 || !validateFiledNullMax(toaster, $scope.jdDoctorInfo.jdDepartmentId, "科室", true, 0)
				  || !validateFiledNullMax(toaster, $scope.jdDoctorInfo.jdTitleId, "职称", true, 0)
				   || !validateFiledNullMax(toaster, $scope.jdDoctorInfo.status, "状态", true, 0)
				    || !validateFiledNullMax(toaster, $scope.jdDoctorInfo.name, "姓名", true, 32)
					 || !validateFiledInteger(toaster, $scope.jdDoctorInfo.seq, "排序序号", true)
				      || !validateFiledNullMax(toaster, $scope.jdDoctorInfo.certificateNumber, "执业证号", true, 0)
				       || !validateFiledNullMax(toaster, $scope.jdDoctorInfo.startDateStr, "从业时间", true, 0)
						 || !validateFiledNullMax(toaster, $scope.jdDoctorInfo.selectedSickCategoryList, "出诊疾病", true, 0)
						  || !validateTelephone(toaster, $scope.jdDoctorInfo.officePhoneNumber, "联系电话")
						   || !validateTelephone(toaster, $scope.jdDoctorInfo.bdPhoneNumber, "BD人员手机", true)
						   || !validateFiledNullMax(toaster, $scope.jdDoctorInfo.description, "简介", true, 0)
							|| !validateFiledInteger(toaster, $scope.jdDoctorInfo.subsidy, "平台补贴", false, true)
							 || !validateFiledInteger(toaster, $scope.jdDoctorInfo.deposit, "保证金", false, true)
							  || !validateFiledIntegerNorP(toaster, $scope.jdDoctorInfo.freeCount, "每天补贴号数", false)
								|| !validateFiledInteger(toaster, $scope.jdDoctorInfo.popularity, "人气", true))
        		return;
        	// 提交
        	if(!$scope.submitFlag) {
        		$scope.submitFlag = true;
				$http.post(REST_PREFIX + "doctor/validate", $scope.jdDoctorInfo).success(function (result) {
					if (result.result == 2) {
						$scope.submitFlag = false;
						toaster.pop("error", "提示", "邀请码【"+$scope.jdDoctorInfo.recommandCode+"】已经存在");
					} else {
						if($scope.obj.flow.files[0]) {
							$scope.obj.flow.upload();
						} else {
							if(jdDoctor) {
								$http.put(REST_PREFIX+"doctor", $scope.jdDoctorInfo).success(function(saveResult) {
									if(saveResult.result == 0) {
										$modalInstance.close("success");
									} else {
										toaster.pop("error", "提示", saveResult.description);
									}
								});
							} else {
								$http.post(REST_PREFIX+"doctor", $scope.jdDoctorInfo).success(function(saveResult) {
									if(saveResult.result == 0) {
										$modalInstance.close("success");
									} else {
										toaster.pop("error", "提示", saveResult.description);
									}
								});
							}
						}
					}
				});
        	}
        };
        $scope.cancel = function (e) {
            $modalInstance.dismiss();
        };
        
        // 图片放大弹出框
        $scope.open = function (jdDoctorInfo) {
            $modal.open({
                templateUrl: 'certificateImages.html',
                controller: 'ImageViewCtrl',
                size: 'lg',
                resolve: {
                    jdDoctorInfo: function () {
                        return jdDoctorInfo;
                    }
                }
            });
        };
 });

/** start 订单历史TAB * */
app.controller('DoctorOrderHistoryCtrl', function ($scope, $http, $modal, ngTableParams, $localStorage,Admin_Constant,cysIndexedDB,$rootScope) {
	$scope.$on("doctorOrderHistory", function (event, msg) {
		$scope.doctorId = msg;
		if(msg)
			$scope.getData();
		else {
			$scope.resultData = [];
			$scope.showData = [];
			$scope.data = [];
			$scope.tableParams.reload();
		}
	});

	$scope.resultData = []; // 后台返回总的结果集
	$scope.showData = []; // 当前选中类型的结果集
	$scope.data = []; // 当前页面的结果集

	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.showData.length,
		getData: function ($defer, params) {
			params.total($scope.showData.length);
			commonResetSelection($scope);
			$scope.data = $scope.showData.slice((params.page() - 1) * params.count(), params.page() * params.count());
			if($scope.data.length == 0 && params.page() > 1) { // 删除操作后如果当前页没有数据，自动跳转到前一页
				params.page(params.page() - 1);
				$scope.tableParams.reload();
			}
			$defer.resolve($scope.data);
		}
	});

	// 获取预约历史列表数据
	$scope.getData = function() {
		$http.get(REST_PREFIX+"doctor/orderHistory/"+$scope.doctorId).success(function (result) {
			$scope.resultData = result.orderList;
			$scope.getShowData();
			$scope.tableParams.reload();
			$(".tr_doctor").removeClass("info");
			$("#tr"+$scope.doctorId).addClass("info");
		});
	};

	// 根据订单状态的值显示对应的描述
	$scope.showOrderStatus = function(status) {
		return showOrderStatus(status, true);
	};

	$scope.currentStatus = "ALL";
	// 查看不同状态的数据
	$scope.statusChange = function(status) {
		if($scope.currentStatus == status)
			return;
		$("#btn_"+$scope.currentStatus).removeClass("btn-primary").addClass("btn-default");
		$("#btn_"+status).removeClass("btn-default").addClass("btn-primary");
		$scope.currentStatus = status;
		$scope.getShowData();
	};

	// 获取选中类型的结果集
	$scope.getShowData = function() {
		$scope.showData = [];
		if($scope.currentStatus == "ALL") {
			$scope.showData = $scope.resultData;
		} else {
			if($scope.currentStatus == "WAIT") {
				$scope.resultData.forEach(function(order){
					if(order.status == "WAITTO_DIAGNOSE") {
						$scope.showData.push(order);
					}
				});
			} else {
				$scope.resultData.forEach(function(order){
					if(order.status == "WAITTO_COMMENT" || order.status == "WAITTO_SHARE"
						|| order.status == "NO_COMMENT" || order.status == "NO_SHARE"
						 || order.status == "FINISHED") {
						$scope.showData.push(order);
					}
				});
			}
		}
		$scope.tableParams.reload();
	};

	$scope.edit = function (jdOrder) {
		var modalInstance = $modal.open({
			templateUrl: 'editOrder.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'editOrderCtrl',
			 size:"lg",
			resolve: {
				jdOrder : function() {
					return jdOrder;
				}
			}
		});
		modalInstance.result.then(function (result) {
			$scope.getData();
		});
	};
	

	
	/*
	 * $http.get(REST_PREFIX + "jdSick/all").success(function (result) {
	 * $scope.allSickList = result.sickList; console.log("allSickList
	 * result=",result); console.log("get
	 * $scope.allSickList=",$scope.allSickList); });
	 */
	
	
});

var jdSick={
		sickList:null,
		initScopeData:function($scope){
			console.log("$scope",$scope);
			jdSick.sickList=($scope.allSickList=jdSick.sickList?jdSick.sickList:jdSick.getAllSicks());
		},
		getAllSicks:function(){
			console.log("getAllSicks,jdSick.sickList=",jdSick.sickList);
			var list = [];
			ajax(REST_PREFIX + "jdSick/all", function(result) {
				if (result.body && result.body.code == 2000) {
					 list = result.body.result.sickList;
				}	
				// list= result.sickList;
			});
			console.log("getAllSicks,list=",list);
			return list;
		}
};


app.controller('editOrderCtrl', function ($scope, $modal,$http, $modalInstance, toaster, jdOrder) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.data = {};
	$scope.jdOrderInfo = {};
	/**
	 * allSickList和selectedSicks前面必须加上data，否则不会进行双向绑定
	 */
	$scope.data.selectedSicks = [];
	$scope.data.allSickList= [];
	$scope.orderSicks= [];
	$scope.selectSickResult=[];
	// $scope.data.allSickList=
	// [{"name":"伤寒","uuid":"1967879b-a88d-4565-ab98-3f2d1bac6772"},{"name":"古典型霍乱","uuid":"9b03bd49-ec07-4864-ab8c-5366c0ccf6f8"},{"name":"中型[典型]霍乱","uuid":"aab78c2f-54ae-4fbd-9382-f2a84d6e9bbb"}];
	// $scope.data.selectedSicks =
	// [{"name":"伤寒","uuid":"1967879b-a88d-4565-ab98-3f2d1bac6772"}];
	
	
	// jdSick.initScopeData($scope);
	// $scope.allSickList=jdSick.sickList;
	console.log("define $scope.data.allSickList=",$scope.data.allSickList);
	console.log("define $scope.data.selectedSicks=",$scope.data.selectedSicks);
	
	if(jdOrder) {
		$scope.jdOrder = jdOrder;
		$scope.jdOrderInfo.uuid = jdOrder.uuid;
		$scope.jdOrderInfo.orderNumber = jdOrder.orderNumber;
		$scope.jdOrderInfo.name = jdOrder.name;
		$scope.jdOrderInfo.phoneNumber = jdOrder.phoneNumber;
		$scope.jdOrderInfo.age = jdOrder.age;
		$scope.jdOrderInfo.sickDescription = jdOrder.sickDescription;
		$scope.jdOrderInfo.status = jdOrder.status;
		$scope.jdOrderInfo.diagnosis = jdOrder.diagnosis;
		$scope.jdOrderInfo.sickRemark = jdOrder.sickRemark;
		// $scope.jdOrderInfo.diagnosis = '可以确诊';
		
		$http.get(REST_PREFIX+"doctor/getOrderSickByOrderId/"+$scope.jdOrderInfo.uuid).success(function (result) {
			$scope.orderSicks = result;
			console.log("$scope.orderSicks=",JSON.stringify($scope.data.orderSicks,null,4));
			
			$scope.data.allSickList=$scope.orderSicks;
			//$scope.selectedSicks=$scope.orderSicks;
			
			
			/*
			 * 
			 * var i; for(i=0;i< $scope.selectedSicks.length;i++) {
			 * if(sick.name==$scope.selectedSicks[i].name) { break; } }
			 * if(i==$scope.selectedSicks.length) {
			 * $scope.selectedSicks.push(sickObj);
			 * console.log(JSON.stringify($scope.selectedSicks,null,4)); } });
			 *  }
			 */
			
			
 			
			// 要等上面返回数据，因为它不是按照顺序来调用的，上面查询比较慢
			/**
			 * 下面这个必须重新赋值给$scope.data.selectedSicks，否则和$scope.data.allSickList对不上
			 */
			/*var selecteds = [];
			$scope.data.allSickList.forEach(function(sick){
				$scope.data.selectedSicks.forEach(function(selected){
					if(sick.name == selected.name) {
						selecteds.push(sick);
					}
				});
			});
			$scope.data.selectedSicks=selecteds;*/
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
		
		$scope.jdOrderInfo.sickIds=sickIds;
		// 提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.put(REST_PREFIX+"doctor/order", $scope.jdOrderInfo).success(function(data) {
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
	// 根据订单状态的值显示对应的描述
	$scope.showOrderStatus = function(status) {
		return showOrderStatus(status, true);
	}
	
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


/** end 订单历史TAB * */

/** start 患者库TAB * */
app.controller('DoctorPatientDbCtrl', function ($scope, $http, $modal, ngTableParams) {
	$scope.$on("doctorPatientDb", function (event, msg) {
		$scope.doctorId = msg;
		if(msg)
			$scope.getData();
		else {
			$scope.resultData = [];
			$scope.data = [];
			$scope.tableParams.reload();
		}
	});

	$scope.resultData = []; // 后台返回总的结果集
	$scope.data = []; // 当前页面的结果集

	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultData.length,
		getData: function ($defer, params) {
			params.total($scope.resultData.length);
			commonResetSelection($scope);
			$scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
			if($scope.data.length == 0 && params.page() > 1) { // 删除操作后如果当前页没有数据，自动跳转到前一页
				params.page(params.page() - 1);
				$scope.tableParams.reload();
			}
			$defer.resolve($scope.data);
		}
	});

	// 获取患者库列表数据
	$scope.getData = function() {
		$http.get(REST_PREFIX+"doctor/patientDb?doctorId="+$scope.doctorId).success(function (result) {
			$scope.resultData = result.patientList;
			$scope.tableParams.reload();
			$(".tr_doctor").removeClass("info");
			$("#tr"+$scope.doctorId).addClass("info");
		});
	};

	// 查看出诊历史
	$scope.showDetail = function(patientId) {
		var modalInstance = $modal.open({
			templateUrl: 'patientDbOrderHistory.html',
			backdrop: 'static',
			keyboard: false,
			size: 'lg',
			controller: 'patientDbOrderHistoryCtrl',
			resolve: {
				doctorId : function() {
					return $scope.doctorId;
				},
				patientId : function() {
					return patientId;
				}
			}
		});
	};
});
app.controller('patientDbOrderHistoryCtrl', function ($scope, $http, $modalInstance, ngTableParams, doctorId, patientId) {
	$scope.resultData = []; // 后台返回总的结果集
	$scope.data = []; // 当前页面的结果集

	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultData.length,
		getData: function ($defer, params) {
			params.total($scope.resultData.length);
			$scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
			if($scope.data.length == 0 && params.page() > 1) { // 删除操作后如果当前页没有数据，自动跳转到前一页
				params.page(params.page() - 1);
				$scope.tableParams.reload();
			}
			$defer.resolve($scope.data);
		}
	});

	// 根据订单状态的值显示对应的描述
	$scope.showOrderStatus = function(status) {
		return showOrderStatus(status, true);
	};

	// 获取患者库列表数据
	$scope.getData = function() {
		$http.get(REST_PREFIX+"doctor/patientDb/orderHistory?doctorId="+doctorId+"&patientId="+patientId).success(function (result) {
			$scope.resultData = result.orderList;
			$scope.tableParams.reload();
		});
	};
	$scope.getData();

	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};

});
/** end 患者库TAB * */

/** start 发展用户TAB * */
app.controller('DoctorOfflineCtrl', function ($scope, $http, $modal, ngTableParams, $window) {
	$scope.resultPage = {totalCount:0};
	$scope.searchInfos = {};
	$scope.doctorId = "";
	$scope.offlineTableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultPage.totalCount,
		getData: function ($defer, params) {
			if($scope.doctorId) {
				$scope.searchInfos.pageIndex = params.page();
				$scope.searchInfos.pageSize = params.count();
				$scope.searchInfos.doctorId = $scope.doctorId;
				$scope.queryString = getQueryString($scope.searchInfos);
				var requestUrl = REST_PREFIX+"doctor/offline"+$scope.queryString;
				$http.get(requestUrl).success(function (result) {
					$scope.resultPage = result.resultPage;
					params.total($scope.resultPage.totalCount);
					params.page($scope.resultPage.nowPage);
					$defer.resolve($scope.resultPage.result);
				});
			}
		}
	});

	$scope.$on("doctorOffline", function (event, msg) {
		if(msg && msg != $scope.doctorId) {
			$scope.doctorId = msg;
			$scope.offlineTableParams.reload();
			$(".tr_doctor").removeClass("info");
			$("#tr"+$scope.doctorId).addClass("info");
		}
	});

	$scope.exportOffline = function() {
		var requestUrl = REST_PREFIX+"patient/offline/download?doctorId="+$scope.doctorId;
		$window.open(requestUrl);
	};

});
/** end 发展用户TAB * */

/** start 地址信息TAB * */
app.controller('DoctorAddressCtrl', function ($scope, $http, $modal, ngTableParams, SweetAlert) {
	$scope.$on("doctorAddress", function (event, msg) {
		$scope.doctorId = msg;
		if(msg)
			$scope.getData();
		else {
			$scope.resultData = [];
			$scope.data = [];
			$scope.tableParams.reload();
		}
	});

	$scope.resultData = []; // 后台返回总的结果集
	$scope.data = []; // 当前页面的结果集

	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultData.length,
		getData: function ($defer, params) {
			params.total($scope.resultData.length);
			$scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
			if($scope.data.length == 0 && params.page() > 1) { // 删除操作后如果当前页没有数据，自动跳转到前一页
				params.page(params.page() - 1);
				$scope.tableParams.reload();
			}
			$defer.resolve($scope.data);
		}
	});

	// 获取医生地址列表数据
	$scope.getData = function() {
		$http.get(REST_PREFIX+"jdAddress/list/"+$scope.doctorId).success(function (result) {
			$scope.resultData = result.addressList;
			$scope.tableParams.reload();
			$(".tr_doctor").removeClass("info");
			$("#tr"+$scope.doctorId).addClass("info");
		});
	};

	// 新增or编辑
	$scope.edit = function (address) {
		var modalInstance = $modal.open({
			templateUrl: 'editAddress.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'editAddressCtrl',
			resolve: {
				address : function() {
					return address;
				},
				doctorId : function() {
					return $scope.doctorId;
				}
			}
		});
		modalInstance.result.then(function (result) {
			$scope.getData();
		});
	};

	// 删除
	$scope.deleteItem = function(id) {
		SweetAlert.swal({
			title: "确定删除吗?",
			text: "记录删除后将不能恢复",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "确定",
			cancelButtonText: "取消"
		}, function (isConfirm) {
			if (isConfirm) {
				$http.delete(REST_PREFIX+"jdAddress/"+id).success(function (result) {
					if(result.result != 0) {
						toaster.pop("error", "提示", result.description);
					} else {
						$scope.getData();
					}
				});
			}
		});
	};
});
app.controller('editAddressCtrl', function ($scope, $http, $modalInstance, toaster, address, doctorId) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.address = {};
	if(address) {
		$scope.address.uuid = address.uuid;
		$scope.address.jdHospitalId = address.jdHospitalId;
		$scope.address.address = address.address;
		$scope.address.room = address.room;
		$scope.address.trafficGuide = address.trafficGuide;
		$scope.address.isDefault = address.isDefault+"";
	} else {
		$scope.address.isDefault = "false";
	}
	$scope.ok = function (e) {
		if(!validateFiledNullMax(toaster, $scope.address.address, "就诊地址", true, 0)
			|| !validateFiledNullMax(toaster, $scope.address.trafficGuide, "交通指导", true, 0)) {
			return;
		}
		// 提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX+"jdAddress/save/"+doctorId, $scope.address).success(function(result) {
				if(result.result != 0) {
					$scope.submitFlag = false;
					toaster.pop("error", "提示", result.description);
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
/** end 地址信息TAB * */

/** start 银行卡信息TAB * */
app.controller('DoctorBankCardCtrl', function ($scope, $http, $modal, ngTableParams, SweetAlert) {
	$scope.$on("doctorBankCard", function (event, msg) {
		$scope.doctorId = msg;
		if(msg)
			$scope.getData();
		else {
			$scope.resultData = [];
			$scope.data = [];
			$scope.tableParams.reload();
		}
	});

	$scope.resultData = []; // 后台返回总的结果集
	$scope.data = []; // 当前页面的结果集

	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultData.length,
		getData: function ($defer, params) {
			params.total($scope.resultData.length);
			$scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
			if($scope.data.length == 0 && params.page() > 1) { // 删除操作后如果当前页没有数据，自动跳转到前一页
				params.page(params.page() - 1);
				$scope.tableParams.reload();
			}
			$defer.resolve($scope.data);
		}
	});

	// 获取医生银行卡列表数据
	$scope.getData = function() {
		$http.get(REST_PREFIX+"jdBankCard/list/"+$scope.doctorId).success(function (result) {
			$scope.resultData = result.bankCardList;
			$scope.tableParams.reload();
			$(".tr_doctor").removeClass("info");
			$("#tr"+$scope.doctorId).addClass("info");
		});
	};

	// 新增or编辑
	$scope.edit = function (bankCard) {
		var modalInstance = $modal.open({
			templateUrl: 'editBankCard.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'editBankCardCtrl',
			resolve: {
				bankCard : function() {
					return bankCard;
				},
				doctorId : function() {
					return $scope.doctorId;
				}
			}
		});
		modalInstance.result.then(function (result) {
			$scope.getData();
		});
	};

	// 删除
	$scope.deleteItem = function(id) {
		SweetAlert.swal({
			title: "确定删除吗?",
			text: "记录删除后将不能恢复",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "确定",
			cancelButtonText: "取消"
		}, function (isConfirm) {
			if (isConfirm) {
				$http.delete(REST_PREFIX+"jdBankCard/"+id).success(function (result) {
					if(result.result != 0) {
						toaster.pop("error", "提示", result.description);
					} else {
						$scope.getData();
					}
				});
			}
		});
	};
});
app.controller('editBankCardCtrl', function ($scope, $http, $modalInstance, toaster, bankCard, doctorId) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.bankCard = {};
	if(bankCard) {
		$scope.bankCard.uuid = bankCard.uuid;
		$scope.bankCard.bankName = bankCard.bankName;
		$scope.bankCard.subBranch = bankCard.subBranch;
		$scope.bankCard.receiptAccount = bankCard.receiptAccount;
		$scope.bankCard.receiptName = bankCard.receiptName;
	}
	$scope.ok = function (e) {
		if(!validateFiledNullMax(toaster, $scope.bankCard.bankName, "开户银行", true, 0)
			|| !validateFiledNullMax(toaster, $scope.bankCard.subBranch, "所属支行", true, 0)
			 || !validateFiledNullMax(toaster, $scope.bankCard.receiptAccount, "银行卡号", true, 0)
			  || !validateFiledNullMax(toaster, $scope.bankCard.receiptName, "持卡人姓名", true, 0)) {
			return;
		}
		if(!validateCardNo($scope.bankCard.receiptAccount)) {
			toaster.pop("error", "提示", "银行卡号不正确");
			return;
		}
		// 提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX+"jdBankCard/save/"+doctorId, $scope.bankCard).success(function(result) {
				if(result.result != 0) {
					$scope.submitFlag = false;
					toaster.pop("error", "提示", result.description);
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
/** end 银行卡信息TAB * */

/** start 见面咨询诊金TAB * */
app.controller('DoctorFeeCtrl', function ($scope, $http, $modal, ngTableParams, SweetAlert) {
	$scope.$on("doctorFee", function (event, msg) {
		$scope.doctorId = msg;
		if(msg){
			$scope.getData();
		}
		else {
			$scope.resultData = [];
			$scope.data = [];
			$scope.tableParams.reload();
		}
	});

	$scope.resultData = []; // 后台返回总的结果集
	$scope.data = []; // 当前页面的结果集

	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultData.length,
		getData: function ($defer, params) {
			params.total($scope.resultData.length);
			$scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
			if($scope.data.length == 0 && params.page() > 1) { // 删除操作后如果当前页没有数据，自动跳转到前一页
				params.page(params.page() - 1);
				$scope.tableParams.reload();
			}
			$defer.resolve($scope.data);
		}
	});

	// 获取医生诊金列表数据
	$scope.getData = function() {
		$http.get(REST_PREFIX+"jdDoctorFee/list/"+$scope.doctorId).success(function (result) {
			$scope.resultData = result.doctorFeeList;
			$scope.tableParams.reload();
			$(".tr_doctor").removeClass("info");
			$("#tr"+$scope.doctorId).addClass("info");
		});
	};

	// 新增or编辑
	$scope.edit = function (doctorFee) {
		var modalInstance = $modal.open({
			templateUrl: 'editDoctorFee.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'editDoctorFeeCtrl',
			resolve: {
				doctorFee : function() {
					return doctorFee;
				},
				doctorId : function() {
					return $scope.doctorId;
				}
			}
		});
		modalInstance.result.then(function (result) {
			$scope.getData();
		});
	};

	// 删除
	$scope.deleteItem = function(doctorFee) {
		SweetAlert.swal({
			title: "确定删除吗?",
			text: "记录删除后将不能恢复",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "确定",
			cancelButtonText: "取消"
		}, function (isConfirm) {
			if (isConfirm) {
			    $http.post(REST_PREFIX+"jdDoctorFee/delete/"+$scope.doctorId, doctorFee.fee + '').success(function (result) {
					if(result.result != 0) {
						toaster.pop("error", "提示", result.description);
					} else {
						$scope.getData();
					}
				});
			}
		});
	};
});
app.controller('editDoctorFeeCtrl', function ($scope, $http, $modalInstance, toaster, doctorFee, doctorId) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.doctorFee = {};
	if(doctorFee) {
		$scope.doctorFee.uuid = doctorFee.uuid;
		$scope.doctorFee.fee = doctorFee.fee;
		$scope.doctorFee.sanjiuFee = doctorFee.sanjiuFee;
		$scope.doctorFee.isDefault = doctorFee.isDefault+"";
	} else {
		$scope.doctorFee.isDefault = "false";
	}
	$scope.ok = function (e) {
		if(!validateFiledInteger(toaster, $scope.doctorFee.fee, "诊金", false, true)) {
			return;
		}
		// 提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			$http.post(REST_PREFIX+"jdDoctorFee/save/"+doctorId, $scope.doctorFee).success(function(result) {
				if(result.result != 0) {
					$scope.submitFlag = false;
					toaster.pop("error", "提示", result.description);
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

/** start 服务设置TAB * */
app.controller('DoctorServiceCtrl', function ($scope, $http, $modal, ngTableParams, SweetAlert) {
    $scope.$on("doctorService", function (event, msg) {
        $scope.doctorId = msg;
        if(msg){
            $scope.getData();
        }
        else {
            $scope.resultData = [];
            $scope.data = [];
            $scope.tableParams.reload();
        }
    });

    $scope.resultData = []; // 后台返回总的结果集
    $scope.data = []; // 当前页面的结果集

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultData.length,
        getData: function ($defer, params) {
            params.total($scope.resultData.length);
            $scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
            if($scope.data.length == 0 && params.page() > 1) { // 删除操作后如果当前页没有数据，自动跳转到前一页
                params.page(params.page() - 1);
                $scope.tableParams.reload();
            }
            $defer.resolve($scope.data);
        }
    });

    // 获取医生诊金列表数据
    $scope.getData = function() {
        $http.get(REST_PREFIX+"doctor/service/list?"+ "doctor_id=" + $scope.doctorId).success(function (result) {
            $scope.resultData = result.body.result;
            $scope.tableParams.reload();
            $(".tr_doctor").removeClass("info");
            $("#tr"+$scope.doctorId).addClass("info");
        });
    };

    // 新增or编辑
    $scope.edit = function (doctorService) {
        var modalInstance = $modal.open({
            templateUrl: 'editDoctorService.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editDoctorServiceCtrl',
            resolve: {
                doctorService : function() {
                    return doctorService;
                },
                doctorId : function() {
                    return $scope.doctorId;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.getData();
        });
    };

});
app.controller('editDoctorServiceCtrl', function ($scope, $http, $modalInstance, toaster, doctorService, doctorId) {
    $scope.submitFlag = false; // 为防止表单重复提交
    $scope.doctorService = {};
    if(doctorService) {
        $scope.doctorService.id = doctorService.id;
        $scope.doctorService.price = doctorService.price;
        $scope.doctorService.serviceType = doctorService.serviceType;
        $scope.doctorService.serviceDesc = doctorService.serviceDesc;
        $scope.doctorService.providerType = doctorService.providerType;
        $scope.doctorService.providerId = doctorService.providerId;
        $scope.doctorService.status = doctorService.status;
        $scope.doctorService.statusDesc = doctorService.statusDesc;
        $scope.doctorService.freePeriod = doctorService.freePeriod;
    } else {
        $scope.doctorService.status = "false";
    }
    $scope.ok = function (e) {
        if(!validateFiledInteger(toaster, $scope.doctorService.price, "价格", false, true)) {
            return;
        }
        // 提交
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            $http.post(REST_PREFIX + "doctor/service", $scope.doctorService).success(function(result) {
                if(result.body.code != 2000) {
                    $scope.submitFlag = false;
                    toaster.pop("error", "提示", "服务器不开心啦");
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


/** start 保险设置TAB * */
app.controller('DoctorInsuranceCtrl', function ($scope, $http, $modal, ngTableParams, SweetAlert) {
    $scope.$on("doctorInsurance", function (event, msg) {
        $scope.doctorId = msg;
        if(msg){
            $scope.getData();
        }
        else {
            $scope.resultData = [];
            $scope.data = [];
            $scope.tableParams.reload();
        }
    });

    $scope.resultData = []; // 后台返回总的结果集
    $scope.data = []; // 当前页面的结果集

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultData.length,
        getData: function ($defer, params) {
            params.total($scope.resultData.length);
            $scope.data = $scope.resultData.slice((params.page() - 1) * params.count(), params.page() * params.count());
            if($scope.data.length == 0 && params.page() > 1) { // 删除操作后如果当前页没有数据，自动跳转到前一页
                params.page(params.page() - 1);
                $scope.tableParams.reload();
            }
            $defer.resolve($scope.data);
        }
    });

    // 获取所有保险产品（其中标记了当前医生开通的保险）列表
    $scope.getData = function() {
        $http.get(REST_PREFIX+"insurance/doctor/" + $scope.doctorId).success(function (result) {
            $scope.resultData = result.body.result;
            $scope.tableParams.reload();
            $(".tr_doctor").removeClass("info");
            $("#tr"+$scope.doctorId).addClass("info");
        });
    };

    // 编辑
    $scope.edit = function (doctorInsurance) {
        var modalInstance = $modal.open({
            templateUrl: 'editDoctorInsurance.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editDoctorInsuranceCtrl',
            resolve: {
                doctorInsurance : function() {
                    return doctorInsurance;
                },
                doctorId : function() {
                    return $scope.doctorId;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.getData();
        });
    };

});
app.controller('editDoctorInsuranceCtrl', function ($scope, $http, $modalInstance, toaster, doctorInsurance, doctorId) {
    $scope.submitFlag = false; // 为防止表单重复提交
    $scope.doctorInsurance = {};
    if(doctorInsurance) {
        $scope.doctorInsurance.productId = doctorInsurance.productId;
        $scope.doctorInsurance.name = doctorInsurance.name;
        $scope.doctorInsurance.vendor = doctorInsurance.vendor;
        $scope.doctorInsurance.status = doctorInsurance.status;
    } else {
        $scope.doctorInsurance.status = "false";
    }
    $scope.ok = function (e) {
        // 提交
        if(!$scope.submitFlag) {
            $scope.submitFlag = true;
            $http.post(REST_PREFIX + "insurance/doctor/" + doctorId, $scope.doctorInsurance).success(function(result) {
                if(result.body.code != 2000) {
                    $scope.submitFlag = false;
                    toaster.pop("error", "提示", "服务器不开心啦");
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


// 图片查看控制器
app.controller('ImageViewCtrl', function ($scope, $modalInstance, jdDoctorInfo) {
    $scope.jdDoctorInfo = jdDoctorInfo;
    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    }
});

/** end 医生诊金TAB * */