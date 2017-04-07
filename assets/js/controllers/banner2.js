'use strict';
var rawText;
var ossprefix;

$(function(){
	console.log("init function");
	
	$(document).on('click','.banner-btn',function(){
		console.log("--",$(this).parent('div').next('div')[0]);
		var $bannerUpdateButton=$(this).parent('div');
		var $bannerSubmitButton=$(this).parent('div').next('div');
		$bannerUpdateButton.addClass('display-none');
		$bannerSubmitButton.removeClass('display-none');
		var bannerId=$(this)[0].dataset.id;
		var $bannerForm=$("#form_"+bannerId);
		$bannerForm.find('input[name="link"]').removeAttr("disabled");
		$bannerForm.find('input[name="isShow"]').removeAttr("disabled");
		$bannerForm.find('.properties').removeAttr("disabled");
	});
	
	$(document).on('click','.banner-btn-submit',function(){
		var bannerId=$(this)[0].dataset.id;
		var $bannerForm=$("#form_"+bannerId);

		//console.log("-$bannerForm-",$bannerForm[0]);
		//console.log("-$bannerForm2-",$(this).parent('form'));
		var link=$bannerForm.find('input[name="link"]').val();
		console.log("link=",link);
		var isShow=$bannerForm.find('input[name="isShow"]:checked').val();
		console.log("isShow=",isShow);
		
		var $inputProperties=$bannerForm.find('.properties');
		console.log("$inputProperties=",$inputProperties);
		
		var otherProperties={};
		$inputProperties.each(function(item){
			console.log("$inputProperties-item=",$inputProperties[item].name+","+$inputProperties[item].value);
			otherProperties[$inputProperties[item].name]=$inputProperties[item].value;
		});
		console.log("otherProperties=",otherProperties);
		
		var imageUrl=$bannerForm.find('input[name="imageUrl_'+bannerId+'"]').val();
		console.log("imageUrl=",imageUrl);
		
		
		//校验
		if(isShow){
			if(link==null||link==''){
				$('#myModal').modal('show');
			}
            if(imageUrl==null||imageUrl==''){
				
			}
            if(link==null||link==''){
				
			}
            
            getImgWidthAndHeight(file, function(width,height){
    			console.log("width",width);
    			console.log("height",height);
    			if(!validImage(type,width,height)){
    				alert("图片不合法");
    				
    				//恢复原来的图片
    				
    				getErrorImageDesc(type,typeDesc);
    				return ;
    			}
    		},$window);
            
		}
		
		var data={
				imageUrl:imageUrl,
				link:link,
				isShow:isShow,
				id:bannerId,
				otherProperties:otherProperties
		};
		
		$.ajax({
			url:REST_PREFIX+"banner/",
			type:"POST",
			data:JSON.stringify(data),
			contentType:"application/json",
			dataType:"json",
			success:function(result){
				if(result.result==0){
					alert("保存成功");
				}
			}
		
		});
	});
	
});

