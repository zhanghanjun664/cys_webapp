/*===========================首页轮播 开始===========================*/
function bannerMove(obj){
	this.num=0;
	this.timer=null;
	this.maxnum=$('.banner_move .banner_sileder').length;
	this.time=obj.time||null;
	this.width=$('.banner_move_wrap').eq(0).width();
	this.height=$('.banner_move_wrap').eq(0).height();
	this.setAttr();
	this.setTimer();
	this.pointClick();
}

//设置属性
bannerMove.prototype.setAttr = function() {
	var _this=this;
	$('.banner_sileder').css({'width':_this.width+'px','height':_this.height+'px'});
};

//设置时间
bannerMove.prototype.setTimer=function(){
	if ($('.banner_move .banner_sileder').length==1) {
		return;
	};
	var _this=this;
	clearInterval(_this.timer);
	_this.timer=setInterval(function(){
		_this.num++;
		if (_this.num>=_this.maxnum) {
			_this.num=0;
		};
		_this.setAnimate(_this.num);
		_this.setPointactive(_this.num);
	},_this.time);
}

//点击小圆点
bannerMove.prototype.pointClick=function(){
	var _this=this;
	$('.pointior').on('click','li',function(ev){
		clearInterval(_this.timer);
		_this.num=$(this).index();
		_this.setAnimate(_this.num);
		_this.setPointactive(_this.num);
		_this.setTimer();
	});
}

//设置原点切换时的动画
bannerMove.prototype.setPointactive=function(ind){
	$('.pointior li').removeClass('point_active');
	$('.pointior li').eq(ind).addClass('point_active');
}

//设置轮播动画
bannerMove.prototype.setAnimate=function(num){
	var _this=this;
	var left=-(parseInt(num)*parseInt(_this.width))+'px';
	$('.banner_move').stop().animate({'opacity':1},function(){
		$('.banner_move').css({'left':left})
	});
}

/*===========================首页轮播 结束===========================*/



/*===========================搜索 开始===========================*/
function search(obj){
	this.placeholder=obj.placeholder;
	this.input=obj.input;
	this.click=obj.click;
	this.form=obj.form;
	this.setPlaceholder();
	this.clickSearch();
}

//检测浏览器是否支持placeholder
search.prototype.checkPlaceholder=function(){
	var attr = "placeholder";
	var input = document.createElement("input");
	return attr in input;
}

//设置placeholder
search.prototype.setPlaceholder=function(){
	var _this=this;
	if (_this.checkPlaceholder()) {
		$(_this.input).attr('placeholder',_this.placeholder);
	}else{
		
		$('.search span').html(_this.placeholder);
		$('.search span').show();

		$('.search span').on('click',function(ev){
			$(_this.input).focus();
		});

		$(_this.input).on('keydown',function(ev){
			$('.search span').hide();
		});


		$(_this.input).on('keyup',function(ev){
			if ($(_this.input).val()=="") {
				$('.search span').show();
			};
		});
	}	
}

/*点击搜索*/
search.prototype.clickSearch=function(){
	var _this=this;
	$(_this.click).on('click',function(ev){
		if( $.trim( $(_this.input).val() ).length==0){
			$(_this.input).focus();
			if( _this.checkPlaceholder()==false ){
				$('.search span').show();
			}
		}else{
			$(_this.form).submit();
		}
	});
}
/*===========================搜索 结束===========================*/


/*===========================首页医院列表 开始===========================*/
function hospital_hover(){

	$('#biuuu_city_list').on('mouseover','li',function(ev){
		$('.hospital_hover').remove();
		var obj=$('<div class="pa hospital_hover"></div>');
		obj.appendTo($(this));
	});

	$('#biuuu_city_list').on('mouseout','li',function(ev){
		$('.hospital_hover').remove();
	});
}
/*===========================首页医院列表 结束===========================*/


/*===========================首页二维码 开始===========================*/

/*===========================首页二维码 结束===========================*/