<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.constants.MedicalStatus" %>
<%@ page import="cn.aidee.jdoctor.model.JdMedicalRecordQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdMedicalRecordQueryModel medicalRecord = (JdMedicalRecordQueryModel) request.getAttribute("medicalRecord");
    JdPatientModel patient = (JdPatientModel) request.getAttribute("patient");
    boolean showEdit = medicalRecord != null;
    String name = medicalRecord == null ? patient.getName() : medicalRecord.getPatientName();
    String patientId = medicalRecord == null ? patient.getUuid().toString() : medicalRecord.getJdPatientId().toString();
    String wxconfig = (String) request.getAttribute("wxconfig");
    boolean hasUploaded = (Boolean) request.getAttribute("hasUploaded");
    boolean canEdit = (Boolean) request.getAttribute("canEdit");
    
    String recordUrl = (medicalRecord!=null&&medicalRecord.getMedicalRecord()!=null)?medicalRecord.getMedicalRecord() : "";
    String prescriptionUrl = (medicalRecord!=null&&medicalRecord.getPrescription()!=null)?medicalRecord.getPrescription() : "";
    String reportImgUrls = (medicalRecord!=null&&medicalRecord.getMedicalReport()!=null)?medicalRecord.getMedicalReport() : "";
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/head.jsp"/>
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.animation.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.frame.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.frame.android-holo.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.scroller.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.scroller.android-holo.css" rel="stylesheet">
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2><%=name%>的病历</h2>
        <%
            if (showEdit && canEdit) {
        %>
            <span class="edit pa" id="caseedit" statu="edit">编辑</span>
        <%
            }
        %>
    </header>
    <!--header-->

    <!--content-->
    <div class="content addcase_wrap">
    <%
        if (medicalRecord != null) {
            boolean readOnly = medicalRecord.getJdOrderId() != null;
    %>
        <ul class="list case_list addcase">
            <li class="pr clearfix">
                <span class="fl addcase_title">医生</span>
                <span class="fl addcase_content">
                    <input type="text" placeholder="请输入医生姓名" id="casename" readonly
                           value="<%=readOnly?medicalRecord.getDoctorName():medicalRecord.getManualDoctorName()%>"
                           maxlength="30">
                </span>
                <span class="pa arrow"></span>
            </li>
            <li class="pr clearfix">
                <span class="fl addcase_title">医院</span>
                <span class="fl addcase_content">
                    <input type="text" placeholder="请输入医院名称" id="casehosname" readonly
                           value="<%=readOnly?medicalRecord.getHospitalName():medicalRecord.getManualHospitalName()%>"
                           maxlength="60">
                </span>
                <span class="pa arrow"></span>
            </li>
            <li class="pr clearfix">
                <span class="fl addcase_title">就诊日期</span>
                <span class="fl addcase_content">
                    <input type="text" readonly placeholder="请选择就诊日期" id="visiting_time" readonly
                           value="<%=DateUtils.format(medicalRecord.getVisitedDate(), "yyyy-MM-dd")%>">
                </span>
                <span class="pa arrow"></span>
            </li>
        </ul>
        <section class="fillcase">
            <div class="fillcase_title">病情描述</div>
            <div class="fillcase_textarea">
                <textarea placeholder="请输入病情描述" id="casetextarea" readonly
                          maxlength="250"><%=medicalRecord.getDoctorDiagnosis()%></textarea>
            </div>
        </section>
    <%
        } else {
    %>
        <div class="content addcase_wrap">
            <ul class="list case_list addcase">
                <li class="pr clearfix">
                    <span class="fl addcase_title">医生</span>
                    <span class="fl addcase_content">
                        <input type="text" placeholder="请输入医生姓名" id="casename">
                    </span>
                    <span class="pa arrow"></span>
                </li>
                <li class="pr clearfix">
                    <span class="fl addcase_title">医院</span>
                    <span class="fl addcase_content">
                        <input type="text" placeholder="请输入医院名称" id="casehosname">
                    </span>
                    <span class="pa arrow"></span>
                </li>
                <li class="pr clearfix">
                    <span class="fl addcase_title">就诊日期</span>
                    <span class="fl addcase_content">
                        <input type="text" readonly placeholder="请选择就诊日期" id="visiting_time">
                    </span>
                    <span class="pa arrow"></span>
                </li>
            </ul>
            <section class="fillcase">
                <div class="fillcase_title">病情描述</div>
                <div class="fillcase_textarea">
                    <textarea placeholder="请输入病情描述" id="casetextarea"></textarea>
                </div>
            </section>
        </div>
    <%
        }
    %>
        <ul class="list case_list addcase addcasepic">
            <li class="pr clearfix">
                <span class="fl addcase_title">病历</span>
                    <span class="fl addcase_content clearfix">
                        <div class="fl uploadpic pr" onclick="uploadRecord()" id="record"></div>
                    </span>

            </li>
            <li class="pr clearfix">
                <span class="fl addcase_title">处方单</span>
                    <span class="fl addcase_content clearfix">
                        <div class="fl uploadpic pr" onclick="uploadPrescription()" id="prescription"></div>
                    </span>
            </li>
            <li class="pr clearfix">
                <span class="fl addcase_title">检查报告</span>
                    <span class="fl addcase_content clearfix">
                        <div class="fl uploadpic pr" id="report1" onclick="uploadReport(1)"></div>
                        <div class="fl uploadpic pr" id="report2" onclick="uploadReport(2)"></div>
                        <div class="fl uploadpic pr" id="report3" onclick="uploadReport(3)"></div>
                    </span>
            </li>
        </ul>
        <div class="fillcase_tit">图片仅供医生查看</div>
    </div>
    <!--content-->
    <div class="fixbtn" style="display:<%=showEdit?"none":""%>" id="casefinish">提交</div>
