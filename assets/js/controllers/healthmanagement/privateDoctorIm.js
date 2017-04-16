app.controller("privateDoctorImCtrl", ["$scope", "WebIMWidget", function($scope, WebIMWidget) {
	console.log("进来了")
	//  WebIMWidget.init({
	//    appkey:"kj7swf8o70pf2",
	//    token:"doC38rom5UcpE7sNAXfWvxHEr6hXhR4NaJZD55HvbR9aTpIyQPjjjW0jHQczR3NtVPeILr9MNhasAId4HDw48gPhk+bNslkk"
	//  });
	WebIMWidget.init({
		appkey: "kj7swf8o70pf2",
		token: "doC38rom5UcpE7sNAXfWvxHEr6hXhR4NaJZD55HvbR9aTpIyQPjjjW0jHQczR3NtVPeILr9MNhasAId4HDw48gPhk+bNslkk",
		style: {
			left: 5,
			top: 5,
			width: 630,
			height:600
		},
		displayConversationList: true,
		onSuccess: function() {
			//初始化完成
			console.log("初始化完成")
			WebIMWidget.setConversation(1,"d:498848967");
		},
		onError: function() {
			//初始化错误
			console.log('连接失败：' + error);
		}
	});
	
	
	WebIMWidget.setUserInfoProvider(function(targetId, obj) {
        obj.onSuccess({
            name: "用户：" + targetId
        });
    });

	
	WebIMWidget.show();
	

}]);