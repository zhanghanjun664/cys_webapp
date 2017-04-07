<%@ page import="cn.aidee.jdoctor.model.JdMedicalRecordQueryModel" %>
<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="cn.aidee.jdoctor.constants.MedicalStatus" %>
<%@ page import="cn.aidee.jdoctor.model.JdSickQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.wechat.WechatUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdMedicalRecordQueryModel medicalRecord = (JdMedicalRecordQueryModel) request.getAttribute("medicalRecord");
    JdPatientModel patient = (JdPatientModel) request.getAttribute("patient");
    List<JdSickQueryModel> sickList = (List<JdSickQueryModel>) request.getAttribute("sickList");
    List<JdSickQueryModel> medicalTags = (List<JdSickQueryModel>) request.getAttribute("medicalTags");
    String wxconfig = (String)request.getAttribute("wxconfig");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <a class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit">病历详情</h3>
    <a href="javascript:void(0);" class="btn-save-expertise">保存</a>
</header>
<!-- topbar end -->

<!-- case detail start -->
<div class="main case-detail form" id="medical-record-info">
    <div class="grid mt-10">
        <p>
            <label>患者</label>
            <input type="text" value="<%=patient.getName()%>(<%=patient.getAge()%>岁)" readonly/>
        </p>

        <p>
            <label>就诊日期</label>
            <input type="text" value="<%=DateUtils.format(medicalRecord.getVisitedDate(), "yyyy-MM-dd")%>" readonly/>
        </p>

        <p>
            <label>医院</label>
            <input type="text" value="<%=medicalRecord.getHospitalName()!=null?medicalRecord.getHospitalName():medicalRecord.getManualHospitalName()%>" readonly/>
        </p>
    </div>
    <h3>病情描述</h3>

    <div class="grid">
        <textarea readonly><%=medicalRecord.getDoctorDiagnosis()%></textarea>
    </div>

    <div class="grid mt-10">
        <p>
            <label>病历</label>
					<span>
                        <%
                            if(medicalRecord.getMedicalRecord() != null && medicalRecord.getRecordStatus().equals(MedicalStatus.AUDITPASS.getValue())) {
                        %>
                        <img src="<%=medicalRecord.getMedicalRecord()%>" onclick="previewImage('<%=medicalRecord.getMedicalRecord()%>')" width="34" height="34"/>
                        <%
                            }
                        %>
					</span>
        </p>

        <p>
            <label>处方单</label>
					<span>
						<%
                            if(medicalRecord.getPrescription() != null && medicalRecord.getPrescriptionStatus().equals(MedicalStatus.AUDITPASS.getValue())) {
                        %>
                        <img src="<%=medicalRecord.getPrescription()%>" onclick="previewImage('<%=medicalRecord.getPrescription()%>')" width="34" height="34"/>
                        <%
                            }
                        %>
					</span>
        </p>

        <p>
            <label>检查报告</label>
					<span>
						<%
                            if(medicalRecord.getMedicalReport() != null && medicalRecord.getReportStatus().equals(MedicalStatus.AUDITPASS.getValue())) {
                                String[] reportsImg = medicalRecord.getMedicalReport().split(";");
                                for(String reportImg : reportsImg) {
                        %>
                                <img src="<%=reportImg%>" onclick="previewImage('<%=reportImg%>')" width="34" height="34"/>
                        <%
                                }
                            }
                        %>
					</span>
        </p>
    </div>

    <div class="grid mt-10">
        <a>疾病标签<input style="width: 72%;padding-left: 10px;text-align: right;border: 0;" value="<%=WechatUtils.showDoctorSkills(medicalTags)%>" type="text" name="expertise" id="expertise" readonly /></a>
    </div>
</div>
<!-- case detail end -->
<!-- disease tag start -->
<div id="page-expertise">
    <div class="main expertise">
        <div class="grid">
            <ul>
                <%
                    for(JdSickQueryModel sick : sickList) {
                        boolean selected = false;
                        for(JdSickQueryModel skill : medicalTags) {
                            if(sick.getUuid().toString().equals(skill.getUuid().toString())) {
                                selected = true;
                                break;
                            }
                        }
                        if(selected) {
                %>
                        <li>
                            <label><%=sick.getName()%></label>
                            <div class="switch-button switch-on">
                                <span class="slider-button on"></span>
                                <input type="hidden" value="<%=sick.getUuid().toString()%>">
                            </div>
                        </li>
                <%
                        } else {
                %>
                        <li>
                            <label><%=sick.getName()%></label>
                            <div class="switch-button switch-off">
                                <span class="slider-button"></span>
                                <input type="hidden" value="<%=sick.getUuid().toString()%>">
                            </div>
                        </li>
                <%
                        }
                    }
                %>
            </ul>
        </div>
    </div>
</div>
<!-- disease tag end -->
</body>
<script src="../../wechat/js/weixin.js" type="text/javascript"></script>
<script>
    var wxconfig = <%=wxconfig%>;
    wx.config({
        debug: false,
        appId: wxconfig.appId,
        timestamp: wxconfig.timestamp,
        nonceStr: wxconfig.nonceStr,
        signature: wxconfig.signature,
        jsApiList: ['previewImage']
    });
    //预览图片
    function previewImage(imgUrl) {
        wx.previewImage({
            current: imgUrl,
            urls: [imgUrl]
        });
    }

    // 转换开关
    $('.slider-button').on('click', function () {
        if ($(this).hasClass('on')) {
            $(this).removeClass('on').parent().removeClass('switch-on').addClass('switch-off');
        } else {
            var switchBtnOn = $('.switch-on');
            if(switchBtnOn.length == 5) {
                layer.msg('最多选择5个');
            } else {
                $(this).addClass('on').parent().removeClass('switch-off').addClass('switch-on');
            }
        }
    });
    // 专长
    $('#expertise').on('click', function(){
        $('.topbar .tit').text('疾病标签');
        $('.btn-save-expertise').show();
        $('#medical-record-info').hide().next().show();
    });
    // 专长保存
    var submitFlag = false;
    $('.btn-save-expertise').on('click', function() {
        if(submitFlag)
            return;
        submitFlag = true;
        var switchBtnOn = $('.switch-on');
        var arr = [];
        var skill = [];
        for(var i=0; i<switchBtnOn.length; i++){
            var item = switchBtnOn.eq(i);
            var label = item.prev().text();
            var val = item.find("input").val();
            arr.push(label);
            skill.push(val);
        }
        $('#expertise').val(arr.join(','));
        $('.topbar .tit').text('病历详情');
        $(this).hide();
        $('#page-expertise').hide().prev().show();

        //提交后台
        var data = {"tags":skill.join(','), "medicalRecordId":"<%=medicalRecord.getUuid().toString()%>", "patientId":"<%=patient.getUuid().toString()%>"};
        sendRequest("saveMedicalTags.htm", "POST", data, function(msg) {
            submitFlag = false;
            if(msg) {
                layer.msg(msg);
            }
        }, function() {
            layer.msg('保存失败');
            submitFlag = false;
        });
    });
</script>
</html>
