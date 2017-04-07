<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdMedicalRecordQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<JdMedicalRecordQueryModel> medicalRecordList = (List<JdMedicalRecordQueryModel>) request.getAttribute("medicalRecordList");
    String name = (String) request.getAttribute("name");
    String patientId = (String) request.getAttribute("patientId");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/head.jsp"/>
</head>
<body>
<!--wrap-->
<div class="wrap">

    <!--header-->
    <header class="header pr">

        <h1 class="logo pa">
            <a onclick="toMain()"></a>
        </h1>

        <h2><%=name==null?"":name%>病历</h2>


    </header>
    <!--header-->


    <!--content-->
    <div class="content content_mt">
        <ul class="minecase">
            <%
                if(medicalRecordList != null) {
                    for(JdMedicalRecordQueryModel medicalRecord : medicalRecordList) {
            %>
            <li class="pr">
                <a onclick="goto('toMedicalRecord.htm?recordId=<%=medicalRecord.getUuid().toString()%>')">
                    <p class="minecase_title"><%=DateUtils.format(medicalRecord.getVisitedDate(), "yyyy-MM-dd")%>      <%=medicalRecord.getJdOrderId()!=null?medicalRecord.getDoctorName():medicalRecord.getManualDoctorName()%></p>
                    <p class="minecase_content">病情描述：<%=medicalRecord.getDoctorDiagnosis()%></p>
                </a>
                <span class="pa arrow"></span>
            </li>
            <%
                    }
                }
            %>
        </ul>
    </div>
    <!--content-->
</div>
<!--wrap-->

<a class="fixbtn" onclick="goto('toMedicalRecord.htm?patientId=<%=patientId%>')">添加</a>
</body>
</html>
