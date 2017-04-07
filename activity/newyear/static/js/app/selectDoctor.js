
define(function(require){
    var $=require('jquery');
    var layer=require('layer');


    var doctorId=null;


    var importDoctor=function(){

        //点击输入或者选择医生
        $('#selectDoctor').on('click',function(ev){
            if (  $.trim($('#selectDoctor').val()).length==0 ){
                $('#search_wrap').css({'display':'block'});

                if($('#recomend_doctor li').length==0){
                    getPopularDoctor();
                };

            }else {
                var content=$('#selectDoctor').val();
                $('#search_wrap').css({'display':'block'});
                $('#select_doctor_search').val(content);
            }
        });


        //点击确定或者取消
        $('#confirm_search').on('click',function(){
            if ($(this).attr('state')=="cancel"){
                $('#search_wrap').css({'display':'none'});
            }else{

                getResult();


            }
        });

        //获取人气医生
        function getPopularDoctor(){

            var s=
            {
                resultObject:[
                    {name: '胡大一', jdDoctorId: 'a262bb86-14e0-4922-8b9a-95bf721a5c52'},
                    {name: '张京梅', jdDoctorId: 'bb55ecc9-bcfa-4732-ad0e-9f553246cc55'},
                    {name: '任艺虹', jdDoctorId: '594347c6-48ae-419c-961a-30e22b536443'},
                    {name: '董吁钢', jdDoctorId: '8f3e7b65-06f7-41e7-9615-d874c76973ed'},
                    {name: '刘小慧', jdDoctorId: '835a8621-840d-4b55-87ec-a7558f5ce0d0'},
                    {name: '张纯', jdDoctorId: '	578c8a6d-3dd0-4b32-b5cb-2e034422bd85'},
                    {name: '郭军', jdDoctorId: '7501048e-22e0-42f3-9d80-6995409dc5f0'},
                    {name: '袁基华', jdDoctorId: '66a3d842-1f2c-4623-8daf-a13103eb4e63'},
                    {name: '侯玉清', jdDoctorId: '4f2702ee-83a0-452a-be9b-02604efc3f6d'},
                    {name: '黄铮', jdDoctorId: '1180c7db-98e1-4333-b3ab-a01d781a0197'},
                    {name: '苏俊武', jdDoctorId: 'ee0bcbc1-4361-49ca-b9cc-73f7a7283575'},
                    {name: '陶波', jdDoctorId: '1a76625e-fb19-412e-b472-0888a75b9783'},
                    {name: '姚晓黎', jdDoctorId: 'f50efd61-8efe-404d-b9fd-625688155627'},
                    {name: '宋艳东', jdDoctorId: '61aa7503-14cd-40ab-9be7-4c7628dfd27e'},
                    {name: '倪新海', jdDoctorId: 'c613e2bc-3ec6-414c-be60-ac9a6f86c4f3'},
                    {name: '周炯', jdDoctorId: '7d5e499b-1070-41ce-b071-d64e3729b229'},
                    {name: '胡荣', jdDoctorId: '500188a8-5984-4fa7-ae6a-c473a753f728'},
                    {name: '吕强', jdDoctorId: 'ffa1443c-5250-4169-9796-c4b702726354'},
                    {name: '高玉龙', jdDoctorId: '4cf9f1d5-293d-44ca-95e5-274c5a255b63'},
                    {name: '赵战勇', jdDoctorId: '678b0375-c837-4962-a53d-a23ba0c5cdf6'},
                    {name: '代成波', jdDoctorId: 'ac1aea31-0a7a-406b-9505-5ca0e7d7b5ca'},
                    {name: '黄莉', jdDoctorId: '	781963d4-e1ad-454a-9172-71e61a386641'},
                    {name: '迟东升', jdDoctorId: '9f9d98d1-06d6-4b57-803e-69743a8e089c'},
                    {name: '曹丰', jdDoctorId: 'ce26ad2e-1cf4-4737-a08e-95ae052ed516'},
                    {name: '白凯', jdDoctorId: '91e515d8-590e-47bf-99e2-146b8e486b32'},
                    {name: '齐向前', jdDoctorId: '95b059eb-f301-4f45-af72-2d9ce02552cd'},
                    {name: '刘英华', jdDoctorId: 'b6c3b910-a5ac-4cb2-a288-2eda8d32257a'},
                    {name: '迟东升', jdDoctorId: '9f7083a3-ee3a-470b-8129-622c5821b2c3'},
                    {name: '侯允天', jdDoctorId: 'ba65b8e6-97fa-4f6e-9801-d7fa971c1ee7'},
                    {name: '刘爱华', jdDoctorId: 'c0b34b82-7fac-4591-9b14-e3cf53d2d6bf'},
                    {name: '吴杏', jdDoctorId: '	d6d13f3a-1ffe-4883-81ed-701c2ebe6908'},
                    {name: '罗彤', jdDoctorId: '	c5aace3c-2dc8-46e9-9eed-6751f3cd5a4c'},
                    {name: '钱家琦', jdDoctorId: '46501ea7-331c-4c33-8dee-df6d2bbd4c2d'},
                    {name: '梁远红', jdDoctorId: '3cffcbb6-b200-4ae9-bcb6-f2497098222d'},
                    {name: '乌汉东', jdDoctorId: '44241e5f-cbd6-40f5-b750-bed722b1bb86'},
                    {name: '席玉胜', jdDoctorId: '33bc3ec5-b50f-4b36-ab92-c135cc729cdd'}
                ]
            };

            for (var i=0;i<s.resultObject.length;i++){


                var content= s.resultObject[i].name;

                var id= s.resultObject[i].jdDoctorId;
                var oLi=$('<li class="fl"><span id='+id+'>'+content+'</span></li>');
                oLi.appendTo($('#recomend_doctor'));
            }





            //$.ajax({
            //    type:"get",
            //    url:"/wxapi/activity/newyear2016/popularDoctor",
            //    data: {'num ': '12'},
            //    dataType:'json',
            //    asyne:false,
            //    success:function(s){
            //
            //        if (s.result==0){
            //            for (var i=0;i<s.resultObject.length;i++){
            //                var content= s.resultObject[i].name;
            //                if(content == 'null' || content ==null){
            //                    continue
            //                }
            //                var id= s.resultObject[i].jdDoctorId;
            //                var oLi=$('<li class="fl"><span id='+id+'>'+content+'</span></li>');
            //                oLi.appendTo($('#recomend_doctor'));
            //            }
            //        }else{
            //
            //        }
            //    }
            // });


        };

        //搜索结果
        function getResult(){
            var search_content=$.trim($('#select_doctor_search').val());

            $('#recommend').css({'display':'none'});
            $('#result').css({'display':'block'});
      
            $.ajax({
                type:"POST",
                url:"/wxapi/activity/newyear2016/selectDoctor",
                data:{name:search_content},
                dataType:'json',
                asyne:false,
                success:function(s){

                    if (s.result==0){

                        $('#select_result').html('');

                        for (var i=0;i<s.resultObject.length;i++){
                            var content= s.resultObject[i].name;
                            if(content == 'null' || content ==null){
                                continue
                            }
                            var id= s.resultObject[i].id;
                            var oLi=$('<li class="fl"><span id='+id+'>'+content+'</span></li>');
                            oLi.appendTo($('#select_result'));
                        }

                        $('#select_result').off();

                        $('#select_result').on('click','li',function(){
                            var select_content=$(this).find('span').html();
                            doctorId=$(this).find('span').attr('id');
                            $('#select_doctor_search').val(select_content);
                            $('#select_doctor_search').val(select_content);
                            $('#confirm_search').html('搜索');
                            $('#selectDoctor').val(select_content);
                            $('#search_wrap').css({'display':'none'});
                            $('#confirm_search').attr('state','confirm');
                        });
                    }else{

                    }
                }
             });



        };



        //点击确定发送
        $('#confirm_send').on('click',function(ev){

            if ( $.trim($('#selectDoctor').val()).length==0 ){
                layer.alert('请输入或选择医生', {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });
                return false;
            }else{
                window.sessionStorage.setItem('doctorname',$.trim($('#selectDoctor').val()));
                var cardImg1=window.sessionStorage.getItem('bgsrc');
                var cardImg2=window.sessionStorage.getItem('wishSrc');
                var jdDoctorId=doctorId;
                $.ajax({
                    type:"POST",
                    asyne:false,
                    url:"/wxapi/activity/newyear2016/saveGreetCardAndSendDoctor",
                    data: {'jdDoctorId':jdDoctorId,'cardImg1':cardImg1,'cardImg2':cardImg2},
                    dataType:'json',
                    success:function(s){
                        if (s.result==0){
                            $('#selectDoctor').val('');
                            window.location.href="acceptprize.html?id="+s.resultObject.id+"&jdDoctorId="+jdDoctorId;
                        }else{

                        }
                    }
                 });

            }
        });

        //输入的时候
        $('#select_doctor_search').on('keyup',function(){
            if ($.trim($('#select_doctor_search').val()).length==0){
                $('#result').css({'display':'none'});
                $('#recommend').css({'display':'block'});
            }else{
                getResult();
            }
        });

        //判断是否有输入
        $('#select_doctor_search').on('input',function(ev){
            if (  $.trim($('#select_doctor_search').val()).length ==0){
                 $('#confirm_search').html('取消');
                 $('#confirm_search').attr('state','cancel');
                 $('#result').css({'display':'none'});
                 $('#recommend').css({'display':'block'});
            }else {
		$('#confirm_search').html('搜索');
                $('#confirm_search').attr('state','confirm');
            }
        });



        //选择人气医生
        $('#recomend_doctor').on('click','li',function(){
            var content=$(this).find('span').html();
            var id=$(this).find('span').attr('id');
            doctorId=id;
            $('#select_doctor_search').val(content);
            $('#confirm_search').html('搜索');

            $('#selectDoctor').val(content);
            $('#search_wrap').css({'display':'none'});
            $('#confirm_search').attr('state','confirm');




        });



    };







    var getSlectBg=function(){

        var attrId=window.sessionStorage.getItem('attrId');
        var bgsrc=window.sessionStorage.getItem('bgsrc');
        var wishSrc=window.sessionStorage.getItem('wishSrc');


        if (!attrId){
            layer.alert('请先选择背景图和祝福语', {
                title: false,
                closeBtn: false
            }, function(){
                layer.closeAll();
                window.location.href="index.html";
            });
            return false;
        };


        $('.showcard').attr('attr',attrId);
        $('.show_backgroundimage').attr('src',bgsrc);
        $('.show_wish_images').attr('src',wishSrc);


    };




    return {
        getSlectBg:getSlectBg,
        importDoctor:importDoctor
    }





});