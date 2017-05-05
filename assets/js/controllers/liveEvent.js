'use strict';
var uploadResult="initValue";


app.controller('liveEventCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window) {
    initScope({
        searchModalResolve : function($scope) {
            return {
                searchInfos : function() {
                    return $scope.searchInfos;
                }
            }
        },
        editModalResolve : function($scope) {
            return {
                obj : function() {
                    // 必须用深拷贝复制1个新对象出来,否则Edit的修改会影响到父的对象
                    var newObj = angular.copy($scope.obj);
                    filterField(newObj, "selected,updateDate,createDate");
                    return newObj;
                }
            }
        },
        getCustomQueryString : function() {
            return getQueryString($scope.searchInfos);
        },
        //searchTemplateUrl : 'searchJdSick.html',
        //searchController : 'searchJdSickCtrl',
        editTemplateUrl : 'editLiveCtrl.html',
        editController : 'editLiveCtrl',
        tableQueryUrl : "live/list",
        deleteUrl : "/",
        $scope : $scope,
        $http : $http,
        $modal : $modal,
        ngTableParams : ngTableParams,
        toaster : toaster,
        SweetAlert : SweetAlert,
    });

    $scope.selectQuestions = function (liveEvent) {
        $scope.thisliveEvent = liveEvent;
        var modalInstance = $modal.open({
            templateUrl: 'selectQuestionCtrl.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectQuestionCtrl',
            resolve:  {
                    obj : function() {
                        // 必须用深拷贝复制1个新对象出来,否则Edit的修改会影响到父的对象
                        var newObj = angular.copy($scope.thisliveEvent);
                        filterField(newObj, "selected,updateDate,createDate");
                        return newObj;
                    }
            }
        });
        modalInstance.result.then(function (result) {
            console.log("reload after selectQuestions,result=",result)
            $scope.tableParams.reload();
        });

    };

});

