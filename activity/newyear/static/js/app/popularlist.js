define(function(require){

    var $=require('jquery');

    var iscroll=require('iscroll');

    var layer=require('layer');





    var getPopularData=function(){

        $('#popular_list').html('');

        $.ajax({
            type:"get",
            url:"/wxapi/activity/newyear2016/popularDoctor",
            asyne:false,
            data:{'num':'10'},
            dataType:'json',
            success:function(s){

                if (s.result==0){

                    for (var i=0;i<s.resultObject.length;i++){
                        var src=s.resultObject[i].headPic;
                        var name= s.resultObject[i].name;
                        if(name == 'null' || name ==null){
                            continue
                        }
                        var cardNumber= s.resultObject[i].popularity;
                        if (src=="" || src == "null" || src == null){
                            var oLi=$('<li>'+
                            '<div class="polularnumber">'+(i+1)+'</div>'+
                            '<div class="popularpic pr">'+
                            '<div class="popular_pic_wrap pa"></div>'+
                            '</div>'+
                            '<div class="popularshow">'+
                            '<p class="clearfix popularname"><span class="fl">'+name+'</span><span class="fr doctorNumber">'+cardNumber+'</span></p>'+
                            '<p class="popular_hp pr">'+
                            '<span class="pa"></span>'+
                            '</p>'+
                            '</div>'+
                            '</li>');
                            oLi.appendTo( $('#popular_list'));
                        }else{
                            var oLi=$('<li>'+
                            '<div class="polularnumber">'+(i+1)+'</div>'+
                            '<div class="popularpic pr">'+
                            '<div class="popular_pic_wrap pa"><img src="'+src+'"></div>'+
                            '</div>'+
                            '<div class="popularshow">'+
                            '<p class="clearfix popularname"><span class="fl">'+name+'</span><span class="fr doctorNumber">'+cardNumber+'</span></p>'+
                            '<p class="popular_hp pr">'+
                            '<span class="pa"></span>'+
                            '</p>'+
                            '</div>'+
                            '</li>');
                            oLi.appendTo( $('#popular_list'));
                        }

                    };


                    var myScroll = new IScroll('#iscroll_wrap',{
                        scrollbars: true
                    });


                }else{

                    layer.alert('获取人气医生榜失败', {
                        title: false,
                        closeBtn: false
                    }, function(){
                        layer.closeAll();
                    });

                }
            }
         });





    };


    var getSchedule=function(){
        var sum=0;
        //得到10个医生的贺卡总数
        for (var i=0;i< $('#popular_list li').length;i++){
            var sunOne=parseInt($('.doctorNumber').eq(i).html());
            sum=sum+sunOne;
        }

        //渲染进度条
        for (var i=0;i< $('#popular_list li').length;i++){
            var schedule= (parseInt( $('.doctorNumber').eq(i).html() )/sum)*100+"%";
            $('.popular_hp').eq(i).find('span').css({'width':schedule});
        }
    };


    return{
        getPopularData:getPopularData,
        getSchedule:getSchedule
    };







});
