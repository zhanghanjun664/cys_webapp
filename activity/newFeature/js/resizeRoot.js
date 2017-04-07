(function() {
	var maxWidth=640,maxFontSize=26,_this=this,fontSize;
	var root=document.getElementsByTagName('html')[0];
	var screenWidth = (screen.width > 0) ? (_this.innerWidth >= screen.width || _this.innerWidth == 0) ? screen.width : _this.innerWidth : _this.innerWidth;
	var screenHeight = (screen.height > 0) ? (_this.innerHeight >= screen.height || _this.innerHeight == 0) ? _this.height : _this.innerHeight : _this.innerHeight;
	/*设定最大的宽度*/
	if(screenWidth>maxWidth){screenWidth=maxWidth};
	if(screenHeight>maxWidth){screenHeight=maxWidth};
	if(screenWidth > screenHeight){screenWidth = screenHeight;};
	var browser = {
		versions : function() {
			var u = navigator.userAgent, app = navigator.appVersion;
			return {//移动终端浏览器版本信息
				trident : u.indexOf('Trident') > -1, //IE内核
				presto : u.indexOf('Presto') > -1, //opera内核
				webKit : u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
				gecko : u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
				mobile : !!u.match(/AppleWebKit.*Mobile.*/)
				|| !!u.match(/AppleWebKit/), //是否为移动终端
				ios : !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
				android : u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
				iPhone : u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器
				iPad: u.indexOf('iPad') > -1, //是否iPad
				webApp : u.indexOf('Safari') == -1,//是否web应该程序，没有头部与底部
				google:u.indexOf('Chrome')>-1
			};
		}(),
		language : (navigator.browserLanguage || navigator.language).toLowerCase()
	};
	/*设计为750 字体为100 (iphone6 由大到小)*/
	//var multiple=750/100;
	//var fontSize=(screenWidth/multiple);
	//root.style.fontSize=fontSize+'px';

	/*设计图为640 字体大小为40 (iphone4 or iphone5 由小放大)*/
	if(browser.versions.iPad){
		fontSize=maxFontSize;
	}else if(browser.versions.ios||browser.versions.android){
		var multiple=40/(640/2);
		fontSize=(screenWidth*multiple)/2;
	}else if(screenWidth>=maxWidth){
		fontSize=maxFontSize;
	}else {
		fontSize=maxFontSize;
	}

	root.style.fontSize=fontSize+'px';

})(window,document);