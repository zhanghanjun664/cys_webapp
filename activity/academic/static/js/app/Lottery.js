define(function(require){

	var $=require('jquery');

	var layer=require('layer');

	var awardRotate=require('awardRotate');



	var turnplate={
		restaraunts:[],
		colors:[],
		outsideRadius:192,
		textRadius:155,
		insideRadius:68,
		startAngle:0,
		bRotate:false
	};


	turnplate.restaraunts = [ "乐心GPRS远程血压计", "100元体验金","小米充电器","鱼跃听诊器","乐心血压计","心云血压计","九安血压计"];
	turnplate.colors = ["#fff3c1", "#fff9e6", "#ffd8a2", "#fff9e6","#ffd8a2", "#fff9e6", "#ffd8a2"];



	//旋转转盘 item:奖品位置; txt：提示语;
	function rotateFn(item, txt){
		var angles = item * (360 / turnplate.restaraunts.length) - (360 / (turnplate.restaraunts.length*2));
		if(angles<270){
			angles = 270 - angles;
		}else{
			angles = 360 - angles + 270;
		}
		$('#wheelcanvas').stopRotate();


		$('#wheelcanvas').rotate({
			angle:0,
			animateTo:angles+1800,
			duration:8000,
			callback:function (){
				turnplate.bRotate = !turnplate.bRotate;
				$('#prize_show').html('<p>恭喜您获得</p><p>'+txt+'</p>');

			}
		});
	};



	var drawRouletteWheel=function() {
		if ($('#wheelcanvas').length<1){return false;}
		var canvas = document.getElementById("wheelcanvas");

		if (canvas.getContext) {
			//根据奖品个数计算圆周角度
			var arc = Math.PI / (turnplate.restaraunts.length/2);
			var ctx = canvas.getContext("2d");
			//在给定矩形内清空一个矩形
			ctx.clearRect(0,0,422,422);
			//strokeStyle 属性设置或返回用于笔触的颜色、渐变或模式
			ctx.strokeStyle = "#FFBE04";
			//font 属性设置或返回画布上文本内容的当前字体属性
			ctx.font = '18px Microsoft YaHei';
			for(var i = 0; i < turnplate.restaraunts.length; i++) {
				var angle = turnplate.startAngle + i * arc;
				ctx.fillStyle = turnplate.colors[i];
				ctx.beginPath();
				//arc(x,y,r,起始角,结束角,绘制方向) 方法创建弧/曲线（用于创建圆或部分圆）
				ctx.arc(211, 211, turnplate.outsideRadius, angle, angle + arc, false);
				ctx.arc(211, 211, turnplate.insideRadius, angle + arc, angle, true);
				ctx.stroke();
				ctx.fill();
				//锁画布(为了保存之前的画布状态)
				ctx.save();

				//----绘制奖品开始----
				ctx.fillStyle = "#663333";
				var text = turnplate.restaraunts[i];
				var line_height = 17;
				//translate方法重新映射画布上的 (0,0) 位置
				ctx.translate(211 + Math.cos(angle + arc / 2) * turnplate.textRadius, 211 + Math.sin(angle + arc / 2) * turnplate.textRadius);

				//rotate方法旋转当前的绘图
				ctx.rotate(angle + arc / 2 + Math.PI / 2);

				/** 下面代码根据奖品类型、奖品名称长度渲染不同效果，如字体、颜色、图片效果。(具体根据实际情况改变) **/
				if(text.indexOf("M")>0){//流量包
					var texts = text.split("M");
					for(var j = 0; j<texts.length; j++){
						ctx.font = j == 0?'bold 20px Microsoft YaHei':'16px Microsoft YaHei';
						if(j == 0){
							ctx.fillText(texts[j]+"M", -ctx.measureText(texts[j]+"M").width / 2, j * line_height);
						}else{
							ctx.fillText(texts[j], -ctx.measureText(texts[j]).width / 2, j * line_height);
						}
					}
				}else if(text.indexOf("M") == -1 && text.length>6){//奖品名称长度超过一定范围
					text = text.substring(0,6)+"||"+text.substring(6);
					var texts = text.split("||");
					for(var j = 0; j<texts.length; j++){
						ctx.fillText(texts[j], -ctx.measureText(texts[j]).width / 2, j * line_height);
					}
				}else{
					//在画布上绘制填色的文本。文本的默认颜色是黑色
					//measureText()方法返回包含一个对象，该对象包含以像素计的指定字体宽度
					ctx.fillText(text, -ctx.measureText(text).width / 2, 0);
				}

				//把当前画布返回（调整）到上一个save()状态之前
				ctx.restore();
				//----绘制奖品结束----
			}
		}
	}



	var Lotteryrotate=function (){

		$('.pointer').on('click',function(){

			$.ajax({
				url:"/weixin/activity/saveArgument.htm",
				async:false,
				type:"get",
				dataType:'json',
				beforeSend:function(){},
				success:function(s){
					if(s.result == "0"){
						var resultInt = s.resultObject;
						if ( parseInt( $('#prize_show p').length)>1  ){
							layer.alert("您已经抽过一次奖品了", {title: false, closeBtn: false}, function(){layer.closeAll();});
							return false;
						}
						if(turnplate.bRotate){
							return false;
						};
						turnplate.bRotate = !turnplate.bRotate;
						//获取随机数(奖品个数范围内)
						var item=parseInt(resultInt);
						rotateFn(item, turnplate.restaraunts[item-1]);
					}else{
						layer.alert(s.description, {title: false, closeBtn: false}, function(){layer.closeAll();});
					}
				},
				error:function(msgbak){
					layer.alert("系统异常", {title: false, closeBtn: false}, function(){layer.closeAll();});
				}
			});

		});
	};







	return {
		drawRouletteWheel:drawRouletteWheel,
		rotate:Lotteryrotate
	}


});