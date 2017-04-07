define(function(){

	var fastClick=function(){

		window.addEventListener('load', function() {
  				FastClick.attach(document.body);
		}, false);

	}

	return {
		fastClick:fastClick
	}

});