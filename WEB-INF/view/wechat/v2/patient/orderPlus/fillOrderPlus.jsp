<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientQueryModel" %>
<%@ page import="java.util.List" %>
<%
    JdDoctorQueryModel doctorInfo = (JdDoctorQueryModel)request.getAttribute("doctorQueryModel");
    List<JdPatientQueryModel> contactsList = (List<JdPatientQueryModel>) request.getAttribute("contactsList");
    String address = (String)request.getAttribute("address");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.animation.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.frame.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.frame.android-holo.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.scroller.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.scroller.android-holo.css" rel="stylesheet">
    <jsp:include page="../../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap" id="addorder_wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>申请放号</h2>
        <div class="header_logo pa">
            <a onclick="toPersonal()" class="mine_center pa"></a>
        </div>
    </header>
    <!--header-->

    <!--doctor_msg-->
    <div class="doctor_msg clearfix">
        <div class="fl doctor_msg_header">
            <span style="background:url(<%=doctorInfo.getHeadPic()%>) center center no-repeat;background-size:cover;"></span>
        </div>
        <div class="fl doctor_msg_content">
            <p><%=doctorInfo.getName()%>丨</i><%=doctorInfo.getTitle()%><span class="bond">保证金:<b>￥20</b></span></p>

            <p><%=doctorInfo.getHospital()%></p>

            <p class="clearfix"><span class="dmc_adress fl">地址：</span><span class="dmc_address_c fl"><%=address%></span></p>
        </div>
    </div>
    <!--doctor_msg-->

    <!--content-->
    <div class="content fillorder_wrap">
        <ul class="list fillorder_list addpeople_list">
            <li class="clearfix pr addpeople" id="fillorderheight">
                <label class="fillorder_title fl">家庭联系人</label>
                <label class="fillorder_input fl clearfix" id="select_order">
                    <%
                        if (contactsList != null && contactsList.size() > 0) {
                            for (JdPatientQueryModel contact : contactsList) {
                    %>
                    <div class="fl order_people"
                         onclick="loadContact('<%=contact.getName()%>','<%=contact.getPhoneNumber()%>','<%=contact.getIdCard()%>')">
                        <%=contact.getName()%>
                    </div>
                    <%
                            }
                        }
                    %>
                </label>
                <span class="pa" id="addpeople" bol="true"></span>
            </li>
        </ul>

        <section class="fillorder">
            <ul class="list fillorder_list filllist_height">

                <li class="clearfix">
                    <label class="fillorder_title fl"><i class="must">*</i>姓名</label>
                    <label class="fillorder_input fl"><input type="text" placeholder="与患者证件一致" id="name"></label>
                </li>

                <li class="clearfix">
                    <label class="fillorder_title fl"><i class="must">*</i>手机号</label>
                    <label class="fillorder_input fl"><input type="text" placeholder="11位手机号码" id="phone"></label>
                </li>

                <li class="clearfix">
                    <label class="fillorder_title fl"><i class="must">*</i>身份证</label>
                    <label class="fillorder_input fl"><input type="text" placeholder="与患者证件一致" id="idCard" maxlength="18" onkeyup="idCardChange()"></label>
                </li>

                <li class="clearfix">
                    <label class="fillorder_title fl"><i class="must">*</i>年龄</label>
                    <label class="fillorder_input fl"><input type="text" placeholder="与患者证件一致" readonly id="age"></label>
                </li>

                <li class="clearfix">
                    <label class="fillorder_title fl"><i class="must">*</i>病情描述</label>
                    <label class="fillorder_input fl"><input type="text" placeholder="请输入病情描述" id="bqms"></label>
                </li>


                <li class="clearfix">
                    <label class="fillorder_title fl"><i class="must">*</i>预约时间</label>
                    <label class="fillorder_input fl addorder">
                        <input type="text" class="starttime" placeholder="开始时间" readonly id="order_starttime" value=""><span>至</span><input type="text" readonly class="endtime" placeholder="结束时间" id="order_endtime" value="">
                    </label>
                </li>

            </ul>
        </section>
        <div class="addorder_mush"><b class="addorder_active" id="addorder_mush"></b>我已经了解<span id="addknow">《橙医生申请放号须知》</span></div>
    </div>
    <!--content-->
    <div class="fixbtn" onclick="doSubmitInfo()">提交申请</div>
