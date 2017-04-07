<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdHealthExaminationQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.JdBloodGlucoseQueryModel" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JdPatientModel patient = (JdPatientModel)request.getAttribute("patientModel");
    List<JdHealthExaminationQueryModel> healthExaminationList = (List<JdHealthExaminationQueryModel>)request.getAttribute("healthExaminationList");
    List<String> healthExaminationCategories = new ArrayList<String>();
    List<Double> systolicPressureData = new ArrayList<Double>();
    List<Double> diastolicPressureData = new ArrayList<Double>();
    List<Double> heartRateData = new ArrayList<Double>();
    BigDecimal healthExaminationLen = new BigDecimal(healthExaminationList.size());
    BigDecimal maxHeartRate = BigDecimal.ZERO;
    BigDecimal minHeartRate = BigDecimal.ZERO;
    BigDecimal sumDiastolicPressure = BigDecimal.ZERO;
    BigDecimal sumSystolicPressure = BigDecimal.ZERO;
    BigDecimal sumHeartRate = BigDecimal.ZERO;
    for(JdHealthExaminationQueryModel healthExamination : healthExaminationList) {
        if(maxHeartRate.intValue() == 0 || maxHeartRate.compareTo(healthExamination.getHeartRate()) == -1) {
            maxHeartRate = healthExamination.getHeartRate();
        }
        if(minHeartRate.intValue() == 0 || minHeartRate.compareTo(healthExamination.getHeartRate()) == 1) {
            minHeartRate = healthExamination.getHeartRate();
        }
        sumDiastolicPressure = sumDiastolicPressure.add(healthExamination.getDiastolicPressure());
        sumSystolicPressure = sumSystolicPressure.add(healthExamination.getSystolicPressure());
        sumHeartRate = sumHeartRate.add(healthExamination.getHeartRate());
        systolicPressureData.add(healthExamination.getSystolicPressure().doubleValue());
        diastolicPressureData.add(healthExamination.getDiastolicPressure().doubleValue());
        heartRateData.add(healthExamination.getHeartRate().doubleValue());
        healthExaminationCategories.add(DateUtils.format(healthExamination.getExamDate(), "时间 yyyy-MM-dd HH:mm"));
    }

    List<JdBloodGlucoseQueryModel> bloodGlucoseList = (List<JdBloodGlucoseQueryModel>)request.getAttribute("bloodGlucoseList");
    List<String> bloodGlucoseCategories = new ArrayList<String>();
    List<Double> bloodGlucoseData = new ArrayList<Double>();
    BigDecimal bloodGlucoseLen = new BigDecimal(bloodGlucoseList.size());
    BigDecimal sumBloodGlucose = BigDecimal.ZERO;
    BigDecimal minBloodGlucose = BigDecimal.ZERO;
    BigDecimal maxBloodGlucose = BigDecimal.ZERO;
    for(JdBloodGlucoseQueryModel bloodGlucose : bloodGlucoseList) {
        if(maxBloodGlucose.intValue() == 0 || maxBloodGlucose.compareTo(bloodGlucose.getBloodGlucose()) == -1) {
            maxBloodGlucose = bloodGlucose.getBloodGlucose();
        }
        if(minBloodGlucose.intValue() == 0 || minBloodGlucose.compareTo(bloodGlucose.getBloodGlucose()) == 1) {
            minBloodGlucose = bloodGlucose.getBloodGlucose();
        }
        sumBloodGlucose = sumBloodGlucose.add(bloodGlucose.getBloodGlucose());
        bloodGlucoseData.add(bloodGlucose.getBloodGlucose().doubleValue());
        bloodGlucoseCategories.add(DateUtils.format(bloodGlucose.getExamDate(), "时间 yyyy-MM-dd HH:mm"));
    }
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
    <h3 class="tit"><%=patient==null?"":patient.getName()%>测量数据</h3>
</header>
<!-- topbar end -->

<!-- main start -->
<div class="tab health-items">
    <div class="tab-tit">
        <a href="javascript:void(0);" class="active">血压和心率</a>
        <a href="javascript:void(0);">血糖</a>
    </div>
    <div class="tab-con">
        <!-- 血压和心率 -->
        <div class="item" style="display:block;">
            <div class="item-info">
                <h3>血压<em class="unit">(mmHg)</em></h3>
                <div class="item-detail clearfix">
                    <p><em>平均值:</em><span id="avgHealthExamination"><%=healthExaminationLen.intValue()==0? 0 : sumSystolicPressure.divide(healthExaminationLen, 1)%>/<%=healthExaminationLen.intValue()==0? 0 : sumDiastolicPressure.divide(healthExaminationLen, 1)%></span></p>
                </div>
            </div>
            <div id="chart-1" style="width:100%; height:200px;"></div>
            <div class="item-info">
                <h3>心率<em class="unit">(b/min)</em></h3>
                <div class="item-detail clearfix">
                    <p><em>平均值:</em><span id="avgHeartRate"><%=healthExaminationLen.intValue()==0? 0 : sumHeartRate.divide(healthExaminationLen, 1)%></span></p>
                    <p><em>最高:</em><span id="maxHeartRate"><%=maxHeartRate.setScale(0)%></span></p>
                    <p><em>最低:</em><span id="minHeartRate"><%=minHeartRate.setScale(0)%></span></p>
                </div>
            </div>
            <div id="chart-2" style="width:100%; height:200px;"></div>
        </div>
        <!-- 血糖 -->
        <div class="item">
            <div class="item-info">
                <h3>血糖<em class="unit">(mmol/L)</em>
                </h3>
                <div class="item-detail clearfix">
                    <p><em>平均值:</em><span id="avgBloodGlucose"><%=bloodGlucoseLen.intValue()==0? 0 : sumBloodGlucose.divide(bloodGlucoseLen, 1)%></span></p>
                    <p><em>最高值:</em><span id="maxBloodGlucose"><%=maxBloodGlucose.setScale(1)%></span></p>
                    <p><em>最低值:</em><span id="minBloodGlucose"><%=minBloodGlucose.setScale(1)%></span></p>
                </div>
            </div>
            <div id="chart-3" style="width:100%; height:280px;"></div>
        </div>
    </div>
