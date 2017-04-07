<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="cn.aidee.framework.base.utils.DateUtils"%>
<%@ page import="cn.aidee.jdoctor.model.*"%>
<%@ page import="java.util.List"%>
<%
	String exceed = (String) request.getAttribute("exceed");
	JdPatientModel patient = (JdPatientModel) request.getAttribute("patient");
	int waitToPay = (Integer) request.getAttribute("waitToPay");
	JdDoctorQueryModel doctorInfo = (JdDoctorQueryModel) request.getAttribute("doctorQueryModel");
	String orderTip = (String) request.getAttribute("orderTip");
	AvailableTimeQueryModel availableTime = (AvailableTimeQueryModel) request.getAttribute("availableTime");
	List<JdPatientQueryModel> contactsList = (List<JdPatientQueryModel>) request.getAttribute("contactsList");
	List<JdCouponQueryModel> couponList = (List<JdCouponQueryModel>) request.getAttribute("couponList");
	//医生当天免费号数用完 获取用户所拥有的现金券
	List<JdCouponQueryModel> userhasCouponList = (List<JdCouponQueryModel>) request
			.getAttribute("userhasCouponList");
	List<JdCouponQueryModel> userInvitationCouponList = (List<JdCouponQueryModel>) request
			.getAttribute("userInvitationCouponList");
	Integer inviteCouponCount = (Integer) request.getAttribute("inviteCouponCount");
	if (inviteCouponCount == null)
		inviteCouponCount = 0;
	Integer couponCountLimit = (Integer) request.getAttribute("couponCountLimit");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
