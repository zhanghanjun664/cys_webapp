<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Boolean recordLogin = (Boolean) request.getAttribute("recordLogin");
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
        <h2>住院直通车</h2>
        <span class="edit pa" onclick="goto('toOperationOrderList.htm')">预约记录</span>
    </header>
    <!--header-->
    <!--content-->
    <div class="content oper_wrap">
        <!--oper_in-->
        <section class="oper_in">
            直通车是橙医生联合知名三甲医院推出的名医手术申请的快速通道。橙医生团队将协助患者整理入院资料、与医生沟通。便捷获取权威医生意见、名医手术治疗、快捷排队住院等，缩短就医流程，减少反复奔波的花费。
        </section>
        <!--oper_in-->
        <!--submitdata-->
        <section class="submitdata pr">
            <div class="submitdata_line pa"></div>
            <div class="op_one">
                <div class="op_title"><i class="opnumber">1</i>提交资料</div>
                <div class="op_content"><span>患者完成资料提交后，橙医生团队将联系患者了解病情和整理入院资料。</span></div>
            </div>
            <div class="op_one">
                <div class="op_title"><i class="opnumber">2</i>专家诊断</div>
                <div class="op_content"><span>患者资料完备后，专家将给出诊疗建议，符合住院直通车要求的患者安排办理入院，未确诊或不符合的可根据患者意愿预约专家面诊。</span></div>
            </div>
            <div class="op_one">
                <div class="op_title"><i class="opnumber">3</i>办理住院</div>
                <div class="op_content border_none"><span>入院具备手术条件后，安排专家手术。</span></div>
            </div>
        </section>
        <!--submitdata-->

        <!--cooper_hospital-->
        <section class="cooper_hospital">
            <div class="cooper_title">部分合作医院：</div>
            <ul class="cooper_hoslist">
                <li>首都医科大学附属北京安贞医院</li>
                <li>中国医学科学院阜外心血管病医院</li>
                <li>中国人民解放军总医院（301医院）</li>
                <li>首都医科大学宣武医院</li>
                <li>首都医科大学附属北京朝阳医院</li>
                <li>首都医科大学附属北京天坛医院</li>
                <li>首都医科大学附属北京同仁医院</li>
                <li>北京大学第一医院</li>
                <li>北京大学人民医院</li>
                <li>上海复旦大学附属中山医院</li>
                <li>上海交通大学附属瑞金医院</li>
                <li>第二军医大学长征医院</li>
                <li>广东省人民医院</li>
                <li>广东省中医院</li>
                <li>中山大学附属第一医院</li>
                <li>广州军区总医院</li>
                <li>南方医科大学南方医院</li>
                <li>暨南大学附属第一医院（华侨医院）</li>
                <li>浙江省人民医院</li>
                <li>浙江大学医学院附属第一医院</li>
                <li>浙江大学医学院附属第二医院</li>
                <li>浙江省儿童医院</li>
            </ul>
        </section>
        <!--cooper_hospital-->
    </div>
    <!--content-->
    <div class="fixbtn" onclick="goto('toFillOperationOrder.htm')">我要预约</div>
</div>
<!--wrap-->
</body>
<script>
    var recordLogin = <%=recordLogin%>;
    if(recordLogin) {
        sendPageVisit(Page_Constant.Operation, true);
    } else {
        sendPageVisit(Page_Constant.Operation);
    }
</script>
</html>