</div>
<!--wrap-->

<div class="mustknow_wrap" id="addorder_rules">
    <header class="closeheader pr">
        <a href="javascript:void(0)" class="pa close rules_close"></a>
        <h2>申请放号须知</h2>
    </header>
    <div class="roll_content">
        <p><i>1.</i><b>“申请放号”是橙医生团队推出的极速申请心脑血管专家号源服务。</b></p>
        <p><i>2.</i><b>用户提交加号申请时间段后，橙医生团队根据用户提交的信息，与医生沟通，医生调配个人时间接诊，满足用户预约名医的需求。</b></p>
        <p><i>3.</i><b>申请放号只能申请当天24小时后至14天内的号源。</b></p>
        <p><i>4.</i><b>为确保申请放号的真实性，橙医生团队将收取20元申请放号保证金，咨询结束后，登录橙医生完成评价，即可返还20元保证金。</b></p>
        <p><i>5.</i><b>如医生不能履约，橙医生会提前为您协调其它时间或其他医生，如医生爽约，除了全额退款，橙医生也将替医生赔偿您10元违约金。</b></p>
        <p><i>6.</i><b>申请放号成功，医生已经调配个人时间出诊并放出号源。如果用户没有预约该号源，将视为用户爽约，橙医生将扣除20元保证金。</b></p>
        <p><i>7.</i><b>如需开药、检查，请在医院另付挂号费。</b></p>
        <div class="iknow rules_close" id="addIknow">我知道了</div>
    </div>
</div>