<jsp:include page="../include/head.jsp" />
</head>
<body>
	<!--wrap-->
	<div class="wrap fill_order_wrap" id="fillorder_wrap">
		<!--header-->
		<header class="header pr">
			<h1 class="logo pa">
				<a onclick="toMain()"></a>
			</h1>
			<h2>订单填写</h2>
			<div class="header_logo pa">
				<a onclick="toPersonal()" class="mine_center pa"></a>
			</div>
		</header>
		<!--header-->

		<!--doctor_msg-->
		<div class="doctor_msg clearfix">
			<div class="fl doctor_msg_header">
				<span
					style="background:url(<%=doctorInfo.getHeadPic()%>) center center no-repeat;background-size:cover;"></span>
			</div>
			<div class="fl doctor_msg_content">
				<p><%=doctorInfo.getName()%>
					丨
					<%=doctorInfo.getTitle()%></p>
				<p><%=doctorInfo.getHospital()%></p>
				<p>
					时间：<span class="dmc_wekday"><%=DateUtils.getWeekOfDate(availableTime.getDateTime())%>
						<%=DateUtils.format(availableTime.getDateTime(), "HH:mm")%>(<%=DateUtils.format(availableTime.getDateTime(), "MM-dd")%>)</span>
				</p>
				<p class="clearfix">
					<span class="dmc_adress fl">地址：</span><span
						class="dmc_address_c fl"><%=availableTime.getAddress()%></span>
				</p>
			</div>
		</div>
		<!--doctor_msg-->

		<!--content-->
		<div class="content fillorder_wrap">
			<ul class="list fillorder_list addpeople_list">
				<%
					if (patient != null) {
				%>
				<li class="clearfix pr addpeople" id="fillorderheight"><label
					class="fillorder_title fl">家庭联系人</label> <label
					class="fillorder_input fl clearfix" id="select_order"> <%
 	if (contactsList != null && contactsList.size() > 0) {
 			for (JdPatientQueryModel contact : contactsList) {
 %>
						<div
							onclick="loadContact('<%=contact.getName()%>','<%=contact.getPhoneNumber()%>','<%=contact.getIdCard()%>','<%=contact.getAge()%>')"
							class="fl order_people"><%=contact.getName()%></div> <%
 	}
 		}
 %>
				</label> <span class="pa" id="addpeople" bol="true"></span></li>
				<%
					}
				%>
			</ul>
			<section class="fillorder">
				<ul class="list fillorder_list filllist_height">
					<%
						if (patient == null) {
					%>
					<li class="clearfix borderb pr"><label
						class="fillorder_title fl"><i class="must">*</i>手机号</label> <label
						class="fillorder_input fl"><input type="text"
							maxlength="11" class="fl" placeholder="11位手机号码" id="regphone"></label>
						<div class="sendcode pa" id="reggetcode" bol=true>获取验证码</div></li>
					<li class="clearfix"><label class="fillorder_title fl"><i
							class="must">*</i>验证码</label> <label class="fillorder_input fl"><input
							type="text" id="code" placeholder="请输入验证码"></label></li>
					<li class="clearfix"><label class="fillorder_title fl">邀请码</label>
						<label class="fillorder_input fl"><input type="text"
							id="inviteCode" placeholder="选填"></label></li>
					<%
						} else {
					%>
					<li class="clearfix"><label class="fillorder_title fl"><i
							class="must">*</i>手机号</label> <label class="fillorder_input fl"><input
							type="text" maxlength="11" id="regphone" placeholder="11位手机号码"></label>
					</li>
					<%
						}
					%>
					<li class="clearfix"><label class="fillorder_title fl"><i
							class="must">*</i>姓名</label> <label class="fillorder_input fl"><input
							type="text" id="name" placeholder="与患者证件一致"></label></li>
					<li class="clearfix"><label class="fillorder_title fl"><i
							class="must">*</i>身份证</label> <label class="fillorder_input fl"><input
							type="text" id="idCard" placeholder="与患者证件一致" maxlength="18"
							onkeyup="idCardChange()"></label></li>
					<li class="clearfix"><label class="fillorder_title fl"><i
							class="must">*</i>年龄</label> <label class="fillorder_input fl"><input
							type="text" id="age" placeholder="与患者证件一致" readonly></label></li>
					<li class="clearfix"><label class="fillorder_title fl"><i
							class="must">*</i>病情描述</label> <label class="fillorder_input fl"><input
							type="text" id="desc" placeholder="请输入病情描述"></label></li>

					<li class="clearfix pr"><label class="fillorder_title fl">是否手术</label>
						<label class="fillorder_input fl"> <input type="text"
							placeholder="请输入病情描述" value="免费派遣陪诊员协助" readonly
							style="color: #999;">
					</label>

						<div class="switch_button" id="useOperation" bol=false>
							<span></span>
						</div></li>

				</ul>
			</section>
			<section class="volume_wrap">
				<%
					if (patient != null && exceed == null && availableTime.getFee().intValue() > 0) {
						if (couponCountLimit > 0 && inviteCouponCount > 0) {
				%>
				<div class="volume_list clearfix">
					<section class="volume_section">
						<label class="volume_left fl">邀请券</label> <label
							class="volume_content fl"> <span class="volume_money fl"
							id="showIntive" style="display: none;">-￥0</span>
							<div class="switch_button" id="useIntive" bol=true>
								<span></span>
							</div>
						</label>
					</section>
					<section class="volume_section" id="Intive_Content"
						style="display: none;">
						<label class="volume_left fl volume_left_color">共<span
							id="IntiveNumber"><%=inviteCouponCount%></span>张
						</label> <label class="volume_content fl">
							<div class="number_wrap fr">
								<div class="number_left" id="IntiveReduction">
									<span></span>
								</div>
								<div class="number_center">
									<input type="text" value="0" readonly id="useIntiveNumber">
								</div>
								<div class="number_right" id="IntiveAdd">
									<span></span> <b></b>
								</div>
							</div> <span class="volume_money2 fr">￥<i id="Denomination">20</i></span>
						</label>
					</section>
				</div>
				<%
					}
						if (couponList != null && couponList.size() > 0) {
				%>
				<div class="volume_list clearfix">
					<section class="volume_section">
						<label class="volume_left fl fillorder_title ">现金券</label> 
						<label class="volume_content fl"> 
						    <span class="volume_money fl"  style="display: none;" id="showCash">-￥0</span>
							<div class="switch_button" id="useCash" bol=true>
								<span></span>
							</div>
						</label>
					</section>
					<section class="volume_section" style="display: none;"
						id="cash_Content">
						<label class="volume_left fl volume_left_color">共<%=couponList == null ? 0 : couponList.size()%>张
						</label>
						<%
							if (couponList != null) {
										for (JdCouponQueryModel coupon : couponList) {
						%>
						<label class="volume_content fr">
							<div class="cash_list volume_left_color">
								￥<%=coupon.getValue().setScale(0)%>
								<div class="switch_button switch_cash js_cash_btn"
									money="<%=coupon.getValue().setScale(0)%>"
									id="<%=coupon.getUuid().toString()%>">
									<span></span>
								</div>
							</div>
						</label>
						<%
							}
									}
						%>
					</section>
				</div>
				<%
					}
					}
				%>
				<%
					//医生当天免费号数用完 获取用户所拥有的现金券
					if (userhasCouponList != null && userhasCouponList.size() > 0) {
				%>
				<div class="volume_list clearfix">
					<section class="volume_section">
						<label class="volume_left fl" style="width: 80%;">现金券（医生今天补贴限额已用完）</label>
						<label class="volume_content fl" style="width: 13%;"> <span
							class="volume_money fl" style="display: none;">-￥0</span>
							<div class="switch_button" id="useNoCash" bol=false>
								<span></span>
							</div>
						</label>
					</section>
					<section class="volume_section" id="useNo_Content">
						<label class="volume_left fl volume_left_color">共<%=userhasCouponList == null ? 0 : userhasCouponList.size()%>张
						</label>
						<%
							if (userhasCouponList != null) {
									for (JdCouponQueryModel coupon : userhasCouponList) {
						%>
						<label class="volume_content fr">
							<div class="cash_list volume_left_color">
								￥<%=coupon.getValue().setScale(0)%>
								<span style="font-size: 10px;"></span>
								<div class="switch_button js_btn_nocan">
									<span></span>
								</div>
							</div>
						</label>
						<%
							}
								}
						%>
					</section>
				</div>
				<%
					}
				%>
				<%
					//医生当天免费号数用完 获取用户所拥有的邀请券
					if (userInvitationCouponList != null && userInvitationCouponList.size() > 0) {
				%>
				<div class="volume_list clearfix">
					<section class="volume_section">
						<label class="volume_left fl" style="width: 80%;">邀请券（医生今天补贴限额已用完）</label>
						<label class="volume_content fl" style="width: 13%;"> <span
							class="volume_money fl" style="display: none;">-￥0</span>
							<div class="switch_button" id="useNoIntive" bol=false>
								<span></span>
							</div>
						</label>
					</section>
					<section class="volume_section" id="useNoIntive_Content">
						<label class="volume_left fl volume_left_color">共<%=userInvitationCouponList == null ? 0 : userInvitationCouponList.size()%>张
						</label>
						<%
							if (userInvitationCouponList != null) {
									for (JdCouponQueryModel coupon : userInvitationCouponList) {
						%>
						<label class="volume_content fr">
							<div class="cash_list volume_left_color">
								￥<%=coupon.getValue().setScale(0)%>
								<span style="font-size: 10px;"></span>
								<div class="switch_button js_btn_nocan">
									<span></span>
								</div>
							</div>
						</label>
						<%
							}
								}
						%>
					</section>
				</div>
				<%
					}
				%>
			</section>
			<section class="fillorder">
				<div class="order_footer clearfix">
					<label class="order_footer_left fl">咨询费</label>
					<%
						String priceDisplay = availableTime.getFee().setScale(0).toString();

						//游客无折扣
						if (patient != null) {
							int discount = availableTime.getDiscount();
							if (discount > 0 && discount < 10) {
								priceDisplay += "(" + availableTime.getDiscount() + "折)";
							}
						}
					%>
					<label class="order_right_content">￥<span
						id="fillorderFees"><%=priceDisplay%></span></label>
				</div>
				<div class="order_footer clearfix">
					<label class="order_footer_left fl">保证金</label> <label
						class="order_right_content">￥<span id="fillorderBond"><%=doctorInfo.getDeposit().setScale(0)%></span></label>
				</div>
			</section>
			<div class="addorder_mush">
				<b class="addorder_active" id="addorder_mush"></b>我已经了解<span
					id="reservation">《橙医生预约须知》</span>
			</div>
		</div>
		<!--content-->

		<!--gotoorder-->
		<footer class="gotoorder">
			<div class="follorderFill fl">合计：</div>
			<div class="foolorderFill_right fl">
				￥<span id="fillorderTotal"><%=availableTime.getFee().add(doctorInfo.getDeposit()).setScale(0)%></span>
			</div>
			<div class="fillorderto" onclick="submitOrder()">提交订单</div>
		</footer>
		<!--gotoorder-->
	</div>
	<!--wrap-->

	<div class="mustknow_wrap" id="reservation_wrap">
		<header class="closeheader pr">
			<a href="javascript:void(0)" class="pa close reservation_know"></a>
			<h2>预约须知</h2>
		</header>
		<div class="roll_content">
			<%
				String[] tips = orderTip.split("\n");
				for (String tip : tips) {
					out.println("<p>" + tip + "</p>");
				}
			%>
			<div class="iknow reservation_know">我知道了</div>
		</div>
	</div>

