requirejs.config({
   baseUrl:'../static/',
   paths:{
       'jquery':['js/libs/jquery/jquery'],
       'fastClick':['js/libs/fastclick/fastclick'],
       'css':['js/libs/css/css.min'],
       'swiper':['js/libs/swiper/swiper.min'],
       "layer":['js/libs/layer/layer'],
       "iscroll":['js/libs/iscroll/iscroll'],
       'wechat':['http://res.wx.qq.com/open/js/jweixin-1.0.0'],

       'index':['js/app/index'],
       'selectBackground':['js/app/selectBackground'],
       'selectDoctor':['js/app/selectDoctor'],
       'acceptprize':['js/app/acceptprize'],
       'popularlist':['js/app/popularlist'],
       'invite':['js/app/invite'],
       'received':['js/app/received'],
       'doctorShare':['js/app/doctorShare'],
       'doctorReceived':['js/app/doctorReceived']


   },
    map:{
        '*':{
            'css':['css']
        }
    },

    shim:{
        'layer': ['css!../static/css/layer.css','css!../static/css/layer_skin_extend.css'],
       'swiper':['css!../static/css/swiper.min.css']

    }
});



