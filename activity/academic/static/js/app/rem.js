(function() {
	
	/*设计图为640 字体大小为40*/
	function changefontsize(){
			var _this=this;

			var html=document.getElementsByTagName('html')[0];

			var screenWitdh=_this.innerWidth;

			var Fsize=(screenWitdh*0.125)/2;

			if (Fsize>23){
				Fsize=23;
			}


			html.style.fontSize=Fsize+"px";


	}
	changefontsize();

	window.onresize=function(){
		changefontsize();
	}

})();

