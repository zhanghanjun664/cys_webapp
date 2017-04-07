<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdOperationModel" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientQueryModel" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.List" %>
<%
    List<JdPatientQueryModel> contactsList = (List<JdPatientQueryModel>) request.getAttribute("contactsList");
    JdOperationModel operation = (JdOperationModel) request.getAttribute("operation");
    String isOneYuanOperation = (String) request.getAttribute("isOneYuanOperation");
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
        <h2><%=operation == null ? "预约申请" : operation.getName() + "预约详情"%></h2>
    </header>
    <%
        if (operation != null) {
    %>
        <span class="edit pa" id="family_edit" statu="del">删除</span>
    <%
        }
    %>
    <!--header-->

    <!--content-->
    <div class="content addcase_wrap">
        <%
            if (operation == null) {
        %>
        <ul class="list fillorder_list addpeople_list">
            <li class="clearfix pr addpeople" id="fillorderheight">
                <label class="fillorder_title fl">家庭联系人</label>
                <label class="fillorder_input fl clearfix" id="select_order">
                    <%
                        if (contactsList != null && contactsList.size() > 0) {
                            for (JdPatientQueryModel contact : contactsList) {
                    %>
                    <div class="fl order_people"
                         onclick="loadContact('<%=contact.getName()%>','<%=contact.getPhoneNumber()%>','<%=contact.getIdCard()%>')">
                        <%=contact.getName()%>
                    </div>
                    <%
                            }
                        }
                    %>
                </label>
                <span class="pa" id="addpeople" bol="true"></span>
            </li>
        </ul>
        <%
            }
        %>
        <ul class="list case_list addcase opercase">
            <li class="pr clearfix">
                <span class="fl addcase_title"><i class="must"><%=operation == null ? "*" : ""%></i>姓名</span>
                <span class="fl addcase_content">
                    <input type="text" placeholder="请输入姓名" id="name" <%=operation == null ? "":"readonly"%> >
                </span>
                <span class="pa arrow"></span>
            </li>

            <li class="pr clearfix">
                <span class="fl addcase_title"><i class="must"><%=operation == null ? "*" : ""%></i>身份证</span>
                <span class="fl addcase_content">
                    <input type="text" placeholder="请输入身份证" id="idCard" <%=operation == null ? "":"readonly"%>>
                </span>
                <span class="pa arrow" id="idCard_messsage"></span>
            </li>

            <li class="pr clearfix">
                <span class="fl addcase_title"><i class="must"><%=operation == null ? "*" : ""%></i>手机号</span>
                <span class="fl addcase_content">
                    <input type="text" placeholder="请输入手机号" id="phone" <%=operation == null ? "":"readonly"%>>
                </span>
                <span class="pa arrow"></span>
            </li>
        </ul>

        <ul class="list case_list addcase">
            <li class="pr clearfix">
                <span class="fl addcase_title"><i class="must"><%=operation == null ? "*" : ""%></i>预约项目</span>
                <span class="fl addcase_content pr case_sex" id="yyxm">
                	<% if (isOneYuanOperation == null) { %>
                    <i id="yyxm_zy" style="padding-left:0.22rem;padding-right:0.22rem; ">住院</i>
                    <i id="yyxm_ss" style="padding-left:0.22rem;padding-right:0.22rem; ">手术</i>
                    <% } else {%>
                    <i id="yyxm_one" style="padding-left:0.22rem;padding-right:0.22rem; " class="order_people_active">一元手术</i>
                    <% } %>
                </span>
            </li>

            <li class="pr clearfix des_write_wrap">
                <span class="fl addcase_title"><i class="must"><%=operation == null ? "*" : ""%></i>病情描述</span>
                <span class="fl addcase_content pr case_sex">
                    <textarea id="sickDescription" class="des_write" maxlength="100"
                              <%=operation == null ? "":"readonly"%> placeholder="请输入病情描述(1-100字)"></textarea>
                </span>
            </li>

            <li class="pr clearfix">
                <span class="fl addcase_title">预约医院</span>
                <span class="fl addcase_content">
                    <input type="text" placeholder="" id="yyyy" <%=operation == null ? "":"readonly"%>>
                </span>
                <span class="pa arrow"></span>
            </li>

            <li class="pr clearfix">
                <span class="fl addcase_title">预约医生</span>
                <span class="fl addcase_content">
                    <input type="text" placeholder="" id="yyys" <%=operation == null ? "":"readonly"%>>
                </span>
                <span class="pa arrow"></span>
            </li>
        </ul>
    </div>
    <!--content-->
    <%
        if (operation == null) {
    %>
        <div class="fixbtn" onclick="submitOperatorOrderInfo()">提交预约</div>
    <%
        }
    %>
