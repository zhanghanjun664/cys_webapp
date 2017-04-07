<%@ page import="cn.aidee.jdoctor.constants.MedicalStatus" %>
<%@ page import="cn.aidee.jdoctor.model.JdMedicalRecordModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdOrderQueryModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdOrderQueryModel order = (JdOrderQueryModel) request.getAttribute("order");
    String wxconfig = (String)request.getAttribute("wxconfig");
    JdMedicalRecordModel medicalRecord = (JdMedicalRecordModel)request.getAttribute("medicalRecord");
    String recordUrl = (medicalRecord!=null&&medicalRecord.getMedicalRecord()!=null)?medicalRecord.getMedicalRecord() : "";
    String prescriptionUrl = (medicalRecord!=null&&medicalRecord.getPrescription()!=null)?medicalRecord.getPrescription() : "";
    String reportImgUrls = (medicalRecord!=null&&medicalRecord.getMedicalReport()!=null)?medicalRecord.getMedicalReport() : "";
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">
    <!--header-->
    <header class="header pr">
        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>
        <h2>评价</h2>
        <div class="header_logo pa">
            <a onclick="toPersonal()" class="mine_center pa"></a>
        </div>
    </header>
    <!--header-->

    <!--content-->
    <div class="content eval_wrap">
        <dl class="eval_doctor clearfix">
            <dt class="fl">
                <span style="background:url(<%=order.getDocHeadPic()%>) center center no-repeat;background-size:cover;"></span>
            </dt>
            <dd class="fl">
                <p><%=order.getDoctor()%> 丨 <%=order.getTitle()%></p>
                <p><%=order.getAppointmentAddress()%></p>
            </dd>
        </dl>
        <%--<%--%>
            <%--if(medicalRecord != null) {--%>
        <%--%>--%>
            <%--<ul class="list case_list addcase addcasepic">--%>
                <%--<li class="pr clearfix">--%>
                    <%--<span class="fl addcase_title">病历</span>--%>
                    <%--<span class="fl addcase_content clearfix">--%>
                        <%--<div class="fl uploadpic pr" onclick="uploadRecord()" id="record"></div>--%>
                    <%--</span>--%>

                <%--</li>--%>
                <%--<li class="pr clearfix">--%>
                    <%--<span class="fl addcase_title">处方单</span>--%>
                    <%--<span class="fl addcase_content clearfix">--%>
                        <%--<div class="fl uploadpic pr" onclick="uploadPrescription()" id="prescription"></div>--%>
                    <%--</span>--%>
                <%--</li>--%>
                <%--<li class="pr clearfix">--%>
                    <%--<span class="fl addcase_title">检查报告</span>--%>
                    <%--<span class="fl addcase_content clearfix">--%>
                        <%--<div class="fl uploadpic pr" id="report1" onclick="uploadReport(1)"></div>--%>
                        <%--<div class="fl uploadpic pr" id="report2" onclick="uploadReport(2)"></div>--%>
                        <%--<div class="fl uploadpic pr" id="report3" onclick="uploadReport(3)"></div>--%>
                    <%--</span>--%>
                <%--</li>--%>
            <%--</ul>--%>
            <%--<div class="fillcase_tit">图片仅供医生查看，每项审核通过可获<i style="color: #ff8600;font-size: 0.28rem;">￥30</i>现金劵</div>--%>
        <%--<%--%>
            <%--}--%>
        <%--%>--%>
        <ul class="list case_list addcase addcasepic evalution_mt">
            <li class="pr clearfix" style="font-size: 10px;">
                <span class="fl addcase_title">服务态度</span>
                <span class="fl addcase_content clearfix">
                    <span class="raty fl start eval_start" id="service"></span>
                </span>
            </li>
            <li class="pr clearfix" style="font-size: 10px;">
                <span class="fl addcase_title">专业度</span>
                <span class="fl addcase_content clearfix">
                    <span class="raty fl start eval_start"></span>
                </span>
            </li>
            <li class="pr clearfix">
                <span class="fl addcase_title">排队时间</span>
                <span class="fl addcase_content clearfix ">
                    <i class="fl queuing" onclick="ChooseOpt.chooseHalfDatetp(this);" value="0">无等待</i>
                    <i class="fl queuing" onclick="ChooseOpt.chooseHalfDatetp(this);" value="10">5-30分钟</i>
                    <i class="fl queuing" onclick="ChooseOpt.chooseHalfDatetp(this);" value="20">>30分钟</i>
                </span>
            </li>
            <li class="pr clearfix">
                <textarea id="comment" class="eval_textarea" placeholder="写下您的就医体验及对医生的评价，不少于20个字。" style="height: 2.5rem;"></textarea>
            </li>
        </ul>
    </div>
    <!--content-->

    <!--fnfooter-->
    <footer class="fnfooter clearfix">
        <a onclick="submitComment();" class="fr again">提交评论</a>
    </footer>
    <!--fnfooter-->
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
<script src="../../wechat/js/jquery.raty.js" type="text/javascript"></script>
<script>
    sendPageVisit(Page_Constant.CommentOrderDetail);

    var wxconfig = <%=wxconfig%>;
    wx.config({
        debug: false,
        appId: wxconfig.appId,
        timestamp: wxconfig.timestamp,
        nonceStr: wxconfig.nonceStr,
        signature: wxconfig.signature,
        jsApiList: ['chooseImage','uploadImage','previewImage']
    });

    /*************************** start 上传图片 ***************************/
    $('.medical-mask, .popup-btn-cancel').on('click', closePop);
    function closePop() {
        $('.medical-mask, .upload-avatar-wrap').fadeOut();
        $("#previewBtn").unbind("click");
        $("#uploadBtn").unbind("click");
    }

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
    var canUploadRecord = <%=medicalRecord!=null && !MedicalStatus.AUDITPASS.getValue().equals(medicalRecord.getRecordStatus())%>;
    function uploadRecord() {
        if(canUploadRecord) {
            if(isUploadRecord) {
                $("#previewBtn").bind("click", function(e) {
                    closePop();
                    wx.previewImage({
                        current: recordUrl,
                        urls: [recordUrl]
                    });
                });
                $("#uploadBtn").bind("click", showUploadRecord);
                $('.medical-mask, .upload-avatar-wrap').fadeIn();
            } else {
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
    var canUploadPrescription = <%=medicalRecord!=null && !MedicalStatus.AUDITPASS.getValue().equals(medicalRecord.getPrescriptionStatus())%>;
    function uploadPrescription() {
        if(canUploadPrescription) {
            if(isUploadPrescription) {
                $("#previewBtn").bind("click", function(e) {
                    closePop();
                    wx.previewImage({
                        current: prescriptionUrl,
                        urls: [prescriptionUrl]
                    });
                });
                $("#uploadBtn").bind("click", showUploadPrescription);
                $('.medical-mask, .upload-avatar-wrap').fadeIn();
            } else {
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
    var canUploadReport = <%=medicalRecord!=null && !MedicalStatus.AUDITPASS.getValue().equals(medicalRecord.getReportStatus())%>;
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
                $("#previewBtn").bind("click", function(e) {
                    closePop();
                    wx.previewImage({
                        current: tempUrl,
                        urls: [tempUrl]
                    });
                });
                $("#uploadBtn").bind("click", showUploadReport);
                $('.medical-mask, .upload-avatar-wrap').fadeIn();
            } else {
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

    //评分
    $('.raty').each(function(){
        $(this).raty({
            starOff: '../../wechat/images/v2/star.png',
            starOn: '../../wechat/images/v2/star_on.png',
            click: function (score, evt) {
                if($(this).attr("id") == "service") {
                    serviceStars = score;
                } else {
                    professionStars = score;
                }
            }
        });
    });

    //排队时间事件
    var ChooseOpt = {
        chooseHalfDatetp:function(ob){
            $(".queuing").removeClass('order_people_active');
            $(ob).addClass('order_people_active');
            waitTime = $(ob).attr('value');
        }
    };

    //提交评论
    var submitFlag = false;
    var serviceStars,professionStars,waitTime;
    function submitComment() {
        if(!serviceStars) {
            layer.alert("请评价服务态度", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if(!professionStars) {
            layer.alert("请评价专业度", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if(!waitTime) {
            layer.alert("请评价排队时间", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        var comment = $.trim($('#comment').val());
        if(comment.length < 20) {
            layer.alert("评价内容不能少于20个字", {
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
        var data = {"orderId":"<%=order.getUuid().toString()%>", "serviceStars":serviceStars, "professionStars":professionStars,
            "waitTime":waitTime, "comment":comment};
        if(recordUrl)
            data.recordUrl = recordUrl;
        if(prescriptionUrl)
            data.prescriptionUrl = prescriptionUrl;
        var reportUrl = getReportUrl();
        if(reportUrl)
            data.reportUrl = reportUrl;
        sendRequest("submitComment.htm", "POST", data, function(result) {
            if(result) {
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                    goto("toOrderList.htm?status=0");
                });
            }
        }, function() {
            submitFlag = false;
        });
    }
</script>
</html>