</div>
<!--wrap-->

<!-- mask start -->
<div class="medical-mask"></div>
<!-- mask end -->
<!-- popup start -->
<div class="medical-popup upload-avatar-wrap">
    <div class="popup-content">
        <a id="previewBtn">预览</a>
        <a id="uploadBtn">重新上传</a>
    </div>
    <div class="popup-bottom">
        <a class="popup-btn-cancel">取消</a>
    </div>
</div>
<!-- popup end -->

</body>
<script src="../../wechat/js/weixin.js" type="text/javascript"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.core.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.scroller.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.util.datetime.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.datetimebase.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.datetime.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.android-holo.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/i18n/mobiscroll.i18n.zh.js"></script>
<script>
    sendPageVisit(Page_Constant.MedicalRecord);

    var wxconfig = <%=wxconfig%>;
    wx.config({
        debug: false,
        appId: wxconfig.appId,
        timestamp: wxconfig.timestamp,
        nonceStr: wxconfig.nonceStr,
        signature: wxconfig.signature,
        jsApiList: ['chooseImage','uploadImage','previewImage']
    });

    var hasUploaded = <%=hasUploaded%>;
    var isNew = <%=medicalRecord == null%>;
    var readOnly = <%=medicalRecord!=null && medicalRecord.getJdOrderId()!=null%>;
    if(isNew) {
        // 日期选择
        var now = new Date();
        $('#visiting_time').mobiscroll().date({
            theme: 'android-holo',
            lang: 'zh',
            dateFormat: 'yy-mm-dd',
            display: 'bottom',
            maxDate: new Date(now.getFullYear(), now.getMonth(), now.getDate())
        });
    }

    /*===================================编辑病历===================================*/
    var editFlag = false;
    $('#caseedit').on('click', function (ev) {
        if ($(this).attr('statu') == "edit") {
            editFlag = true;
            if(hasUploaded) {
                $(this).html('');
            } else {
                $(this).html('删除');
            }
            $(this).attr('statu', 'del');
            // 日期选择
            var now = new Date();
            $('#visiting_time').mobiscroll().date({
                theme: 'android-holo',
                lang: 'zh',
                dateFormat: 'yy-mm-dd',
                display: 'bottom',
                maxDate: new Date(now.getFullYear(), now.getMonth(), now.getDate())
            });
            $('#casename').removeAttr('readonly');
            $('#casehosname').removeAttr('readonly');
            $('#casetextarea').removeAttr('readonly');
            $('#casefinish').css({'display': ''});
            return;
        }
        if ($(this).attr('statu') == "del") {
            if(!hasUploaded) {
                layer.confirm("删除病历将无法恢复，确定要删除?", {
                    title: false,
                    closeBtn: false,
                    btn: ['取消', '确定']
                }, function () {
                    layer.closeAll();
                }, function () {
                    if(recordId) {
                        var data = {"recordId" : recordId};
                        sendRequest("deleteMedicalRecord.htm", "POST", data, function(result) {
                            if(result) {
                                layer.alert(result, {
                                    title: false,
                                    closeBtn: false
                                }, function () {
                                    layer.closeAll();
                                });
                            } else {
                                goto("toMedicalRecordList.htm?patientId=<%=patientId%>");
                            }
                        });
                    }
                    layer.closeAll();
                });
            }
        }
    });
    /*提交病历*/
    var submitFlag = false;
    $('#casefinish').on('click', function (ev) {
        if (checknull('#casename') == false) {
            layer.alert('请输入医生姓名', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#casename').focus();
            });
            return;
        }
        if (checknull('#casehosname') == false) {
            layer.alert('请输入医院名称', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#casehosname').focus();
            });
            return;
        }
        if (checknull('#visiting_time') == false) {
            layer.alert('请选择就诊日期', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if (checknull('#casetextarea') == false) {
            layer.alert('请输入病情描述', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#casetextarea').focus();
            });
            return;
        }
        if(submitFlag)
            return;
        submitFlag = true;
        var doctorName = $.trim($("#casename").val());
        var hospital = $.trim($("#casehosname").val());
        var visitDate = $.trim($("#visiting_time").val());
        var sickDescription = $.trim($("#casetextarea").val());
        var data = {
            "patientId" : "<%=patientId%>",
            "doctorName" : doctorName,
            "hospital" : hospital,
            "visitDate" : visitDate,
            "sickDescription" : sickDescription
        };
        if(recordId)
            data.recordId = recordId;
        if(recordUrl)
            data.recordUrl = recordUrl;
        if(prescriptionUrl)
            data.prescriptionUrl = prescriptionUrl;
        var reportUrl = getReportUrl();
        if(reportUrl)
            data.reportUrl = reportUrl;
        sendRequest("updateMedicalRecord.htm", "POST", data, function(result) {
            if(result) {
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
                submitFlag = false;
            } else {
                layer.alert('保存成功', {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    goto("toMedicalRecordList.htm?patientId=<%=patientId%>");
                });
            }
        }, function() {
            submitFlag = false;
        });
    });

    /*************************** start 上传图片 ***************************/
    $('.medical-mask, .popup-btn-cancel').on('click', closePop);
    function closePop() {
        $('.medical-mask, .upload-avatar-wrap').fadeOut();
        $("#previewBtn").unbind("click");
        $("#uploadBtn").unbind("click");
    }

    var recordId = '<%= medicalRecord == null ? "": medicalRecord.getUuid().toString()%>';
    var recordUrl = '<%=recordUrl%>';
    var prescriptionUrl = '<%=prescriptionUrl%>';
    var reportImgUrls = '<%=reportImgUrls%>';
    
    var reportUrl1,reportUrl2,reportUrl3;
    var isUploadRecord=false, isUploadPrescription=false, isUploadReport1=false, isUploadReport2=false, isUploadReport3=false;
    if(recordUrl) {
        isUploadRecord = true;
        $("#record").css("background", "url(" + recordUrl + ") center center no-repeat").css("background-size","cover");
    }
    if(prescriptionUrl) {
        isUploadPrescription = true;
        $("#prescription").css("background", "url(" + prescriptionUrl + ") center center no-repeat").css("background-size","cover");
    }
    if(reportImgUrls) {
    	reportImgUrls = reportImgUrls.split(";");
        for(var i = 0; i < reportImgUrls.length; i++) {
            if(i == 0) {
                isUploadReport1 = true;
                reportUrl1 = reportImgUrls[i];
                $("#report1").css("background", "url(" + reportUrl1 + ") center center no-repeat").css("background-size","cover");
            } else if(i == 1) {
                isUploadReport2 = true;
                reportUrl2 = reportImgUrls[i];
                $("#report2").css("background", "url(" + reportUrl2 + ") center center no-repeat").css("background-size","cover");
            } else {
                isUploadReport3 = true;
                reportUrl3 = reportImgUrls[i];
                $("#report3").css("background", "url(" + reportUrl3 + ") center center no-repeat").css("background-size","cover");
            }
        }
    }

    //病历
    var canUploadRecord = <%=medicalRecord==null || !MedicalStatus.AUDITPASS.getValue().equals(medicalRecord.getRecordStatus())%>;
    function uploadRecord() {
        if(canUploadRecord) {
            if(isUploadRecord) {
                if(!isNew && !editFlag) {
                    wx.previewImage({
                        current: recordUrl,
                        urls: [recordUrl]
                    });
                } else {
                    $("#previewBtn").bind("click", function(e) {
                        closePop();
                        wx.previewImage({
                            current: recordUrl,
                            urls: [recordUrl]
                        });
                    });
                    $("#uploadBtn").bind("click", showUploadRecord);
                    $('.medical-mask, .upload-avatar-wrap').fadeIn();
                }
            } else if(isNew || editFlag) {
                showUploadRecord();
            }
        } else {
            wx.previewImage({
                current: recordUrl,
                urls: [recordUrl]
            });
        }
    }
    function showUploadRecord() {
        closePop();
        wx.chooseImage({
            count: 1,
            success: function (res) {
                var localIds = res.localIds;
                wx.uploadImage({
                    localId:localIds[0],
                    isShowProgressTips: 1,
                    success: function (res) {
                        var serverId = res.serverId;
                        sendRequest("getImageByType.htm?type=medicalRecord&serverId="+serverId, "GET", function(src) {
                            $("#record").css("background", "url(" + src + ") center center no-repeat").css("background-size","cover");
                            recordUrl = src;
                            isUploadRecord = true;
                        });
                    }
                });
            }
        });
    }

    //处方单
    var canUploadPrescription = <%=medicalRecord==null || !MedicalStatus.AUDITPASS.getValue().equals(medicalRecord.getPrescriptionStatus())%>;
    function uploadPrescription() {
        if(canUploadPrescription) {
            if(isUploadPrescription) {
                if(!isNew && !editFlag) {
                    wx.previewImage({
                        current: prescriptionUrl,
                        urls: [prescriptionUrl]
                    });
                } else {
                    $("#previewBtn").bind("click", function(e) {
                        closePop();
                        wx.previewImage({
                            current: prescriptionUrl,
                            urls: [prescriptionUrl]
                        });
                    });
                    $("#uploadBtn").bind("click", showUploadPrescription);
                    $('.medical-mask, .upload-avatar-wrap').fadeIn();
                }
            } else if(isNew || editFlag) {
                showUploadPrescription();
            }
        } else {
            wx.previewImage({
                current: prescriptionUrl,
                urls: [prescriptionUrl]
            });
        }
    }
    function showUploadPrescription() {
        closePop();
        wx.chooseImage({
            count: 1,
            success: function (res) {
                var localIds = res.localIds;
                wx.uploadImage({
                    localId:localIds[0],
                    isShowProgressTips: 1,
                    success: function (res) {
                        var serverId = res.serverId;
                        sendRequest("getImageByType.htm?type=prescription&serverId="+serverId, "GET", function(src) {
                            $("#prescription").css("background", "url(" + src + ") center center no-repeat").css("background-size","cover");
                            prescriptionUrl = src;
                            isUploadPrescription = true;
                        });
                    }
                });
            }
        });
    }

    //检查报告
    var canUploadReport = <%=medicalRecord==null || !MedicalStatus.AUDITPASS.getValue().equals(medicalRecord.getReportStatus())%>;
    var reportPosition = 0;
    function uploadReport(position) {
        reportPosition = position;
        var tempUrl,tempIsUpload;
        if(position == 1) {
            tempUrl = reportUrl1;
            tempIsUpload = isUploadReport1;
        } else if(position == 2) {
            tempUrl = reportUrl2;
            tempIsUpload = isUploadReport2;
        } else {
            tempUrl = reportUrl3;
            tempIsUpload = isUploadReport3;
        }
        if(canUploadReport) {
            if(tempIsUpload) {
                if(!isNew && !editFlag) {
                    if(tempUrl) {
                        wx.previewImage({
                            current: tempUrl,
                            urls: [tempUrl]
                        });
                    }
                } else {
                    $("#previewBtn").bind("click", function(e) {
                        closePop();
                        wx.previewImage({
                            current: tempUrl,
                            urls: [tempUrl]
                        });
                    });
                    $("#uploadBtn").bind("click", showUploadReport);
                    $('.medical-mask, .upload-avatar-wrap').fadeIn();
                }
            } else if(isNew || editFlag) {
                showUploadReport();
            }
        } else {
            if(tempUrl) {
                wx.previewImage({
                    current: tempUrl,
                    urls: [tempUrl]
                });
            }
        }
    }
    function showUploadReport() {
        closePop();
        wx.chooseImage({
            count: 1,
            success: function (res) {
                var localIds = res.localIds;
                wx.uploadImage({
                    localId:localIds[0],
                    isShowProgressTips: 1,
                    success: function (res) {
                        var serverId = res.serverId;
                        sendRequest("getImageByType.htm?type=medicalReport&serverId="+serverId, "GET", function(src) {
                            if(reportPosition == 1) {
                                $("#report1").css("background", "url(" + src + ") center center no-repeat").css("background-size","cover");
                                reportUrl1 = src;
//                                alert(reportUrl1);
                                isUploadReport1 = true;
                            } else if(reportPosition == 2) {
                                $("#report2").css("background", "url(" + src + ") center center no-repeat").css("background-size","cover");
                                reportUrl2 = src;
                                isUploadReport2 = true;
                            } else {
                                $("#report3").css("background", "url(" + src + ") center center no-repeat").css("background-size","cover");
                                reportUrl3 = src;
                                isUploadReport3 = true;
                            }
                        });
                    }
                });
            }
        });
    }
    //获取检查报告图片组成的url
    function getReportUrl() {
        var url;
        if(reportUrl1)
            url = reportUrl1;
        if(reportUrl2) {
            if(url)
                url += ";" + reportUrl2;
            else
                url = reportUrl2;
        }
        if(reportUrl3) {
            if(url)
                url += ";" + reportUrl3;
            else
                url = reportUrl3;
        }
        return url;
    }
    /*************************** end 上传图片 ***************************/
</script>
</html>
