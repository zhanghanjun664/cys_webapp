'use strict';

var onlineDiagnoseReply = {
	// 初始化页面数据与方法
	statusList : null,
	channelList : null,
	genderList : null,
	initScopeData : function($scope) {
		onlineDiagnoseReply.statusList = ($scope.statusList = onlineDiagnoseReply.statusList ? onlineDiagnoseReply.statusList
				: onlineDiagnoseReply.initStatusList());
		onlineDiagnoseReply.channelList = ($scope.channelList = onlineDiagnoseReply.channelList ? onlineDiagnoseReply.channelList
				: onlineDiagnoseReply.initChannelList());
		onlineDiagnoseReply.genderList = ($scope.genderList = onlineDiagnoseReply.genderList ? onlineDiagnoseReply.genderList
				: onlineDiagnoseReply.initGenderList());
	},
	initChannelList : function() {
		var list = [];
		list.push({
			name : '公众号',
			value : 'PUBLIC'
		});
		list.push({
			name : '推送文章',
			value : 'PUSHARTICLE'
		});
		list.push({
			name : '心脑百问',
			value : 'QUESTION'
		});
		list.push({
			name : '其它',
			value : 'OTHER'
		});
		list.push({
			name : '39健康',
			value : 'SANJIU'
		});
		return list;
	},
	initGenderList : function() {
		var list = [];
		list.push({
			name : '女',
			value : 'F'
		});
		list.push({
			name : '男',
			value : 'M'
		});
		return list;
	},
	initStatusList : function() {
		var list = [];
		list.push({
			name : '未回复',
			value : 0
		});
		list.push({
			name : '已回复',
			value : 1
		});
		list.push({
			name : '已结束',
			value : 2
		});
		return list;
	}
}

app.controller('onlineDiagnoseReplyCtrl', function($scope, $http, $modal, toaster, SweetAlert) {
	$scope.submitFlag = false; // 为防止表单重复提交
	$scope.obj = {};

	setTimeout(function() {
		remainWord("#replyContent", 250, "#replyContent-remainWord");
	}, 0)
	onlineDiagnoseReply.initScopeData($scope);

	$scope.getItemName = getItemName;
	$scope.orderNumberQuery = function() {
		var orderNumber = $scope.obj.orderNumber;
		var requestUrl = REST_PREFIX + "onlineDiagnoseReply/findOnlineDiagnose" + "?orderNumber=" + orderNumber;
		$("#order-info").hide();
		$http.get(requestUrl).success(function(result) {
			var data;
			if (result.body) {
				data = result.body;
			} else {
				data = result;
			}

			if (data && data.code == 2000) {
				$("#order-info").show();
				$scope.obj = data.result;
			} else {
				toaster.pop("error", "提示", "查询失败");
			}
		});
	};

	$scope.reply = function() {
		console.info($scope.obj);
		if (!validateFiledNullMax(toaster, $scope.obj.orderNumber, "订单号", true, 0)
				|| !validateFiledNullMax(toaster, $scope.obj.replyDoctor, "回复的医生", true, 0)
				|| !validateFiledNullMax(toaster, $scope.obj.replyContent, "回复内容", true, 0))
			return;
		if (!$scope.submitFlag) {
			$scope.submitFlag = true;
			$scope.obj = retainField($scope.obj, "replyContent,orderNumber,replyDoctor");
			$http.post(REST_PREFIX + "onlineDiagnoseReply", $scope.obj).success(function(result) {
				$scope.submitFlag = false;
				$scope.obj = {};
				$("#order-info").hide();
				$("#replyContent-remainWord").html("0/250");
				resultProcess($scope, result, null, toaster);
			});
		}
	};
});
