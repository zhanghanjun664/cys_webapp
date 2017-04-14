app.controller("privateDoctorImCtrl",function($scope,$modal,$element){
	RongIMClient.init("kj7swf8o70pf2");
	$scope.config = {
        testAppKey: 'kj7swf8o70pf2',
        appKey: 'qf3d5gbj3mzgh',
        weixinKey: 'c9kqb3rdkdbfj',
        token: "doC38rom5UcpE7sNAXfWvxHEr6hXhR4NaJZD55HvbR9aTpIyQPjjjW0jHQczR3NtVPeILr9MNhasAId4HDw48gPhk+bNslkk",
        targetId: "d:647858843",
        type: 'PRIVATE',
        doctorId: "test_user_id",
        teamId: null,
        quota: null,
        repeat: false
    };
	//"d:498848967"
	$scope.historyMsg = [];
	//获取聊天记录(type ===1 ,表示第一次获取聊天记录);
    var getHistory = function (type, number) {
    	$scope.getMoreHistoryMsgBtn = "消息拉取中...";
        var conversationtype = RongIMLib.ConversationType.PRIVATE;
//
//      if ($scope.config.type === "PRIVATE") {
//          conversationtype = RongIMLib.ConversationType.PRIVATE;
//      } else if ($scope.config.type === "GROUP") {
//          conversationtype = RongIMLib.ConversationType.GROUP;
//      }
//
//      if (conversationtype === null) {
//          console.log("服务器配置出错")
//          return false;
//      }
		//拉历史消息
        RongIMClient.getInstance().getHistoryMessages(conversationtype, $scope.config.targetId, null, number, {
            onSuccess: function (list, hasMsg) {
            	console.log(list,hasMsg);
            	if(!hasMsg&&!list.length){
            		console.log("不能再拉了");
            		$scope.$apply(function(){
            			$scope.getMoreHistoryMsgBtn = "已经没有更多消息";
            			$scope.getMoreHistoryMsg = null;
            		})
            		
            		return
            	}
            	$scope.$apply(function(){
            		if (type === 1) {
	                	console.log("第一次获取聊天记录");
	                	$scope.getMoreHistoryMsgBtn = "查看更多消息";
	                	$scope.historyMsg = list;
	                	$scope.scrollBar();
	                } else if (type === 2) {
	                	console.log("不是第一次获取聊天记录");
	                	$scope.getMoreHistoryMsgBtn = "查看更多消息";
	                	$scope.historyMsg = list.concat($scope.historyMsg);
	                } else {
	                    console("请设置是否第一次进入聊天记录");
	                }
	                
            	})
                
            },
            onError: function (error) {
                console.log("失败了")
            }
        });
    };
    
	
	$scope.scrollBar = function () {
        setTimeout(function () {
			$(".pdiBottom_chatcontTop").scrollTop($(".pdiBottom_chatRecord").height());
        }, 0);
    };
	
	
	//服务器链接
    var connect = function () {
        RongIMClient.connect($scope.config.token, {
            onSuccess: function (userId) {
                console.log("Login successfully." + userId);
                getHistory(1, 10);
                //获取会话列表
                RongIMClient.getInstance().getConversationList({
                  onSuccess: function(list) {
                    console.log(list);
                  },
                  onError: function(error) {
                    console.log("出错")
                     // do something...
                  }
                },null);
            },
            onTokenIncorrect: function () {
                console.log('token无效');
            },
            onError: function (errorCode) {
                var info = '';
                switch (errorCode) {
                    case RongIMLib.ErrorCode.TIMEOUT:
                        info = '超时';
                        break;
                    case RongIMLib.ErrorCode.UNKNOWN_ERROR:
                        info = '未知错误';
                        break;
                    case RongIMLib.ErrorCode.UNACCEPTABLE_PaROTOCOL_VERSION:
                        info = '不可接受的协议版本';
                        break;
                    case RongIMLib.ErrorCode.IDENTIFIER_REJECTED:
                        info = 'appkey不正确';
                        break;
                    case RongIMLib.ErrorCode.SERVER_UNAVAILABLE:
                        info = '服务器不可用';
                        break;
                }
                console.log(errorCode,info);
            }
        });

        //连接状态监听器
        RongIMClient.setConnectionStatusListener({
            onChanged: function (status) {
                switch (status) {
                    //链接成功
                    case RongIMLib.ConnectionStatus.CONNECTED:
                        console.log('链接成功');
                        break;
                    //正在链接
                    case RongIMLib.ConnectionStatus.CONNECTING:
                        console.log('正在链接');
                        break;
                    //重新链接
                    case RongIMLib.ConnectionStatus.DISCONNECTED:
                        console.log('断开连接');
                        break;
                    //其他设备登陆
                    case RongIMLib.ConnectionStatus.KICKED_OFFLINE_BY_OTHER_CLIENT:
                        console.log('其他设备登陆');
                        break;
                    //网络不可用
                    case RongIMLib.ConnectionStatus.NETWORK_UNAVAILABLE:
                        console.log('网络不可用');
                        break;
                }
            }
        });

        //消息监听器
        RongIMClient.setOnReceiveMessageListener({
            // 接收到的消息
            onReceived: function (message) {
            	console.log("收到新的消息");
                console.log(message);

                // 判断消息类型
                switch (message.messageType) {
                    case RongIMClient.MessageType.TextMessage:
                    	if (message.conversationType === 1) {
                            if ($scope.config.type === "PRIVATE") {
                                if (message.senderUserId === $scope.config.targetId) {
                                    setItem(message);
                                    messageUtil.goToBottom();
                                }
                            }
                        } else {
                            console.log("不支持的聊天类型");
                        }
                        break;
                    case RongIMClient.MessageType.VoiceMessage:
                        console.log("语音消息");
                        break;
                    case RongIMClient.MessageType.ImageMessage:
						console.log("图片消息")
                        if ($scope.config.repeat === false) {
                            if (message.conversationType === 3) {
                                if ($scope.config.type === "GROUP") {
                                    if (message.targetId === $scope.config.targetId) {
                                        setItem(message);
                                        messageUtil.goToBottom();
                                    }
                                }
                            } else if (message.conversationType === 1) {
                                if ($scope.config.type === "PRIVATE") {
                                    if (message.senderUserId === $scope.config.targetId) {
                                        setItem(message);
                                        messageUtil.goToBottom();
                                    }
                                }
                            } else {
                                console.log("不支持的聊天类型");
                            }
                        }

                        break;
                    case RongIMClient.MessageType.DiscussionNotificationMessage:
                        // do something...
                        break;
                    case RongIMClient.MessageType.LocationMessage:
                        // do something...
                        break;
                    case RongIMClient.MessageType.RichContentMessage:
                        // do something...
                        if ($scope.config.repeat === false) {
                            if (message.conversationType === 3) {
                                if ($scope.config.type === "GROUP") {
                                    if (message.targetId === $scope.config.targetId) {
                                        setItem(message);
                                        messageUtil.goToBottom();
                                    }
                                }
                            } else if (message.conversationType === 1) {
                                if ($scope.config.type === "PRIVATE") {
                                    if (message.senderUserId === $scope.config.targetId) {
                                        setItem(message);
                                        messageUtil.goToBottom();
                                    }
                                }
                            } else {
                                console.log("不支持的聊天类型");
                            }
                        }

                        break;
                    case RongIMClient.MessageType.DiscussionNotificationMessage:
                        // do something...
                        break;
                    case RongIMClient.MessageType.InformationNotificationMessage:
                        // do something...
                        break;
                    case RongIMClient.MessageType.ContactNotificationMessage:
                        // do something...
                        break;
                    case RongIMClient.MessageType.ProfileNotificationMessage:
                        // do something...
                        break;
                    case RongIMClient.MessageType.CommandNotificationMessage:

                        if ($scope.config.repeat === false) {
                            if ($scope.config.type === "PRIVATE") {
                                if (message.senderUserId === $scope.config.targetId) {
                                    if (message.content.name === 'stop_im') {
                                        chatStatus(2);
                                    } else if (message.content.name === 'resume_im') {
                                        //条数
                                        if ($scope.config.token) {
                                            chatStatus(4);
                                            sendMessageUtil.sendMessage();
                                        } else {
                                            getUserMessage();
                                        }
                                    }
                                }
                            }
                        }
                        break;
                    case RongIMClient.MessageType.CommandMessage:
                        // do something...
                        break;
                    case RongIMClient.MessageType.UnknownMessage:
                        // do something...
                        break;
                    default:
                    // 自定义消息
                    // do something...
                }
            }
        });
    };
	connect();
	$scope.send = function(){
		if($scope.sendContent==undefined||$scope.sendContent.length==0){
			console.log("不能发送消息");
			return
		}
		var msg = new RongIMLib.TextMessage({content:$scope.sendContent,extra:"附加信息"});
		var conversationtype = RongIMLib.ConversationType.PRIVATE; // 私聊
		RongIMClient.getInstance().sendMessage(conversationtype, $scope.config.targetId, msg, {
            // 发送消息成功
            onSuccess: function (message) {
                //message 为发送的消息对象并且包含服务器返回的消息唯一Id和发送消息时间戳
                console.log(message);
                $scope.$apply(function(){
                	$scope.historyMsg.push(message);
                	$scope.scrollBar();
                	$scope.sendContent = "";
                })
            },
            onError: function (errorCode,message) {
                var info = '';
                switch (errorCode) {
                    case RongIMLib.ErrorCode.TIMEOUT:
                        info = '超时';
                        break;
                    case RongIMLib.ErrorCode.UNKNOWN_ERROR:
                        info = '未知错误';
                        break;
                    case RongIMLib.ErrorCode.REJECTED_BY_BLACKLIST:
                        info = '在黑名单中，无法向对方发送消息';
                        break;
                    case RongIMLib.ErrorCode.NOT_IN_DISCUSSION:
                        info = '不在讨论组中';
                        break;
                    case RongIMLib.ErrorCode.NOT_IN_GROUP:
                        info = '不在群组中';
                        break;
                    case RongIMLib.ErrorCode.NOT_IN_CHATROOM:
                        info = '不在聊天室中';
                        break;
                    default :
                        info = x;
                        break;
                }
                console.log('发送失败:' + info);
            }
        });
	}
	$scope.shouldSend = function(e){
		if(e.keyCode == 13){
			$scope.send();
		}
	}
	$scope.getMoreHistoryMsg = function(){
		getHistory(2,20);
	}
	
	
	
	
	
	
	
	
	$scope.ShowSearch = false;
	$scope.hadClicked = "小白";
	$scope.openSearch = function(){
	  $scope.ShowSearch = !$scope.ShowSearch
	}
	
	$scope.handleClick = function(item){
		console.log(item);
		$scope.hadClicked = item.name;
	}
	
	//患者列表
	$scope.userList = [
		{
			hadRead:false,
			name:"小白",
			tel:13513345678,
			tags:["365服务包","高血压"],
			content:"我是风儿你是沙，你会唱吗？",
			time:"今天 15:22:22"
		},
		{
			hadRead:false,
			name:"小明",
			tel:13544446666,
			tags:["365服务包"],
			content:"我是风儿你是沙，你会不会唱啊我的天按时唱吗？",
			time:"2016-12-12 15:22:22"
		},
		{
			hadRead:false,
			name:"小桥",
			tel:13513345678,
			tags:["365服务包","高血压"],
			content:"我是风儿你是沙，你会唱吗？",
			time:"今天 15:22:22"
		},
		{
			hadRead:true,
			name:"晓晨",
			tel:13544446666,
			tags:["365服务包"],
			content:"我是风儿你是沙，你会不会唱啊我你会不会唱啊我你会不会我的他那是大是大四阶段？",
			time:"2016-12-12 15:22:22"
		}
		,
		{
			hadRead:false,
			name:"小玲",
			tel:13544446666,
			tags:["365服务包"],
			content:"我是风儿你是沙，你会不会唱啊我的天按时唱吗？",
			time:"2016-12-12 15:22:22"
		}
	]
	
	//判断是否在同一天
	$scope.handleDay = function(next,now,index){
		nextDay=parseInt((next+8*60*60*1000)/(24*60*60*1000));
		nowDay=parseInt((now+8*60*60*1000)/(24*60*60*1000));
		if( nextDay - nowDay >0){
			$scope.historyMsg[index].showDetailDate = true;
		}else{
			$scope.historyMsg[index].showDetailDate = false;
		}
	}
	//看大图
	$scope.showImg = function(imgUrl){
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
})
//模态框
app.controller("pdiShowImageCtrl",function($scope,items){
	$scope.showImgUrl = items
})
