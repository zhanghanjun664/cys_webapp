<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%
    String client = (String)request.getSession().getAttribute(WebConstants.SESSION_CLIENT_TYPE);
	boolean isReqFromApp = true;
	if (client == null || !client.equals(WebConstants.SESSION_CLIENT_APP)){
	    isReqFromApp = false;
	}
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <% if (isReqFromApp){ %>
            <title>安排出诊</title>
    <% } %>
    <jsp:include page="../include/doctor_head.jsp"/>

</head>
<body>
<!-- topbar start -->
<!--  对于从app过来的请求，不显示页面的header -->
<% if (!isReqFromApp) { %>
<header class="fixed topbar">
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit">出诊安排</h3>
</header>
<% } %> 

<!-- topbar end --> 
<!-- visit arrange start -->


<div class="main visit-arrange" <% if (isReqFromApp){ %> style="padding-top:0px;" <% } %>>
    <div class="grid mt-10 form">
        <p>
            <label for="addr">地址</label>
            <input type="text" name="addr" id="addr" class="add-addr" onclick="addrClick(this)" placeholder="请先添加出诊地址" readonly/>
        </p>
        <p>
            <label for="fee">诊金</label>
            <input type="text" name="fee" id="fee" class="add-fee" onclick="feeClick(this)" placeholder="请先添加出诊金额" readonly/>
        </p>
        <p>
            <label for="discount" class="patron_fee">老患者折扣</label>
            <input type="text" name="discount" id="discount" placeholder="请先选择折扣" readonly />
        </p>
    </div>

    <!-- calendar -->
    <div class="calendar mt-10">
        <div class="calendar-hd">2015</div>
        <div class="calendar-con">
            <a class="btn-calendar btn-prev">上一个</a>
            <a class="btn-calendar btn-next">下一个</a>
            <div class="calendar-box"></div>
        </div>
    </div>

    <!-- number allocation -->
    <div class="tab mt-10">
        <div class="tab-tit tab-tit-1">
            <a class="active">上午</a>
            <a>下午</a>
        </div>
        <div class="tab-con tab-con-1">
            <!-- 上午 -->
            <div id="morning"></div>
            <!-- 下午 -->
            <div id="afternoon" style="display:none;"></div>
        </div>
    </div>
</div>
<!-- visit arrange end -->

<div class="mask"></div>
<!-- visit addr start -->
<div class="popup visit-addr-wrap">
    <div class="popup-content" id="addressList"></div>
    <div class="popup-bottom">
        <a class="popup-btn-cancel">取消</a>
    </div>
</div>
<!-- visit addr end -->



<!-- fee start -->
<div class="popup fee-wrap">
    <div class="popup-content">
        <ul class="amount-list clearfix" id="feeList" style="display: none;"></ul>
        <a class="popup-add-fee" onclick="goto('toDoctorFeeManage.htm')">管理出诊金额</a>
    </div>
    <div class="popup-bottom">
        <a class="popup-btn-cancel">取消</a>
    </div>
</div>
<!-- fee end -->


<!-- discount_wrap start -->
<div class="popup discount_wrap">
    <div class="popup-content">
        <ul class="discount-list clearfix">
            <li discount="10">不打折</li>
            <li discount="9">9折</li>
            <li discount="8">8折</li>
            <li discount="7">7折</li>
            <li discount="6">6折</li>
            <li discount="5">5折</li>
            <li discount="4">4折</li>
            <li discount="3">3折</li>
            <li discount="2">2折</li>
            <li discount="1">1折</li>
            <li discount="0">免费</li>
        </ul>
    
    </div>
    <div class="popup-bottom">
        <a href="javascript:;" class="popup-btn-cancel">取消</a>
    </div>
</div>
<!-- discount_wrap start -->

