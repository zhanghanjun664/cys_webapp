/*正则表达式*/
var regular={
    phone:/^[1][3587]\d{9}$/,
    code:/^[0-9]{4}$/
}


/*错误信息*/
var message={
     phoneError:"请输入正确的手机号码",
     codeError:"请输入正确的验证码",
     phoneNull:"请输入手机号码",
     codeNull:"请输入验证码",
     codeSuccessMsg:"有橙医生就有暖冬，感谢参与活动，注意查收红包或现金券奖励"
}


var call={

    timer:null,

    countDownTime:60,

    //执行
    on:function(){
        //this.clickArea();
        this.getCode();
        this.submitData();
    },

    //增加点击的面积
    clickArea:function(){
        $('#clickphone').on('click',function(){
           $('#phone').focus();
        });

        $('#clickcode').on('click',function(){
           $('#code').focus();
        });
    },
    //倒计时
    countDown:function(){
        var _this=this;

        //清除定时器
        clearInterval(this.timer);

        //codeDown

        $('#getcode').addClass('codeDown');

        $('#getcode').attr('clickBol','false');

        _this.countDownTime--;

        $('#getcode').html('60s');


        //设置定时器
        this.timer=setInterval(function(){

         var nowTime =  _this.countDownTime--;




         $('#getcode').html(nowTime+"s");

            if (nowTime==0){
                clearInterval(_this.timer);
                $('#getcode').removeClass('codeDown');
                $('#getcode').attr('clickBol','true');
                _this.countDownTime=60;
                $('#getcode').html('获取验证码');
            }



        },1000);

    },

    //点击验证码
    getCode:function(){

        var _this=this;

        $('#getcode').on('click',function(){

            if ($(this).attr('clickBol')=="false"){
                return false;
            }


            var phone=$('#phone').val().trim();

            //判断手机号码是否为空
            if ( phone.length==0 ){

                var msg = new Yalert({
                    title:message.phoneNull,
                    type:'ok',
                    time:'5000',
                    leftfn:function(){
                        $('#phone').focus();
                    }
                });

                $('#phone').focus();
                return false;
            };

            //判断手机号码是否输入正确
            if (!regular.phone.test(phone)){

                var msg = new Yalert({
                    title:message.phoneError,
                    type:'ok',
                    time:'5000',
                    leftfn:function(){
                        $('#phone').focus();
                    }
                });

                return false;
            };
            $.ajax({
                url: "/weixin/activity/getActivityCode.htm?phoneNumber="+phone,
                success: function(msg){
                    if(msg) {
                        var msgAlert = new Yalert({
                            title:msg,
                            type:'ok',
                            time:'5000'
                        });
                        goToResister = false;
                    } else{
                        goToResister = true;
                    }
                },
                error:function(){
                    goToResister = false;
                }
            });

            //倒计时
            _this.countDown();


        });

    },

    submitData:function(){

        //点击提交
        $('#submit').on('click',function(ev){

            var phone=$('#phone').val().trim();
            var code=$('#code').val().trim();

            //判断手机号码是否为空
            if ( phone.length==0 ){

                var msg = new Yalert({
                    title:message.phoneNull,
                    type:'ok',
                    time:'5000',
                    leftfn:function(){
                        $('#phone').focus();
                    }
                });
                return false;
            };


            //判断手机号码是否输入正确
            if (!regular.phone.test(phone)){

                var msg = new Yalert({
                    title:message.phoneError,
                    type:'ok',
                    time:'5000',
                    leftfn:function(){
                        $('#phone').focus();
                    }
                });

                return false;
            };

            //判断是否输入验证码
            if ( code.length==0 ){

                var msg = new Yalert({
                    title:message.codeNull,
                    type:'ok',
                    time:'5000',
                    leftfn:function(){
                        $('#code').focus();
                    }
                });
                return false;
            };

            //判断验证是否输入正确
            if (!regular.code.test(code)){

                var msg = new Yalert({
                    title:message.codeError,
                    type:'ok',
                    time:'5000',
                    leftfn:function(){
                        $('#code').focus();
                    }
                });
                return false;
            };
            var data = {"phoneNumber": phone, "code": code, "description":"2015圣诞节活动"};
            var goToResister = false;
            $.ajax({
                url: "/weixin/patient/verifyCode.htm",
                data:data,
                type:"POST",
                async: false,
                success: function(msg){
                    if(msg == ''){
                        var data = {"phoneNumber": phone, "code": code, "description":"2015圣诞节活动"};
                        $.ajax({
                            url: "/weixin/activity/christmas.htm",
                            data:data,
                            type:"POST",
                            async: false,
                            success: function(msgbak){

                                var json_msg = JSON.parse(msgbak);

                                if(json_msg.result != "0"){
                                    var msgAlert = new Yalert({
                                        title:json_msg.description,
                                        type:'ok',
                                        time:'20000'
                                    });
                                }else if(json_msg.result == "0"){
                                    var msgAlert = new Yalert({
                                        title:message.codeSuccessMsg,
                                        type:'ok',
                                        time:'20000',
                                        leftfn:function(){
                                            window.location.href = "/weixin/patient/main.htm";
                                        }
                                    });
                                }
                            },
                            error:function(msgbak){
                                var json_msg = JSON.parse(msgbak);
                                var msgAlert = new Yalert({
                                    title:json_msg.description,
                                    type:'注册失败',
                                    time:'20000'
                                });
                            }
                        });
                    }else{
                        goToResister = false;
                        var msgAlert = new Yalert({
                            title:msg,
                            type:'ok',
                            time:'20000',
                            leftfn:function(){
                                $('#code').focus();
                            }
                        });
                    }
                },
                error:function(){
                    var msgAler = new Yalert({
                        title:msg,
                        type:'ok',
                        time:'5000',
                        leftfn:function(){
                            $('#code').focus();
                        }
                    });
                    goToResister = false;
                }
            });
            //alert('提交成功');

        });
    }
}

$(function(){
    FastClick.attach(document.body);
    call.on();
});

