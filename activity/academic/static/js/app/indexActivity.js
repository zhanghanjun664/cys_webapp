define(function(require){
    var $=require('jquery');

    var layer=require('layer');

    var gotoAcademic = function(){
        $('#academic_start_btn').on('click',function(){
            $.ajax({
                url:"/weixin/activity/goAcademic.htm",
                async:false,
                type:"get",
                dataType:'json',
                beforeSend:function(){},
                success:function(s){
                    if(s.result == "0"){
                        window.location.href="getoActivityHtm.htm?htmlurl=activity/academic/choiceQuestion";
                    }
                    if(s.result == "401"){
                        layer.alert(s.description, {title: false, closeBtn: false}, function(){layer.closeAll();});
                    }
                    if(s.result == "108"){
                        window.location.href="getoActivityHtm.htm?htmlurl=activity/academic/register";
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

    return {
        gotoAcademic:gotoAcademic
    }
});