<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.aidee.jdoctor.model.JdPatientModel" %>
<%@ page import="com.google.gson.Gson" %>
<%
    JdPatientModel contactInfo = (JdPatientModel) request.getAttribute("contactInfo");
    boolean readonly = contactInfo != null;
    String submitText = "完成";
    String type = (String) request.getAttribute("type");
    if ("medical".equals(type) || "health".equals(type)) {
        submitText = "下一步";
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
            <a onclick="toMain()" alt="返回首页"></a>
        </h1>

        <h2><%=readonly ? contactInfo.getName() : "添加家庭联系人"%>
        </h2>
    </header>
    <!--header-->
    <!--content-->
    <%
        if (readonly) {
    %>
        <span class="edit pa" id="family_edit" statu="edit">编辑</span>
    <%
        }
    %>
    <div class="content addcase_wrap">

        <ul class="list case_list addcase">
            <li class="pr clearfix">
                <span class="fl addcase_title">姓名</span>
							<span class="fl addcase_content">
								<input type="text" placeholder="请输入姓名" id="aname" <%=readonly?"readonly":""%>>
							</span>
                <span class="pa arrow"></span>
            </li>

            <li class="pr clearfix">
                <span class="fl addcase_title">身份证</span>
							<span class="fl addcase_content">
								<input type="text" placeholder="请输入身份证" id="familycard" maxlength="18"
                                    <%=readonly?"readonly":""%>>
							</span>
                <span class="pa arrow"></span>
            </li>

            <li class="pr clearfix">
                <span class="fl addcase_title">性别</span>
							<span class="fl addcase_content pr case_sex" id="family_sex">
								<i>男</i><i>女</i>
							</span>
            </li>

            <li class="pr clearfix">
                <span class="fl addcase_title">年龄</span>
							<span class="fl addcase_content">
								<input type="text" readonly placeholder="与身份证一致" id="familyage" readonly>
							</span>
            </li>

            <li class="pr clearfix">
                <span class="fl addcase_title">手机号</span>
							<span class="fl addcase_content">
								<input type="text" placeholder="请输入手机号" id="aphone" <%=readonly?"readonly":""%>>
							</span>
                <span class="pa arrow"></span>
            </li>
        </ul>


        <section class="fillcase">
            <div class="fillcase_title">病史</div>
            <div class="fillcase_textarea">
                <textarea id="medicalHistory" placeholder="请输入病史" <%=readonly ? "readonly" : ""%>></textarea>
            </div>
        </section>

    </div>
    <!--content-->

    <div class="fixbtn" style="display:<%=readonly?"none":""%>" id="addfamily"><%=submitText%>
    </div>


</div>
<!--wrap-->
</body>
<script>
    sendPageVisit(Page_Constant.AddFamilyContact);

    var contactInfo = <%=contactInfo == null ? null : new Gson().toJson(contactInfo)%>;
    if (contactInfo) {
        $("#aname").val(contactInfo.name);
        $("#familycard").val(contactInfo.idCard);
        $("#familyage").val(contactInfo.age);
        $("#aphone").val(contactInfo.phoneNumber);
        $("#medicalHistory").val(contactInfo.medicalHistory);
        if (contactInfo.gender === "F") {
            $('#family_sex i').css({'color': '#ff8201', 'background': '#fff'});
            $('#family_sex i').eq(1).css({'color': '#fff', 'background': '#ff8303'});
        } else {
            $('#family_sex i').css({'color': '#ff8201', 'background': '#fff'});
            $('#family_sex i').eq(0).css({'color': '#fff', 'background': '#ff8303'});
        }
    }
    $('#familycard').on('input', function (ev) {
        if (checkregular('#familycard', '8')) {
            var UUserCard = $('#familycard').val().trim();
            UUserCard.substring(6, 10) + "-" + UUserCard.substring(10, 12) + "-" + UUserCard.substring(12, 14);
            if (parseInt(UUserCard.substr(16, 1)) % 2 == 1) {
                $('#family_sex i').css({'color': '#ff8201', 'background': '#fff'});
                $('#family_sex i').eq(0).css({'color': '#fff', 'background': '#ff8303'});
            } else {
                $('#family_sex i').css({'color': '#ff8201', 'background': '#fff'});
                $('#family_sex i').eq(1).css({'color': '#fff', 'background': '#ff8303'});
            }
            var myDate = new Date();
            var month = myDate.getMonth() + 1;
            var day = myDate.getDate();
            var age = myDate.getFullYear() - UUserCard.substring(6, 10) - 1;
            if (UUserCard.substring(10, 12) < month || UUserCard.substring(10, 12) == month && UUserCard.substring(12, 14) <= day) {
                age++;
            }
            $('#familyage').val(age);
        }
    });

    $('#addfamily').on('click', function (ev) {
        var type = "<%=type%>";
        var aname = $.trim($('#aname').val());
        var familycard = $.trim($('#familycard').val());
        var aphone = $.trim($("#aphone").val());
        var medicalHistory = $.trim($("#medicalHistory").val());
        //判断是否输入姓名
        if (checknull('#aname') == false) {
            layer.alert('请输入姓名!', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#aname').focus();
            });
            return;
        }
        //判断是否输入身份证号码
        if (checknull('#familycard') == false) {
            layer.alert('请输入身份证号码!', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#familycard').focus();
            });
            return;
        }
        //判断身份证号码是否输入正确
        if (checkregular('#familycard', '8') == false) {
            layer.alert("请输入正确的身份证号码!", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#familycard').focus();
            });
            return;
        }
        //判断是否输入手机号码
        if (checknull('#aphone') == false) {
            layer.alert('请输入正确的11位数手机号!', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#aphone').focus();
            });
            return;
        }
        //判断是否输入正确的手机号码
        if (checkregular('#aphone', '1') == false) {
            layer.alert("请输入正确的11位数手机号!", {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $('#aphone').focus();
            });
            return;
        }

        var data = {
            "name": aname,
            "idCard": familycard,
            "phoneNumber": aphone,
            "medicalHistory": medicalHistory
        };
        if (contactInfo) {
            data.id = contactInfo.uuid;
        }
        //添加成功
        sendRequest("addFamilyContact.htm", "POST", data, function (result) {
            if (result) {
                var info = result.split(";");
                if (info.length === 1) {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                } else {
                    if (type === "medical") {
                        //添加联系人后继续录入病例信息
                        goto("toMedicalRecord.htm?patientId=" + info[1]);
                    } else if (type === "health") {
                        //添加联系人后继续录入健康测量信息
                        goto("toHealthExamination.htm?patientId=" + info[1]);
                    } else {
                        //返回家庭联系人列表
                        goto("toFamilyContact.htm");
                    }
                }
            } else {
                //返回家庭联系人列表
                goto("toFamilyContact.htm");
            }
        });
    });
    $('#family_edit').on('click', function (ev) {
        //点击编辑
        if ($(this).attr('statu') == "edit") {
            /*设置编辑*/
            $('#aname').removeAttr('readonly');
            $('#familycard').removeAttr('readonly');
            $('#aphone').removeAttr('readonly');
            $('#medicalHistory').removeAttr('readonly');

            /*修改状态*/
            $(this).html("删除");
            $('#edit_family').css({'display': 'block'});
            $('#addfamily').css({'display': ''});
            $(this).attr('statu', 'del');
            return;
        }
        //点击删除
        if ($(this).attr('statu') == "del") {
            layer.confirm("将同时删除联系人的病历、健康测量数据，确定要删除?", {
                title: false,
                closeBtn: false,
                btn: ['取消', '确定']
            }, function () {
                layer.closeAll();
            }, function () {
                var data = {"id": contactInfo ? contactInfo.uuid : ""};
                sendRequest("deleteFamilyContact.htm", "POST", data, function (result) {
                    if (result) {
                        layer.alert(result, {
                            title: false,
                            closeBtn: false
                        }, function () {
                            layer.closeAll();
                        });
                    } else {
                        goto("toFamilyContact.htm");
                    }
                });
            });
        }
    });

</script>
</html>
