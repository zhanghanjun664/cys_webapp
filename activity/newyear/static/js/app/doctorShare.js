define(function(require){

    var $=require('jquery');

    var iscroll=require('iscroll');


    //得到地址栏的参数
    function GetQueryString(name){
        var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if(r!=null) {
            return unescape(r[2]);
        }else{
            return null;
        }
    };

    //获取地址栏的ID
    var jdDoctorId=GetQueryString('jdDoctorId');




    var getDoctorMsg=function(){




          $.ajax({
                   type:"get",
                   url:"/wxapi/activity/newyear2016/doctorCardList",
                   data:{'jdDoctorId':jdDoctorId},
                   dataType:'json',
                   success:function(s){
                       if (s.result==0) {

                           //$('#doctor_header').attr('src',s.resultObject.list[0].headPic);
                           $('#doctor_header').css({'background':'url('+s.resultObject.list[0].headPic+') center center no-repeat','background-size':'cover'});

                           $('#doctor_name').html(s.resultObject.list[0].name);

                           $('#doctor_car_number_show').html(s.resultObject.count);
                       }
                   }
                });








        // var myScroll = new IScroll('#discuss_doctor_wrap',{
        //     scrollbars: true
        // });



    };

    var getEvaluate=function(){



          $.ajax({
                   type:"get",
                   url:"/wxapi/activity/newyear2016/doctorComment",
                   data:{'jdDoctorId':jdDoctorId},
                   dataType:'json',
                   success:function(s){
                       $('#Evaluate_list').html('');
                       if(s.resultObject.length > 0){
                           for (var i = 0; i < s.resultObject.length; i++) {
                               var content=s.resultObject[i].comment;
                               var oLi=$('<li>•'+content+'</li>');

                               oLi.appendTo($('#Evaluate_list'));

                           };

                           var oLi2=$('<li>……</li>');

                           oLi2.appendTo($('#Evaluate_list'));


                           var myScroll = new IScroll('#discuss_doctor_wrap2',{
                               scrollbars: true
                           });
                       }else{
                           var oLi=$('<li>TA暂时没有患者评价，去申请加号约TA~ </li>');
                           oLi.appendTo($('#Evaluate_list'));
                       }
                   }
                });
    }


    return{
        getDoctorMsg:getDoctorMsg,
        getEvaluate:getEvaluate
    }

});