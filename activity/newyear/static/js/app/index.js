define(function(require){
    var $=require('jquery');

    var error=false;



    var location=function(){

        $('#star').on('click',function(ev){
            $.ajax({
                type:"get",
                url:"/wxapi/activity/newyear2016/checkUserFollow",
                asyne:false,
                dataType:'json',
                success:function(s){

                    if (s.result=="0"){
                        window.location.href="selectBackground.html";
                    }else{
                        window.location.href="attention.html";
                    }
                }
            });

        });



    };

    return{
        location:location
    }

});