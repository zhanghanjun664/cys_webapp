requirejs.config({
	baseUrl: '/activity/academic/static/',

	paths:{
		"jquery":['js/libs/jquery/jquery.min'],

		"mobiscroll":['js/libs/mobiscroll/mobiscroll.i18n.zh'],
		"mobiscrollcore":['js/libs/mobiscroll/mobiscroll.core'],
		"mobiscrollframe":['js/libs/mobiscroll/mobiscroll.frame'],
		"mobiscrollscroller":['js/libs/mobiscroll/mobiscroll.scroller'],
		"mobiscrollselect":['js/libs/mobiscroll/mobiscroll.select'],

		"awardRotate":['js/libs/awardRotate/awardRotate'],
		"css":['js/libs/css/css.min'],
		"layer":['js/libs/layer/layer'],
		"register":['js/app/register'],
		"choiceQuestion":['js/app/choiceQuestion'],
		"redEvelopes":['js/app/redEvelopes'],
		"Lottery":['js/app/Lottery'],
		"personalInformation":['js/app/personalInformation'],
		"indexActivity":['js/app/indexActivity']

	},

	map: {
		'*': {
			'css': ['css']
		}
	},

	shim : {
		'layer': ['css!../static/css/layer.css','css!../static/css/layer_skin_extend.css'],
		'mobiscroll':['css!../static/css/mobiscroll.animation.css','css!../static/css/mobiscroll.icons.css','css!../static/css/mobiscroll.frame.css','css!../static/css/mobiscroll.scroller.css','jquery'],
		'awardRotate':['jquery']
	}



});

require(['js/app/fastClick'],function(s){
	s.fastClick();
});



if (location.href.indexOf('register')>0) {
	require(['register'],function(s){
		s.registerNext();
		s.getCode();
	});
};


if (location.href.indexOf('choiceQuestion')>0) {
	require(['choiceQuestion'],function(s){
		s.submitQuestion();
	});
};

if (location.href.indexOf('redEnvelopes')>0) {
	require(['redEvelopes'],function(s){
		s.showMoney();
		s.receiveRedEvelopes();
	});
};


if (location.href.indexOf('lottery')>0) {
	require(['lottery'],function(s){
		s.drawRouletteWheel();
		s.rotate();
	});
};


if (location.href.indexOf('academicActivity')>0) {

	require(['indexActivity'],function(s){
		s.gotoAcademic();
	});
};

if (location.href.indexOf('checkdoctorActivityCode')>0) {

	require(['personalInformation'],function(s){
		s.selectData();
		s.submitData();
	});
};