app.controller('editLiveCtrl', function($scope, $http, $modalInstance, $modal,toaster, obj) {
    $scope.submitFlag = false;
    $scope.obj = {};
    $scope.obj.activity={};
    $scope.obj.featureInfo={};
    $scope.data={};
    $scope.data.doctorName='';
    
    if (obj) {
        $scope.obj = obj;
    }else{
        $scope.obj.baseHeat=50; 
        $scope.obj.activity.isActivity=false;
        $scope.obj.featureInfo.isFeature=false;
    }
    console.log("$scope.obj=",$scope.obj);
    if($scope.obj.doctor){
        $scope.data.doctorName=$scope.obj.doctor.name;
    }
    
    
    //注意新的字段不要放在前面，要不会被上面赋值覆盖掉
    //$scope.obj.displayAreas = [{name:"往期直播",value:2},{name:"下期预告",value:1},{name:"不展示",value:0}];
    $scope.data.displayAreas = {"往期直播":2,"下期预告":1,"不展示":0};
    $scope.data.featureTypes = {"提问入口":"question"};
    
    
    initEdit({
        $scope : $scope,
        $modalInstance : $modalInstance,
        toaster : toaster
    });

    
    $scope.uploadUrl=REST_PREFIX+"live/upload";
    
    $scope.subcoverObj = new Flow(); // 头像文件对象
    $scope.noSubcoverImage = true;
    if($scope.subcoverObj&&$scope.obj.subcover){
        $scope.noSubcoverImage = false;
    }
    $scope.removeSubcoverImage = function () {
        $scope.noSubcoverImage = true;
    };
    
    
    $scope.coverObj = new Flow(); // 头像文件对象
    $scope.noCoverImage = true;
    if($scope.coverObj&&$scope.obj.cover){
        $scope.noCoverImage = false;
    }
    $scope.removeCoverImage = function () {
        $scope.noCoverImage = true;
    };
    
    console.log("subcoverObj=",$scope.subcoverObj);
    console.log("coverObj=",$scope.coverObj);
    console.log("uploadUrl=",$scope.uploadUrl);
    console.log("noSubcoverImage=",$scope.noSubcoverImage);
    console.log("noCoverImage=",$scope.noCoverImage);
    
     
    $scope.upload=function($files, $event, $flow,id){
        console.log("id",id);
        uploadResult="uploading";
        $flow.upload();
    };
    
    // 图片上传成功回调函数
    $scope.uploadSuccess = function(file, message, $flow,id) {
        var result = JSON.parse(message);
        console.log("result=",result);
        if(result.result == 0) {
            $('#imageUrl_'+id).val(result.uploadUrl);
            toaster.pop("success", "提示", "上传图片成功!");
            uploadResult="success";
        } else {
             SweetAlert.swal({
                    title: "上传图片失败，请稍后重试!",
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "确定"
                });
            $flow.cancel();
            uploadResult="fail";
        }
    };
    
    
    
    $scope.ok = function(e) {
        
        console.log("uploadResult",uploadResult);
        console.log("$scope.obj",$scope.obj);
        $scope.obj.subcover=$('#imageUrl_subcover').val();
        $scope.obj.cover=$('#imageUrl_cover').val();
        delete $scope.obj.questionCount;
        $scope.obj.dateCreated=new Date($scope.obj.dateCreated);
        $scope.obj.dateUpdated=new Date($scope.obj.dateUpdated);
        $scope.obj.startTime=new Date($scope.obj.startTime);
        $scope.obj.endTime=new Date($scope.obj.endTime);
        console.log("after add image $scope.obj",$scope.obj);
        if(uploadResult=="uploading" || uploadResult=="fail"){
             toaster.pop("error", "提示", "图片正在上传或者上传图片失败，请稍后重试!");
             return;
        }
        if(!validateFiledNullMax(toaster, $scope.obj.subcover, "小图", true, 0)){
            return;
        }
        if(!validateFiledNullMax(toaster, $scope.obj.cover, "大图", true, 0)){
            return;
        }
        if($scope.obj.doctor){
            delete $scope.obj.doctor.availableTime;
        }
        
                if($scope.obj.featureInfo.isFeature){
                   if(!$scope.obj.featureInfo.featureType){
                       toaster.pop("error", "提示", "请选择预告活动类型!");
                       return;
                   }
                }
                if($scope.obj.activity.isActivity){
                   if(!$scope.obj.activity.activityTag||!$scope.obj.activity.activityTopic||!$scope.obj.activity.activityLink){
                       toaster.pop("error", "提示", "往期活动、标签、主题不能为空!");
                       return;
                   }
                }
        // 提交
        if (!$scope.submitFlag &&( uploadResult=="success" || uploadResult=="initValue")) {
            $scope.submitFlag = true;
            $http.post(REST_PREFIX + "live/update", $scope.obj).success(function(result) {
                resultProcess($scope,result, $modalInstance, toaster);
            });
        }
    };
    
     $scope.selectDoctor=function(){
            var modalInstance = $modal.open({
                templateUrl: 'selectDoctor.html',
                backdrop: 'static',
                keyboard: false,
                controller: 'selectDoctorCtrl',
                size:"lg",
                resolve: {
                }
            });
            modalInstance.result.then(function (result) {
                $scope.doctorChange(result);
            });
        }

     $scope.doctorChange=function(result){
         $scope.obj.doctorId=result.jdDoctorId;
         $scope.data.doctorName=result.name;
     };
     
});

