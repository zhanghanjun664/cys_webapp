define(function(require){

	var $=require('jquery');
	var layer=require('layer');
	
	//how much money
	var showMoney=function(){
		var moneyClass="money"+getHowMuchMoney();

        $('#money').addClass(moneyClass);
	}


	function getHowMuchMoney(){
		var money = 0;
         $.ajax({
			 url:"/weixin/activity/getHowMuchMoney.htm",
             async:false,
             type:"get",
             dataType:'json',
             beforeSend:function(){},
             success:function(s){
				 if(s.result == "0"){
					 money = s.resultObject;
				 }
			 }
         });
		return money;
	}

	var receiveRedEvelopes=function(){

		$('#receiveRedEvelopes').on('click',function(){

				 $.ajax({
					 url:"/weixin/activity/doctorSendRedPackets.htm",
		             async:false,
		             type:"get",
		             dataType:'json',
		             beforeSend:function(){},
		             success:function(s){
						 if(s.result == "0"){
							 layer.alert("感谢您的支持", {title: false, closeBtn: false}, function(){
								 window.location.href="getoActivityHtm.htm?htmlurl=activity/academic/end";
							 });
						 }else if(s.result == "401"){
							 window.location.href="getoActivityHtm.htm?htmlurl=activity/academic/end";
						 }
					 }
		         });



		});

	}


	return {
		showMoney:showMoney,
		receiveRedEvelopes:receiveRedEvelopes
	}


});