</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.FillOperationOrder);

    var yyxmvalue = "";
    var gender = "";
    var operationt = <%=operation == null ? null : new Gson().toJson(operation)%>;
    if (operationt) {
        $("#name").val(operationt.name);
        $("#idCard").val(operationt.idCard);
        $("#phone").val(operationt.phoneNumber);
        $("#sickDescription").val(operationt.sickDescription);
        $("#yyyy").val(operationt.hospitalName);
        $("#yyys").val(operationt.doctorName);
        if (operationt.type == '住院') {
            $('#yyxm_zy').addClass('order_people_active');
            yyxmvalue = "住院";
        } else if(operationt.type == '手术'){
            $('#yyxm_ss').addClass('order_people_active');
            yyxmvalue = "手术";
        } else if(operationt.type == '一元手术'){
            $('#yyxm_one').addClass('order_people_active');
            yyxmvalue = "一元手术";
        }
    }
    /*判断家庭联系人的高度*/
    if ($('#select_order').height() <= 44) {
        $('#addpeople').css({'display': 'none'});
    }
    /*家庭联系人收起or展开*/
    $('#addpeople').on('click', function (ev) {
        if ($(this).attr('bol') == "true") {
            $('#fillorderheight').css({'height': 'auto'});
            $('#addpeople').addClass('addactive');
            $(this).attr('bol', 'false');
            return;
        }
        if ($(this).attr('bol') == "false") {
            $('#fillorderheight').css({'height': '0.88rem'});
            $('#addpeople').removeClass('addactive');
            $(this).attr('bol', 'true');
        }
    });
    //选中联系人后改变样式
    $('#select_order').on('click', '.order_people', function (ev) {
        $('.order_people').removeClass('order_people_active');
        $('.order_people').eq($(this).index()).addClass('order_people_active');
        ev.stopPropagation();
    });
    //选中联系人后加载信息
    function loadContact(name, phone, idCard) {
        if (name != "null") $("#name").val(name);
        else $("#name").val("");
        if (phone != "null") $("#phone").val(phone);
        else $("#phone").val("");
        if (idCard != "null") $("#idCard").val(idCard);
        else $("#idCard").val("");
    }
    //选中预约项目后改变样式,记录选择
    $('#yyxm_zy').on('click', function (ev) {
        if (operationt == null) {
            $('#yyxm i').removeClass('order_people_active');
            $('#yyxm i').eq($(this).index()).addClass('order_people_active');
            ev.stopPropagation();
            yyxmvalue = "住院";
        }
    });
    $('#yyxm_ss').on('click', function (ev) {
        if (operationt == null) {
            $('#yyxm i').removeClass('order_people_active');
            $('#yyxm i').eq($(this).index()).addClass('order_people_active');
            ev.stopPropagation();
            yyxmvalue = "手术";
        }
    });
    $('#yyxm_one').on('click', function (ev) {
        if (operationt == null) {
            $('#yyxm i').removeClass('order_people_active');
            $('#yyxm i').eq($(this).index()).addClass('order_people_active');
            ev.stopPropagation();
            yyxmvalue = "一元手术";
        }
    });
    function submitOperatorOrderInfo() {
        //判断用户名是否输入
        if (checknull('#name') == false) {
            layer.alert("请输入姓名", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#name').focus();
            });
            return;
        }
        //判断身份证号是否输入
        if (checknull('#idCard') == false) {
            layer.alert("请输入身份证号", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#idCard').focus();
            });
            return;
        }
        //判断手机号是否输入
        if (checknull('#phone') == false) {
            layer.alert("请输入手机号", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#phone').focus();
            });
            return;
        }
        //判断是否输入正确的手机号码
        if (checkregular('#phone', '1') == false) {
            layer.alert("请输入正确的11位数手机号", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#phone').focus();
            });
            return;
        }
        if (yyxmvalue.trim().length == 0) {
            layer.alert("请选择预约项目", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            return;
        }
        //判断病情描述是否输入
        if (checknull('#sickDescription') == false) {
            layer.alert("请输入病情描述", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#sickDescription').focus();
            });
            return;
        }
        var vname = $("#name").val().trim();
        var vidCard = $("#idCard").val().trim();
        var vphone = $("#phone").val().trim();
        var vyyxm = yyxmvalue;
        var sickDescription = $("#sickDescription").val().trim();
        var vyyyy = $("#yyyy").val().trim();
        var vyyys = $("#yyys").val().trim();
        var data = { 'name': vname, 'idCard': vidCard, 'phoneNumber': vphone,
                        'type': vyyxm, 'sickDescription': sickDescription, 'hospitalName': vyyyy, 'doctorName': vyyys };
        //post请求保存数据
        sendRequest("saveOperationOrder.htm", "POST", data, function (result) {
            if (result) {
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
            } else {
                //返回到预约列表
                <%--goto("toOperationOrderList.htm");--%>

                    window.sessionStorage.setItem('cys_through_train',JSON.stringify({
                    'name':vname,
                    'idcard':vidCard,
                    'cell_phone':vphone,
                    'hospital_name':vyyyy,
                    'doctor_name':vyyys
                    }));


                window.location.href='/wechat_web/wap_wechat_patient/html/directTrainConfirm.html';
            }
        });
    }

    //删除预约
    $('#family_edit').on('click', function (ev) {
        layer.confirm("确定要删除预约订单吗?", {
            title: false,
            closeBtn: false,
            btn: ['取消', '确定']
        }, function () {
            layer.closeAll();
        }, function () {
            //删除预约订单post请求
            var data = {"id": operationt.uuid};
            sendRequest("deleteOperationOrder.htm", "POST", data, function (result) {
                if (result) {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    goto('toOperationOrderList.htm');
                }
            });
        });
    });
</script>
</html>