app.controller('bannerCtrl', function ($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window, $localStorage, Admin_Constant) {
	$scope.resultPage = {totalCount:0};
	$scope.data = []; // 当前页面的结果集
	$scope.typeDescs = [];
	
	$http.get(REST_PREFIX+"banner/list").success(function (result) {
		$scope.data = result.result;
		$scope.data.forEach(function(item){
			if(!contains($scope.typeDescs,item.typeDesc)){
				$scope.typeDescs.push(item.typeDesc);
			}
		});
	});
	$scope.uploadUrl=REST_PREFIX+"banner/upload";
	 
	
	$scope.getImgNaturalDimensions=function(img, callback) {
	    var nWidth, nHeight
	    if (img.naturalWidth) { // 现代浏览器
	        nWidth = img.naturalWidth
	        nHeight = img.naturalHeight
	    } else { // IE6/7/8
	        var imgae = new Image()
	        image.src = img.src
	        image.onload = function() {
	            callback(image.width, image.height);
	        }
	    }
	    return [nWidth, nHeight]
	}
	
	
	$scope.upload=function($files, $event, $flow,type,typeDesc){
		console.log("$files",$files);
		console.log("$event",$event);
		console.log("$flow",$flow);
		
		var file=$files[0].file;
		console.log("file",file);
		
		/*var $img=
		getImgNaturalDimensions($img,function(width,height){
			console.log("width",width);
			console.log("height",height);
		});*/
		
		
		getImgWidthAndHeight(file, function(width,height){
			console.log("width",width);
			console.log("height",height);
			if(!validImage(type,width,height)){
				toaster.pop("error", "提示", getErrorImageDesc(type,typeDesc),"10000");
				//恢复原来的图片
				$flow.cancel();
				return ;
			}
		},$window);
		
		$flow.upload();
		
	};
	function getErrorImageDesc(type,typeDesc){
		var desc='';
		if(type=='doctor_app_ios'){
			desc=typeDesc+'图片必须符合宽度640,高度256';
		}else if(type=='doctor_app_android'){
			desc=typeDesc+'图片必须符合宽度740,高度248';
		}else if(type=='patient_wx_index'){
			desc=typeDesc+'图片必须符合宽度640,高度280';
		}
		return desc;
	}
	function validImage(type,width,height){
		if(type=='doctor_app_ios'){
			if(width!='640'&&height!='256'){
				return false;
			}
		}else if(type=='doctor_app_android'){
            if(width!='720'&&height!='260'){
            	return false;
			}
		}else if(type=='patient_wx_index'){
            if(width!='640'&&height!='280'){
            	return false;
			}
		}
		return true;
	}
	
	$scope.removeImage = function ($flow,id) {
		$('#imageUrl_'+id).val('');
		$('#hasimage_'+id).attr('src','');
		$('#hasimage_'+id).addClass('display-none');
		$flow.cancel();
	};
	
	$scope.showHasImage=function($flow,id){
		var $imageUrl=$('#imageUrl_'+id);
		var imageUrlValue=$imageUrl.val();
		if(!$flow.files.length&&imageUrlValue!=null&&imageUrlValue!=''){
			return true;
		}
		return false;
	}
	
	$scope.showNoImage=function ($flow,imageUrl,id){//原来的imageUrl不为空，同时当前选择的文件$flow为空
		var $imageUrl=$('#imageUrl_'+id);
		var imageUrlValue=$imageUrl.val();
		if(!$flow.files.length&&((imageUrlValue!=null&&imageUrlValue!='')?false:true)){
			return true;
		}
		
		return false;
	}
	$scope.showRemoveBtn=function (imageUrl,id){
		var $imageUrl=$('#imageUrl_'+id);
		var imageUrlValue=$imageUrl.val();
		if(imageUrlValue!=null&&imageUrlValue!=''){
			return true;
		}
		return false;
	}
	// 图片上传成功回调函数
	$scope.uploadSuccess = function(file, message,id,$flow) {
		var result = JSON.parse(message);
		console.log("result=",result);
		if(result.result == 0) {
			$('#imageUrl_'+id).val(result.uploadUrl);
		} else {
			toaster.pop("error", "提示", "上传图片失败，请联系管理员!");
			$scope.submitFlag = false;
			$('#imageUrl_'+id).val('');
			$flow.cancel();
		}
	};
	
	
	
	// 新增
    $scope.edit = function (followupTemplate) {
    	
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
   
    
  
	// 点击删除按钮
	function commonDeleteButtonClick(toaster, $scope) {
		if ($scope.selections.length > 0) {
			var ownerTypes=getOwnerTypeStringFromSelections($scope.selections);
			if(ownerTypes!=null&&ownerTypes.indexOf("1")>=0){// 医生建的
				 SweetAlert.swal({
	    	            // text: "不能删除！",
	    			    title: "有些模板为医生个人模板,不允许删除！",
	    	            // showCancelButton: true,
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


});


