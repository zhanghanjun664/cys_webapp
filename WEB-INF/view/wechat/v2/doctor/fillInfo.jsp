<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="cn.aidee.jdoctor.model.wechat.DistrictModel" %>
<%@ page import="cn.aidee.jdoctor.model.*" %>
<%@ page import="com.google.gson.Gson" %>
<%
    List<DistrictModel> districtList = (List<DistrictModel>)request.getAttribute("districtList");
    List<JdHospitalQueryModel> hospitalList = (List<JdHospitalQueryModel>)request.getAttribute("hospitalList");
//    List<JdSickQueryModel> sickList = (List<JdSickQueryModel>)request.getAttribute("sickList");
    List<JdTitleQueryModel> titleList = (List<JdTitleQueryModel>)request.getAttribute("titleList");
    List<JdDepartmentQueryModel> departmentList = (List<JdDepartmentQueryModel>)request.getAttribute("departmentList");
    String wxconfig = (String)request.getAttribute("wxconfig");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.animation.css" rel="stylesheet" />
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.icons.css" rel="stylesheet" />
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.frame.css" rel="stylesheet" />
    <link href="../../wechat/css/patient_v2/mobiscroll/mobiscroll.scroller.css" rel="stylesheet" />
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <h3 class="tit">填写个人信息</h3>
    <a href="javascript:void(0);" class="back-to-home logo">返回首页</a>
    <a href="javascript:void(0);" class="step-next">下一步</a>
    <a href="javascript:void(0);" class="step-next-1">下一步</a>
    <a href="javascript:void(0);" class="btn-save">保存</a>
    <a href="javascript:void(0);" class="btn-save-1">保存</a>
</header>
<!-- topbar end -->

<!-- page personal info start -->
<div id="page-personal-info">
    <!-- personal info start -->
    <div class="main personal-info">
        <form class="form form-per-info wizard" id="form-per-info">
            <div class="steps">
                <ul class="clearfix">
                    <li class="current"><i></i>
                        <h3>基本信息</h3></li>
                    <li><i></i>
                        <h3>医生简介</h3><s></s></li>
                    <li><i></i>
                        <h3>职称证明</h3><s></s></li>
                </ul>
            </div>
            <div class="content">
                <!-- info basic -->
                <div class="info-basic">
                    <div class="grid">
                        <a href="javascript:void(0);" class="upload-avatar" onclick="uploadHeadPic()">头像
                            <i>(请上传清晰免冠照,以便通过审核)</i>
                            <img src="" class="fr" width="48" height="48" style="margin-right: 18px;display: none;"/>
                        </a>

                        <p>
                            <label for="full-name">姓名</label>
                            <input type="text" name="full-name" id="full-name"/>
                        </p>
                    </div>

                    <div class="grid mt-10">
                        <p>
                            <label for="area">医院所在地区</label>
                            <select id="area">
                            <%
                                boolean defaultFlag = false;
                                String defaultDistrictId = "", defaultDistrict = "";
                                for(DistrictModel districtModel : districtList) {
                                    if(!defaultFlag) {
                                        defaultFlag = true;
                                        defaultDistrictId = districtModel.getId();
                                        defaultDistrict = districtModel.getName();
                                    }
                            %>
                                <optgroup label="<%=districtModel.getName()%>" id="<%=districtModel.getId()%>">
                                <%
                                    for(DistrictModel childDistrict : districtModel.getChildDistricts()) {
                                %>
                                    <option value="<%=childDistrict.getId()%>"><%=childDistrict.getName()%></option>
                                <%
                                    }
                                %>
                                </optgroup>
                            <%
                                }
                            %>
                            </select>
                        </p>

                        <p>
                            <label for="hospital-name">医院名称</label>
                            <select id="hospital-name"></select>
                        </p>

                        <p>
                            <label for="title">职称</label>
                            <select id="title">
                                <%
                                    for(JdTitleQueryModel title : titleList) {
                                %>
                                    <option value="<%=title.getUuid().toString()%>"><%=title.getName()%></option>
                                <%
                                    }
                                %>
                            </select>
                        </p>

                        <p>
                            <label for="department">科室</label>
                            <select id="department">
                                <%
                                    for(JdDepartmentQueryModel department : departmentList) {
                                %>
                                    <option value="<%=department.getUuid().toString()%>"><%=department.getName()%></option>
                                <%
                                    }
                                %>
                            </select>
                        </p>

                        <p>
                            <label for="license">医生执业证号</label>
                            <input type="text" name="license" id="license"/>
                        </p>

                        <p>
                            <label for="work-time">从业时间</label>
                            <input type="text" name="work-time" id="work-time" readonly/>
                        </p>

                        <p>
                            <label for="expertise">擅长</label>
                            <input type="text" name="expertise" id="expertise" maxlength=200 />
                        </p>
                    </div>
                </div>

                <!-- brief intro -->
                <div class="brief-intro">
                    <div class="grid">
                        <textarea name="intro" id="intro" placeholder="请输入医生简介"></textarea>
                    </div>
                </div>

                <!-- title certificate -->
                <div class="title-certificate">
                    <div class="grid">
                        <div class="title-grid-hd">请上传你的职称证明照片<b>(工牌、证书、成绩单、医生聘书等)</b></div>
                        <div class="title-grid-con">
                            <img id="certImg" src="../../wechat/images/v2/add.png" width="65" height="65" onclick="uploadCertificateImage()" />
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <!-- personal info end -->
</div>
<!-- page personal info end -->