</body>
<script>
    var gDiscount = 10;
    //上下午切换
    clickTab('.tab-tit a', '.tab-con > div');

    var timeArray = ["07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30",
                    "11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30",
                    "15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30",
                    "19:00","19:30"];
    //初始化时间点
    function resetTime() {
        var str = new StringBuilder();
        for(var i = 1; i < 27; i++) {
            str.append('<div class="num-allocation-item mt-10"><dl><dt>');
            var fee = "", feeValue="", addrId = "", addrValue = "";
            
            fee = preFee;
            feeValue = $("#fee").val();
            
            addrId = preAddrId;
            addrValue = $("#addr").val();

            var patronFeeDisplay = getPatronFeeDisplay(fee, gDiscount);
            
            str.append('<p><input id="fee'+i+'" onclick="feeClick(this)" type="text" class="add-fee" fee="' + fee + '" value="' + feeValue + ' 老患者价格:' + patronFeeDisplay + '" discount="' + gDiscount + '" placeholder="请先添加出诊金额" readonly/></p>');
            str.append('<p><input id="addr'+i+'" onclick="addrClick(this)" type="text" class="add-addr" addr-id="'+addrId+'" value="'+addrValue+'" placeholder="请先添加出诊地址" readonly/></p>');
            str.append('</dt><dd class="fh-dd" onclick="fhClick(this)"><i class="fh-time">'+timeArray[i-1]+'</i>');
            str.append('<em class="fh-text">放号</em></dd></dl></div>');
            if(i == 10) {
                $("#morning").html(str.toString());
                str = new StringBuilder();
            }
        }
        $("#afternoon").html(str.toString());
    }

    /*************************** start 日期选择相关 ***************************/
    //获取选中日期的附属数据(已设置、不允许设置时间点)
    function asynTargetDayAttach() {
        resetTime();
        var data = {"targetDate":targetDate};
        sendRequest("asynTargetDayAttach.htm", "GET", data, function(result) {
            if(result.result >= 0) {
                var $fhdd = $(".fh-dd");
                if(result.noVisitedTime) { //不允许设置的时间点
                    var notAllowTimeArray = result.noVisitedTime.dateList.split(",");
                    $fhdd.each(function(index, dd){
                        var $this = $(dd);
                        var $parentNode = $this.parent();
                        var time = $this.find(".fh-time").text();
                        if(arraySearch(notAllowTimeArray, time) > -1) {
                            $parentNode.find(".add-fee").addClass("status-3");
                            $parentNode.find(".add-addr").addClass("status-3");
                            $this.addClass("status-3");
                        }
                    });
                }
                if(result.result == 1) {
                    var msg = '放号是否与上周'+targetWeek+'一致?';
                    layer.confirm(msg, {
                        title: false,
                        closeBtn: false,
                        btn: ['取消', '确定']
                    }, function(){
                        layer.closeAll();
                    }, function(){
                        sendRequest("setAsLastWeek.htm", "POST", data, function(result) {
                            if(result) {
                                layer.alert(result, {
                                    title: false,
                                    closeBtn: false
                                }, function () {
                                    layer.closeAll();
                                });
                            } else {
                                asynTargetDayAttach();
                            }
                        });
                    });
                } else {
                    
                    if(result.availableTimeList) { //已设置的时间点
                        var list = result.availableTimeList;
                        for(var i=0;i<list.length;i++) {
                            var availableTime = list[i];
                            var status = availableTime.orderStatus;
                            var dateTime = availableTime.dateTime.substring(availableTime.dateTime.length-5,availableTime.dateTime.length);
                            $fhdd.each(function(index, dd){
                                
                                var $this = $(dd);
                                var $parentNode = $this.parent();
                                var time = $this.find(".fh-time").text();
                                if(time === dateTime) {
                                    $parentNode.find(".add-fee").addClass("status-3");
                                    $parentNode.find(".add-addr").addClass("status-3");
                                    //将当前选中日期下已经设置好诊金的时间段的内容刷新
                                    var slotFee = availableTime.fee;
                                    var slotDiscount = availableTime.discount;
                                    
                                    var addFee = $parentNode.find(".add-fee");
                                    addFee.attr("fee", slotFee);
                                    addFee.attr("discount", slotDiscount);
                                    
                                    refreshFeeForTimeSlot(addFee, slotFee, slotDiscount);
                                    //addFee.attr("fee-id", availableTime.jdDoctorFeeId);
                                    
                                    var addAddr = $parentNode.find(".add-addr");
                                    addAddr.val(availableTime.address);
                                    addAddr.attr("addr-id", availableTime.jdAddressId);
                                    $this.addClass("status status-2 cancel-odd-num");
                                    $this.find(".fh-text").html("取消");
                                    $this.attr("id",availableTime.uuid);
                                    if(status) {
                                        $this.addClass("status-3");
                                        $this.find(".fh-text").html(status);
                                    } 
                                }
                            });
                        }
                    }
                }
                if(targetDate === today) { //当前时间点之前不能设置
                    var d = new Date();
                    var hour = d.getHours();
                    if(hour < 10) hour = "0" + hour;
                    var minute = d.getMinutes();
                    if(minute < 10) minute = "0" + minute;
                    var maxDate = hour + ":" + minute;
                    $fhdd.each(function(index, dd){
                        var $this = $(dd);
                        var $parentNode = $this.parent();
                        var time = $this.find(".fh-time").text();
                        //判断时间点是否小于当前时间或不允许设置
                        if(maxDate > time) {
                            $parentNode.find(".add-fee").addClass("status-3");
                            $parentNode.find(".add-addr").addClass("status-3");
                            $this.removeClass("status status-2 cancel-odd-num").addClass("status-3");
                        }
                    });
                }
            }
        });
    }

    //获取AddDayCount天后的日期
    function getDateStr(AddDayCount) {
        var d = new Date();
        d.setDate(d.getDate() + AddDayCount);
        var y = d.getFullYear();
        var m = d.getMonth() + 1;
        if(m < 10)
            m = "0" + m;
        var date = d.getDate();
        return y+"-"+m+";"+date;
    }

    //获取AddDayCount天后的星期
    function getWeek(AddDayCount) {
        var arr = ['日', '一', '二', '三', '四', '五', '六'];
        var week = new Date().getDay();
        var nArr = [];
        for (var i = 0; i < arguments.length; i++) {
            var limit = (week + arguments[i]) % arr.length;
            nArr.push(arr[limit]);
        }
        return nArr;
    }

    //初始化日期选择
    var targetDate;
    var targetWeek;
    var today;
    var oCalendar = $('.calendar-box');
    var html = new StringBuilder();
    html.append('<ul>');
    for (var i = 0; i < 14; i++) {
        var str = getDateStr(i);
        str = str.split(";");
        if(i == 0) {
            $(".calendar-hd").html(str[0]);
            var day = str[1];
            if(day < 10)
                day = "0" + day;
            targetDate = str[0] + "-" + day;
            today = str[0] + "-" + day;
            targetWeek = getWeek(i);
            asynTargetDayAttach();
        }
        html.append('<li><i class="week">' + getWeek(i) + '</i><span class="date" y-m="' + str[0] + '" data-day="' + i + '">' + str[1] + '</span></li>');
    }
    html.append('</ul>');
    oCalendar.append(html.toString());
    $('[data-day="0"]').addClass('visit-date');

    var _width = $('.calendar-box ul').width();
    // 下一个
    $('.btn-next').on('click', function () {
        $('.calendar-box ul').animate({left: -_width / 2}, 300);
    });
    // 上一个
    $('.btn-prev').on('click', function () {
        $('.calendar-box ul').animate({left: 0}, 300);
    });

    //点击日期选择
    $('.calendar-box span.date').on('click', function () {
        var dataDay = $(this).attr('data-day');
        if (isEmpty('#addr')) {
            layer.msg('请先选择出诊地址');
        } else if (isEmpty('#fee')) {
            layer.msg('请先选择出诊金额');
        } else {
            var ym = $(this).attr('y-m');
            $(".calendar-hd").html(ym);
            $('.date').removeClass('visit-date');
            $(this).addClass('visit-date');
            var day = $(this).text();
            if(day < 10)
                day = "0" + day;
            targetDate = ym + "-" + day;
            targetWeek = $(this).prev().text();
            asynTargetDayAttach();
        }
    });

    //放号、取消 点击事件
    var fhFlag = false;
    function fhClick(obj) {
        var $this = $(obj);
        var $parentNode = $this.parent();
        var text = $this.find(".fh-text").html();
        if(text === "放号") {
            if($this.hasClass("status-3")){
                return;
            }
            //var feeId = $parentNode.find(".add-fee").attr("fee-id");
            var fee = $parentNode.find(".add-fee").attr("fee");
            if(fee == undefined) {
                layer.msg('请先选择出诊金额');
                return;
            }
            var discount = $parentNode.find(".add-fee").attr("discount");
            if (discount == undefined || discount == ""){
                discount = 10;
            }
            var addrId = $parentNode.find(".add-addr").attr("addr-id");
            if(!addrId) {
                layer.msg('请先选择出诊地址');
                return;
            }
            if(fhFlag)
                return;
            fhFlag = true;
            var time = $this.find(".fh-time").text();
            var data = {"fee":fee, "discount":discount, "addrId":addrId, "time":targetDate+" "+time};
            sendRequest("addAvailableTime.htm", "POST", data, function(result) {
                result = result.split(";");
                if(result.length == 1) {
                    layer.alert(result[0], {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    layer.msg("放号成功", {
                        time: 1000 //1秒关闭（如果不配置，默认是3秒）
                    });
                    
                    $parentNode.find(".add-fee").addClass("status-3");
                    $parentNode.find(".add-addr").addClass("status-3");
                    $this.addClass("status status-2 cancel-odd-num");
                    $this.find(".fh-text").html("取消");
                    $this.attr("id",result[1]);
                }
                fhFlag = false;
            }, function () {
                fhFlag = false;
            });
        } else if(text === "取消") {
            if($this.hasClass("status-3")){
                return;
            }
            layer.confirm('确定要取消放号?', {
                title: false,
                closeBtn: false,
                btn: ['取消', '确定']
            }, function(){
                layer.closeAll();
            }, function(){
                if(fhFlag)
                    return;
                fhFlag = true;
                var id = $this.attr("id");
                var data = {"id":id};
                sendRequest("deleteAvailableTime.htm", "POST", data, function(result) {
                    if(result) {
                        if(result.indexOf("已被预约")>-1) {
                            result = "该时间点已被预约，无法取消！详情请咨询客服:<a href=\"tel:400-061-8989\">400-061-8989</a>";
                        }
                        layer.alert(result, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                        });
                    } else {
                        $parentNode.find(".add-fee").removeClass("status-3");
                        $parentNode.find(".add-addr").removeClass("status-3");
                        $this.removeClass("status status-2 cancel-odd-num");
                        $this.find(".fh-text").html("放号");
                    }
                    fhFlag = false;
                }, function () {
                    fhFlag = false;
                });
            });
        }
    }
    /*************************** end 日期选择相关 ***************************/

    /*************************** start 出诊地址选择 ***************************/
    function asynAddressList() {
        var data = {"random":Math.random()*10000};
        sendRequest("asynAddressList.htm", "GET", data, function(result) {
            var str = new StringBuilder();
            if(result) {
                for(var i = 0, len = result.length; i < len; i++) {
                    var address = result[i];
                    if(address.isDefault) {
                        $('#addr').val(address.address);
                        unifiedSetAddress(address.uuid,address.address);
                        str.append('<a onclick="selectAddr(this,\''+address.uuid+'\')">'+address.address+' <b>(默认)</b></a>');
                    } else {
                        str.append('<a onclick="selectAddr(this,\''+address.uuid+'\')">'+address.address+'</a>');
                    }
                }
            }
            str.append('<a class="popup-add-addr" onclick="goto(\'toAddressManage.htm\')">管理出诊地址</a>');
            $("#addressList").html(str.toString());
        });
    }
    asynAddressList();
    var targetAddrId;
    var preAddrId = "";
    function addrClick(obj) {
        var $this = $(obj);
        if($this.hasClass("status-3")){
            return;
        }
        $('.mask, .visit-addr-wrap').fadeIn();
        targetAddrId = $this.attr("id");
    }
    function selectAddr(obj,addrId) {
        $('.mask, .visit-addr-wrap').fadeOut();
        var $targetAddrId = $('#'+targetAddrId);
        var addrText = $(obj).html().split('<b>', 1)[0];
        $targetAddrId.val(addrText);
        if(targetAddrId === "addr") { //统一设置
            unifiedSetAddress(addrId, addrText);
        } else { //单独设置
            $targetAddrId.attr("addr-id", addrId);
        }
    }
    //统一设置地址
    function unifiedSetAddress(addrId, addrText) {
        $(".add-addr").each(function(index,addr){
            if(!$(addr).hasClass("status-3") ) {
                $(addr).val(addrText);
                $(addr).attr("addr-id", addrId);
            }
        });
        preAddrId = addrId;
    }
    /*************************** end 出诊地址选择 ***************************/

    /*************************** start 诊金选择 ***************************/
    /* 获取所有用户已经设置的诊金选项， 并将所有时间段的诊金设置为默认诊金  */
    function asynFeeList() {
        var data = {"random":Math.random()*10000};
        sendRequest("asynDoctorFeeList.htm", "GET", data, function(result) {
            if(result) {
                var str = new StringBuilder();
                var len = result.length;
                var defaultFee = -1;
                if(len > 0) {
                    $("#feeList").css("display", "");
                }
                for(var i = 0; i < len; i++) {
                    var fee = result[i];
                    // 注意： fee为-1时，当前记录仅用于携带默认折扣，得到默认折扣后应当将其忽略 
                    if (fee.fee < 0 && fee.discount > 0 && fee.discount < 11){
                        gDiscount = fee.discount;
                        continue;
                    }
                    if(fee.isDefault) {
                        // 初始条件下， 将所有时间段的价格设置为默认诊金
                        defaultFee = fee.fee;
                        preFee = defaultFee;
                        $('#fee').val('￥' + defaultFee);
                    }
                    str.append('<li onclick="selectFee(this,\''+fee.fee+'\')">￥'+fee.fee+'</li>');
                }
                
                if (defaultFee != -1){
                    unifiedSetFee(defaultFee);
                    $('#discount').val(getPatronFeeDisplay(defaultFee, gDiscount));
                }
                
                $("#feeList").html(str.toString());
            }
        });
    }
    
    var preFee = "";
    asynFeeList();
    
    var targetFeeId;
    
    // 综合设置和单项设置共享该函数，因此需要得到当前的设置焦点(targetFeeId)
    function feeClick(obj) {
        var $this = $(obj);
        if($this.hasClass("status-3")){
            return;
        }
        $('.mask, .fee-wrap').fadeIn();
        targetFeeId = $this.attr("id");
    }
    
    function selectFee(obj,fee) {
        $('.mask, .fee-wrap').fadeOut();
        var $targetFeeId = $('#'+targetFeeId);

        if(targetFeeId === "fee") { //当前操作的控件是全局价格，因此统一设置 
            $targetFeeId.val('￥' + fee);
            unifiedSetFee(fee);
            
        } else { //对一个时间段单独设置 
            refreshFeeForTimeSlot($targetFeeId, fee, gDiscount)
        }
    }
    
    //统一设置诊金
    function unifiedSetFee(fee) {
        var patronFeeDisplay = getPatronFeeDisplay(fee, gDiscount);
        $('#discount').val(patronFeeDisplay);
        
        $(".add-fee").each(function(index, feeBar){
            if(!$(feeBar).hasClass("status-3") ) {
                refreshFeeForTimeSlot($(feeBar), fee, gDiscount);
            }
        });
        // 全局诊金设置重置
        $('#fee').val('￥' + fee);
        preFee = fee;
    }
    /*************************** end 诊金选择 ***************************/
    
    
    /*************************** start 老顾客诊金折扣选择 ***************************/
    $('#discount').on('click',function(){
        $('.mask, .discount_wrap').fadeIn();
    });

    $('.discount-list li').on('click',function(){
        $('.mask, .popup').fadeOut();
        gDiscount = $(this).attr('discount');
        
        //获取当前设置的折扣前价格
        var origPrice = parseFloat($('#fee').val().substring(1));
        if (isNaN(origPrice)) {
            $('#discount').val('');
            alert ("请先设置诊金！");
            return false;
        }
        // 根据新的折扣选择刷新所有时间段的值 
        unifiedSetFee(origPrice);
    });
   
    /*************************** end 老顾客诊金折扣选择 ***************************/
    
    /** 更新某一个时间段的诊金价格及显示  **/
    function refreshFeeForTimeSlot(component, fee, discount){
        var patronFeeDisplay = getPatronFeeDisplay(fee, discount);
        if (discount === "" || discount == undefined){
            	component.val('￥' + fee);
	    }else{
	        if (fee == 0 ){
	            component.val('免费');
	        }else {
	        	component.val('￥' + fee + '   老患者价格:' + patronFeeDisplay );
	        }
	    }
        component.attr("fee", fee);
        component.attr("discount", discount);
    }
    
    /** 根据折扣值生成折扣显示  **/
    function getPatronFeeDisplay(fee, discount){
        var patronFeeDisplay;
        if (fee == undefined){
            patronFeeDisplay = '';
        }
        else {
            if (discount == 10 && fee != 0) {
                patronFeeDisplay = '￥' + fee + '(无折扣)';
            }
            else if (fee == 0 || discount == 0 || discount == "" || discount == undefined ) {
                patronFeeDisplay = '0(免费)';
            }else{
                patronFeeDisplay = '￥' + (fee * discount) / 10 + '(' + discount + '折)';
            }
        }
        
        return patronFeeDisplay;
    }
    
    // 取消
    $('.popup-btn-cancel').on('click', function () {
        $('.mask, .popup').fadeOut();
    });
</script>
</html> 
