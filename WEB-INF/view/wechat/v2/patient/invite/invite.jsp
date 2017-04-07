<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdRecommendDoctorQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdUserFriendsCouponQueryModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String qrcodeUrl = (String) request.getAttribute("qrcodeUrl");
    List<JdRecommendDoctorQueryModel> recommendDoctorList = (List<JdRecommendDoctorQueryModel>) request.getAttribute("recommendDoctorList");
    List<JdUserFriendsCouponQueryModel> userFriendsCouponList = (List<JdUserFriendsCouponQueryModel>) request.getAttribute("userFriendsCouponList");
    if(userFriendsCouponList == null) {
        userFriendsCouponList = new ArrayList<JdUserFriendsCouponQueryModel>();
    }
    String headImgUrl = (String) request.getAttribute("headImgUrl");
    
    if (headImgUrl == null || headImgUrl == "") {
        headImgUrl = "https://m.chengyisheng.com.cn/wechat_web/wap_wechat_patient/images/load_head.png";
    }
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--Invite_top-->
    <div class="Invite_top">
        <div class="Invite_explain">
            <div class="Invite_wrap">

                <div class="invite_header"
                     style="background:url(<%=headImgUrl%>) center center no-repeat;background-size:cover;"></div>

                <p class="invite_first_p">我注册了橙医生，平台上都是很难约到的心脑血管名医，免排队，至少15分钟看诊，服务超赞</p>

                <p>我申请给你发了<span>￥100</span> 现金券，来体验最好的心脑血管名医就诊服务吧！</p>

            </div>
        </div>
        <div class="Invite_code"><img src="<%=qrcodeUrl%>" alt=""></div>
        <div class="Invite_tit">长按二维码&nbsp领取现金券</div>
    </div>
    <!--Invite_top-->
    <div class="Invite_friend_number"><%=userFriendsCouponList.size()%>个好友已领取</div>

    <!--Invite_friend_list-->
    <div class="Invite_friend_list">
        <ul id="Invite_friend_list">
            <%
                if (userFriendsCouponList.size() > 0) {
                    for (JdUserFriendsCouponQueryModel friend : userFriendsCouponList) {
                        String imgUrl = friend.getHeadImgUrl();
                        if(imgUrl == null) {
                            imgUrl = "../../wechat/images/v1/header2.png";
                        }
            %>
                    <li>
                        <div class="invite_l"
                             style="background:url(<%= imgUrl%>) center center no-repeat;background-size:cover;"></div>
                        <div class="inite_r">
                            <p class="inte_name"><%= WechatUtils.displayNullValue(friend.getName())%><span>￥<%= friend.getAmount().setScale(0)%></span>
                            </p>
                            <p class="inte_time"><%= DateUtils.format(friend.getCreateDate(), "yyyy年MM月dd日 HH:mm:ss")%>
                            </p>
                        </div>
                    </li>
            <%
                    }
                }
            %>
        </ul>
    </div>
    <!--Invite_friend_list-->
    <div class="Invite_more" id="Invite_more">展开更多<span></span></div>

    <div class="Invite_friend_number">开始您的预约</div>
    <!--Invite_doctor-->
    <div class="Invite_doctor">
        <ul class="Invite_doctor_list">
            <%
                if (recommendDoctorList != null && recommendDoctorList.size() > 0) {
                    for (JdRecommendDoctorQueryModel doctor : recommendDoctorList) {
            %>
            <li>
                <div class="doctor_pic"
                     style="background:url(<%=doctor.getImgUrl()%>) center center no-repeat;background-size:cover;"></div>
                <div class="invite_doctor_msg">
                    <p class="invite_doctor_name"><%= doctor.getDoctorName()%> | <%= doctor.getTitle()%>
                    </p>

                    <p class="invite_doctor_hos"><%= doctor.getHospital()%>
                    </p>

                    <p class="invite_doctr_title"><%= doctor.getDescription()%>
                    </p>

                    <p class="invite_now"><a onclick="goto('doctor.htm?jd_doctor_id=<%= doctor.getJdDoctorId().toString()%>')">立即预约</a>
                    </p>
                </div>
            </li>
            <%
                    }
                }
            %>

        </ul>
    </div>
    <!--Invite_doctor-->

    <!--intive_gomore-->
    <div class="intive_gomore"><a onclick="toMain()">去橙医生查看更多心脑血管名医</a><span></span></div>
    <!--intive_gomore-->

    <!--intive_logo-->
    <div class="intive_logo"><img src="../../wechat/images/v1/invite_logo.png"></div>
    <!--intive_logo-->
</div>
<!--wrap-->
</body>
<script type="text/javascript">
    sendPageVisit(Page_Constant.Invite);
    var friendsSize = <%=userFriendsCouponList.size()%>;
    if(friendsSize < 3) {
        $("#Invite_more").css("display", "none");
    } else {
        $('#Invite_friend_list').css({'height': '102px', 'overflow': 'hidden'});
    }
    var addPeople = {
        clickbol: true,
        //执行方法
        addon: function () {
            var _this = this;
            $('#Invite_more').on('click', function (ev) {
                if (_this.clickbol == false) {
                    $('#Invite_friend_list').css({'height': '102px', 'overflow': 'hidden'});
                    _this.clickbol = true;
                    $('#Invite_more').html('展开全部<span></span>');
                    $('#Invite_friend_list').attr('all', true);
                } else {
                    _this.clickbol = false;
                    $('#Invite_more').html('收起列表<span class="getup"></span>');
                    $('#Invite_friend_list').css({'height': 'auto', 'overflow': 'auto'});
                }
            });
        }
    };
    addPeople.addon();
</script>
</html>