<!-- page expertise start -->
<%--<div id="page-expertise">
    <div class="main expertise">
        <div class="grid">
            <ul>
                <%
                    for(JdSickQueryModel sick : sickList) {
                %>
                    <li>
                        <label><%=sick.getName()%></label>
                        <div class="switch-button switch-off">
                            <span class="slider-button"></span>
                            <input type="hidden" value="<%=sick.getUuid().toString()%>">
                        </div>
                    </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</div>--%>
<!-- page expertise end -->

<!-- mask start -->
<div class="mask"></div>
<!-- mask end -->
<!-- popup start -->
<div class="popup upload-avatar-wrap">
    <div class="popup-content">
        <a id="previewBtn">预览</a>
        <a id="uploadBtn">重新上传</a>
    </div>
    <div class="popup-bottom">
        <a class="popup-btn-cancel">取消</a>
    </div>
</div>
<!-- popup end -->
</body>
<script src="../../wechat/js/weixin.js" type="text/javascript"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.core.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.scroller.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.select.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.util.datetime.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.datetimebase.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.datetime.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/mobiscroll.frame.android-holo.js"></script>
<script type="text/javascript" src="../../wechat/js/patient_v2/mobiscroll/i18n/mobiscroll.i18n.zh.js"></script>
<script>
    $(function () {
        var wxconfig = <%=wxconfig%>;
        wx.config({
            debug: false,
            appId: wxconfig.appId,
            timestamp: wxconfig.timestamp,
            nonceStr: wxconfig.nonceStr,
            signature: wxconfig.signature,
            jsApiList: ['chooseImage','uploadImage','previewImage']
        });

        var fullName = $('#full-name'), hospitalName = $('#hospital-name'), area = $('#area'),
            title = $('#title'), department = $('#department'), license = $('#license'),
            workTime = $('#work-time'), expertise = $('#expertise'), intro = $('#intro');

        // 下一步
        $('.step-next').on('click', function () {
            if(!headPic) {
                layer.msg('请上传头像');
            } else if (isEmpty('#full-name') || isEmpty('#hospital-name') || isEmpty('#area') || isEmpty('#title') || isEmpty('#department') || isEmpty('#license') || isEmpty('#work-time') || isEmpty('#expertise')) {
                layer.msg('请先完善信息');
            } else {
                $('.step-next').hide().next().show();
                $('.steps li').eq(1).addClass('current');
                $('.info-basic').hide().next().show();
            }
        });

        // step 2
        $('.step-next-1').on('click', function () {
            if (isEmpty('#intro')) {
                layer.msg('请输入医生简介');
            } else {
                $(this).hide().siblings('.btn-save-1').show();
                $('.steps li').eq(2).addClass('current');
                $('.brief-intro').hide().next().show();
            }
        });

        // 保存个人信息
        var submitFlag = false;
        $('.btn-save-1').on('click', function () {
            if(submitFlag)
                return;
            submitFlag = true;
            if(!certificateImage) {
                layer.msg('请上传证明');
                submitFlag = false;
                return;
            }
            var data = {
                "name" : trim(fullName.val()),
                "districtId" : districtId,
                "hospitalId" : hospitalName.val(),
                "titleId" : title.val(),
                "departmentId" : department.val(),
                "certificateNumber" : trim(license.val()),
                "startDate" : workTime.val(),
                "expertise" : $('#expertise').val(),
                "description" : intro.val(),
                "headPic" : headPic,
                "certificateImage" : certificateImage
            };
            sendRequest("saveInfo.htm", "POST", data, function(result) {
                if(result) {
                    layer.alert(result, {
                        title: false,
                        closeBtn: false
                    }, function () {
                        layer.closeAll();
                    });
                    submitFlag = false;
                } else {
                    layer.alert('保存成功，审核需要2-7个工作日，请耐心等待！', {
                        title: false,
                        closeBtn: false,
                        btn: '确定'
                    }, function () {
                        layer.closeAll();
                        window.location.href = 'toPersonal.htm';
                    });
                }
            }, function() {
                submitFlag = false;
            });
        });

        // 医院所在区域
        var districtId = "<%=defaultDistrictId%>";
        $('#area').mobiscroll().select({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            group: {
                groupWheel: true,
                header: false,
                clustered: true
            },
            groupLabel: 'Country',
            fixedWidth: [100, 170],
            setText: '完成',
            onMarkupReady: function (markup) {
                $('.dwbc', markup).insertBefore($('.dwcc', markup));
            },
            onSelect: function (valueText, inst) {
                var group = $('#area option[value="' + inst.getVal() + '"]').parent();
                var label = group.attr('label');
                districtId = group.attr('id');
                $('#area_dummy').val(label + ' ' + valueText);
                hospitalName.val("");
                updateHospitalList();
            }
        });
        $('#area_dummy').val("<%=defaultDistrict%> " + $('#area_dummy').val());

        var hospitalList = <%=new Gson().toJson(hospitalList)%>;
        // 更新医院可选列表
        function updateHospitalList() {
            var areaId = area.val();
            var str = new StringBuilder();
            for(var i = 0; i < hospitalList.length; i++) {
                var hospital = hospitalList[i];
                if(hospital.jdDistrictAreaId === areaId) {
                    str.append('<option value="'+hospital.uuid+'">'+hospital.name+'</option>');
                }
            }
            $("#hospital-name").html(str.toString());
            $('#hospital-name_dummy').val(hospitalName.contents()[0].innerHTML);
        }
        updateHospitalList();

        // 医院列表
        $('#hospital-name').mobiscroll().select({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            setText: '完成',
            onMarkupReady: function (markup) {
                $('.dwbc', markup).insertBefore($('.dwcc', markup));
            },
            onSelect: function (valueText, inst) {
                $('#hospital-name_dummy').val(valueText);
            }
        });

        // 职称列表
        $('#title').mobiscroll().select({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            setText: '完成',
            onMarkupReady: function (markup) {
                $('.dwbc', markup).insertBefore($('.dwcc', markup));
            },
            onSelect: function (valueText, inst) {
                $('#title_dummy').val(valueText);
            }
        });

        // 科室列表
        $('#department').mobiscroll().select({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            setText: '完成',
            onMarkupReady: function (markup) {
                $('.dwbc', markup).insertBefore($('.dwcc', markup));
            },
            onSelect: function (valueText, inst) {
                $('#department_dummy').val(valueText);
            }
        });

        // 从业时间
        $('#work-time').mobiscroll().date({
            theme: 'mobiscroll',
            lang: 'zh',
            display: 'bottom',
            setText: '完成',
            dateFormat: 'yy-mm-dd',
            onMarkupReady: function (markup) {
                $('.dwbc', markup).insertBefore($('.dwcc', markup));
            }
        });

        // 专长
//        $('#expertise').on('click', function () {
//            $('.topbar .tit').text('专长');
//            $('.topbar .step-next').hide().siblings('.btn-save').show();
//            $('#page-personal-info').hide().next().show();
//        });

        // 转换开关
        $('.slider-button').on('click', function () {
            if ($(this).hasClass('on')) {
                $(this).removeClass('on').parent().removeClass('switch-on').addClass('switch-off');
            } else {
                $(this).addClass('on').parent().removeClass('switch-off').addClass('switch-on');
            }
        });

        // 专长保存
//        var skills;
//        $('.btn-save').on('click', function () {
//            var switchBtnOn = $('.switch-on');
//            var arr = [];
//            var skill = [];
//            for (var i = 0; i < switchBtnOn.length; i++) {
//                var item = switchBtnOn.eq(i);
//                var label = item.prev().text();
//                var val = item.find("input").val();
//                arr.push(label);
//                skill.push(val);
//            }
//            var toString = arr.join(',');
//            skills = skill.join(',');
//            $('#expertise').val(toString);
//            $('.topbar .tit').text('填写个人信息');
//            $(this).hide().siblings('.step-next').show();
//            $('#page-expertise').hide().prev().show();
//        });
    });

    /*************************** start 上传图片 ***************************/
    $('.mask, .popup-btn-cancel').on('click', closePop);
    function closePop() {
        $('.mask, .upload-avatar-wrap').fadeOut();
        $("#previewBtn").unbind("click");
        $("#uploadBtn").unbind("click");
    }
    var headPic,certificateImage,isUploadHead=false,isUploadCert=false;
    //上传个人头像
    function uploadHeadPic() {
        if (isUploadHead) {
            $("#previewBtn").bind("click", function (e) {
                closePop();
                wx.previewImage({
                    current: headPic,
                    urls: [headPic]
                });
            });
            $("#uploadBtn").bind("click", showUploadHeadPic);
            $('.mask, .upload-avatar-wrap').fadeIn();
        } else {
            showUploadHeadPic();
        }
    }
    function showUploadHeadPic() {
        closePop();
        wx.chooseImage({
            count: 1,
            success: function (res) {
                var localIds = res.localIds;
                wx.uploadImage({
                    localId:localIds[0],
                    isShowProgressTips: 1,
                    success: function (res) {
                        var serverId = res.serverId;
                        sendRequest("getImageByType.htm?type=headPic&serverId="+serverId, "GET", function(src) {
                            $("img.fr").attr("src", src).css("display", "block");
                            headPic = src;
                            isUploadHead = true;
                        });
                    }
                });
            }
        });
    }
    //上传证件头像
    function uploadCertificateImage() {
        if (isUploadCert) {
            $("#previewBtn").bind("click", function (e) {
                closePop();
                wx.previewImage({
                    current: certificateImage,
                    urls: [certificateImage]
                });
            });
            $("#uploadBtn").bind("click", showUploadCertImg);
            $('.mask, .upload-avatar-wrap').fadeIn();
        } else {
            showUploadCertImg();
        }
    }
    function showUploadCertImg() {
        closePop();
        wx.chooseImage({
            count: 1,
            success: function (res) {
                var localIds = res.localIds;
                wx.uploadImage({
                    localId:localIds[0],
                    isShowProgressTips: 1,
                    success: function (res) {
                        var serverId = res.serverId;
                        sendRequest("getImageByType.htm?type=certPic&serverId="+serverId, "GET", function(src) {
                            $("#certImg").attr("src", src);
                            certificateImage = src;
                            isUploadCert = true;
                        });
                    }
                });
            }
        });
    }
</script>
</html>
