'use strict';

/**
 * Config for the router
 */
app.config(['$stateProvider', '$urlRouterProvider', '$controllerProvider', '$compileProvider', '$filterProvider', '$provide', '$ocLazyLoadProvider', 'JS_REQUIRES',
    function ($stateProvider, $urlRouterProvider, $controllerProvider, $compileProvider, $filterProvider, $provide, $ocLazyLoadProvider, jsRequires) {

        app.controller = $controllerProvider.register;
        app.directive = $compileProvider.directive;
        app.filter = $filterProvider.register;
        app.factory = $provide.factory;
        app.service = $provide.service;
        app.constant = $provide.constant;
        app.value = $provide.value;

        // LAZY MODULES
        $ocLazyLoadProvider.config({
            debug: false,
            events: true,
            modules: jsRequires.modules
        });

        // APPLICATION ROUTES
        $urlRouterProvider.otherwise("/app");

        // Set up the states
        $stateProvider.state('app', {
            url: "/app",
            templateUrl: "assets/views/app.html",
            resolve: loadSequence('modernizr', 'moment', 'angularMoment', 
                    'uiSwitch', 'perfect-scrollbar-plugin', 'perfect_scrollbar', 
                    'toaster', 'ngAside', 'vAccordion', 'sweet-alert', 'oitozero.ngSweetAlert',
                    'chatCtrl', 'ui.select', 'ui.mask', 'monospaced.elastic', 'navbarCtrl', 
                    'aideeSearchMenuCtrl'),
            abstract: false
        }).state('app.system', {
            url: '/system',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '系统管理',
            ncyBreadcrumb: {
                label: 'System'
            }
        }).state('app.system.menu', {
            url: '/menu',
            templateUrl: "assets/views/system/menu.html",
            title: '菜单管理',
            ncyBreadcrumb: {
                label: 'Menu'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'aideeMenuCtrl')
        }).state('app.system.role', {
            url: '/role',
            templateUrl: "assets/views/system/role.html",
            title: '角色管理',
            ncyBreadcrumb: {
                label: 'Role'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'aideeRoleCtrl')
        }).state('app.system.authority', {
            url: '/authority',
            templateUrl: "assets/views/system/authority.html",
            title: '权限管理',
            ncyBreadcrumb: {
                label: 'Authority'
            },
            authentication: true
        }).state('app.system.user', {
            url: '/user',
            templateUrl: "assets/views/system/user.html",
            title: '用户管理',
            ncyBreadcrumb: {
                label: 'User'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'aideeUserCtrl')
        }).state('app.system.params', {
            url: '/params',
            templateUrl: "assets/views/system/paramsConfig.html",
            title: '参数管理',
            ncyBreadcrumb: {
                label: 'Params'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'paramsConfigCtrl')
        }).state('app.system.buttonPermit', {
            url: '/buttonPermit',
            templateUrl: "assets/views/system/buttonPermit.html",
            title: '按钮权限管理',
            ncyBreadcrumb: {
                label: 'ButtonPermit'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'buttonPermitCtrl')
        }).state('app.config', {
            url: '/config',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '系统配置',
            ncyBreadcrumb: {
                label: 'Config'
            }
        }).state('app.config.banner', {
            url: '/banner',
            templateUrl: "assets/views/jdoctor/banner.html",
            title: '广告位配置',
            ncyBreadcrumb: {
                label: 'banner'
            },
            authentication: true,
            resolve: loadSequence('flow','touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'bannerCtrl')
        }).state('app.config.jdDistrict', {
            url: '/jdDistrict',
            templateUrl: "assets/views/jdoctor/jdDistrict.html",
            title: '地区信息',
            ncyBreadcrumb: {
                label: 'JdDistrict'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdDistrictCtrl')
        }).state('app.config.jdDistrictArea', {
            url: '/jdDistrictArea',
            templateUrl: "assets/views/jdoctor/jdDistrictArea.html",
            title: '市辖区信息',
            ncyBreadcrumb: {
                label: 'JdDistrictArea'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdDistrictAreaCtrl')
        }).state('app.config.jdHospital', {
            url: '/jdHospital',
            templateUrl: "assets/views/jdoctor/jdHospital.html",
            title: '医院信息',
            ncyBreadcrumb: {
                label: 'JdHospital'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'jdHospitalCtrl')
        }).state('app.config.jdDepartment', {
            url: '/jdDepartment',
            templateUrl: "assets/views/jdoctor/jdDepartment.html",
            title: '科室信息',
            ncyBreadcrumb: {
                label: 'JdHospital'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdDepartmentCtrl')
        }).state('app.config.jdSickCategary', {
            url: '/jdSickCategary',
            templateUrl: "assets/views/jdoctor/jdSickCategary.html",
            title: '疾病类型',
            ncyBreadcrumb: {
                label: 'JdSickCategary'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdSickCategaryCtrl')
        }).state('app.config.jdSick', {
            url: '/jdSick',
            templateUrl: "assets/views/jdoctor/jdSick.html",
            title: 'ICD疾病信息',
            ncyBreadcrumb: {
                label: 'JdSick'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdSickCtrl')
        }).state('app.config.jdOrderTip', {
            url: '/jdOrderTip',
            templateUrl: "assets/views/jdoctor/jdOrderTip.html",
            title: '预约须知',
            ncyBreadcrumb: {
                label: 'JdOrderTip'
            },
            authentication: true,
            resolve: loadSequence('jdOrderTipCtrl')
        }).state('app.doctor', {
            url: '/doctor',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '医生模块',
            ncyBreadcrumb: {
                label: 'Doctor'
            }
        }).state('app.doctor.jdTitle', {
            url: '/jdTitle',
            templateUrl: "assets/views/jdoctor/jdTitle.html",
            title: '职称信息',
            ncyBreadcrumb: {
                label: 'JdTitle'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdTitleCtrl')
        }).state('app.doctor.jdDoctor', {
            url: '/jdDoctor',
            templateUrl: "assets/views/jdoctor/jdDoctor.html",
            title: '医生信息',
            ncyBreadcrumb: {
                label: 'JdDoctor'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable','ng-tags-input','jdDoctorCtrl')
        }).state('app.doctor.doctorTeam', {
            url: '/doctorTeam',
            templateUrl: "assets/views/jdoctor/doctorTeam.html",
            title: '医生团队',
            ncyBreadcrumb: {
                label: 'doctorTeam'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'doctorTeamCtrl')
        }).state('app.doctor.jdRecommendDoctor', {
            url: '/jdRecommendDoctor',
            templateUrl: "assets/views/jdoctor/jdRecommendDoctor.html",
            title: '推荐医生',
            ncyBreadcrumb: {
                label: 'jdRecommendDoctor'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'jdRecommendDoctorCtrl')
        }).state('app.doctor.jdPushArticle', {
            url: '/jdPushArticle',
            templateUrl: "assets/views/jdoctor/jdPushArticle.html",
            title: '推送文章',
            ncyBreadcrumb: {
                label: 'jdPushArticle'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'jdPushArticleCtrl')
        }).state('app.doctor.jdPushArticleResult', {
            url: '/jdPushArticleResult',
            templateUrl: "assets/views/jdoctor/jdPushArticleResult.html",
            title: '文章推送结果',
            ncyBreadcrumb: {
                label: 'jdPushArticleResult'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'jdPushArticleResultCtrl')
        }).state('app.doctor.timeView', {
            url: '/timeView',
            templateUrl: "assets/views/jdoctor/timeView.html",
            title: '出诊安排',
            ncyBreadcrumb: {
                label: 'timeView'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'timeViewCtrl')
        }).state('app.doctor.noTimeView', {
            url: '/noTimeView',
            templateUrl: "assets/views/jdoctor/noTimeView.html",
            title: '不允许出诊安排',
            ncyBreadcrumb: {
                label: 'noTimeView'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'noTimeViewCtrl')
        }).state('app.doctor.noVisitedTime', {
            url: '/noVisitedTime',
            templateUrl: "assets/views/jdoctor/noVisitedTime.html",
            title: '不出诊安排',
            ncyBreadcrumb: {
                label: 'noVisitedTime'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'noVisitedTimeCtrl')
        }).state('app.doctor.jdBooking', {
            url: '/jdBooking',
            templateUrl: "assets/views/jdoctor/jdBooking.html",
            title: '预约号信息',
            ncyBreadcrumb: {
                label: 'jdBooking'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'jdBookingCtrl')
        }).state('app.patient', {
            url: '/patient',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '用户模块',
            ncyBreadcrumb: {
                label: 'Patient'
            }
        }).state('app.patient.jdPatient', {
            url: '/jdPatient',
            templateUrl: "assets/views/jdoctor/jdPatient.html",
            title: '用户信息',
            ncyBreadcrumb: {
                label: 'JdPatient'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'jdPatientCtrl')
        }).state('app.patient.jdOperation', {
            url: '/jdOperation',
            templateUrl: "assets/views/jdoctor/jdOperation.html",
            title: '手术直通车',
            ncyBreadcrumb: {
                label: 'JdOperation'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdOperationCtrl')
        }).state('app.patient.jdComment', {
            url: '/jdComment',
            templateUrl: "assets/views/jdoctor/jdComment.html",
            title: '评论信息',
            ncyBreadcrumb: {
                label: 'JdComment'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdCommentCtrl')
        }).state('app.patient.jdHealthExamination', {
            url: '/jdHealthExamination',
            templateUrl: "assets/views/jdoctor/jdHealthExamination.html",
            title: '健康测量',
            ncyBreadcrumb: {
                label: 'jdHealthExamination'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdHealthExaminationCtrl')
        }).state('app.patient.jdMedicalRecord', {
            url: '/jdMedicalRecord',
            templateUrl: "assets/views/jdoctor/jdMedicalRecord.html",
            title: '病例查看',
            ncyBreadcrumb: {
                label: 'jdMedicalRecord'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdMedicalRecordCtrl')
        }).state('app.patient.jdMedicalAudit', {
            url: '/jdMedicalAudit',
            templateUrl: "assets/views/jdoctor/jdMedicalAudit.html",
            title: '病例审核',
            ncyBreadcrumb: {
                label: 'jdMedicalAudit'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdMedicalAuditCtrl')
        }).state('app.patient.patientArchiveList', {
            url: '/patientArchiveList',
            templateUrl: "assets/views/patient-archive/patientArchiveList.html",
            title: '患者档案',
            ncyBreadcrumb: {
                label: 'PatientArchiveList'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable','ng-tags-input','patientArchiveListCtrl')
        }).state('app.order', {
            url: '/patient',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '订单管理',
            ncyBreadcrumb: {
                label: 'Patient'
            }
        }).state('app.order.jdOrder', {
            url: '/jdOrder',
            templateUrl: "assets/views/jdoctor/jdOrder.html",
            title: '见面咨询订单',
            ncyBreadcrumb: {
                label: 'JdOrder'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdOrderCtrl')
        }).state('app.patient.jdOrderPlus', {
            url: '/jdOrderPlus',
            templateUrl: "assets/views/jdoctor/jdOrderPlus.html",
            title: '申请放号',
            ncyBreadcrumb: {
                label: 'JdOrderPlus'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdOrderPlusCtrl')
        }).state('app.order.phoneServiceOrder', {
            url: '/phoneServiceOrder',
            templateUrl: "assets/views/jdoctor/phoneServiceOrder.html",
            title: '电话咨询订单',
            ncyBreadcrumb: {
                label: 'PhoneServiceOrder'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'phoneServiceOrderCtrl')
        }).state('app.order.insuranceOrder', {
            url: '/insuranceOrder',
            templateUrl: "assets/views/insurance/insuranceOrder.html",
            title: '订单信息',
            ncyBreadcrumb: {
                label: 'insuranceOrder'
            },
            authentication: true,
            resolve: loadSequence('flow', 'ngTable', 'insuranceOrderCtrl', 'toaster')
        }).state('app.coupon', {
            url: '/coupon',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '现金券模块',
            ncyBreadcrumb: {
                label: 'Coupon'
            }
        }).state('app.coupon.jdCouponCategory', {
            url: '/jdCouponCategory',
            templateUrl: "assets/views/jdoctor/jdCouponCategory.html",
            title: '现金券类型',
            ncyBreadcrumb: {
                label: 'jdCouponCategory'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdCouponCategoryCtrl')
        }).state('app.coupon.jdCoupon', {
            url: '/jdCoupon',
            templateUrl: "assets/views/jdoctor/jdCoupon.html",
            title: '现金券',
            ncyBreadcrumb: {
                label: 'jdCoupon'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdCouponCtrl')
        }).state('app.coupon.jdCouponTransaction', {
            url: '/jdCouponTransaction',
            templateUrl: "assets/views/jdoctor/jdCouponTransaction.html",
            title: '现金券流水账',
            ncyBreadcrumb: {
                label: 'jdCouponTransaction'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'jdCouponTransactionCtrl')
        }).state('app.message', {
            url: '/message',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '消息模块',
            ncyBreadcrumb: {
                label: 'Message'
            }
        }).state('app.message.pushDoctorTextMessage', {
            url: '/pushDoctorTextMessage',
            templateUrl: "assets/views/jdoctor/pushDoctorTextMessage.html",
            title: '给医生发送消息',
            ncyBreadcrumb: {
                label: 'textMessage'
            },
            authentication: true,
            resolve: loadSequence('ngTable','pushDoctorTextMessageCtrl')
        }).state('app.message.pushPatientTextMessage', {
            url: '/pushPatientTextMessage',
            templateUrl: "assets/views/jdoctor/pushPatientTextMessage.html",
            title: '给用户发送消息',
            ncyBreadcrumb: {
                label: 'textMessage'
            },
            authentication: true,
            resolve: loadSequence('ngTable','pushPatientTextMessageCtrl')
        }).state('app.message.pushOrderPatientTextMessage', {
            url: '/pushOrderPatientTextMessage',
            templateUrl: "assets/views/jdoctor/pushOrderPatientTextMessage.html",
            title: '给患者发送消息',
            ncyBreadcrumb: {
                label: 'textMessage'
            },
            authentication: true,
            resolve: loadSequence('ngTable','pushOrderPatientTextMessageCtrl')
        }).state('app.payment', {
            url: '/payment',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '财务管理',
            ncyBreadcrumb: {
                label: 'Message'
            }
        }).state('app.payment.accountDetails', {
            url: '/accountDetails',
            templateUrl: "assets/views/jdoctor/jdAccountDetails.html",
            title: '平台收支统计',
            ncyBreadcrumb: {
                label: '平台收支统计'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'accountDetailsCtrl')
        }).state('app.payment.doctorWithdrawaling', {
            url: '/doctorWithdrawaling',
            templateUrl: "assets/views/jdoctor/doctorWithdrawaling.html",
            title: '待转账（医生）',
            ncyBreadcrumb: {
                label: '待转账（医生）'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'doctorWithdrawalingCtrl')
        }).state('app.payment.doctorWithdrawalHistory', {
            url: '/doctorWithdrawalHistory',
            templateUrl: "assets/views/jdoctor/doctorWithdrawalHistory.html",
            title: '已转账（医生）',
            ncyBreadcrumb: {
                label: '已转账（医生）'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'doctorWithdrawalHistoryCtrl')
        }).state('app.payment.payment', {
            url: '/payment',
            templateUrl: "assets/views/jdoctor/payment.html",
            title: '付款（医生）',
            ncyBreadcrumb: {
                label: '付款（医生）'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'paymentCtrl')
        }).state('app.payment.patientPaymentHistory', {
            url: '/patientPaymentHistory',
            templateUrl: "assets/views/jdoctor/patientPaymentHistory.html",
            title: '转账信息（患者）',
            ncyBreadcrumb: {
                label: '转账信息（患者）'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'patientPaymentHistoryCtrl')
        }).state('app.payment.patientRedpackPayment', {
            url: '/patientRedpackPayment',
            templateUrl: "assets/views/jdoctor/patientRedpackPayment.html",
            title: '红包（患者）',
            ncyBreadcrumb: {
                label: '红包（患者）'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'patientRedpackPaymentCtrl')
        }).state('app.payment.thirdPartyPaymentAllHistory', {
            url: '/thirdPartyPaymentAllHistory',
            templateUrl: "assets/views/jdoctor/thirdPartyPaymentAllHistory.html",
            title: '第三方订单流水',
            ncyBreadcrumb: {
                label: '第三方订单流水'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'thirdPartyPaymentHistoryCtrl')
        }).state('app.payment.patientPaymentAllHistory', {
            url: '/patientPaymentAllHistory',
            templateUrl: "assets/views/jdoctor/patientPaymentAllHistory.html",
            title: '患者账户流水',
            ncyBreadcrumb: {
                label: '患者账户流水'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'patientPaymentAllHistoryCtrl')
        }).state('app.payment.patientBalance', {
            url: '/patientbalance',
            templateUrl: "assets/views/jdoctor/patientBalance.html",
            title: '用户余额查询',
            ncyBreadcrumb: {
                label: '用户余额查询'
            },
            authentication: true,
            resolve: loadSequence('ngTable', 'patientBalanceCtrl')
        }).state('app.statistics', {
            url: '/statistics',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '统计报表',
            ncyBreadcrumb: {
                label: 'Statistics'
            }
        }).state('app.statistics.userDataAnalysis', {
            url: '/userDataAnalysis',
            templateUrl: "assets/views/jdoctor/userDataAnalysis.html",
            title: '用户数据分析',
            ncyBreadcrumb: {
                label: 'UserDataAnalysis'
            },
            authentication: true,
            resolve: loadSequence('highcharts-ng', 'userDataAnalysisCtrl')
        }).state('app.wechat', {
            url: '/wechat',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '微信模块',
            ncyBreadcrumb: {
                label: 'Wechat'
            }
        }).state('app.wechat.menu', {
            url: '/menu',
            templateUrl: "assets/views/jdoctor/jdWechatMenu.html",
            title: '公众号菜单',
            ncyBreadcrumb: {
                label: 'Menu'
            },
            authentication: true,
            resolve: loadSequence('ngTable','wechatMenuCtrl')
        }).state('app.wechat.qrcode', {
            url: '/qrcode',
            templateUrl: "assets/views/jdoctor/jdQrcode.html",
            title: '渠道二维码信息',
            ncyBreadcrumb: {
                label: 'Qrcode'
            },
            authentication: true,
            resolve: loadSequence('ngTable','qrcodeCtrl')
        }).state('app.wechat.spread', {
            url: '/spread',
            templateUrl: "assets/views/jdoctor/jdQrcodeSpread.html",
            title: '渠道用户统计',
            ncyBreadcrumb: {
                label: 'QrcodeSpread'
            },
            authentication: true,
            resolve: loadSequence('ngTable','qrcodeSpreadCtrl')
        }).state('app.wechat.keyWord', {
            url: '/keyWord',
            templateUrl: "assets/views/jdoctor/jdWechatKeyWord.html",
            title: '自动回复配置',
            ncyBreadcrumb: {
                label: 'jdWechatKeyWord'
            },
            authentication: true,
            resolve: loadSequence('ngTable','jdWechatKeyWordCtrl')
        }).state('app.patientedu', {
            url: '/patientedu',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '医生工具',
            ncyBreadcrumb: {
                label: 'patientedu'
            }
        }).state('app.patientedu.article', {
            url: '/article',
            templateUrl: "assets/views/jdoctor/patientEduArticle.html",
            title: '患教资料维护',
            ncyBreadcrumb: {
                label: 'patientEduArticle'
            },
            authentication: true,
            resolve: loadSequence('flow','touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'patientEduArticleCtrl')
        }).state('app.patientedu.followup', {
            url: '/followup',
            templateUrl: "assets/views/jdoctor/followup.html",
            title: '随访模板维护',
            ncyBreadcrumb: {
                label: 'followup'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'followupCtrl')
        }).state('app.patientedu.sickCategorySet', {
            url: '/sickCategorySet',
            templateUrl: "assets/views/jdoctor/sickCategorySet.html",
            title: '订阅分类设置',
            ncyBreadcrumb: {
                label: 'sickCategorySet'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'sickCategorySetCtrl')
        }).state('app.patientedu.tag', {
            url: '/tag',
            templateUrl: "assets/views/jdoctor/tag.html",
            title: '标签管理',
            ncyBreadcrumb: {
                label: 'tag'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'tagCtrl')
        }).state('app.patient.loginlog', {
            url: '/loginlog',
            templateUrl: "assets/views/jdoctor/loginlog.html",
            title: '登录日志',
            ncyBreadcrumb: {
                label: 'loginlog'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'loginLogCtrl')
        }).state('app.devicemanage', {
            url: '/devicemanage',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '设备管理',
            ncyBreadcrumb: {
                label: 'devicemanage'
            }
        }).state('app.devicemanage.device', {
            url: '/device',
            templateUrl: "assets/views/jdoctor/device.html",
            title: '设备及二维码管理',
            ncyBreadcrumb: {
                label: 'device'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'deviceCtrl')
        }).state('app.devicemanage.deviceBound', {
            url: '/deviceBound',
            templateUrl: "assets/views/jdoctor/deviceBound.html",
            title: '设备绑定记录',
            ncyBreadcrumb: {
                label: 'deviceBound'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'deviceBoundCtrl')
        }).state('app.patient.examinationSharing', {
            url: '/examinationSharing',
            templateUrl: "assets/views/jdoctor/examinationSharing.html",
            title: '健康数据邀请关注记录',
            ncyBreadcrumb: {
                label: 'examinationSharing'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'examinationSharingCtrl')
        }).state('app.config.freqUsedSickCategory', {
            url: '/freqUsedSickCategory',
            templateUrl: "assets/views/jdoctor/freqUsedSickCategory.html",
            title: '常见疾病',
            ncyBreadcrumb: {
                label: 'freqUsedSickCategory'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'freqUsedSickCategoryCtrl')
        }).state('app.message.onlineDiagnoseReply', {
            url: '/onlineDiagnoseReply',
            templateUrl: "assets/views/jdoctor/onlineDiagnoseReply.html",
            title: '给用户回复图像问诊结果',
            ncyBreadcrumb: {
                label: 'onlineDiagnoseReply'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin', 'onlineDiagnoseReplyCtrl')
        }).state('app.config.adItem', {
            url: '/adItem',
            templateUrl: "assets/views/jdoctor/adItem.html",
            title: '广告素材配置',
            ncyBreadcrumb: {
                label: 'adItem'
            },
            authentication: true,
            resolve: loadSequence('flow','touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'adItemCtrl')
        }).state('app.live', {
            url: '/live',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '直播管理',
            ncyBreadcrumb: {
                label: 'live'
            }
        }).state('app.live.list', {
            url: '/liveList',
            templateUrl: "assets/views/jdoctor/liveEvent.html",
            title: '直播列表',
            ncyBreadcrumb: {
                label: 'liveEvent'
            },
            authentication: true,
            resolve: loadSequence('flow','touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'liveEventCtrl')
        }).state('app.patient.healthWarning', {
            url: '/healthWarning',
            templateUrl: "assets/views/jdoctor/healthWarning.html",
            title: '健康测量告警管理',
            ncyBreadcrumb: {
                label: 'healthWarning'
            },
            authentication: true,
            resolve: loadSequence('flow','touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'healthWarningCtrl')
        }).state('error', {
            url: '/error',
            template: '<div ui-view class="fade-in-up"></div>'
        }).state('error.403', {
            url: '/403',
            templateUrl: "assets/views/utility_403.html"
        }).state('app.memberManage', {
            url: '/memberManage',
            template: '<div ui-view class="fade-in-up"></div>',
            title: '会员管理',
            ncyBreadcrumb: {
                label: 'memberManage'
            }
        }).state('app.memberManage.healthServicePackDef', {
            url: '/healthServicePackDef',
            templateUrl: "assets/views/healthmanage/healthServicePackDef.html",
            title: '健康服务包管理',
            ncyBreadcrumb: {
                label: 'healthServicePackDef'
            },
            authentication: true,
            resolve: loadSequence('flow','touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'healthServicePackDefCtrl')
        }).state('app.memberManage.healthServicePack', {
            url: '/healthServicePack',
            templateUrl: "assets/views/healthmanage/healthServicePack.html",
            title: '生成会员激活码',
            ncyBreadcrumb: {
                label: 'healthSericePack'
            },
            authentication: true,
            resolve: loadSequence('flow','touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'healthServicePackCtrl')
        }).state('app.memberManage.memberManage', {
            url: '/memberManage',
            templateUrl: "assets/views/healthmanage/memberManage.html",
            title: '会员管理',
            ncyBreadcrumb: {
                label: 'memberManage'
            },
            authentication: true,
            resolve: loadSequence('flow','touchspin-plugin', 'angular-bootstrap-touchspin', 'ngTable', 'memberManageCtrl')
        }).state('app.memberManage.privateDoctorIm', {
            url: '/privateDoctorIm',
            templateUrl: "assets/views/healthmanage/privateDoctorIm.html",
            title: '私人医生答题',
            ncyBreadcrumb: {
                label: 'PrivateDoctorIm'
            },
            authentication: true,
            resolve: loadSequence('touchspin-plugin', 'angular-bootstrap-touchspin','ngTable', 'privateDoctorImCtrl')
        });

        // Generates a resolve object previously configured in constant.JS_REQUIRES (config.constant.js)
        function loadSequence() {
            var _args = arguments;
            return {
                deps: ['$ocLazyLoad', '$q',
                    function ($ocLL, $q) {
                        var promise = $q.when(1);
                        for (var i = 0, len = _args.length; i < len; i++) {
                            promise = promiseThen(_args[i]);
                        }
                        return promise;

                        function promiseThen(_arg) {
                            if (typeof _arg == 'function')
                                return promise.then(_arg);
                            else
                                return promise.then(function () {
                                    var nowLoad = requiredData(_arg);
                                    if (!nowLoad)
                                        return $.error('Route resolve: Bad resource name [' + _arg + ']');
                                    return $ocLL.load(nowLoad);
                                });
                        }

                        function requiredData(name) {
                            if (jsRequires.modules)
                                for (var m in jsRequires.modules)
                                    if (jsRequires.modules[m].name && jsRequires.modules[m].name === name)
                                        return jsRequires.modules[m];
                            return jsRequires.scripts && jsRequires.scripts[name];
                        }
                    }]
            };
        }
    }]);
