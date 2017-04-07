/*===========================滚动条样式修改===========================*/
$("html,#setScroll").niceScroll({  
	cursorcolor:"#b4b4b4", 		//滚动条颜色
	touchbehavior:false,   		//是否开启类似触屏
	cursorwidth:"4px",     		//滚动条宽度
	cursorborder:"0",  	   		//滚动条边框		
	cursorborderradius:"5px"    //滚动条圆角度数
});



/*===========================首页轮播===========================*/
var bannerMove=new bannerMove({
		time:2500        //设置轮播时间
});


/*===========================调用搜索===========================*/
var search=new search({
	placeholder:'医院 / 医生 / 疾病', //设置placeholder
	input:'#search_content',          //输入框
	click:'#search_btn',	          //点击的按钮
	form:'searform'					  //表单
});

/*===========================首页医院列表特效===========================*/
var hospital_hover=new hospital_hover();

