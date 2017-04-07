<%@ page import="cn.aidee.framework.base.utils.DateUtils" %>
<%@ page import="cn.aidee.jdoctor.model.JdBloodGlucoseQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdHealthExaminationQueryModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Boolean openBloodTab = (Boolean) request.getAttribute("openBloodTab");
    JdPatientModel patient = (JdPatientModel) request.getAttribute("patient");
    List<JdHealthExaminationQueryModel> healthExaminationList = (List<JdHealthExaminationQueryModel>) request.getAttribute("healthExaminationList");
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
    for (JdHealthExaminationQueryModel healthExamination : healthExaminationList) {
        if (maxHeartRate.intValue() == 0 || maxHeartRate.compareTo(healthExamination.getHeartRate()) == -1) {
            maxHeartRate = healthExamination.getHeartRate();
        }
        if (minHeartRate.intValue() == 0 || minHeartRate.compareTo(healthExamination.getHeartRate()) == 1) {
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

    List<JdBloodGlucoseQueryModel> bloodGlucoseList = (List<JdBloodGlucoseQueryModel>) request.getAttribute("bloodGlucoseList");
    List<String> bloodGlucoseCategories = new ArrayList<String>();
    List<Double> bloodGlucoseData = new ArrayList<Double>();
    BigDecimal bloodGlucoseLen = new BigDecimal(bloodGlucoseList.size());
    BigDecimal sumBloodGlucose = BigDecimal.ZERO;
    BigDecimal minBloodGlucose = BigDecimal.ZERO;
    BigDecimal maxBloodGlucose = BigDecimal.ZERO;
    for (JdBloodGlucoseQueryModel bloodGlucose : bloodGlucoseList) {
        if (maxBloodGlucose.intValue() == 0 || maxBloodGlucose.compareTo(bloodGlucose.getBloodGlucose()) == -1) {
            maxBloodGlucose = bloodGlucose.getBloodGlucose();
        }
        if (minBloodGlucose.intValue() == 0 || minBloodGlucose.compareTo(bloodGlucose.getBloodGlucose()) == 1) {
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
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.animation.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.frame.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.frame.android-holo.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.scroller.css" rel="stylesheet">
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.scroller.android-holo.css" rel="stylesheet">
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

        <h2><%=patient==null?"":patient.getName()%></h2>


    </header>
    <!--header-->

    <!--healthtap-->
    <ul class="healthtap borderb clearfix tab_nav">
        <li class="fl pr tabshow_active">血压和心率<b></b></li>
        <li class="fl pr" id="bloodTab">血糖<b></b></li>
    </ul>
    <!--healthtap-->


    <!--content-->
    <div class="content h_wrap borderb bordert">

        <section class="tab_content tab_show">

            <div class="health_title">
                <p>血压<span>(mmHg)</span></p>

                <p>平均值:<span><%=healthExaminationLen.intValue()==0? 0 : sumSystolicPressure.divide(healthExaminationLen, 1)%>/<%=healthExaminationLen.intValue()==0? 0 : sumDiastolicPressure.divide(healthExaminationLen, 1)%></span></p>
            </div>

            <div id="chart-1"></div>

            <div class="health_title">
                <p>心率<span>(b/min)</span></p>

                <p>
                    <i>平均值:<span><%=healthExaminationLen.intValue()==0? 0 : sumHeartRate.divide(healthExaminationLen, 1)%></span></i>
                    <i>最高:<span><%=maxHeartRate.setScale(0)%></span></i>
                    <i>最低:<span><%=minHeartRate.setScale(0)%></span></i>
                </p>
            </div>

            <div id="chart-2"></div>


            <div class="health_footer">
                <a class="fl" onclick="editHealthExamination()">编辑</a>

                <div class="fr" id="record_health">记录血压/心率</div>
            </div>

        </section>

        <section class="tab_content">

            <div class="health_title">
                <p>血糖<span>(mmol/L)</span></p>

                <p>
                    <i>平均值:<span><%=bloodGlucoseLen.intValue()==0? 0 : sumBloodGlucose.divide(bloodGlucoseLen, 2)%></span></i>
                    <i>最高:<span><%=maxBloodGlucose.setScale(2)%></span></i>
                    <i>最低:<span><%=minBloodGlucose.setScale(2)%></span></i>
                </p>
            </div>
            <div id="chart-3"></div>

            <div class="health_footer">
                <a class="fl" onclick="editBloodGlucose()">编辑</a>

                <div class="fr" id="record_bool">记录血糖</div>
            </div>
        </section>

    </div>
    <!--content-->


</div>
<!--wrap-->


<!--pressure_wrap-->
<div class="pressure_wrap">
    <div class="pa sure_wrap">
        <div class="pressure_content">
            <div class="press_input">
                <label>时间</label><input type="text" placeholder="请选择时间" readonly id="heartime">
            </div>

            <div class="press_input">
                <label>收缩率</label>
                <select name="contraction-name" id="contraction-name">
                    <%
                        for(int i=50; i <= 250; i++) {
                            if(i == 100)
                                out.println("<option value=\""+i+"\" selected>"+i+"</option>");
                            else
                                out.println("<option value=\""+i+"\">"+i+"</option>");
                        }
                    %>
                </select>
            </div>

            <div class="press_input">
                <label>舒张压</label>

                <select name="pressure-name" id="pressure-name">
                    <%
                        for(int i=50; i <= 180; i++) {
                            if(i == 80)
                                out.println("<option value=\""+i+"\" selected>"+i+"</option>");
                            else
                                out.println("<option value=\""+i+"\">"+i+"</option>");
                        }
                    %>
                </select>

            </div>

            <div class="press_input">
                <label>心率</label>

                <select name="heartrate_name" id="heartrate_name">
                    <%
                        for(int i=45; i <= 225; i++) {
                            if(i == 80)
                                out.println("<option value=\""+i+"\" selected>"+i+"</option>");
                            else
                                out.println("<option value=\""+i+"\">"+i+"</option>");
                        }
                    %>
                </select>

            </div>

        </div>

        <div class="pressure_btn pa">
            <div class="cancel">取消</div>
            <div id="hearth_ok">确定</div>
        </div>
    </div>
</div>
<!--pressure_wrap-->


<!--pressure_wrap-->
<div class="pressure_wrap">
    <div class="pa sure_wrap">
        <div class="pressure_content">
            <div class="press_input">
                <label>时间</label><input type="text" placeholder="请选择时间" readonly id="booltime">
            </div>

            <div class="press_input">
                <label>血糖</label>
                <select name="blood-name" id="blood-name">
                    <%
                        for(int i=10; i <= 210; i++) {
                            float f = (float)i/10;
                            if(i == 100)
                                out.println("<option value=\""+f+"\" selected>"+f+"</option>");
                            else
                                out.println("<option value=\""+f+"\">"+f+"</option>");
                        }
                    %>
                </select>
            </div>


        </div>

        <div class="pressure_btn pa">
            <div class="cancel">取消</div>
            <div id="bool_ok">确定</div>
        </div>
    </div>
</div>
<!--pressure_wrap-->

</body>
<script type="text/javascript" src="../../wechat/js/patient_v2/highstock.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.core.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.scroller.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.util.datetime.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.datetimebase.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.datetime.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.select.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.android-holo.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/i18n/mobiscroll.i18n.zh.js"></script>
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
            min:0,
            max:14
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


    //时间
    var now = new Date();
    $('#heartime').mobiscroll().datetime({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        maxDate: new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), now.getMinutes()),
        onMarkupReady: function (markup) {
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        }
    });


    // 请选择收缩率
    $('#contraction-name').mobiscroll().select({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        placeholder: '请选择收缩率',
        label: 'contraction-name',
        group: {
            groupWheel: true,
            header: false,
            clustered: true
        },
        setText: '完成',
        onMarkupReady: function (markup) {
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        }
    });


    //舒张压
    $('#pressure-name').mobiscroll().select({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        placeholder: '请选择舒张压',
        label: 'pressure-name',
        group: {
            groupWheel: true,
            header: false,
            clustered: true
        },
        setText: '完成',
        onMarkupReady: function (markup) {
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        }
    });


    //心率
    $('#heartrate_name').mobiscroll().select({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        placeholder: '请选择心率',
        label: 'heartrate_name',
        group: {
            groupWheel: true,
            header: false,
            clustered: true
        },
        setText: '完成',
        onMarkupReady: function (markup) {
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        }
    });


    //血糖

    $('#blood-name').mobiscroll().select({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        placeholder: '请选择血糖',
        label: 'blood-name',
        group: {
            groupWheel: true,
            header: false,
            clustered: true
        },
        setText: '完成',
        onMarkupReady: function (markup) {
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        }
    });

    //血糖时间

    $('#booltime').mobiscroll().datetime({
        theme: 'mobiscroll',
        lang: 'zh',
        display: 'bottom',
        maxDate: new Date(now.getFullYear(), now.getMonth(), now.getDate(), now.getHours(), now.getMinutes()),
        onMarkupReady: function (markup) {
            $('.dwbc', markup).insertBefore($('.dwcc', markup));
        }
    });


    $('#record_health').on('click', function (ev) {
        $('.pressure_wrap').eq(0).css({'display': 'block'});
    });


    $('.cancel').on('click', function (ev) {
        $('.pressure_wrap').css({'display': 'none'});
    });
//血压和心率
    $('#hearth_ok').on('click', function (ev) {
        var time =$("#heartime").val();
        var systolicPressure =$("#contraction-name").val();
        var diastolicPressure = $("#pressure-name").val();
        var heartRate= $("#heartrate_name").val();
        //判断时间是否输入
        if (checknull("#heartime") == false) {
            layer.alert("请选择时间", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if (checknull("#contraction-name") == false) {
            layer.alert("请选择收缩压", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if (checknull("#pressure-name") == false) {
            layer.alert("请选择舒张压", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if (checknull("#heartrate_name") == false) {
            layer.alert("请选择心率", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        var data = {"patientId":patientId, "time":time, "diastolicPressure":diastolicPressure, "systolicPressure":systolicPressure, "heartRate":heartRate};
        sendRequest("addHealthExamination.htm", "POST", data, function (msg) {
            if (msg) {
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                window.location.reload();
            }
        });
    });
//记录血糖确认
    $('#record_bool').on('click', function (ev) {
        $('.pressure_wrap').eq(1).css({'display': 'block'});

    });
    $('#bool_ok').on('click', function (ev) {
        var bloodTime = $("#booltime").val();
        var bloodGlucose = $("#blood-name").val();
        if (checknull("#booltime") == false) {
            layer.alert("请选择时间", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        if (checknull("#blood-name") == false) {
            layer.alert("请选择血糖值", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        var data = {"patientId":patientId, "time":bloodTime, "bloodGlucose":bloodGlucose};
        sendRequest("addBloodGlucose.htm", "POST", data, function (msg) {
            if (msg) {
                layer.alert(msg, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                window.location.reload();
            }
        });
    });

  //tab切换

    $('.tab_nav').on('click', 'li', function (ev) {
        $('.tab_nav li').removeClass('tabshow_active');
        $('.tab_nav li').eq($(this).index()).addClass('tabshow_active');
        $('.tab_content').removeClass('tab_show');
        $('.tab_content').eq($(this).index()).addClass('tab_show');
    });
    var openBloodTab = <%=openBloodTab%>;
    if(openBloodTab) {
        $("#bloodTab").click();
    }
    //跳转编辑
    function editHealthExamination() {
        goto('toEditHealthExamination.htm?patientId='+patientId);
    }
    function editBloodGlucose() {
        goto('toEditHealthExamination.htm?type=bloodGlucose&patientId='+patientId);
    }
</script>
</html>
