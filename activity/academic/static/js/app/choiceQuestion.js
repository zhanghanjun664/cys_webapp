define(function(require){

    var $=require('jquery');

    var layer=require('layer');

    var questionArray=[];

    var submitQuestion=function(){
        getAnswer("#questionOne",0);
        getAnswer("#questionTwo",1);
        submitAnswer();
    }


    //get the answer to the question  
    function getAnswer(obj,i){
         $(obj).on('click','.question',function(){
            $(obj).find('.question_choice').removeClass('question_choice_slect');
            var choise_num=parseInt($(this).index())-2;
            questionArray[i]=$(this).attr('attr');
             $(obj).find('.question_choice').eq(choise_num).addClass('question_choice_slect');
        });
    }


    //submit the answer to the question
    function submitAnswer(){

        $('#submitAnswer').on('click',function(){

            if ( questionArray.length<2 ) {
                layer.alert("请把问题回答完整", {title: false, closeBtn: false}, function(){layer.closeAll();});
                return false;
            };

            $.ajax({
                url:"/weixin/activity/saveArgument.htm",
                async:false,
                type:"get",
                dataType:'json',
                data:{"nifedipine":questionArray[0],"aspirin":questionArray[1]},
                beforeSend:function(){},
                success:function(s){
                    if(s.result == "0"){
                        window.location.href="getoActivityHtm.htm?htmlurl=activity/academic/redEnvelopes";
                    }
                    if(s.result == "401"){
                        window.location.href="getoActivityHtm.htm?htmlurl=activity/academic/end";
                    }
                    if(s.result == "111"){
                        layer.alert(s.description, {title: false, closeBtn: false}, function(){layer.closeAll();});
                    }else{
                        layer.alert(s.description, {title: false, closeBtn: false}, function(){layer.closeAll();});
                    }
                },
                error:function(msgbak){
                    layer.alert("系统异常", {title: false, closeBtn: false}, function(){layer.closeAll();});
                }
            });



        });

    }




    return{
        submitQuestion:submitQuestion
    }


});