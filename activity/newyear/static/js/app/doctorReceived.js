define(function(require){

   var $=require('jquery');

   var iscroll=require('iscroll');

	var wx=require('wechat');

	var layer=require('layer');

	var wxconfig=null;
	function GetQueryString(name){
		var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
		var r = window.location.search.substr(1).match(reg);
		if(r!=null) {
			return unescape(r[2]);
		}else{
			return null;
		}
	};
	var id=GetQueryString('id');
  	var doctorName = '';
	var cardCount = '';

	//var prompt_dialog_box=function(){
	//	if (!window.localStorage.getItem('two')){
	//		$('#box2').css({'display':'block'});
	//		$('#box2').on('click',function(ev){
	//			window.localStorage.setItem('two',true);
	//			$('#box2').css({'display':'none'});
	//		});
	//	}
	//};




   var BlessedLanguage=function(){




	   $.ajax({
		   type:"get",
		   url:"/wxapi/activity/newyear2016/doctorCardList",
		   data:{'jdDoctorId':id},
		   dataType:'json',
		   success:function(s){
			   if (s.result==0) {
				   var doctorName = s.resultObject.list[0].name;
				   var cardCount = s.resultObject.count;
				   //医生贺卡数只显示一次
				   $('#show_reviceived_number').html(s.resultObject.count);

				   $('#wish').html('');

				   for (var i = 0; i < s.resultObject.list.length; i++) {

					   var name=s.resultObject.list[i].patientWechatName;//这个是发送祝福的人的名字，但是这里没有，先用医生名字替代


					   var wish=s.resultObject.list[i].cardImg2;

					   if (wish.indexOf('wish1')>0) {
						   wish='财源滚滚，坐享其“橙”';
					   };


					   if (wish.indexOf('wish2')>0) {
						   wish='财源亨通，一举“橙”名';
					   };

					   if (wish.indexOf('wish3')>0) {
						   wish='福禄寿喜，儿女“橙”行';
					   };


					   if (wish.indexOf('wish4')>0) {
						   wish='福如东海，东“橙”西就';
					   };

					   if (wish.indexOf('wish5')>0) {
						   wish='富贵吉祥，功“橙”名就';
					   };

					   if (wish.indexOf('wish6')>0) {
						   wish='恭喜发财，事业有“橙”';
					   };

					   if (wish.indexOf('wish7')>0) {
						   wish='马到“橙”功，福寿安康';
					   };

					   if (wish.indexOf('wish8')>0) {
						   wish='人寿年丰，家“橙”业就';
					   };


					   if (wish.indexOf('wish9')>0) {
						   wish='寿与天齐，功“橙”行满';
					   };

					   if (wish.indexOf('wish10')>0) {
						   wish='万事大吉，水到渠“橙”';
					   };

					   if (wish.indexOf('wish11')>0) {
						   wish='万事如意，心想事“橙”';
					   };


					   if (wish.indexOf('wish12')>0) {
						   wish='笑口常开，点石“橙”金';
					   };


					   var oLi=$('<li>'+
					   '<p>'+name+'祝您：</p>'+
					   '<p>'+wish+'</p>'+
					   '</li>');
					   oLi.appendTo($('#wish'));


				   };

				   var oLi2=$('<li>……</li>');

				   oLi2.appendTo($('#wish'));

				   var myScroll = new IScroll('#wish_list',{
					   scrollbars: true
				   });
			   };
		   }
	   });

   };



   var getEvaluate=function(){

	   $.ajax({
		   type:"get",
		   url:"/wxapi/activity/newyear2016/doctorComment",
		   data:{'jdDoctorId':id},
		   dataType:'json',
		   success:function(s){
			   $('#Evaluate_list').html('');
				if(s.resultObject.length > 0){
					for (var i = 0; i < s.resultObject.length; i++) {
						var content=s.resultObject[i].comment;
						var oLi=$('<li>•'+content+'</li>');

						oLi.appendTo($('#Evaluate_list'));

					};

					var oLi2=$('<li>……</li>');

					oLi2.appendTo($('#Evaluate_list'));


					var myScroll = new IScroll('#discuss_doctor_wrap2',{
						scrollbars: true
					});
				}else{
					var oLi=$('<li>您暂时没收到评价，接下来橙医生和您一起努力！</li>');
					oLi.appendTo($('#Evaluate_list'));
				}

		   }
	   });



   };

	var doctorShare=function(){

		$('#doctor_share').on('click',function(){
			if ($('.share_wrap').length>0){
				return false;
			};
			var oWrap=$('<div class="share_wrap"><div class="share_marked_words"></div></div>');
			oWrap.appendTo($('body'));

			oWrap.on('click',function(){
				oWrap.remove();
			});
		});
	};


	function strToJson(str){
		var json = eval('(' + str + ')');
		return json;
	}


	var getAppId=function(){

		wxconfig=null;

		$.ajax({
			type:"get",
			url:"/wxapi/activity/newyear2016/wxDoctorConfig",
			data:{url:"http://m.chengyisheng.com.cn/activity/newyear/view/doctorReceived.html?id="+id},
			asyne:false,
			dataType:'json',
			success:function(s){
				if (s.result==0){
					//wxconfig=strToJson(s.resultObject);
					wxconfig=s.resultObject;
					weChatShare();
				}
			}
		});

	};



	function weChatShare(){


		wx.config({
			debug: false,
			appId: wxconfig.appId,
			timestamp: wxconfig.timestamp,
			nonceStr: wxconfig.nonceStr,
			signature: wxconfig.signature,
			jsApiList: ['checkJsApi', 'onMenuShareTimeline', 'onMenuShareAppMessage']
		});
		wx.ready(function () {
			wx.checkJsApi({
				jsApiList: ['onMenuShareTimeline', 'onMenuShareAppMessage'],
				success: function (res) {
					if (!res.checkResult.onMenuShareTimeline || !res.checkResult.onMenuShareAppMessage) {
						var msg = '您的微信版本不支持分享接口，请升级后再分享，谢谢支持！';
						layer.alert(msg, {
							title: false,
							closeBtn: false
						}, function () {
							layer.closeAll();
						});
					}
				}
			});
			wx.onMenuShareTimeline({
				title: '我在橙医生，收到很多患者寄来的新春贺卡，进来看看吧！',
				desc:'新年快乐，你也来送我贺卡抢红包吧！',
				link: 'http://m.chengyisheng.com.cn/activity/newyear/view/doctorShare.html'+"?jdDoctorId="+id,
				imgUrl: 'http://m.chengyisheng.com.cn/activity/newyear/static/images/doctor200.jpg',
				success: function () {
					var msg="分享成功";
					layer.alert(msg, {
						title: false,
						closeBtn: false
					}, function () {
						layer.closeAll();
					});
				}
			});
			wx.onMenuShareAppMessage({
				title: '我在橙医生，收到很多患者寄来的新春贺卡，进来看看吧！',
				desc:'新年快乐，你也来送我贺卡抢红包吧！',
				link: 'http://m.chengyisheng.com.cn/activity/newyear/view/doctorShare.html'+"?jdDoctorId="+id,
				imgUrl: 'http://m.chengyisheng.com.cn/activity/newyear/static/images/doctor200.jpg',
				type: 'link',
				success: function () {
					var msg="分享成功";
					layer.alert(msg, {
						title: false,
						closeBtn: false
					}, function () {
						layer.closeAll();
					});
				}
			});
		});
	};


	var prompt_dialog_box=function(){

			if (!window.localStorage.getItem('two')){
				$('#box2').css({'display':'block'});
				$('#box2').on('click',function(){
					window.localStorage.setItem('two',true);
					$('#box2').css({'display':'none'});
				});
			}
		};


   return{
	   prompt_dialog_box:prompt_dialog_box,
	   BlessedLanguage:BlessedLanguage,
	   getEvaluate:getEvaluate,
	   doctorShare:doctorShare,
	   getAppId:getAppId
   }
});