</body>
<script>
    sendPageVisit(Page_Constant.FillOrder);

    //点击发送验证码
    $('#reggetcode').on('click', function (ev) {
        if ($(this).attr('bol') == "false") {
            return;
        }
        //判断用户是否输入手机号码
        if (checknull('#regphone') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#regphone').focus();
            });
            return;
        }
        //判断手机号码是否正确
        if (checkregular('#regphone', '1') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#regphone').focus();
            });
            return;
        }
        var url = 'getRegisterVerifyCode.htm?phoneNumber=' + $('#regphone').val().trim();
        sendRequest(url, "GET", function (msg) {
            if (msg) {
                if (msg.indexOf('已注册') > -1) {
                    layer.confirm(errorMsg.phonesave, {
                        title: false,
                        closeBtn: false,
                        btn: ['登陆', '确定']
                    }, function () {
                        goto('toLogin.htm?targetReqUrl=' + encodeURIComponent('fillOrder.htm?doctorId=<%=doctorInfo.getUuid().toString()%>'+
                                                                              '&timeId=<%=availableTime.getUuid().toString()%>'));
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    layer.alert(msg, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                }
            } else {
                //执行发送验证码
                vercode();
            }
        });
    });

    /*判断家庭联系人的高度*/
    if ($('#select_order').height()<=44) {
        $('#addpeople').css({'display':'none'});
    }
    /*家庭联系人收起or展开*/
    $('#addpeople').on('click',function(ev){
        if ($(this).attr('bol')=="true") {
            $('#fillorderheight').css({'height':'auto'});
            $('#addpeople').addClass('addactive');
            $(this).attr('bol','false');
            return;
        }
        if ($(this).attr('bol')=="false") {
            $('#fillorderheight').css({'height':'0.88rem'});
            $('#addpeople').removeClass('addactive');
            $(this).attr('bol','true');
        }
    });

    //选中联系人后改变样式
    $('#select_order').on('click','.order_people',function(ev){
        $('.order_people').removeClass('order_people_active');
        $('.order_people').eq($(this).index()).addClass('order_people_active');
        ev.stopPropagation();
    });
    //选中联系人后加载信息
    function loadContact(name, phone, idCard, age) {
        if(name != "null") $("#name").val(name);
        else $("#name").val("");
        if(phone != "null") $("#regphone").val(phone);
        else $("#regphone").val("");
        if(idCard != "null") $("#idCard").val(idCard);
        else $("#idCard").val("");
        if(age != "null") $("#age").val(age);
        else $("#age").val("");
        idCardChange();
    }

    //预约需知checkbox勾选
    $('#addorder_mush').on('click',function(ev){
        if ($(this).hasClass('addorder_active')) {
            $(this).removeClass('addorder_active');
        } else {
            $(this).addClass('addorder_active');
        }
    });
    /*点击预约需知*/
    $('#reservation').on('click',function(ev){
        $('#fillorder_wrap').css({'display':'none'});
        $('#reservation_wrap').css({'display':'block'});
    });
    /*关闭预约需知*/
    $('.reservation_know').on('click',function(ev){
        $('#fillorder_wrap').css({'display':'block'});
        $('#reservation_wrap').css({'display':'none'});
    });

    /*********************现金券的选择 start****************************/
    var couponType = "";
    var couponId;
    var fillOrder={
        IntiveNumber:parseInt($('#IntiveNumber').html()),//邀请券的张数
        couponCountLimit:<%=couponCountLimit%>,
        couponValueLimit:<%=doctorInfo.getSubsidy().setScale(0)%>,
        Denomination:parseInt($('#Denomination').html()),//邀请券一张的面额
        cashSize:0,//选择了的现金券的面额
        method:1,//计算方式,1为使用邀请券的计算方法、2为使用了现金券的计算方法
        bond:parseInt($('#fillorderBond').html()),//保证金
        fees:parseInt($('#fillorderFees').html()),//咨询费
        addFlag:true,//邀请券是否可按加号
        on:function(){
            var _this=this;
            //点击使用邀请券
            $('#useIntive').on('click',function(ev){
                if ($('#useIntive').attr('bol')=="true") {
                    _this.openIntive();
                    $('#useIntive').attr('bol','false');
                    _this.cancelCash();
                    $('#useCash').attr('bol','true');
                    _this.method=1;
                    couponType = "invite";
                }else{
                    _this.cancelIntive();
                    $('#useIntive').attr('bol','true');
                    couponType = "";
                }
                _this.Calculation();
            });
            //使用现金券
            $('#useCash').on('click',function(ev){
                if ($('#useCash').attr('bol')=="true") {
                    _this.openCash();
                    $('#useCash').attr('bol','false');
                    _this.cancelIntive();
                    $('#useIntive').attr('bol','true');
                    _this.method=2;
                    couponType = "cash";
                }else{
                    _this.cancelCash();
                    $('#useCash').attr('bol','true');
                    couponType = "";
                }
                _this.Calculation();
            });
            //是否需要手术治疗
            $('#useOperation').on('click',function (ev) {
                if($('#useOperation').attr('bol') == "true"){
                    $('#useOperation').attr('bol','false');
                    $('#useOperation').removeClass('switc_on');
                }else{
                    $('#useOperation').attr('bol','true');
                    $('#useOperation').addClass('switc_on');
                }
            });
        },
        //计算的方法
        Calculation:function(){
            var _this=this;
            //邀请券的数量
            var IntiveThisNumber=parseInt($('#useIntiveNumber').val());
            $('#showIntive').html('￥-'+ _this.Denomination*(IntiveThisNumber));
            $('#showCash').html('-￥'+_this.cashSize);
            //计算总价
            if (_this.method=="1") {
                var total = (_this.fees)-(_this.Denomination*(IntiveThisNumber));
                if(total < 0) {
                    _this.addFlag = false;
                    total = 0;
                }
                total=(_this.bond)+total;
                $('#fillorderTotal').html(total);
                return false;
            } else if (_this.method=="2") {
                var total = (_this.fees)-(_this.cashSize);
                if(total < 0)
                    total = 0;
                total=(_this.bond)+total;
                $('#fillorderTotal').html(total);
                return false;
            } else {
                $('#fillorderTotal').html((_this.bond)+(_this.fees));
            }
        },
        //开启邀请券功能
        openIntive:function(){
            var _this=this;
            //开启邀请券的按钮
            $('#useIntive').addClass('switc_on');
            //显示抵扣的价格
            $('#showIntive').css({'display':'block'});
            //显示使用邀请券的内容
            $('#Intive_Content').css({'display':'block'});
            //点击减
            $('#IntiveReduction').on('click',function(ev){
                //已经是0的话，不能够再减下去
                if ($('#useIntiveNumber').val()=="0") {
                    return false;
                }
                _this.addFlag = true;
                //减少个数
                var nowNumber=parseInt($('#useIntiveNumber').val());
                $('#useIntiveNumber').val(nowNumber-1);
                _this.Calculation();
            });
            //点击加
            $('#IntiveAdd').on('click',function(ev){
                if(!_this.addFlag) return;
                //现在的数量
                var nowNumber=parseInt($('#useIntiveNumber').val());
                //加后的数字
                var afterAddNumber=nowNumber+1;
                //判断加后的数字是否超过可以使用张数
                if (afterAddNumber>_this.IntiveNumber) {
                    return false;
                }
                if (afterAddNumber>_this.couponCountLimit) {
                    layer.msg("该医生最多使用"+_this.couponCountLimit+"张邀请券");
                    return false;
                }
                $('#useIntiveNumber').val(afterAddNumber);
                _this.Calculation();
            });
        },
        //取消邀请券
        cancelIntive:function(){
            var _this=this;
            _this.method=3;
            //取消邀请券的按钮
            $('#useIntive').removeClass('switc_on');
            //取消抵扣的价格
            $('#showIntive').css({'display':'none'});
            //取消显示内容
            $('#Intive_Content').css({'display':'none'});
            $('#IntiveAdd').off();
            $('#IntiveReduction').off();
        },
        //开启现金券的功能
        openCash:function(){
            var _this=this;
            //按钮的样式
            $('#useCash').addClass('switc_on');
            $('#showCash').css({'display':'block'});
            $('#cash_Content').css({'display':'block'});
            //选择使用的现金券
            $('.switch_cash').on('click',function(ev){
                var buzhou = 0;
                //获取现金券面额
                var moneyStr = $(this).attr('money');
                try{
                    buzhou = 1;
                    var money=parseInt(moneyStr);
                    buzhou = 2;
                    if (money>_this.couponValueLimit) {
                        _this.cashSize=_this.couponValueLimit;
                    }else{
                        _this.cashSize=parseInt(moneyStr);
                    }
                    buzhou = 3;
                    $('.switch_cash').removeClass('switc_on');
                    buzhou = 4;
                    $(this).addClass('switc_on');
                    buzhou = 5;
                    couponId = $(this).attr("id");
                    buzhou = 6;
                    _this.Calculation();
                    buzhou = 7;
                }catch(exception){
                    alert("选择使用的现金券金额异常，请截图将相关信息发送客服，金额："+moneyStr+"问题步骤："+buzhou);
                }
            });
        },
        //取消现金券的功能
        cancelCash:function(){
            var _this=this;
            _this.method=3;
            $('#useCash').removeClass('switc_on');
            $('#showCash').css({'display':'none'});
            $('#cash_Content').css({'display':'none'});
        }
    };
    fillOrder.on();
    if(fillOrder.couponValueLimit <= 0){
        fillOrder.cancelCash();
        $('#useCash').hide();
        $('#showCash').html('当前医生不可使用现金券'); 
        $('#showCash').css('color', '#999');
        $('#showCash').css('display', 'block');
    }

    /*********************现金券的选择 end****************************/

    //身份证输入框粘贴事件
    $('#idCard').bind("paste", function(e){
        var pastedText = undefined;
        if (window.clipboardData && window.clipboardData.getData) {
            pastedText = window.clipboardData.getData('Text');
        } else {
            pastedText = e.originalEvent.clipboardData.getData('Text');
        }
        var oldVal = $.trim($('#idCard').val());
        $('#idCard').val(oldVal+pastedText);
        idCardChange();
    });
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

    var waitToPay = <%=waitToPay%>;
    //检查是否有待付款订单
    function checkWaittoPay() {
        if(waitToPay > 0) {
            var tip = "您有待付款订单，请先支付或取消待付款的订单后，再提交新订单。现在跳转待付款订单列表？";
            layer.confirm(tip, {
                title: false,
                closeBtn: false,
                btn: ['取消', '确定']
            }, function () {
                layer.closeAll();
            }, function () {
                goto("toOrderList.htm?status=1");
            });
            return true;
        } else {
            return false;
        }
    }
    var submitFlag = false;
    //提交订单
    function submitOrder() {
        if(checkWaittoPay())
            return;
        if (!$('#addorder_mush').hasClass('addorder_active')) {
            layer.alert("请先了解《预约须知》并勾选", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        //判断手机号码是否正确
        if (checkregular('#regphone', '1') == false) {
            layer.alert(errorMsg.mobile, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#regphone').focus();
            });
            return;
        }
        var phone = $('#regphone').val().trim();
        var patient = '<%=patient%>';
        if(patient == "null") {
            var code = $('#code').val().trim();
            if(code.length == 0) {
                layer.alert("请输入验证码", {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    $('#code').focus();
                });
                return;
            }
            if(submitFlag)
                return;
            submitFlag = true;
            var data = {'phoneNumber': phone, 'code': code};
            sendRequest("verifyCode.htm", "POST", data, function(result) {
                if(result) {
                    submitFlag = false;
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                    return;
                }
                var inviteCode = $('#inviteCode').val().trim();
                continueSubmit(phone, inviteCode);
            }, function() {
                submitFlag = false;
            });
        } else {
            continueSubmit(phone);
        }
    }
    function continueSubmit(phone, inviteCode) {
        var name = $('#name').val().trim();
        var idCard = $('#idCard').val().trim();
        var desc = $('#desc').val().trim();
        var useOperation = $('#useOperation').attr('bol');
        if(name.length == 0) {
            submitFlag = false;
            layer.alert("请填写姓名", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#name').focus();
            });
            return;
        }
        if(!idCardFlag && idCard.length != 15 && idCard.length != 18) {
            submitFlag = false;
            layer.alert("身份证号不正确", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#idCard').focus();
            });
            return;
        }
        if(desc.length == 0) {
            submitFlag = false;
            layer.alert("请填写病情描述", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#desc').focus();
            });
            return;
        }
        var data = {"phone":phone, "name":name, "idCard":idCard, "desc":desc, "inviteCode":inviteCode,
            "couponType":couponType,"couponId":couponId,"couponCount":parseInt($('#useIntiveNumber').val()),
            "doctorId":'<%=doctorInfo.getUuid().toString()%>', "timeId":'<%=availableTime.getUuid().toString()%>',
            "useOperation":useOperation};
        sendRequest("submitOrder.htm", "POST", data, function(result) {
            if(result) {
                var info = result.split(":");
                if(info.length == 1) {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    var status = info[0];
                    if (status === 'duplicate') {
                    	layer.alert(info[1], {
                        	title: false,
                        	closeBtn: false
                    	}, function () {
                        	goto('/wechat_web/wap_wechat_patient/html/myReservation.html');
                    	});
                    } else if (status === 'booked') {
                        layer.alert(info[1], {
                        	title: false,
                        	closeBtn: false
                    	}, function () {
                        	goto('/wechat_web/wap_wechat_patient/html/appointment.html?doctor_id=<%=doctorInfo.getUuid().toString()%>');
                    	});
                    } else {
                    	goto('/wechat_web/wap_wechat_patient/html/cashier.html?order_id='+
                            info[1]+'&order_type=OFFLINE');
                    }
                }
            }
            submitFlag = false;
        }, function() {
            submitFlag = false;
        });
    }
    //现金券不可以使用
    $(".js_btn_nocan").on('click',function(ev){
        layer.alert("医生今天补贴限额已用完", {
            title: false,
            closeBtn: false
        }, function () {
            layer.closeAll();
        });
    });
    $('#useNoCash').on('click',function(ev){
        if ($('#useNoCash').attr('bol')=="true") {
            $('#useNoCash').attr('bol','false');
            $("#useNo_Content").show();
        }else{
            $('#useNoCash').attr('bol','true');
            $("#useNo_Content").hide();
        }
    });
    $('#useNoIntive').on('click',function(ev){
        if ($('#useNoIntive').attr('bol')=="true") {
            $('#useNoIntive').attr('bol','false');
            $("#useNoIntive_Content").show();
        }else{
            $('#useNoIntive').attr('bol','true');
            $("#useNoIntive_Content").hide();
        }
    });
    $(function(){
        if(fillOrder.couponValueLimit > 0) {
            if ($("#useCash").length > 0) {
                $("#useCash").click();
                $(".js_cash_btn:eq(0)").click()
            }
        }
    });
</script>
</html>
