app.controller("privateDoctorImCtrl", ["$rootScope", "$scope", "$http", "WebIMWidget", "$modal", function($rootScope, $scope, $http, WebIMWidget, $modal) {

//	console.log("历史消息长度:" + history.length)
//	var clickRefresh = false;
//	window.onbeforeunload = function(event) {
//		console.log("关闭电脑~")
//		clickRefresh = true;
//		alert();
//		if(event.clientX > document.body.clientWidth && event.clientY < 0 || event.altKey) {
//			alert("你关闭了浏览器");
//		} else {
//			alert("你正在刷新页面");
//		}
//	}
//	console.log(sessionStorage.getItem("EnterPrivateDoctorIm"),clickRefresh);
//	if(sessionStorage.getItem("EnterPrivateDoctorIm") && clickRefresh){
//		return
//	}
//	sessionStorage.setItem("EnterPrivateDoctorIm", "true");
	
	
	$rootScope.config = {
		testAppKey: 'kj7swf8o70pf2',
		appKey: 'qf3d5gbj3mzgh',
		weixinKey: 'c9kqb3rdkdbfj',
		useAppKey: null,
		token: null
	};
	switch(window.location.hostname) {
		case "admin.chengyisheng.com.cn":
			$rootScope.config.useAppKey = $rootScope.config.appKey;
			break;
		case "admin-staging.chengyisheng.com.cn":
			$rootScope.config.useAppKey = $rootScope.config.testAppKey;
			break;
		case "staging.chengyisheng.com.cn":
			$rootScope.config.useAppKey = $rootScope.config.testAppKey;
			break;
		case "admin-wxtest.chengyisheng.com.cn":
			$rootScope.config.useAppKey = $rootScope.config.weixinKey;
			break;
		case "wxtest.chengyisheng.com.cn":
			$rootScope.config.useAppKey = $rootScope.config.weixinKey;
			break;
		default:
			$rootScope.config.useAppKey = $rootScope.config.weixinKey;
			break;
	}

	console.log("进来了privateDoctorIm.js");
	WebIMWidget.show();
	//	if(sessionStorage.getItem("EnterprivateDoctorIm")){
	//		return
	//	}
	//	sessionStorage.setItem("EnterprivateDoctorIm","true");
	$http.get(REST_PREFIX + "healthManage/doctor/iminfo").then(function(data) {

		$rootScope.doctorId = data.data.body.result.imId;
		$rootScope.config.token = data.data.body.result.imRegistrationId;
		WebIMWidget.init({
			appkey: $rootScope.config.useAppKey,
			token: $rootScope.config.token,
			style: {
				left: 5,
				top: 2,
				width: 580,
				height: 550
			},
			displayConversationList: true,
			onSuccess: function() {
				//初始化完成
				console.log("初始化完成")
				//			WebIMWidget.setConversation(1,"d:498848967");
			},
			onError: function() {
				//初始化错误
				console.log('连接失败：' + error);
			}
		});

		WebIMWidget.setUserInfoProvider(function(targetId, obj) {
						console.log(targetId);
			$http({
				method: 'POST',
				url: REST_PREFIX + "healthManage/chatList/info",
				dataType: 'json',
				data: targetId

			}).then(function(data) {
				obj.onSuccess({
					data: data.data.body.result
				});
			});

		});
	})

	$rootScope.showNoEdit = false; //其他设备登陆，禁止聊天
	$rootScope.showReconnecting = false; //正在重连
	$scope.reconnect = function() {
		location.reload()
//		$rootScope.showReconnecting = true;
//		RongIMClient.reconnect({
//			onSuccess: function() {
//				$rootScope.showNoEdit = false;
//				$rootScope.showReconnecting = false;
//				console.log("重新连接成功");
//			},
//			onError: function() {
//				console.log("重新连接失败");
//			}
//		});
	}

	$scope.memberManage = {};
	//查看会员列表
	$scope.selectMemberManage = function() {
		var modalInstance = $modal.open({
			templateUrl: '../../../assets/views/common/selectMemberManage.html',
			//templateUrl: 'selectHealthServicePack.html',
			backdrop: 'static',
			keyboard: false,
			controller: 'selectMemberManageCtrl',
			size: "lg",
			resolve: {}
		});
		modalInstance.result.then(function(result) {
			console.log("selectMemberManage result=", result);
			for(var k in result) {
				$scope.memberManage[k] = result[k];
			}
			console.log("selectMemberManage =", $scope.memberManage);
			//根据masterPatientId查询targetid
			var data = {
				"servicePackId": $scope.memberManage.id,
				"masterPatientId": $scope.memberManage.masterPatientId
			};
			$.ajax({
				data: data,
				type: 'GET',
				dataType: 'json',
				url: REST_PREFIX + "healthManage/im/master/initiate",
				success: function(result) {
					if(result.body && result.body.code == 2000) {
						var targetId = result.body.result.targetId;
						console.log(targetId)
						WebIMWidget.setConversation(1, targetId);
					}
				}
			});

		});
	};

	//聊天窗口点击患者档案
	//  var masterPatientId='af29f4ea-1247-4658-a17b-12d0d92160b9';
	$scope.selectPatientArchive = function(masterPatientId) {
		console.log(masterPatientId);
		if(masterPatientId) {
			openPatientArchiveModel(masterPatientId, $modal, $scope);
		} else {
			alert("请先选择会话")
		}
	}

	//看大图
	$rootScope.showImg = function(imgUrl) {
		$modal.open({
			templateUrl: 'pdiShowImage.html',
			controller: 'pdiShowImageCtrl',
			size: "lg",
			resolve: {
				items: function() {
					return imgUrl
				}
			}
		})
	}

}]);

app.controller("pdiShowImageCtrl", function($scope, items) {
	$scope.showImgUrl = items
})