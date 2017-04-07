'use strict';
var rawText;
var ossprefix;
app.controller('FollowupCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window, $localStorage, Admin_Constant) {
	$scope.resultPage = {totalCount:0};
	$scope.data = []; //当前页面的结果集
	$scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
			commonResetSelection($scope);//重置查询框
			$scope.searchInfos.pageIndex = params.page();//params为ngTableParams对象的第一个参数
			$scope.searchInfos.pageSize = params.count();
			$scope.queryString = getQueryString($scope.searchInfos);
			if($scope.searchInfos.departmentids&&$scope.searchInfos.departmentids.length>0) {
				$scope.searchInfos.departmentids.forEach(function(id) {
					$scope.queryString += "&departmentIds=" + id;
				});
			}
			console.log("查询$scope.searchInfos=",$scope.searchInfos);
			var requestUrl = REST_PREFIX+"followup/list"+$scope.queryString;
			$http.get(requestUrl).success(function (result) {
				$scope.resultPage = result.resultPage;
				ossprefix=result.ossprefix;
				params.total($scope.resultPage.totalRecords);
//				params.page($scope.resultPage.nowPage);
				
				$scope.data = $scope.resultPage.content;
				console.log("data=",$scope.data);
				$defer.resolve($scope.data);
			});
			

        }
    });
	$scope.contains=function contains(arr, obj) {  
	    var i = arr.length;  
	    while (i--) {  
	        if (arr[i] === obj) {  
	            return true;  
	        }  
	    }  
	    return false;  
	} ; 
	//获取科室列表
	$http.get(REST_PREFIX+"jdDepartment/list").success(function (result) {
		console.log("jdDepartment/list",result.departmentList);
		var originDepartmentList=result.departmentList;
		var afterFilterDepartmentList=[];
		var needDepartment=['神经外科','心血管内科','心血管外科','神经内科'];
		originDepartmentList.forEach(function(item){
			if($scope.contains(needDepartment,item.name)){
				afterFilterDepartmentList.push(item);
			}
		})
		console.log("afterFilterDepartmentList=",afterFilterDepartmentList);
		$scope.departments = afterFilterDepartmentList;
	});
	
	//新增
    $scope.edit = function (followupTemplate) {
    	if(followupTemplate.ownerType==1){
   		 SweetAlert.swal({
   	            //text: "不能删除！",
   			    title: "该模板为医生个人模板，不允许编辑！",
   	            //showCancelButton: true,
   	            confirmButtonColor: "#DD6B55",
   	            confirmButtonText: "确定"
   	        });
   		 return;
   	    }
    	var modalInstance = $modal.open({
            templateUrl: 'editfollowupTemplate.html',
            backdrop: 'static',
            keyboard: false,
            windowClass: 'app-modal-window',
            controller: 'editfollowupTemplateCtrl',
    		resolve: {
    			followupTemplate : function() {
    				return followupTemplate;
    			},
    			departments: function(){
    				return $scope.departments;
    			}
            }
        });
    	modalInstance.result.then(function (result) {
			$scope.tableParams.reload();
        });
    };
    //删除操作
    $scope.deleteItem = function(id,ownerType) {
    	if(ownerType==1){
    		 SweetAlert.swal({
    	            //text: "不能删除！",
    			    title: "该模板为医生个人模板,不允许删除！",
    	            //showCancelButton: true,
    	            confirmButtonColor: "#DD6B55",
    	            confirmButtonText: "确定"
    	        });
    		 return;
    	}
        SweetAlert.swal({
            title: "是否删除该模板",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
				$http.delete(REST_PREFIX+"followup/"+id).success(function (result) {
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
	//点击删除按钮
	function commonDeleteButtonClick(toaster, $scope) {
		if ($scope.selections.length > 0) {
			var ownerTypes=getOwnerTypeStringFromSelections($scope.selections);
			if(ownerTypes!=null&&ownerTypes.indexOf("1")>=0){//医生建的
				 SweetAlert.swal({
	    	            //text: "不能删除！",
	    			    title: "有些模板为医生个人模板,不允许删除！",
	    	            //showCancelButton: true,
	    	            confirmButtonColor: "#DD6B55",
	    	            confirmButtonText: "确定",
	    	        });
				 return;
			}
			
			var ids = getIdStringFromSelections($scope.selections);
			$scope.deleteItem(ids);
		} else {
			showSelectOneTip(toaster, "error");
		}
	};
	function getOwnerTypeStringFromSelections(entities) {
		var result = null;
		entities.forEach(function(entity) {
			if (entity) {
				if (! result) {
					result = entity.ownerType+'';
				} else {
					result = result + "," + entity.ownerType;
				}
			}
		});
		return result;
	};
    //点击编辑按钮
    $scope.update = function () {
    	commonEditButtonClick(toaster, $scope);
    };
    //点击查询按钮
	$scope.searchInfos = {name:null,followupTemplateDepartments:[],ownerName:null,departmentids:[]};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchfollowupTemplate.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchfollowupTemplateCtrl',
			resolve: {
				searchInfos : function() {
					return $scope.searchInfos;
				},
				departments: function(){
    				return $scope.departments;
    			}
			}
		});
		modalInstance.result.then(function (searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.searchInfos.departmentids=[];
			$scope.searchInfos.followupTemplateDepartments.forEach(function(item) {
				$scope.searchInfos.departmentids.push(item.uuid);
			});
			console.log("modalInstance searchInfos=",searchInfos);
			console.log("modalInstance followupTemplateDepartments=",$scope.searchInfos.followupTemplateDepartments);
			$scope.tableParams.reload();
			
		});
	};
});
app.controller('searchfollowupTemplateCtrl', function ($scope, $modalInstance, searchInfos,departments) {
	//恢复上一次的查询条件
	$scope.searchInfos = searchInfos;
	$scope.departments = departments;
	console.log("searchfollowupTemplateCtrl searchInfos=",searchInfos);
	console.log("searchfollowupTemplateCtrl departments=",departments);

	$scope.ok = function (e) {
		$modalInstance.close($scope.searchInfos);
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	$scope.clear = function () {
		$scope.searchInfos = {name:null,departments:[],ownerName:null};
	};
});

app.controller('editfollowupTemplateCtrl', function ($scope, $http, $modalInstance, toaster , followupTemplate,departments) {
	
	$scope.submitFlag = false; //为防止表单重复提交
	$scope.followupTemplateInfo = {};
	$scope.data = {};
	$scope.data.followupTemplateDepartments =[];
	$scope.followupTemplateInfo.departmentIds =[];
	$scope.departments = departments;
	console.log("editfollowupTemplateCtrl->departments=",$scope.departments);
	//$scope.milestones = [];

	if(followupTemplate) {
		console.log("editfollowupTemplateCtrl->followupTemplate=",followupTemplate);

		//编辑逻辑
		//获取文章已选分类
		var selectedFollowupTemplateDepartments = [];
		var departmentInfoList=followupTemplate.departmentInfoList;
		console.log("editfollowupTemplateCtrl->departmentInfoList=",departmentInfoList);
		if(departmentInfoList!=undefined&&departmentInfoList!=null){
			$scope.departments.forEach(function(department){
				departmentInfoList.forEach(function(selected){
					if(department.uuid == selected.id) {
						selectedFollowupTemplateDepartments.push(department);
					}
				});
			});
		}
		
		$scope.data.followupTemplateDepartments = selectedFollowupTemplateDepartments;
		console.log("editfollowupTemplateCtrl->followupTemplateDepartments=",$scope.data.followupTemplateDepartments);
		console.log("editfollowupTemplateCtrl->followupTemplate.milestones=",followupTemplate.milestones);
		//已有数据的赋值展示
		$scope.followupTemplateInfo.id = followupTemplate.id;
		$scope.followupTemplateInfo.favorites = followupTemplate.favorites;
		$scope.followupTemplateInfo.ownerName = followupTemplate.ownerName;
		$scope.followupTemplateInfo.isStarred = followupTemplate.isStarred+"";
		$scope.followupTemplateInfo.ownerType = followupTemplate.ownerType;
		$scope.followupTemplateInfo.name = followupTemplate.name;
		$scope.followupTemplateInfo.popularity = followupTemplate.popularity;
		$scope.followupTemplateInfo.milestones=followupTemplate.milestones;
		console.log("editfollowupTemplateCtrl->milestones=",$scope.followupTemplateInfo.milestones);
		//$scope.milestones=followupTemplate.milestones;
		//console.log("editfollowupTemplateCtrl->milestones=",$scope.milestones);
		$scope.tests=["1","2"];
		//var appendHtml=$("#appendHtml");
		//appendHtml.append("<span>hello world</span>");
		var addhtml="<span>hello world</span>";
		$("#appendHtml").html(addhtml);
	}else {
		//新增逻辑
		//表单默认值
		$scope.followupTemplateInfo.isStarred = "true";
		$scope.followupTemplateInfo.ownerName = "橙医生诊所";
		$scope.followupTemplateInfo.ownerType = 0;
		
	}
	

	
	$scope.ok = function (e) {
	
		//校验相关
		if(!validateFiledNullMax(toaster, $scope.followupTemplateInfo.name, "标题", true, 0))
			return;
		
		//提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			$scope.data.followupTemplateDepartments.forEach(function(item) {
				$scope.followupTemplateInfo.departmentIds.push(item.uuid);
			});
			
			$http.post(REST_PREFIX+"followup/", $scope.followupTemplateInfo).success(function(result) {
				$modalInstance.close("success");
			});
		}
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	
});
