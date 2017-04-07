define(function(require){


    //$('')

    var $=require('jquery');

    var layer=require('layer');

    var timer=null;
    var timeNum=60;

    var errorMsg = {
        mobile: '请输入正确的11位数手机号！',
        pass:'请输入正确的密码！',
        verifyCode: '请输入正确的验证码！'
    };

    var reg = {
        mobile: /^1[3-9][0-9]{9}$/,
        verifyCode: /abcd/,
        pass:/^['a-z0-9A-Z']{6,20}/
    };


    var registerNext=function(){

        $('#registerNext').on('click',function(){

            var mobilePhone=$('#mobilePhone');
            var password=$('#passWord');
            var verCode=$('#verCode');


            if ($.trim(mobilePhone.val()).length==0  ){

                layer.alert(errorMsg.mobile, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                    mobilePhone.focus();
                });

                return false;
            };


            if (  !reg.mobile.test($.trim(mobilePhone.val()))  ){
                layer.alert(errorMsg.mobile, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                    mobilePhone.focus();
                });
                return false;
            }


            if ($.trim(password.val()).length==0  ){
                layer.alert(errorMsg.pass, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                    password.focus();
                });
                return false;
            };


            if (  !reg.pass.test($.trim(password.val()))  ){
                layer.alert(errorMsg.pass, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                    password.focus();
                });
                return false;
            }


            if ($.trim(verCode.val()).length==0  ){

                layer.alert(errorMsg.verifyCode, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                    verCode.focus();
                });

                return false;
            };
            var phoneNumber = mobilePhone.val();
            var data ={"phoneNumber":phoneNumber,"code":verCode.val()};
            var passwordStr = hex_md5(password.val())
            $.ajax({
                url: "/weixin/doctor/verifyCode.htm",
                type:"POST",
                data:data,
                success: function(msg){
                    if(msg == '') {
                        window.location.href = "checkdoctorActivityCode.htm?phoneNumber="+phoneNumber+"&password="+passwordStr;
                    } else{
                        alert(msg);
                    }
                },
                error:function(){
                    alert("系统错误");
                }
            });

        });


    };


    var getCode= function () {
        $('#getCode').attr('bol','true');

        $('#getCode').on('click',function(ev){

            var mobilePhone=$('#mobilePhone');

            if ($.trim(mobilePhone.val()).length==0  ){

                layer.alert(errorMsg.mobile, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                    mobilePhone.focus();
                });

                return false;
            };


            if (  !reg.mobile.test($.trim(mobilePhone.val()))  ){
                layer.alert(errorMsg.mobile, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                    mobilePhone.focus();
                });
                return false;
            };
            var goToResister = false;
            $.ajax({
                url: "/weixin/activity/getActivityCode.htm?phoneNumber="+mobilePhone.val(),
                async: false,
                success: function(msg){
                    if(msg != "") {
                        alert(msg);
                        goToResister = false;
                    } else{
                        goToResister = true;
                    }
                },
                error:function(){
                    goToResister = false;
                }
            });

            if(!goToResister){
                return false;
            }

            if ($(this).attr('bol')=='false'){
                return false;
            };

            $('#getCode').attr('bol','false');
            $('#getCode').attr('background','#fd9627');

            clearInterval(timer);

            timer=setInterval(function () {

                var countDown=timeNum--;
                $('#getCode').html(countDown);

                if (countDown==0){
                    clearInterval(timer);
                    timeNum=60;
                    $('#getCode').html('获取验证码');
                    $('#getCode').attr('bol','true');
                    $('#getCode').attr('background','#fd9627');
                }


            },1000);





        });



    };



    return{
        registerNext:registerNext,
        getCode:getCode
    }





});