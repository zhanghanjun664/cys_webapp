app.controller("privateDoctorImCtrl", ["$rootScope","$scope", "WebIMWidget", function($rootScope,$scope,WebIMWidget) {
	$rootScope.doctorId = "test_user_id";
	WebIMWidget.init({
		appkey: "kj7swf8o70pf2",
		token: "doC38rom5UcpE7sNAXfWvxHEr6hXhR4NaJZD55HvbR9aTpIyQPjjjW0jHQczR3NtVPeILr9MNhasAId4HDw48gPhk+bNslkk",
		style: {
			left: 5,
			top: 2,
			width: 580,
			height:600
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
        obj.onSuccess({
            name: "name：" + targetId,
            portraitUri:"头像url",
            tel:119,
            userId:targetId
        });
    });
	
	
	WebIMWidget.show();
	

}]);