app.controller('selectDoctorCtrl', function ($scope, $http, $modalInstance,ngTableParams,toaster, $localStorage, Admin_Constant,$rootScope){
    $scope.justopen = true;
    $scope.jdDistricts = []; //地区信息;
    $scope.jdHospitals = []; //医院信息;
    $scope.jdDepartments=[];//部门信息;
    $scope.jdTitles=[];//职称;
    //获得地区信息
    $scope.getDistrictInfos = function () {
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
    };
    $scope.getDistrictInfos();
    //获得部门信息
    $scope.getDepartmentInfos=function(){
        $scope.jdDepartments = $localStorage[Admin_Constant.LocalStorage.Departments];
        if(!$scope.jdDepartments) {
            $http.get(REST_PREFIX + "jdDepartment/list").success(function (result) {
                $scope.jdDepartments = result.departmentList;
                $localStorage[Admin_Constant.LocalStorage.Departments] = $scope.jdDepartments;
            });
        }
    };
    $scope.getDepartmentInfos();
    //获得职称信息
    $scope.getTitleInfos=function(){
        $scope.jdTitles = $localStorage[Admin_Constant.LocalStorage.Titles];
        if(!$scope.jdTitles) {
            $http.get(REST_PREFIX + "jdTitle/list").success(function (result) {
                $scope.jdTitles = result.titleList;
                $localStorage[Admin_Constant.LocalStorage.Titles] = $scope.jdTitles;
            });
        }
    };
    $scope.getTitleInfos();

    $scope.resultPage = {totalCount:0};
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行
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
                var requestUrl = REST_PREFIX+"doctor/list"+$scope.queryString;
                $http.get(requestUrl).success(function (result) {
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

    $scope.query=function(){
        $scope.tableParams.reload();
    };

    //根据地区获得医院结果集
    $scope.onDistrictChange=function(districtId){
        //$scope.jdHospitals = $localStorage[Admin_Constant.LocalStorage.Hospitals];
        if(!$rootScope.jdHospitals) {
            var url = REST_PREFIX + "jdHospital/search?jd_district_id=" + districtId;
            $http.get(url).success(function (result) {
                $scope.jdHospitals = result.hospitalList;
            });
        } else{
            var temp = [];
            $rootScope.jdHospitals.forEach(function(item){
                if(item.jdDistrictId == districtId){
                    temp.push(item);
                }
            });
            $scope.jdHospitals = temp;
        }
    };

    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };

    $scope.ok = function (e) {
        if ($scope.selections.length == 0) {
            toaster.pop("warning", "", "请选择一条记录", "1000");
        } else if ($scope.selections.length > 1) {
            toaster.pop("warning", "", "请只选择一条记录", "1000");
        } else {
            var rowObject = new Object();
            rowObject.name = $scope.selections[0].name;
            rowObject.jdDoctorId = $scope.selections[0].uuid;
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

app.controller('selectQuestionCtrl', function($scope, $http, $modal,$modalInstance, ngTableParams, toaster, SweetAlert, $window,obj) {
    initScope({
        searchModalResolve : function($scope) {
            return {
                searchInfos : function() {
                    return $scope.searchInfos;
                }
            }
        },
        getCustomQueryString : function() {
            console.log("obj:",obj);
            if(obj && obj.id){
                $scope.searchInfos.live_event_id=obj.id;
            }else{
                $scope.searchInfos.live_event_id='';
            }
            
            return getQueryString($scope.searchInfos);
        },
        tableQueryUrl : "live/questions",
        $scope : $scope,
        $http : $http,
        $modal : $modal,
        ngTableParams : ngTableParams,
        toaster : toaster,
        SweetAlert : SweetAlert,
    });

    $scope.cancel = function (e) {
        //$modalInstance.dismiss();
        //这里用close方法，不要用dismiss，dismiss是直接关闭的，不会传递会数据给回去，而close方法可以传递参数回去，
        //而且传递可以后可以刷新之前页面的列表,传递回去的看$scope.selectQuestions这个函数
        $modalInstance.close();
    };

 // 删除操作
    $scope.deleteItem = function (id) {
        console.log("deleteItem id",id);
        var deleteUrl ="live/question/delete/";//指定删除的url
        SweetAlert.swal({
            title: "确定删除吗?",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
                $http.post(REST_PREFIX + deleteUrl + id).success(function (result) {
                    if (!(result && result.body && result.body.code == 2000)) {
                        toaster.pop("error", "提示", "删除失败");
                    } else {
                        toaster.pop("success", "提示", "删除成功");
                    }
                    $scope.tableParams.reload();
                });
            }
        });
    };
    
    $scope.ok = function (e) {
        var $questionStatusInput=$("input[type=checkbox].question-status");
        console.log("$questionStatusInput=",$questionStatusInput);
        var questionStatus={};
        $questionStatusInput.each(function(item){
            var id=$questionStatusInput[item].dataset.qid;
            var checked=$questionStatusInput[item].checked;
            var status=checked?1:0;
            questionStatus[id]=status;
        });
        console.log("questionStatus=",questionStatus);
        
         $http.post(REST_PREFIX + "live/question/updateStatus",questionStatus).success(function (result) {
             if (!(result && result.body && result.body.code == 2000)) {
                 toaster.pop("error", "提示", "采纳失败");
             } else {
                 toaster.pop("success", "提示", "采纳成功");
                 $scope.tableParams.reload();
                 $modalInstance.close();
             }
         });
        
    };
    
    
    $scope.changeSelection = function (index) {
        console.log("index=",index);
    };
    
});
