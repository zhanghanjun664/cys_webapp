define(function(require){

    var $=require('jquery');

    var mobiscrollcore=require('mobiscrollcore');

    var mobiscrollframe=require('mobiscrollframe');

    var mobiscrollscroller=require('mobiscrollscroller');

    var mobiscrollselect=require('mobiscrollselect');

    var mobiscroll=require('mobiscroll');


    var layer=require('layer');


    var errorMsg={
        name:"请输入您的姓名！",
        area:"请选择医院所在地区！",
        hospitalNam:"请选择医院！",
        title:"请选择职称！",
        department:'请选择科室！'
    };

    var oldId=null;




    function getHospitalList(id){

        if (oldId==id){

            return false;
        }

        $('#hospital-name_dummy').val('');

        $.ajax({
            async: true,
            url: "/weixin/activity/getHospitalByDistrictId.htm",
            data: {'districtId': id},
            dataType: 'json',
            success: function (s) {

                if (s.result == 0) {

                    //hospital-name

                    var obj = '<option selected disabled></option>';

                    for (var i = 0; i < s.resultObject.length; i++) {
                        obj += '<option value=' + s.resultObject[i].uuid + '>' + s.resultObject[i].name + '</option>';
                    }
                    $('#hospital-name').html(obj);
                    oldId=id;

                }
            }


        });


    };

    //Ajax 同步请求获得城市地区
    function getArea(){

        $.ajax({
            async:false,
            url:'/weixin/activity/getDistrice.htm',
            dataType:'json',
            success:function(s){
                if (s.result == 0){
                    var obj='<option selected disabled></option>';

                    for (var i= 0;i<s.resultObject.length;i++){
                        obj+='<option value='+ s.resultObject[i].uuid+'>'+s.resultObject[i].name+'</option>';
                    }
                    $('#area').html(obj);
                }
            }

        });


    };

    //Ajax 同步请求职称
    function getTitle(){
        $.ajax({
            async:false,
            url:'/weixin/activity/getTitle.htm',
            dataType:'json',
            success:function(s){
                if (s.result == 0){
                    var obj='<option selected disabled></option>';

                    for (var i= 0;i<s.resultObject.length;i++){
                        obj+='<option value='+ s.resultObject[i].uuid+'>'+s.resultObject[i].name+'</option>';
                    }
                    $('#title').html(obj);
                }
            }

        });
    };


    //Ajax 同步请求科室
    function getDepartment(){

        $.ajax({
            async:false,
            url:'/weixin/activity/getDepartments.htm',
            dataType:'json',
            success:function(s){
                if (s.result == 0){
                    var obj='<option selected disabled></option>';

                    for (var i= 0;i<s.resultObject.length;i++){
                        obj+='<option value='+ s.resultObject[i].uuid+'>'+s.resultObject[i].name+'</option>';
                    }
                    $('#department').html(obj);
                }
            }

        });


    }





    var selectData=function(){

        getArea();
        getTitle();
        getDepartment();

        // 医院所在区域
        $('#area').mobiscroll().select({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            label: 'City',
            group: {
                groupWheel: true,
                header: false,
                clustered: true
            },
            placeholder: '请选择所在地区',
            groupLabel: 'Country',
            fixedWidth: [100, 170],
            setText: '完成',
            onMarkupReady: function(markup){
                $('.dwbc', markup).insertBefore($('.dwcc', markup));
            },
            onSelect: function(valueText, inst){


                getHospitalList( $('#area').val() );


                //var group = $('#area option[value="'+ inst.getVal() +'"]').parent().attr('label');
                $('#area_dummy').val( valueText);

            }
        });


        //医院列表
        $('#hospital-name').mobiscroll().select({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            setText: '完成',
            placeholder: '请选择医院',
            onMarkupReady: function (markup) {
                $('.dwbc', markup).insertBefore($('.dwcc', markup));

            },
            onSelect: function (valueText, inst) {

                if (valueText=="请选择医院所在地区"){
                    $('#hospital-name_dummy').val("");
                }else{
                    $('#hospital-name_dummy').val(valueText);
                }
            }
        });

        //职称
        $('#title').mobiscroll().select({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            setText: '完成',
            placeholder: '请选择职称',
            onMarkupReady: function (markup) {
                $('.dwbc', markup).insertBefore($('.dwcc', markup));
            },
            onSelect: function (valueText, inst) {
                $('#title_dummy').val(valueText);
            }
        });

        //科室
        $('#department').mobiscroll().select({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            setText: '完成',
            placeholder: '请选择科室',
            onMarkupReady: function (markup) {
                $('.dwbc', markup).insertBefore($('.dwcc', markup));
            },
            onSelect: function (valueText, inst) {
                $('#department_dummy').val(valueText);
            }
        });
    };

    var submitData=function(){

        $('#personal_next').on('click',function(ev){

            if ($.trim( $('#personalName').val()).length==0 ){

                layer.alert(errorMsg.name, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                    $('#personalName').focus();
                });

                return false;
            };


            if ($.trim( $('#area_dummy').val()).length==0 ){

                layer.alert(errorMsg.area, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();

                });

                return false;
            };


            if ($.trim( $('#hospital-name_dummy').val()).length==0 ){

                layer.alert(errorMsg.hospitalNam, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();

                });

                return false;
            };


            if ($.trim( $('#title_dummy').val()).length==0 ){

                layer.alert(errorMsg.title, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });

                return false;
            };

            if ($.trim( $('#department_dummy').val()).length==0 ){

                layer.alert(errorMsg.department, {
                    title: false,
                    closeBtn: false
                }, function(){
                    layer.closeAll();
                });

                return false;
            };

            var phoneNumber = $.trim($('#phoneNumber').val());
            var name = $.trim($('#personalName').val());
            var districtId = $('#area').val();
            var hospitalId = $('#hospital-name').val();
            var titleId = $('#title').val();
            var departmentId = $('#department').val();
            var password = $.trim($('#password').val());
            var certificateNumber = '';
            var data = {"phoneNumber": phoneNumber,"name":name,password:password,
                "districtId":districtId,"hospitalId":hospitalId,"titleId":titleId,"departmentId":departmentId,"certificateNumber":certificateNumber};
            var goToResister = false;
            $.ajax({
                url: "/weixin/activity/doctorActivityRegister.htm",
                data:data,
                type:"POST",
                async:false,
                success: function(msg){
                    var msgObj = JSON.parse(msg)
                    if(msgObj.result != "0") {
                        layer.alert(msgObj.description, {
                            title: false,
                            closeBtn: false
                        }, function(){
                            layer.closeAll();
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
            if(goToResister){
                window.location.href = "getoActivityHtm.htm?time=20160101&htmlurl=activity/academic/choiceQuestion";
            }

        });
    };




    return{
        selectData:selectData,
        submitData:submitData
    }















});