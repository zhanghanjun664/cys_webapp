'use strict';
var ossprefix;
var uploadResult;

app.controller('bannerCtrl', function($scope, $http, $modal, ngTableParams, toaster, SweetAlert, $window,
		$localStorage, Admin_Constant) {
	/* 初始化内容start */
	$(document).on('click', '.banner-btn', function() {
		console.log("--", $(this).parent('div').next('div')[0]);
		var $bannerUpdateButton = $(this).parent('div');
		var $bannerSubmitButton = $(this).parent('div').next('div');
		$bannerUpdateButton.addClass('display-none');
		$bannerSubmitButton.removeClass('display-none');
		var bannerId = $(this)[0].dataset.id;
		var $bannerForm = $("#form_" + bannerId);
		$bannerForm.find('input[name="link"]').removeAttr("disabled");
		$bannerForm.find('input[name="isShow"]').removeAttr("disabled");
		$bannerForm.find('.properties').removeAttr("disabled");
	});

	$(document).on('click', '.banner-btn-submit', function() {

		var bannerId = $(this)[0].dataset.id;
		var $bannerForm = $("#form_" + bannerId);
		var link = $bannerForm.find('input[name="link"]').val();
		var isShow = $bannerForm.find('input[name="isShow"]:checked').val();

		var $inputProperties = $bannerForm.find('.properties');

		var otherProperties = {};
		$inputProperties.each(function(item) {
			otherProperties[$inputProperties[item].name] = $inputProperties[item].value;
		});

		var imageUrl = $bannerForm.find('input[name="imageUrl_' + bannerId + '"]').val();

		var type = $bannerForm[0].dataset.type;
		var typeDesc = $bannerForm[0].dataset.typedesc;
		// 校验
		if (isShow == 'true') {// isShow取到的值貌似不是bool类型
			if (!link) {
				SweetAlert.swal({
					title : "跳转链接不能为空!",
					confirmButtonColor : "#DD6B55",
					confirmButtonText : "确定"
				});
				return;
			}

			// 发现问题：点击上传图片，同时快速点击保存表单按钮，则则imageUrl会为空,因为图片上传比较慢，要等图片上传完后返回url，再将url设置到该表单的隐藏域imageUrl_{{banner.id}}中，
			// 若没等图片上传完就快速点击保存，则imageUrl该值还是为空的
			if (uploadResult == "uploading") {
				SweetAlert.swal({
					title : "请稍后再保存,图片正在上传中....",
					confirmButtonColor : "#DD6B55",
					confirmButtonText : "确定"
				});
				return;
			}

			if (uploadResult == "fail") {
				SweetAlert.swal({
					title : "图片上传失败,请重新上传,再点击保存",
					confirmButtonColor : "#DD6B55",
					confirmButtonText : "确定"
				});
				return;
			}

			if (imageUrl) {
				var image = getImgNaturalWidthAndHeight(imageUrl);// 当点击保存的速度过快，但imageUrl不会为空，但是此处image取到的宽度和高度还是为空的,因为image.onload方法需要时间
				if (!validImage(type, image.width, image.height)) {
					SweetAlert.swal({
						title : getErrorImageDesc(type, typeDesc),
						confirmButtonColor : "#DD6B55",
						confirmButtonText : "确定"
					});
					return;
				}
			}

		}

		var data = {
			imageUrl : imageUrl,
			link : link,
			isShow : isShow,
			id : bannerId,
			otherProperties : otherProperties
		};
		$.ajax({
			url : REST_PREFIX + "banner/",
			type : "POST",
			data : JSON.stringify(data),
			contentType : "application/json",
			dataType : "json",
			success : function(result) {
				if (result.result == 0) {
					// alert("保存成功");
					SweetAlert.swal({
						title : "保存成功!",
						confirmButtonColor : "#DD6B55",
						confirmButtonText : "确定"
					});
				}

			}

		});
	});
	/* 初始化内容end */

	// controller里面处理的内容
	$scope.data = []; // 当前页面的结果集
	$scope.typeDescs = [];

	$http.get(REST_PREFIX + "banner/list").success(function(result) {
		$scope.data = result.result;
		$scope.data.forEach(function(item) {
			if (!contains($scope.typeDescs, item.typeDesc)) {
				$scope.typeDescs.push(item.typeDesc);
			}
		});
	});

	$scope.uploadUrl = REST_PREFIX + "banner/upload";

	$scope.upload = function($files, $event, $flow, type, typeDesc) {
		console.log("$files", $files);
		console.log("$event", $event);
		console.log("$flow", $flow);

		//
		uploadResult = "uploading";

		var file = $files[0].file;
		console.log("file", file);

		getImgWidthAndHeight(file, function(width, height) {
			console.log("upload.width", width);
			console.log("upload.height", height);
			if (!validImage(type, width, height)) {
				console.log("图片尺寸不正确");
				// 恢复原来的图片
				$flow.cancel();
				// toaster.pop("error", "提示", getErrorImageDesc(type,typeDesc));
				SweetAlert.swal({
					title : getErrorImageDesc(type, typeDesc),
					confirmButtonColor : "#DD6B55",
					confirmButtonText : "确定"
				});
				return;
			} else {
				console.log("开始上传");
				$flow.upload();
			}

		}, $window);

	};

	// 图片上传成功回调函数
	$scope.uploadSuccess = function(file, message, id, $flow) {
		var result = JSON.parse(message);
		console.log("result=", result);
		if (result.result == 0) {
			$('#imageUrl_' + id).val(result.uploadUrl);
			toaster.pop("success", "提示", "上传图片成功!");
			uploadResult = "success";
		} else {
			// toaster.pop("error", "提示", "上传图片失败，请稍后重试!");
			SweetAlert.swal({
				title : "上传图片失败，请稍后重试!",
				confirmButtonColor : "#DD6B55",
				confirmButtonText : "确定"
			});
			// $('#imageUrl_'+id).val('');
			$flow.cancel();
			uploadResult = "fail";
		}
	};

	function getErrorImageDesc(type, typeDesc) {
		var desc = '';
		if (type == 'doctor_app_ios') {
			desc = typeDesc + '图片必须符合宽度640,高度256';
		} else if (type == 'doctor_app_android') {
			desc = typeDesc + '图片必须符合宽度720,高度260';
		} else if (type == 'patient_wx_index') {
			desc = typeDesc + '图片必须符合宽度740,高度248';
		} else if (type == 'patient_edu_article') {
			desc = typeDesc + '图片必须符合宽度640,高度136';
		}
		return desc;
	}

	function validImage(type, width, height) {
		if (type == 'doctor_app_ios') {
			if (width != '640' && height != '256') {
				return false;
			}
		} else if (type == 'doctor_app_android') {
			if (width != '720' && height != '260') {
				return false;
			}
		} else if (type == 'patient_wx_index') {
			if (width != '640' && height != '280') {
				return false;
			}
		} else if (type == 'patient_edu_article') {
			if (width != '640' && height != '136') {
				return false;
			}
		}
		return true;
	}

	$scope.removeImage = function($flow, id) {
		$('#imageUrl_' + id).val('');
		$('#hasimage_' + id).attr('src', '');
		$('#hasimage_' + id).addClass('display-none');
		$flow.cancel();
	};

	$scope.showHasImage = function($flow, id) {
		var $imageUrl = $('#imageUrl_' + id);
		var imageUrlValue = $imageUrl.val();
		if (!$flow.files.length && imageUrlValue != null && imageUrlValue != '') {
			return true;
		}
		return false;
	}

	$scope.showNoImage = function($flow, imageUrl, id) {// 原来的imageUrl不为空，同时当前选择的文件$flow为空
		var $imageUrl = $('#imageUrl_' + id);
		var imageUrlValue = $imageUrl.val();
		if (!$flow.files.length && ((imageUrlValue != null && imageUrlValue != '') ? false : true)) {
			return true;
		}

		return false;
	}

	$scope.showRemoveBtn = function(imageUrl, id) {
		var $imageUrl = $('#imageUrl_' + id);
		var imageUrlValue = $imageUrl.val();
		if (imageUrlValue != null && imageUrlValue != '') {
			return true;
		}
		return false;
	}

});
