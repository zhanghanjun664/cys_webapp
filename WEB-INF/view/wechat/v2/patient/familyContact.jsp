<%@ page import="cn.aidee.jdoctor.model.JdPatientQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<JdPatientQueryModel> contactList = (List<JdPatientQueryModel>) request.getAttribute("contactsList");
    int maxNumber = (Integer) request.getAttribute("maxNumber");
    boolean canAddFlag = false;
    if (contactList == null || contactList.size() < maxNumber) {
        canAddFlag = true;
    }
    String title = "家庭联系人";
    String type = (String) request.getAttribute("type");
    if (type != null) {
        if (type.equals("medical")) {
            title = "病历管理";
        } else if (type.equals("health")) {
            title = "健康测量";
        }
    }
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
        <h2><%=title%></h2>
    </header>
    <!--header-->
    <%
        if (contactList == null || contactList.size() == 0) {
    %>
        <div class="content">
            <div class="no_case">
                <p class="no_case_pic"></p>

                <p class="no_case_font">暂无家庭联系人！</p>

                <p>
                    <a class="addfamily btn" onclick="goto('toAddContact.htm?type=<%=type==null?"":type%>')">添加家庭联系人</a>
                </p>
            </div>
        </div>
    <%
        } else {
    %>
        <div class="content content_mt">
            <ul class="list case_list">
                <%
                    String tempHref = "toAddContact.htm?id=";
                    if (type != null) {
                        if (type.equals("medical")) {
                            tempHref = "toMedicalRecordList.htm?patientId=";
                        } else if (type.equals("health")) {
                            tempHref = "toHealthExamination.htm?patientId=";
                        }
                    }
                    for (JdPatientQueryModel patient : contactList) {
                        String href = tempHref + patient.getUuid().toString();
                %>
                    <li onclick="goto('<%=href%>')">
                        <a href="javascript:void(0);" class="pr"><%=patient.getName()%>
                            <span class="pa"></span>
                        </a>
                    </li>
                <%
                    }
                %>
            </ul>
        </div>
        <a class="fixbtn" onclick="addContact()">添加家庭联系人</a>
    <%
        }
    %>
</div>
<!--wrap-->
</body>
<script>
    var canAddFlag = <%=canAddFlag%>;
    var max = <%=maxNumber%>;
    function addContact() {
        if (canAddFlag) {
            goto('toAddContact.htm?type=<%=type==null?"":type%>');
        } else {
            var msg = '家庭联系人不能超过' + max + '个!';
            layer.alert(msg, {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
        }
    }
</script>
</html>
