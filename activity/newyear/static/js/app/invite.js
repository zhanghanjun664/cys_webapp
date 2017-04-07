define(function(require){

    var $=require('jquery');

    //var backgroundmap='../static/backgroundmap/bg2.png';
    var backgroundmap=null;

    //var wishmap='../static/wishmap/wish2.png';
    var wishmap=null;

    function GetQueryString(name){
        var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if(r!=null) {
            return unescape(r[2]);
        }else{
            return null;
        }
    };
    var cardId=GetQueryString('id');


    var getCardMessage=function(){

        $.ajax({
            type:"get",
            url:"/wxapi/activity/newyear2016/getGreetCardById",
            data:{'id':cardId},
            asyne:false,
            dataType:'json',
            success:function(s){

                if (s.result=="0"){
                    //resultObject
                    backgroundmap= s.resultObject.cardImg1;
                    wishmap= s.resultObject.cardImg2;

                    if (backgroundmap.indexOf('bg3')>0){
                        $('.showcard').attr('attr','3');
                    }


                    $('.show_backgroundimage').attr('src',backgroundmap);

                    $('.show_wish_images').attr('src',wishmap);

                }else{
                    window.location.reload();
                }
            }
        });



        //var backgroundmap='../static/backgroundmap/bg2.png';
        //
        //var wishmap='../static/wishmap/wish2.png';





    };

    return {
        getCardMessage:getCardMessage
    }


});