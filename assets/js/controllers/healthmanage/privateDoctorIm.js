app.controller("privateDoctorImCtrl", ["$rootScope", "$scope", "$http", "WebIMWidget", "$modal", function($rootScope, $scope, $http, WebIMWidget, $modal) {
	
	$rootScope.config = {
        testAppKey: 'kj7swf8o70pf2',
        appKey: 'qf3d5gbj3mzgh',
        weixinKey: 'c9kqb3rdkdbfj',
        useAppKey:null,
        token:null
    };
    switch (window.location.hostname) {
        case "admin.chengyisheng.com.cn":
            $rootScope.config.useAppKey = $rootScope.config.appKey;
            break;
        case "admin-staging.chengyisheng.com.cn":
            $rootScope.config.useAppKey = $rootScope.config.testAppKey;
            break;
        case "admin-wxtest.chengyisheng.com.cn":
            $rootScope.config.useAppKey = $rootScope.config.weixinKey;
            break;
        default:
            $rootScope.config.useAppKey = $rootScope.config.testAppKey;
            break;
    }
	
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
				height: 600
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
			$http({
				method: 'POST',
				url: REST_PREFIX+"healthManage/chatList/info" ,
				dataType: 'json',
				data: targetId

			}).then(function(data) {
				obj.onSuccess({
				  data:data.data.body.result
				});
			});
			
		});
	})



	WebIMWidget.show();

	$scope.memberManage = {};
    //查看会员列表
    $scope.selectMemberManage = function () {
        var modalInstance = $modal.open({
            templateUrl: '../../../assets/views/common/selectMemberManage.html',
        	//templateUrl: 'selectHealthServicePack.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'selectMemberManageCtrl',
            size:"lg",
            resolve: {}
        });
        modalInstance.result.then(function (result) {
        	console.log("selectMemberManage result=",result);
            for (var k in result) {
                $scope.memberManage [k] = result[k];
            }
            console.log("selectMemberManage =",$scope.memberManage);
            //根据masterPatientId查询targetid
            var data={"servicePackId":$scope.memberManage.id,"masterPatientId":$scope.memberManage.masterPatientId};
            $.ajax({
            	 data:data,
                 type: 'GET',
                 dataType: 'json',
            	 url:REST_PREFIX + "healthManage/im/master/initiate",
            	 success: function (result) {
            		 if (result.body && result.body.code == 2000) {
         				var targetId = result.body.result.targetId;
         				console.log(targetId)
         				WebIMWidget.setConversation(1,targetId);
         			}
            	 }            	
            });
            
        });
    };
    
    //聊天窗口点击患者档案
//  var masterPatientId='af29f4ea-1247-4658-a17b-12d0d92160b9';
	$scope.selectPatientArchive = function (masterPatientId) {
		console.log(masterPatientId);
		if(masterPatientId){
			openPatientArchiveModel(masterPatientId,$modal,$scope);
		}else{
			alert("请先选择会话")
		}
	}
	
	//看大图
	$rootScope.showImg = function(imgUrl){
		$modal.open({
			templateUrl:'pdiShowImage.html',
			controller:'pdiShowImageCtrl',
			size:"lg",
			resolve:{
				items:function(){
					return imgUrl
				}
			}
		})
	}
	

}]);

app.controller("pdiShowImageCtrl",function($scope,items){
	$scope.showImgUrl = items
})