</div>
<!-- main end -->
</body>
<script type="text/javascript" src="../../wechat/js/patient_v2/highstock.js"></script>
<script>
    var patientId = "<%=patient.getUuid().toString()%>";
    var healthExaminationCategories = <%=new Gson().toJson(healthExaminationCategories)%>;
    var bloodGlucoseCategories = <%=new Gson().toJson(bloodGlucoseCategories)%>;
    var systolicPressureData = <%=new Gson().toJson(systolicPressureData)%>;
    var diastolicPressureData = <%=new Gson().toJson(diastolicPressureData)%>;
    var heartRateData = <%=new Gson().toJson(heartRateData)%>;
    var bloodGlucoseData = <%=new Gson().toJson(bloodGlucoseData)%>;

    var healthExaminationLen = <%=healthExaminationLen.intValue()%>;
    var sumSystolicPressure = <%=sumSystolicPressure.setScale(2).doubleValue()%>;
    var sumDiastolicPressure = <%=sumDiastolicPressure.setScale(2).doubleValue()%>;
    var sumHeartRate = <%=sumHeartRate.setScale(2).doubleValue()%>;

    var bloodGlucoseLen = <%=bloodGlucoseLen.intValue()%>;
    var sumBloodGlucose = <%=sumBloodGlucose.setScale(2).doubleValue()%>;
    $(function () {
        // tab
        clickTab('.tab-tit a', '.tab-con .item');

        // charts
        $('#chart-1').highcharts({
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            colors: ['#fe875d', '#78cafa'],
            xAxis: {
                categories: healthExaminationCategories,
                labels: {
                    enabled: false
                },
                tickWidth: 0,
                min: 0,
                max: 14
            },
            yAxis: {
                title: {
                    text: null
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }],
                tickPositions: [50, 100, 150, 200, 250]
            },
            legend: {
                verticalAlign: 'top',
                borderWidth: 0
            },
            tooltip: {
                backgroundColor: 'rgba(0,0,0,.5)',
                borderWidth: 0,
                borderRadius: 6,
                shadow: false,
                style: {
                    color: '#fff',
                    padding: '8px'
                },
                shared: true,
                crosshairs: {
                    width: 1,
                    color: 'gray'
                }
            },
            series: [{
                name: '收缩压',
                data: systolicPressureData
            }, {
                name: '舒张压',
                data: diastolicPressureData
            }],
            credits: {
                enabled: false
            }
        });

        $('#chart-2').highcharts({
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            colors: ['#78cafa'],
            xAxis: {
                categories: healthExaminationCategories,
                labels: {
                    enabled: false
                },
                tickWidth: 0,
                min: 0,
                max: 14
            },
            yAxis: {
                title: {
                    text: null
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }],
                tickPositions: [45, 90, 135, 180, 225]
            },
            legend: {
                layout: 'vertical',
                align: 'center',
                verticalAlign: 'top',
                borderWidth: 0
            },
            series: [{
                name: '心率',
                data: heartRateData
            }],
            credits: {
                enabled: false
            },
            tooltip: {
                backgroundColor: 'rgba(0,0,0,.5)',
                borderWidth: 0,
                borderRadius: 6,
                shadow: false,
                style: {
                    color: '#fff',
                    padding: '8px'
                }
            }
        });

        $('#chart-3').highcharts({
            title: {
                text: null
            },
            scrollbar: {
                enabled: true
            },
            colors: ['#fe875d'],
            xAxis: {
                categories: bloodGlucoseCategories,
                labels: {
                    enabled: false
                },
                tickWidth: 0,
                min: 0,
                max: 14
            },
            yAxis: {
                title: {
                    text: null
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }],
                tickPositions: [1.0, 6.0, 11.0, 16.0, 21.0]
            },
            legend: {
                layout: 'vertical',
                align: 'center',
                verticalAlign: 'top',
                borderWidth: 0
            },
            series: [{
                name: '血糖',
                data: bloodGlucoseData
            }],
            credits: {
                enabled: false
            },
            tooltip: {
                backgroundColor: 'rgba(0,0,0,.5)',
                borderWidth: 0,
                borderRadius: 6,
                shadow: false,
                style: {
                    color: '#fff',
                    padding: '8px'
                }
            }
        });

    });
</script>
</html>