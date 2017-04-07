<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdBloodGlucoseQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdHealthExaminationQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdPatientModel patient = (JdPatientModel) request.getAttribute("patient");
    List<JdHealthExaminationQueryModel> healthExaminationList = (List<JdHealthExaminationQueryModel>) request.getAttribute("healthExaminationList");
    List<JdBloodGlucoseQueryModel> bloodGlucoseList = (List<JdBloodGlucoseQueryModel>) request.getAttribute("bloodGlucoseList");
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
        <h2>
            <!-- <%=patient == null ? "" : patient.getName()%>-->
            <%=bloodGlucoseList == null ? "编辑血压和心率记录" : "编辑血糖"%>
        </h2>
    </header>
    <!--header-->
    <%
        if (bloodGlucoseList != null) {
    %>
    <!--content-->
    <div class="content edit_he" id="health_heart">
        <%
            for (JdBloodGlucoseQueryModel bloodGlucose : bloodGlucoseList) {
        %>
        <ul class="health_list borderb bordert">
            <li class="health_list_title clearfix pr">
                <span class="fl"><%=DateUtils.format(bloodGlucose.getExamDate(), "yyyy-MM-dd HH:mm")%></span>
                <i class="pa" onclick="delBloodGlucose(this, '<%=bloodGlucose.getUuid().toString()%>')"></i>
            </li>
            <li class="h_list_content">
                <p class="clearfix">
                    <span class="fl">血糖</span>
                    <i class="fr">
                        <small><%=bloodGlucose.getBloodGlucose().setScale(2)%>
                        </small>
                        mmol/L</i>
                </p>

            </li>
        </ul>
        <%
            }
        %>
    </div>
    <!--content-->
    <%
        }
        if (healthExaminationList != null) {
    %>
    <div class="content edit_he" id="health_heart">
    <%
            for (JdHealthExaminationQueryModel healthExamination : healthExaminationList) {
    %>
            <ul class="health_list borderb bordert">

                <li class="health_list_title clearfix pr">
                    <span class="fl"><%=DateUtils.format(healthExamination.getExamDate(), "yyyy-MM-dd HH:mm")%></span>
                    <i class="pa" onclick="delHealthExamination(this, '<%=healthExamination.getUuid().toString()%>')"></i>
                </li>
                <li class="h_list_content">
                    <p class="clearfix">
                        <span class="fl">收缩压</span>
                        <i class="fr">
                            <small><%=healthExamination.getSystolicPressure().setScale(2)%>
                            </small>
                            mmHg</i>
                    </p>
                    <p class="clearfix">
                        <span class="fl">舒张压</span>
                        <i class="fr">
                            <small><%=healthExamination.getDiastolicPressure().setScale(2)%>
                            </small>
                            mmHg</i>
                    </p>
                    <p class="clearfix">
                        <span class="fl">心率</span>
                        <i class="fr">
                            <small><%=healthExamination.getHeartRate().setScale(0)%>
                            </small>
                            b/min</i>
                    </p>
                </li>
            </ul>
    <%
            }
    %>
    </div>
    <%
        }
    %>
    <a class="fixbtn"
       onclick="goto('toHealthExamination.htm?patientId=<%=patient == null ? "" : patient.getUuid().toString()%>')">完成</a>
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.EditHealthMeasurment);
    /*===================================编辑心率===================================*/
    function delHealthExamination(target, id) {
        var _this = $(target);
        layer.confirm("确定删除此条血压心率数据吗？", {
            title: false,
            closeBtn: false,
            btn: ['取消', '确定']
        }, function () {
            layer.closeAll();
        }, function () {
            var data = {"id": id};
            sendRequest("deleteHealthExamination.htm", "POST", data, function (result) {
                if (result) {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    _this.parent().parent().remove();
                    layer.closeAll();
                }
            });
        });

    }
    /*===================================编辑血糖===================================*/
    function delBloodGlucose(target, id) {

        var _this = $(target);

        layer.confirm("确定删除此条血糖数据吗？", {
            title: false,
            closeBtn: false,
            btn: ['取消', '确定']
        }, function () {
            layer.closeAll();
        }, function () {
            var data = {"id": id};
            sendRequest("deleteBloodGlucose.htm", "POST", data, function (result) {
                if (result) {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    _this.parent().parent().remove();
                    layer.closeAll();
                }
            });
        });
    }
</script>
</html>