</body>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.core.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.scroller.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.util.datetime.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.datetimebase.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.datetime.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.select.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.android-holo.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/i18n/mobiscroll.i18n.zh.js"></script>
<script>
    sendPageVisit(Page_Constant.FillOrderPlus);

    // 加号须知checkbox勾选
    $('#addorder_mush').on('click',function(ev){
        if ($(this).hasClass('addorder_active')) {
            $(this).removeClass('addorder_active');
        } else {
            $(this).addClass('addorder_active');
        }
    });
    // 加号须知显示/隐藏
    $('#addknow').on('click',function(ev){
        $('#addorder_wrap').css({'display':'none'});
        $('#addorder_rules').css({'display':'block'});
    });
    $('.rules_close').on('click',function(ev){
        $('#addorder_wrap').css({'display':'block'});
        $('#addorder_rules').css({'display':'none'});
    });
    // 日期相关
    function dateCompare(date1,date2){
        date1 = date1.replace(/\-/gi,"/");
        date2 = date2.replace(/\-/gi,"/");
        var time1 = new Date(date1).getTime();
        var time2 = new Date(date2).getTime();
        if(time1 > time2) {
            return "1";
        } else if(time1 == time2) {
            return "2";
        } else {
            return "3";
        }
    }
    //定义一个开始的年份
    var twoWeek = new Date();
    twoWeek.setTime(twoWeek.getTime()+(13*24*60*60*1000));
    var tomorrow = new Date();
    tomorrow.setTime(tomorrow.getTime()+(24*60*60*1000));
    $('#order_starttime').mobiscroll().date({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        setText: '完成',
        dateFormat: 'yy-mm-dd',
        minDate: tomorrow,
        maxDate: twoWeek,
        onMarkupReady: function(markup){
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        }
    });
    $('#order_endtime').mobiscroll().date({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        setText: '完成',
        dateFormat: 'yy-mm-dd',
        minDate: tomorrow,
        maxDate: twoWeek,
        onMarkupReady: function(markup){
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        }
    });
    /*判断家庭联系人的高度*/
    if ($('#select_order').height() <= 44) {
        $('#addpeople').css({'display': 'none'});
    }
    /*家庭联系人收起or展开*/
    $('#addpeople').on('click', function (ev) {
        if ($(this).attr('bol') == "true") {
            $('#fillorderheight').css({'height': 'auto'});
            $('#addpeople').addClass('addactive');
            $(this).attr('bol', 'false');
            return;
        }
        if ($(this).attr('bol') == "false") {
            $('#fillorderheight').css({'height': '0.88rem'});
            $('#addpeople').removeClass('addactive');
            $(this).attr('bol', 'true');
        }
    });
    //选中联系人后改变样式
    $('#select_order').on('click', '.order_people', function (ev) {
        $('.order_people').removeClass('order_people_active');
        $('.order_people').eq($(this).index()).addClass('order_people_active');
        ev.stopPropagation();
    });

    //选中联系人后加载信息
    function loadContact(name, phone, idCard) {
        if (name != "null") $("#name").val(name);
        else $("#name").val("");
        if (phone != "null") $("#phone").val(phone);
        else $("#phone").val("");
        if (idCard != "null") $("#idCard").val(idCard);
        else $("#idCard").val("");
        idCardChange();
    }
    var idCardFlag = false;
    function idCardChange() {
        var result = checkIdCard($.trim($('#idCard').val()));
        if(result) {
            idCardFlag = true;
            var ageGender = result.split(";");
            $("#age").val(ageGender[0]);
        } else {
            idCardFlag = false;
            $("#age").val("");
        }
    }
    var submitFlag = false;
    function doSubmitInfo(){
        if (!$('#addorder_mush').hasClass('addorder_active')) {
            layer.alert("请先了解加号须知并勾选", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        //判断用户名是否输入
        if (checknull('#name') == false) {
            layer.alert("请输入姓名", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#name').focus();
            });
            return;
        }
        //判断手机号是否输入
        if (checknull('#phone') == false) {
            layer.alert("请输入手机号", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#phone').focus();
            });
            return;
        }
        //校验手机号
        if (checkregular('#phone', '1') == false) {
            layer.alert("请输入正确的11位数手机号", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#phone').focus();
            });
            return;
        }
        //判断身份证号是否输入
        if (checknull('#idCard') == false) {
            layer.alert("请输入身份证号", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#idCard').focus();
            });
            return;
        }
        var vidCard = $("#idCard").val().trim();
        if(!idCardFlag && vidCard.length != 15 && vidCard.length != 18) {
            layer.alert("身份证号不正确", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#idCard').focus();
            });
            return;
        }
        //判断病情是否输入
        if (checknull('#bqms') == false) {
            layer.alert("请输入病情描述", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#bqms').focus();
            });
            return;
        }
        //记录第一个时间
        var nowSelect=$('#order_starttime').val();
        //记录第二个时间
        var nowSelect2=$('#order_endtime').val();
        //预约时间是否输入
        if (!nowSelect || !nowSelect2) {
            layer.alert("请选择预约时间", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if (dateCompare(nowSelect,nowSelect2)=="1") {
            layer.alert("开始时间不能大于结束时间", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if(submitFlag)
            return;
        submitFlag = true;
        var vname = $("#name").val().trim();
        var vphone = $("#phone").val().trim();
        var vbqms = $("#bqms").val().trim();
        var data = {'doctorId': "<%=doctorInfo.getUuid().toString()%>", 'name': vname, 'idCard': vidCard, 'phoneNumber': vphone,
             'sickDescription': vbqms, 'orderDateStart': nowSelect, 'orderDateEnd': nowSelect2 };
        sendRequest("saveOrderPlus.htm", "POST", data, function (result) {
            var info = result.split(";");
            if(info.length == 1) {
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
                submitFlag = false;
            } else {
                goto("toPayOrderPlus.htm?orderPlusId="+info[1]);
            }
        }, function () {
            submitFlag = false;
        });
    }
</script>
</html>
