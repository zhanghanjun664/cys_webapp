<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdPatientModel patientModel = (JdPatientModel) request.getAttribute("patientModel");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <a href="javascript:void(0);" class="back-to-home logo" onclick="backToHome()">返回首页</a>
    <h3 class="tit"><%=patientModel.getName()%></h3>
</header>
<!-- topbar end -->

<!-- patient info start -->
<div class="main patient-info">
    <div class="grid mt-10">
        <a onclick="toHealthInfo()"><i class="ico-health-data"></i>健康数据<em>血压、血糖、心率</em></a>
    </div>

    <div class="grid mt-10">
        <div class="case-hd">
            <h3><i class="ico-tag"></i>TA的病历(<span id="medicalCount">0</span>)</h3>
        </div>
        <ul class="case-list">
        </ul>
    </div>
</div>
<!-- patient info end -->
</body>
<script>
    /*************************** start 患者病历列表 ***************************/
    var pageIndex1 = 1;
    var loadEnd1 = false;
    function asynPatientMedicalList() {
        var data = {"pageIndex":pageIndex1, "patientId":"<%=patientModel.getUuid().toString()%>", "random":Math.random()*10000};
        sendRequest("asynPatientMedicalList.htm", "GET", data, function(resultPage) {
            if(resultPage) {
                if(pageIndex1 == 1)
                    $("#medicalCount").html(resultPage.totalCount);
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var medicalRecord = resultPage.result[i];
                    var tag = new StringBuilder();
                    for(var j = 0, tagLen = medicalRecord.tags.length; j < tagLen; j++) {
                        tag.append('<label>' + medicalRecord.tags[j] + '</label>');
                    }
                    str.append('<li onclick="toMedicalInfo(\''+medicalRecord.uuid+'\')"><a><i class="case-time">'+medicalRecord.visitedDate+'</i>');
                    str.append('<p class="case-desc">病情描述:'+medicalRecord.doctorDiagnosis+'</p><div class="case-tag"><i class="ico-tag"></i>'+tag.toString()+'</div></a></li>');
                }
                $(".case-list").append(str.toString());
                if(pageIndex1 >= resultPage.totalPage) {
                    loadEnd1 = true;
                } else {
                    pageIndex1++;
                }
            }
        });
    }
    asynPatientMedicalList();
    /*************************** end 患者病历列表 ***************************/

    /*************************** start 滚动到底部自动加载患者病历列表 ***************************/
    var totalheight;
    $(window).scroll(function () {
        if(!loadEnd1) {
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() - 20 <= totalheight) {
                asynPatientMedicalList();
            }
        }
    });
    /*************************** end 滚动到底部自动加载患者病历列表 ***************************/

    // 跳转患者详细信息页面
    function toHealthInfo() {
        window.location.href = 'toPatientHealthInfo.htm?patientId=<%=patientModel.getUuid().toString()%>';
    }
    // 跳转患者详细信息页面
    function toMedicalInfo(medicalRecordId) {
        window.location.href = 'toMedicalRecordInfo.htm?medicalRecordId=' + medicalRecordId;
    }
</script>
</html>
