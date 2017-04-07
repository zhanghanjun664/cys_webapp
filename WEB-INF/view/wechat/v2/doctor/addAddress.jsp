<%@ page import="cn.aidee.jdoctor.model.wechat.DistrictModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.JdAddressModel" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdDoctorModel" %>
<%@ page import="cn.com.chengyisheng.sys.constant.WebConstants" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdDoctorModel doctorModel = (JdDoctorModel) request.getSession().getAttribute(WebConstants.SESSION_DOCTOR);
    List<DistrictModel> districtList = (List<DistrictModel>)request.getAttribute("districtList");
    JdAddressModel addressModel = (JdAddressModel) request.getAttribute("addressModel");
    boolean addFlag = false;
    if(addressModel == null) {
        addFlag = true;
        addressModel = new JdAddressModel();
    }
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
            <title>编辑出诊地址</title>
    <% } %>
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.animation.css" rel="stylesheet" />
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.icons.css" rel="stylesheet" />
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.frame.css" rel="stylesheet" />
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.scroller.css" rel="stylesheet" />
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<!--  对于从app过来的请求，不显示页面的header -->
<% if (!isReqFromApp) { %>
<header class="fixed topbar">
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit">编辑出诊地址</h3>
</header>
<% } %> 
<!-- topbar end -->

<!-- address edit start -->
<div class="main addr-edit" <% if (isReqFromApp){ %> style="padding-top:0px;" <% } %>>
    <form class="form form-addr-edit" id="form-addr-edit">
        <div class="grid">
            <p>
                <label for="area">所在地区</label>
                <select id="area">
                    <%
                        String defaultDistrict = "";
                        String defaultAreaId = "";
                        for(DistrictModel districtModel : districtList) {
                            if(doctorModel.getJdDistrictId().toString().equals(districtModel.getId())) {
                                defaultDistrict = districtModel.getName();
                                defaultAreaId = districtModel.getChildDistricts().get(0).getId();
                            }
                    %>
                    <optgroup label="<%=districtModel.getName()%>">
                        <%
                            for(DistrictModel childDistrict : districtModel.getChildDistricts()) {
                        %>
                        <option value="<%=childDistrict.getId()%>"><%=childDistrict.getName()%></option>
                        <%
                            }
                        %>
                    </optgroup>
                    <%
                        }
                    %>
                </select>
            </p>
            <p>
                <label for="addr">医院地址</label>
                <input type="text" name="addr" id="addr" placeholder="请输入医院地址" value="<%=WechatUtils.displayNullValue(addressModel.getHospitalAddress())%>"/>
            </p>

            <p>
                <label for="consultation-room">诊室</label>
                <input type="text" name="consultation-room" id="consultation-room" placeholder="请输入诊室信息" value="<%=WechatUtils.displayNullValue(addressModel.getRoom())%>"/>
            </p>
        </div>
        <div class="form-submit">
            <input type="button" value="保存" class="btn-submit" />
        </div>
    </form>
</div>
<!-- address edit end -->
</body>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.core.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.scroller.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.select.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/i18n/mobiscroll.i18n.zh.js"></script>
<script>
    <%
        if(!addFlag) {
    %>
        $('#area').val("<%=addressModel.getJdDistrictAreaId().toString()%>");
    <%
        } else {
    %>
        $('#area').val("<%=defaultAreaId%>");
    <%
        }
    %>
    // 医院所在区域
    $('#area').mobiscroll().select({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        group: {
            groupWheel: true,
            header: false,
            clustered: true
        },
        groupLabel: 'Country',
        fixedWidth: [100, 170],
        setText: '完成',
        onMarkupReady: function (markup) {
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        },
        onSelect: function (valueText, inst) {
            var group = $('#area option[value="' + inst.getVal() + '"]').parent();
            var label = group.attr('label');
            $('#area_dummy').val(label + ' ' + valueText);
        }
    });
    //原有值
    <%
        if(!addFlag) {
    %>
        $('#area').val("<%=addressModel.getJdDistrictAreaId().toString()%>");
        $('#area_dummy').val("<%=addressModel.getAddress().substring(0, 2)%> "  + $('#area_dummy').val());
    <%
        } else {
    %>
        $('#area_dummy').val("<%=defaultDistrict%> " + $('#area_dummy').val());
    <%
        }
    %>
    //保存
    var submitFlag = false;
    $(".btn-submit").on("click", function () {
        if(submitFlag)
            return;
        submitFlag = true;
        var area = $('#area').val();
        var addr = trim($("#addr").val());
        var room = trim($("#consultation-room").val());
        if(area.length == 0) {
            layer.alert("请选择地区", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            submitFlag = false;
            return;
        }
        if(addr.length == 0) {
            layer.alert("请填写医院地址", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            submitFlag = false;
            return;
        }
        if(room.length == 0) {
            layer.alert("请填写诊室信息", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            submitFlag = false;
            return;
        }
        var data = {"area":area, "addr":addr, "room":room};
        <%
            if(!addFlag) {
        %>
            data.id = "<%=addressModel.getUuid().toString()%>";
        <%
            }
        %>
        sendRequest("saveAddress.htm", "POST", data, function(msg) {
            if(msg) {
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                // layer.alert("保存成功", {
                //    title: false,
                //    closeBtn: false
                //}, function () {
                //    layer.closeAll();
                goto("toAddressManage.htm");
                //});
            }
            submitFlag = false;
        }, function () {
            submitFlag = false;
        });
    });
</script>
</html>
