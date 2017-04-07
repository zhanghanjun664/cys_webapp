'use strict';
var rawText;
var ossprefix;

var patientEduArticle = {
	initTagSetting : function(id) {
		var obj;
		var id = id ? "/" + id : "";
		ajax(REST_PREFIX + "patientEdu/tags" + id, function(result) {
			if (result.body && result.body.code == 2000) {
				obj = result.body.result;
			}
		});
		return obj;
	}
};

app.controller('PatientEduArticleCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window, $localStorage, Admin_Constant) {
	$scope.resultPage = {totalCount:0};
	$scope.data = []; // 当前页面的结果集
	$scope.tableParams = new ngTableParams({
		page: 1,
		count: 10
	}, {
		total: $scope.resultPage.totalCount,
		getData: function ($defer, params) {
			commonResetSelection($scope);// 重置查询框
			$scope.searchInfos.pageIndex = params.page();// params为ngTableParams对象的第一个参数
			$scope.searchInfos.pageSize = params.count();
//			if($scope.searchInfos.sickCategoryids) {
//				$scope.searchInfos.sickCategoryids.forEach(function(id) {
//					$scope.queryString += "&sickCategoryids=" + id;
//				});
//			}
			if ($scope.searchInfos.selectedTagList) {
				$scope.searchInfos.tagList = [];
				$scope.searchInfos.selectedTagList.forEach(function(item) {
					$scope.searchInfos.tagList.push(item.id);
				});
			}
			$scope.queryString = "?" + $.param($scope.searchInfos, true);
			var requestUrl = REST_PREFIX+"patientEdu/list" + $scope.queryString;
			$http.get(requestUrl).success(function (result) {
				$scope.resultPage = result.resultPage;
				ossprefix=result.ossprefix;
				params.total($scope.resultPage.totalRecords);
// params.page($scope.resultPage.nowPage);

				$scope.data = $scope.resultPage.content;
				$defer.resolve($scope.data);
			});
		}
	});
	
	$scope.openView = function (articleUrl){
		var url=ossprefix+articleUrl;
		window.open(url);
	}
	// 获取疾病关键字列表
	$http.get(REST_PREFIX+"patientEdu/sickCategories").success(function (result) {
		$scope.doctorSkills = result;
	});

	// 新增
	$scope.edit = function (article) {
		var modalInstance = $modal.open({
			templateUrl: 'editArticle.html',
			backdrop: 'static',
			keyboard: false,
			windowClass: 'app-modal-window',
			controller: 'editArticleCtrl',
			resolve: {
				article : function() {
					return article;
				},
				doctorSkills: function(){
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
			title: "确定删除吗？",
			text: "记录删除后将不能恢复",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "确定",
			cancelButtonText: "取消"
		}, function (isConfirm) {
			if (isConfirm) {
				$http.delete(REST_PREFIX+"patientEdu/"+id).success(function (result) {
					if(result.result != 0){
						toaster.pop("error","提示",result.description);
					}else{
						$scope.tableParams.reload();
					}
				});
			}
		});
	};

	// 改变当前选中的行
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
	// 点击查询按钮
	$scope.searchInfos = {title:null,sickCategorys:[],source:null,sickCategoryIds:[]};
	$scope.search = function() {
		var modalInstance = $modal.open({
			templateUrl: 'searchArticle.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'searchArticleCtrl',
			resolve: {
				searchInfos : function() {
					return $scope.searchInfos;
				},
				doctorSkills: function(){
					return $scope.doctorSkills;
				}
			}
		});
		modalInstance.result.then(function (searchInfos) {
			$scope.searchInfos = searchInfos;
			$scope.searchInfos.sickCategoryIds=[];
			$scope.searchInfos.sickCategorys.forEach(function(item) {
				$scope.searchInfos.sickCategoryIds.push(item.sickCategoryId);
			});
			$scope.tableParams.reload();
		});
	};
});
app.controller('searchArticleCtrl', function ($scope, $modalInstance, searchInfos,doctorSkills) {
	// 恢复上一次的查询条件
	$scope.searchInfos = searchInfos;
	$scope.doctorSkills = doctorSkills;
	$scope.tagSetting = patientEduArticle.initTagSetting(null);
	if (!$scope.searchInfos.selectedTagList) {
		$scope.searchInfos.selectedTagList = [];
	}
	$scope.checkTag = checkTag;
	$scope.removeTag = removeTag;
	
	// 页面渲染完才进行的操作
	setTimeout(function() {
		// 移除ng-tags-input的输入框(官方无api禁止出现,此为变通方法)
		$(".tag-list").next("input")[0].remove();
		if ($scope.searchInfos.selectedTagList) {
			// 设置已选项勾选
			$scope.searchInfos.selectedTagList.forEach(function(item) {
				$(":checkbox[value='" + item.id + "']").prop("checked", true);
			});
		}
	}, 0);
	
	$scope.ok = function (e) {
		$modalInstance.close($scope.searchInfos);
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};
	$scope.clear = function () {
		$scope.searchInfos = {title:null,sickCategorys:[],source:null};
	};
});
var initTagsFunction=function(initTags){
	var tags=[];
	initTags.forEach(function(item){
		var obj={'name':item};
		tags.push(obj);
	});
	return tags;
};

app.controller('editArticleCtrl', function ($scope, $http, $modalInstance, toaster , article,doctorSkills) {
	$scope.uploadObj = new Flow(); // 头像文件对象
	$scope.uploadUrl = REST_PREFIX + "patientEdu/upload_article_icon";
	$scope.noImage = true;
	if(article&&article.icon){
		$scope.noImage = false;
	}
	$scope.removeImage = function () {
		$scope.noImage = true;
	};
	// 图片上传成功回调函数
	$scope.uploadSuccess = function(file, message) {
		var result = JSON.parse(message);
		if(result.result == 0) {
			$scope.obj.icon= result.uploadUrl;
			filterField($scope.obj,"selectedTagList");
			$http.post(REST_PREFIX+"patientEdu", $scope.obj).success(function(result) {
				if(result.result==0){
					$modalInstance.close("success");
				}else{
					toaster.pop("error", "提示", "保存失败，请关掉窗口重新打开!");
				}
			});
		} else {
			toaster.pop("error", "提示", "上传图片失败，请联系管理员!");
			$scope.submitFlag = false;
		}
	};

	$scope.checkTag = checkTag;
	$scope.removeTag = removeTag;
	
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};
	$scope.data = {};
	$scope.data.sickCategorys =[];
	$scope.obj.sickCategoryIds =[];
	$scope.doctorSkills = doctorSkills;
	$scope.tagSetting = patientEduArticle.initTagSetting(article ? article.id : null);
	$scope.dateBeginShowStr;
	
	$scope.data.tags=[];
	$scope.initTags=["医声","预防","治疗","饮食","禁忌"];
	$scope.allTags=initTagsFunction($scope.initTags);
	
	$scope.isOriginal=function(){
		if($scope.obj.isOriginal=="true"){
			// 是原创内容,显示正文,隐藏url
			return true;
		}else{
			// 非原创内容,隐藏正文,显示url
			return false;
		}
	}

	// 页面渲染完才进行的操作
	setTimeout(function() {
		// 移除ng-tags-input的输入框(官方无api禁止出现,此为变通方法)
		$(".tag-list").next("input")[0].remove();
	}, 0);

	
	// 初始化ueditor
	setTimeout(function(){
		var opt={
			uploadParam:'basePath=doctor/patient_edu/image/'
		};
		if(article){
			if(article.isOriginal){
				if(article.channel==2){
					opt.toolbars=[];
				}
			}
		}
		rawText = UE.initEditor(rawText, "rawText",opt);
		rawText.addListener( 'ready', function( editor ) {
			if(article){
				if(article.isOriginal){  
					// web后台产生的资料,从OSS的html中 加载编辑器内容
					var url=ossprefix+article.url;
					$http.get(url).success(function(data){
						rawText.setContent(data);
					}).error(function(data){

					});
					if(article.channel==1){

					}else if(article.channel==2){
						// app端产生的资料,不能编辑正文
						rawText.setDisabled();
					}
				}
			}
		} );
	},1000);

	if(article) {
		// 编辑逻辑
		// 获取文章已选分类
		$http.get(REST_PREFIX+"patientEdu/sickCategory/"+article.id).success(function (result) {
			var selectedSkills = [];

			$scope.doctorSkills.forEach(function(skill){
				result.forEach(function(selected){
					if(skill.sickCategoryId == selected.sickCategoryId) {
						selectedSkills.push(skill);
					}
				});
			});
			$scope.data.sickCategorys = selectedSkills;
		});
		// 已有数据的赋值展示
		$scope.obj.title = article.title;
		$scope.obj.id = article.id;
		$scope.obj.summary = article.summary;
		$scope.obj.url = article.url;
		$scope.obj.collectionNum = article.collectionNum;
		$scope.obj.source = article.source;
		$scope.obj.isOriginal = article.isOriginal+"";
		$scope.obj.isShowOnPlatform = article.isShowOnPlatform+"";
		$scope.obj.isShowOnPatient = article.isShowOnPatient+"";
		$scope.obj.isShowOnWap = article.isShowOnWap+"";
		$scope.obj.isRecommend = article.isRecommend+"";
		$scope.obj.channel = article.channel;
		$scope.dateBeginShowStr = article.dateBeginShow;
		$scope.obj.tags = article.tags;
		$scope.obj.readingNumber = article.readingNumber;
		$scope.obj.icon= article.icon;
		$scope.obj.selectedTagList = $scope.tagSetting.selectedTagList;
		$scope.obj.keyword= article.keyword;
		
		var dbtags= article.tags;
		var articleTags=[];
		if(typeof(dbtags)!='undefined'&&dbtags!=null&&dbtags!=''&&dbtags.length>0){
			articleTags=initTagsFunction(dbtags.split(","));
		}
		var selectedTags = [];
		$scope.allTags.forEach(function(tag){
			articleTags.forEach(function(selected){
				if(tag.name == selected.name) {
					selectedTags.push(tag);
				}
			});
		});
		$scope.data.tags = selectedTags;
		console.log("tags=",$scope.data.tags);
		
	}else {
		// 新增逻辑
		// 表单默认值
		$scope.obj.isShowOnPlatform = "true";
		$scope.obj.isOriginal = "true";
		$scope.obj.source = "橙医生诊所";
		$scope.obj.channel = 1;
		$scope.obj.isShowOnPatient = "true";
		$scope.obj.isShowOnWap = "true";
		$scope.obj.isRecommend = "true";
		$scope.dateBeginShowStr=getNowDateStr(new Date());
		//设置阅读数随机
		var random_popularity = Math.floor(Math.random()*(300-100+1)+100);
		$scope.obj.readingNumber = random_popularity;
		$scope.obj.selectedTagList = [];
		// $scope.obj.icon="http://cys-static-img.oss-cn-shenzhen.aliyuncs.com/logo_new.jpg";

         
	}

	$scope.isOriginalClick=function(){
		if($scope.obj.isOriginal){
			rawText.setHeight(200);
		}else{
		}
	}
	
	$scope.sickCategorysSelect=function(){
		if($scope.data.sickCategorys.length>1){
			toaster.pop("error", "提示", "只能选择一项疾病分类");
			$scope.data.sickCategorys=$scope.data.sickCategorys.slice(0,1);
		}
	}
	
	$scope.tagsSelect=function(){
		if($scope.data.tags.length>1){
			toaster.pop("error", "提示", "只能选择一项文章标签");
			$scope.data.tags=$scope.data.tags.slice(0,1);
		}
	}

	$scope.ok = function (e) {
		if($scope.obj.channel==1){
			$scope.obj.rawText=rawText.getContent();
		}

		// 校验相关
		if(!validateFiledNullMax(toaster, $scope.obj.title, "标题", true, 0))
			return;
		if($scope.isOriginal()==true){
			if($scope.obj.channel==1){
				if(!validateFiledNullMax(toaster, $scope.obj.rawText, "详情", true, 0)){
					return;
				}
			}
		}else{
			if(!validateFiledNullMax(toaster, $scope.obj.url, "网址", true, 0)){
				return;
			}
		}
		 if(!validateFiledInteger(toaster, $scope.obj.readingNumber, "阅读数", false, true)) {
	            return;
	    }
		 if(!validateFiledInteger(toaster, $scope.obj.collectionNum, "收藏数", false, true)) {
	            return;
	    }
		 
		$scope.obj.tagList = [];
		$scope.obj.selectedTagList.forEach(function(item) {
			$scope.obj.tagList.push(item.id);
		});
		 
		// 提交
		if(!$scope.submitFlag) {
			$scope.submitFlag = true;
			$scope.data.sickCategorys.forEach(function(item) {
				$scope.obj.sickCategoryIds.push(item.sickCategoryId);
			});
			$scope.dateBeginShowStr=$('#dateBeginShowStr').val();
			$scope.obj.dateBeginShow = new Date($scope.dateBeginShowStr);
			$scope.data.tagsArray=[];
			$scope.data.tags.forEach(function(item) {
				$scope.data.tagsArray.push(item.name);
			});
			$scope.obj.tags=$scope.data.tagsArray.join(",");
			
			
			if($scope.uploadObj.flow.files[0]) {
				$scope.uploadObj.flow.upload();
			} else {
				filterField($scope.obj,"selectedTagList");
				$http.post(REST_PREFIX+"patientEdu", $scope.obj).success(function(result) {
					if(result.result==0){
						$modalInstance.close("success");
					}else{
						toaster.pop("error", "提示", "保存失败，请关掉窗口重新打开!");
					}
					
				});
			}
		}
	};
	$scope.cancel = function (e) {
		$modalInstance.dismiss();
	};

});
