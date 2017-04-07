define(function(require){

    var $=require('jquery');


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
    var jdDoctorId=GetQueryString('id');

    window.sessionStorage.setItem('id',jdDoctorId);

    //得到数量
    var getCardNumber=function(){

        $.ajax({
            type:"get",
            url:"/wxapi/activity/newyear2016/doctorCardList",
            asyne:false,
            data:{'jdDoctorId':jdDoctorId},
            dataType:'json',
            success:function(s){
                if (s.result==0){
                    $('#cardnumber').html(s.resultObject.count);
                };
            }
        });

        //$('#cardnumber').html('15555');
    };




    var goToDoctorReceived = function (){
        $("#doctorReceived").on('click',function(){
            var id = window.sessionStorage.getItem('id');
            window.location.href = "doctorReceived.html?id="+id;
        });
    }


    return {
        getCardNumber:getCardNumber,goToDoctorReceived:goToDoctorReceived

    }


});