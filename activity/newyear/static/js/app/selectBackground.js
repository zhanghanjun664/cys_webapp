define(function(require){

    var $=require('jquery');

    var swiper=require('swiper');

    var bgSrc=$('#swiper-bg').find('.background_style').eq(0).find('img').attr('getsrc');

    var wishSrc=$('#swiper-wish').find('.these_title').eq(0).attr('getsrc');


    var swiper2=new Swiper('#swiper-wish',{
        loop : true
    });


    var swiper = new Swiper('#swiper-bg',{
        loop : true
    });


    function getBgSrc(index){
        bgSrc=$('#swiper-bg').find('.background_style').eq(index).find('img').attr('getsrc');
        window.sessionStorage.setItem('attrId',index );
        window.sessionStorage.setItem('bgsrc',bgSrc );

    }


    function getWishSrc(index){
        wishSrc=$('#swiper-wish').find('.these_title').eq(index).attr('getsrc');
        window.sessionStorage.setItem('wishSrc',wishSrc );
    }



    var createCard=function(){
        $('#createCard').on('click',function(ev){
            getBgSrc(swiper.activeIndex);
            getWishSrc(swiper2.activeIndex);
            window.location.href="selectDoctor.html";
        });
    };


    var prompt_dialog_box=function(){
        if (!window.localStorage.getItem('one')){
            $('#box').css({'display':'block'});
            $('#box').on('click',function(ev){
                window.localStorage.setItem('one',true);
               $('#box').css({'display':'none'});
            });
        }
    };


    return{
        createCard:createCard,
        prompt_dialog_box:prompt_dialog_box
    };








});