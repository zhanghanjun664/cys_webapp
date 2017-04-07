define(function(require){

    var $=require('jquery');
    var layer=require('layer');
    var wx=require('wechat');
    var wxconfig=null;
    var timer=null;
    var timeNum=60;


    function GetQueryString(name){
        var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if(r!=null) {
            return unescape(r[2]);
        }else{
            return null;
        }
    };
    var jdDoctorIdUrl=GetQueryString('jdDoctorId');
    var cardId=GetQueryString('id');




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





    //点击抽奖
    var registerNext=function(){

    $('#accept').on('click',function(){


        var mobilePhone=$('#phone');
        var verCode=$('#code');

        //判断手机号码是否为空
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
        //判断手机号码是否输入正确
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
        //判断验证码是否输入
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


        //抽奖
        $.ajax({
            type:"get",
            url:"/wxapi/activity/newyear2016/luckDraw",
            data:{"phoneNumber":$.trim(mobilePhone.val()),"code":$.trim(verCode.val())},
            dataType:'json',
            beforeSend:function(){
                $('#accept').attr('bol','false');
            },
            success:function(s){
                if (s.result==0){
                    $('#Award_information').html('<div class="Award_message">'+s.description+'</div>');
                }else{
                    layer.alert(s.description, {
                        title: false,
                        closeBtn: false
                    }, function(){
                        layer.closeAll();
                    });
                }
            },
            complete:function(){
                $('#accept').attr('bol','true');
            }
         });





    });


    };


    //点击获取验证码
    var getCode= function () {
        $('#getCode').attr('bol','true');
        $('#getCode').on('click',function(ev){
            var mobilePhone=$('#phone');
            //判断手机号码是否输入
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

            //判断手机号码是否正确
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


            //判断是否可以抽奖

            $.ajax({
                    type:"get",
                    url:"/wxapi/activity/newyear2016/checkUserHasWinning",
                    data:{'phone':$.trim(mobilePhone.val())},
                    dataType:'json',
                    success:function(s){

                        if (s.result==0){


                            //判断60秒内是否发送过短信
                                if ($(this).attr('bol')=='false'){
                                    return false;
                                };

                            // 获取验证码
                            $.ajax({
                                type:"get",
                                url:"/wxapi/activity/newyear2016/getActivityVerifyCode",
                                dataType:'json',
                                data:{'phoneNumber':$.trim(mobilePhone.val())},
                                asyne:false,
                                success:function(s){

                                    if (s.result==0){
                                        $('#getCode').attr('bol','false');
                                        clearInterval(timer);
                                        timer=setInterval(function () {
                                            var countDown=timeNum--;
                                            $('#getCode').html(countDown);

                                            if (countDown==0){
                                                clearInterval(timer);
                                                timeNum=60;
                                                $('#getCode').html('获取验证码');
                                                $('#getCode').attr('bol','true');
                                            }
                                        },1000);
                                    }else{

                                        layer.alert("你已获取验证码，请勿重复操作", {
                                            title: false,
                                            closeBtn: false
                                        }, function(){
                                            layer.closeAll();
                                            mobilePhone.focus();
                                        });
                                    }
                                }
                             });
                        }else{
                            layer.alert(s.description, {
                                title: false,
                                closeBtn: false
                            }, function(){
                                layer.closeAll();
                            });


                        }
                    }
             });
        });
    };

    var getSendDoctorName=function(){
        var name=window.sessionStorage.getItem('doctorname');
        $('#getName').html(name+'医生将会收到您的祝福');
    };


    var share=function(){



        $('#shareCard').on('click',function(){
            if ($('.share_wrap').length>0){
                return false;
            };
            var oWrap=$('<div class="share_wrap"><div class="share_marked_words"></div></div>');
            oWrap.appendTo($('body'));

            oWrap.on('click',function(){
                oWrap.remove();
            });
        });
    };



    function strToJson(str){
        var json = eval('(' + str + ')');
        return json;
    }

    var getAppId=function(){

        wxconfig=null;
        $.ajax({
            type:"get",
            url:"/wxapi/activity/newyear2016/wxPatientConfig",
            data:{url:"http://m.chengyisheng.com.cn/activity/newyear/view/acceptprize.html?id="+cardId+"&jdDoctorId="+jdDoctorIdUrl},
            asyne:false,
            dataType:'json',
            success:function(s){
                if (s.result==0){
                    wxconfig=s.resultObject;
                    //wxconfig=strToJson(s.resultObject);
                    weChatShare();
                }
            }
        });





    };




    function weChatShare(){

        if(wxconfig.appId != null && wxconfig.appId != undefined && wxconfig.appId != ''){


        wx.config({
            debug: false,
            appId: wxconfig.appId,
            timestamp: wxconfig.timestamp,
            nonceStr: wxconfig.nonceStr,
            signature: wxconfig.signature,
            jsApiList: ['checkJsApi', 'onMenuShareTimeline', 'onMenuShareAppMessage']
        });
        wx.ready(function () {
            wx.checkJsApi({
                jsApiList: ['onMenuShareTimeline', 'onMenuShareAppMessage'],
                success: function (res) {
                    if (!res.checkResult.onMenuShareTimeline || !res.checkResult.onMenuShareAppMessage) {
                        var msg = '您的微信版本不支持分享接口，请升级后再分享，谢谢支持！';
                        layer.alert(msg, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                        });
                    }
                }
            });
            wx.onMenuShareTimeline({
                title: '我在橙医生送了贺卡给名医，拿到了红包，你也来吧！',
                desc:'送贺卡给名医，红包大奖等你拿！',
                link: 'http://m.chengyisheng.com.cn/activity/newyear/view/invite.html?id='+cardId+'&jdDoctorId='+jdDoctorIdUrl,
                imgUrl: 'http://m.chengyisheng.com.cn/activity/newyear/static/images/patient200.jpg',
                success: function () {
                    var msg="分享成功";
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                }
            });
            wx.onMenuShareAppMessage({
                title: '我在橙医生送了贺卡给名医，拿到了红包，你也来吧！',
                desc:'送贺卡给名医，红包大奖等你拿！',
                link: 'http://m.chengyisheng.com.cn/activity/newyear/view/invite.html?id='+cardId+'&jdDoctorId='+jdDoctorIdUrl,
                imgUrl: 'http://m.chengyisheng.com.cn/activity/newyear/static/images/patient200.jpg',
                type: 'link',
                success: function () {
                    var msg="分享成功";
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                }
            });
        });
        }
    };


    var checkPrize=function(){

        $.ajax({
            type:"get",
            url:"/wxapi/activity/newyear2016/checkUserRedPack",
            asyne:false,
            dataType:'json',
            success:function(s){
                if (s.result!='0'){
                    $('.prize_bg').addClass('prize_bg2');
                }else {
                    $('.prize_bg').removeClass('prize_bg2');
                    $('#Award_information').html('<div class="Award_message">'+s.description+'</div>');
                }
            }
        });


    }



    return{
        registerNext:registerNext,
        getCode:getCode,
        getSendDoctorName:getSendDoctorName,
        share:share,
        getAppId:getAppId,
        checkPrize:checkPrize

    }


});
