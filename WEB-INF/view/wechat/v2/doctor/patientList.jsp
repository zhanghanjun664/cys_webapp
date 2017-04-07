<%@ page import="cn.aidee.jdoctor.model.JdSickQueryModel" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<JdSickQueryModel> doctorMedicalTags = (List<JdSickQueryModel>) request.getAttribute("doctorMedicalTags");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar topbar-search">
    <a href="javascript:void(0);" class="back-to-home logo" onclick="backToHome()">返回首页</a>

    <div class="search-box">
        <input type="button" class="btn-search"/>
        <input type="text" id="search-txt" placeholder="患者姓名/疾病类型"/>
    </div>
    <a href="javascript:void(0);" class="btn-cancel">取消</a>
</header>
<!-- topbar end -->

<!-- my patient start -->
<div class="main my-patient">
    <div class="tab">
        <div class="tab-tit">
            <a id="timeTab" href="javascript:void(0);" class="active">就诊时间</a>
            <a id="nameTab" href="javascript:void(0);">姓名排序</a>
            <a href="javascript:void(0);">疾病类型<i class="arrow-down"></i></a>
        </div>

        <div class="tab-con">
            <!-- 就诊时间 -->
            <div class="visit-time">
                <ul id="timePatientList"></ul>
            </div>
            <!-- 姓名排序 -->
            <div class="visit-time" style="display:none;">
                <ul id="namePatientList"></ul>
            </div>
            <!-- 疾病类型 -->
            <div class="disease-type" style="display:none;">
                <div class="dis-type-column">
                    <%
                        if(doctorMedicalTags != null) {
                            for(JdSickQueryModel tag : doctorMedicalTags) {
                    %>
                            <label class="tag" id="<%=tag.getUuid().toString()%>"><%=tag.getName()%></label>
                    <%
                            }
                        }
                    %>
                </div>
                <%
                    if(doctorMedicalTags.size() > 0) {
                %>
                        <a onclick="selectDisease()" class="fixed btn-addr-new">确定</a>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</div>
<!-- my patient end -->

<!-- mask start -->
<div class="mask"></div>
<!-- mask end -->
</body>
<script>
    // search
    $('#search-txt').on('focus', function () {
        $(this).parent().animate({
            width: '82%',
            marginLeft: '-48%'
        }, 600);
        $('.mask').fadeIn();
        $('.btn-cancel').show();
    });
    $('.mask, .btn-cancel').on('click', function () {
        $('#search-txt').parent().animate({
            width: '50%',
            marginLeft: '-25%'
        }, 600);
        $('.mask').fadeOut();
        $('.btn-cancel').hide();
    });
    var searchKey;
    //回车触发关键字搜索
    document.onkeydown = function (event) {
        if (event.keyCode == 13) {
            event.preventDefault();
            searchKey = $('#search-txt').val();
            asynTimePatientList(true);
            asynNamePatientList(true);
            $('.btn-cancel').click();
        }
    };

    // tab
    function clickPatientTab(tab, con) {
        $(tab).each(function (i) {
            $(this).click(function () {
                preTab = currentTab;
                if(tagChange) {
                    tagChange = false;
                    asynTimePatientList(true);
                    asynNamePatientList(true);
                }
                $(this).addClass("active").siblings(tab).removeClass("active");
                $(con).eq(i).show().siblings(con).hide();
                currentTab = $(this).attr("id");
                return false;
            })
        })
    }
    var preTab = "";
    var currentTab = "timeTab";
    clickPatientTab('.tab-tit a', '.tab-con > div');

    //疾病点击
    var tagChange = false;
    var tagArray = [];
    $(".tag").on('click', function () {
        tagChange = true;
        var id = $(this).attr("id");
        if($(this).hasClass("type-selected")) {
            $(this).removeClass("type-selected");
            var index = arraySearch(tagArray, id);
            tagArray.splice(index, 1);
        } else {
            $(this).addClass("type-selected");
            tagArray.push(id);
        }
    });

    //疾病选择确定
    function selectDisease() {
        $("#"+preTab).click();
    }
    /*************************** start 患者时间排序列表 ***************************/
    var pageIndex1 = 1;
    var loadEnd1 = false;
    function asynTimePatientList(refresh) {
        if(refresh) {
            $("#timePatientList").html("");
            pageIndex1 = 1;
            loadEnd1 = false;
        }
        var data = {"pageIndex":pageIndex1, "searchKey":searchKey, "tags":tagArray.join(","), "random":Math.random()*10000};
        sendRequest("asynPatientListByPaging.htm", "GET", data, function(resultPage) {
            if(resultPage) {
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var patient = resultPage.result[i];
                    str.append('<li onclick="toPatientInfo(\''+patient.uuid+'\')"><a><h3>'+patient.name+' ('+patient.age+'岁)</h3>');
                    var lastVisited = patient.lastVisitedDate;
                    if(!lastVisited) {
                        lastVisited = "无";
                    }
                    str.append('<p>最近就诊时间:'+lastVisited+'</p></a></li>');
                }
                $("#timePatientList").append(str.toString());
                if(pageIndex1 >= resultPage.totalPage) {
                    loadEnd1 = true;
                } else {
                    pageIndex1++;
                }
            }
        });
    }
    asynTimePatientList();
    /*************************** end 患者时间排序列表 ***************************/

    /*************************** start 患者姓名排序列表 ***************************/
    var pageIndex2 = 1;
    var loadEnd2 = false;
    function asynNamePatientList(refresh) {
        if(refresh) {
            $("#namePatientList").html("");
            pageIndex2 = 1;
            loadEnd2 = false;
        }
        var data = {"pageIndex":pageIndex2, "searchKey":searchKey, "orderBy":"name", "tags":tagArray.join(","), "random":Math.random()*10000};
        sendRequest("asynPatientListByPaging.htm", "GET", data, function(resultPage) {
            if(resultPage) {
                var str = new StringBuilder();
                for(var i = 0, len = resultPage.result.length; i < len; i++) {
                    var patient = resultPage.result[i];
                    str.append('<li onclick="toPatientInfo(\''+patient.uuid+'\')"><a><h3>'+patient.name+' ('+patient.age+'岁)</h3>');
                    var lastVisited = patient.lastVisitedDate;
                    if(!lastVisited) {
                        lastVisited = "无";
                    }
                    str.append('<p>最近就诊时间:'+lastVisited+'</p></a></li>');
                }
                $("#namePatientList").append(str.toString());
                if(pageIndex2 >= resultPage.totalPage) {
                    loadEnd2 = true;
                } else {
                    pageIndex2++;
                }
            }
        });
    }
    asynNamePatientList();
    /*************************** end 患者姓名排序列表 ***************************/

    /*************************** start 滚动到底部自动加载患者列表 ***************************/
    var totalheight;
    $(window).scroll(function () {
        if(currentTab == "timeTab" && !loadEnd1) {
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() - 20 <= totalheight) {
                asynTimePatientList();
            }
        } else if(currentTab == "nameTab" && !loadEnd2) {
            totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop());
            if($(document).height() - 20 <= totalheight) {
                asynNamePatientList();
            }
        }
    });
    /*************************** end 滚动到底部自动加载患者列表 ***************************/

    // 跳转患者详细信息页面
    function toPatientInfo(patientId) {
        window.location.href = 'toPatientInfo.htm?patientId=' + patientId;
    }
</script>
</html>
