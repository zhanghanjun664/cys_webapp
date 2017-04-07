'use strict';

/************* 用户分析控制器 start ****************/
app.controller('UserAnalysisCtrl', function ($window, $scope, $http, $localStorage, Admin_Constant, toaster,$rootScope,cysIndexedDB) {
    $scope.userTypeList = [
        {"value": "O", "name": "预约用户"},
        {"value": "P", "name": "付费用户"}
    ];
    $scope.getAttachInfos = function () {
        //获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if (!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
        //获取渠道信息
        $scope.jdQrcodeList = angular.copy($localStorage[Admin_Constant.LocalStorage.QrCodes]);
        if (!$scope.jdQrcodeList) {
            console.log(1);
            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                $scope.jdQrcodeList = result.jdQrcodeList;
                $localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
                $scope.jdQrcodeList.push({"uuid": "0", "name": "无"});
            });
        } else {
            $scope.jdQrcodeList.push({"uuid": "0", "name": "无"});
        }


        //if(window.localStorage.getItem('qrCodeVersionKey')){
        //    console.log('can found version!');
        //    var oldKey=window.localStorage.getItem('qrCodeVersionKey');
        //    if(oldKey===null||oldKey===""||oldKey===undefined){
        //        return false;
        //    }
        //    cysIndexedDB.openDB();
        //    $http.get(REST_PREFIX + "jdQrcode/dataset_info").success(function (result) {
        //
        //        var newKey=result.lastModifiedTime+result.count;
        //        if(newKey!==oldKey){
        //
        //            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
        //                $scope.jdQrcodeList = result.jdQrcodeList;
        //                cysIndexedDB.addData(cysIndexedDB.db,'qrCode',result.jdQrcodeList);
        //                window.localStorage.setItem('qrCodeVersionKey',newKey);
        //                $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
        //            });
        //
        //        }else{
        //            setTimeout(function(){
        //                $scope.jdQrcodeList=$rootScope.jdQrcodeList;
        //            },1000);
        //        }
        //    });
        //}else {
        //    $http.get(REST_PREFIX + "jdQrcode/dataset_info").success(function (result) {
        //        var key=result.lastModifiedTime+result.count;
        //        cysIndexedDB.openDB();
        //
        //        $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
        //            $scope.jdQrcodeList = result.jdQrcodeList;
        //            cysIndexedDB.addData(cysIndexedDB.db,'qrCode',result.jdQrcodeList);
        //            window.localStorage.setItem('qrCodeVersionKey',key);
        //            $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
        //        });
        //
        //    });
        //}



    };
    $scope.getAttachInfos();

    //时间选择相关
    $scope.today = new Date();
    $scope.lastWeek = function () {
        var date = new Date();
        var last = date.getTime() - 1000 * 60 * 60 * 24 * 7;
        date.setTime(last);
        return getDateStr(date);
    };
    $scope.thisWeek = function () {
        var date = new Date();
        return getDateStr(date);
    };
    $scope.endOpen = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope.startOpened = false;
        $scope.endOpened = !$scope.endOpened;
    };
    $scope.startOpen = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope.endOpened = false;
        $scope.startOpened = !$scope.startOpened;
    };
    //报表相关
    $scope.chartConfig = {
        options: {
            subtitle: {
                text: ''
            },
            chart: {
                width: 1100,
                height: 450,
                backgroundColor: 'transparent'
            },
            scrollbar: {
                enabled: true
            },
            rangeSelector: {
                enabled: false
            },
            plotOptions: {
                series: {
                    lineWidth: 1,
                    fillOpacity: 0.5
                },
                column: {
                    stacking: 'normal'
                },
                area: {
                    stacking: 'normal',
                    marker: {
                        enabled: false
                    }
                }
            },
            exporting: false,
            xAxis: {
                categories: [],
                max: 20
            },
            yAxis: [
                {
                    min: 0,
                    allowDecimals: false,
                    title: {
                        text: 'pv/登录uv/登录ip'
                    },
                    labels: {
                        format: '{value}'
                    }
                }
            ],
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            title: {
                text: '用户分析',
                x: -20
            },
            credits: {
                enabled: false
            },
            loading: false,
            tooltip: {
                crosshairs: [
                    {
                        width: 1,
                        dashStyle: 'dash',
                        color: '#898989'
                    },
                    {
                        width: 1,
                        dashStyle: 'dash',
                        color: '#898989'
                    }
                ],
                borderWidth: 1,
                borderRadius: 5,
                borderColor: '#a4a4a4',
                shadow: false,
                useHTML: true,
                percentageDecimals: 2,
                backgroundColor: "rgba(0,0,0,.4)",
                style: {
                    color: '#fff',
                    padding: '10px'
                },
                shared: true

            },
            useHighStocks: true
        },
        series: [{
            name: 'PV',
            data: []

        }, {
            name: '登录UV',
            data: []
        }, {
            name: '登录IP',
            data: []
        }],
        func: function (chart) {
            $scope.chartData = chart;
            $scope.chartExport = $.proxy(chart.exportChart, chart);
        }
    };

    //筛选条件
    $scope.condition = {
        startDate: $scope.lastWeek(),
        endDate: $scope.thisWeek(),
        userType: null,
        qrcodeList: null,
        areaList: null
    };

    //确定筛选条件
    $scope.resultData = [];
    $scope.ok = function () {
        if(!$scope.condition.startDate || !$scope.condition.endDate) {
            toaster.pop("error", "提示", "时间格式不正确");
            return;
        }
        $scope.queryString = "";
        var str;
        if ($scope.condition.startDate instanceof Date) {
            addQueryString("startDate=" + getDateStr($scope.condition.startDate));
            str = getDateStr($scope.condition.startDate);
        } else {
            addQueryString("startDate=" + $scope.condition.startDate);
            str = angular.copy($scope.condition.startDate);
        }
        str = str.replace(/-/g,"/");
        var date1 = new Date(str);
        if ($scope.condition.endDate instanceof Date) {
            addQueryString("endDate=" + getDateStr($scope.condition.endDate));
            str = getDateStr($scope.condition.endDate);
        } else {
            addQueryString("endDate=" + $scope.condition.endDate);
            str = angular.copy($scope.condition.endDate);
        }
        str = str.replace(/-/g,"/");
        var date2 = new Date(str);
        var diff = date2.getTime() - date1.getTime();
        if(diff > 1000*60*60*24*30) {
            toaster.pop("error", "提示", "时间跨度不能超过30天");
            return;
        }
        if ($scope.condition.userType) {
            var str = new StringBuilder();
            $scope.condition.userType.forEach(function (type) {
                str.append(type.value);
            });
            addQueryString("userType=" + str.toString());
        }
        if ($scope.condition.qrcodeList) {
            var str = new StringBuilder();
            var first = true;
            $scope.condition.qrcodeList.forEach(function (sqrcode) {
                if (first) {
                    first = false;
                    str.append(sqrcode.uuid);
                } else {
                    str.append(";" + sqrcode.uuid);
                }
            });
            addQueryString("qrcodeList=" + str.toString());
        }
        if ($scope.condition.areaList) {
            var str = new StringBuilder();
            var first = true;
            $scope.condition.areaList.forEach(function (area) {
                if (first) {
                    first = false;
                    str.append(area.uuid);
                } else {
                    str.append(";" + area.uuid);
                }
            });
            addQueryString("areaList=" + str.toString());
        }
        var requestUrl = REST_PREFIX + "userDataAnalysis/userDataAnalysis" + $scope.queryString;
        $http.get(requestUrl).success(function (result) {
            if(result.result != 0) {
                toaster.pop("error", "提示", result.description);
            } else {
                $scope.resultData = result.userDataAnalysisList;
                var categories = [];
                var ipData = [];
                var uvData = [];
                var pvData = [];
                var growthData = [];
                angular.forEach(result.userDataAnalysisList, function (data) {
                    categories.push(data.dateStr);
                    ipData.push(data.ip);
                    uvData.push(data.uv);
                    pvData.push(data.pv);
                    growthData.push(data.count);
                });
                for (var i = ipData.length; i < 21; i++) {
                    categories.push("");
                }
                $scope.chartConfig.options.xAxis.categories = categories;
                $scope.chartConfig.series[0].data = pvData;//pv
                $scope.chartConfig.series[1].data = uvData;//登录uv
                $scope.chartConfig.series[2].data = ipData;//登录ip
                //$scope.chartConfig.series[3].data = growthData;//新增用户
            }
        });
    };

    //拼接查询条件
    function addQueryString(condition) {
        if ($scope.queryString) {
            $scope.queryString += '&' + condition;
        } else {
            $scope.queryString += '?' + condition;
        }
    }
});
/************* 用户分析控制器 end ****************/

/************* 活跃用户分析控制器 start ****************/
app.controller('ActiveUserAnalysisCtrl', function ($scope, $http, $modal, toaster, SweetAlert, $localStorage, Admin_Constant) {
    $scope.startOpen = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope.endOpened = false;
        $scope.startOpened = !$scope.startOpened;
    };
    $scope.userTypeList = [
        {"value": "O", "name": "预约用户"},
        {"value": "P", "name": "付费用户"}
    ];
    $scope.getAttachInfos = function () {
        //获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if (!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
        //获取渠道信息
        $scope.jdQrcodeList = angular.copy($localStorage[Admin_Constant.LocalStorage.QrCodes]);
        if (!$scope.jdQrcodeList) {
            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                $scope.jdQrcodeList = result.jdQrcodeList;
                $localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
                $scope.jdQrcodeList.push({"uuid": "0", "name": "无"});
            });
        } else {
            $scope.jdQrcodeList.push({"uuid": "0", "name": "无"});
        }
    };
    $scope.getAttachInfos();

    //筛选条件
    $scope.condition = {
        userType: null,
        qrcodeList: null,
        areaList: null
    };

    //确定筛选条件
    $scope.resultData = [];
    $scope.ok = function () {
        $scope.queryString = "";
        if ($scope.condition.userType) {
            var str = new StringBuilder();
            $scope.condition.userType.forEach(function (type) {
                str.append(type.value);
            });
            addQueryString("userType=" + str.toString());
        }
        if ($scope.condition.qrcodeList) {
            var str = new StringBuilder();
            var first = true;
            $scope.condition.qrcodeList.forEach(function (sqrcode) {
                if (first) {
                    first = false;
                    str.append(sqrcode.uuid);
                } else {
                    str.append(";" + sqrcode.uuid);
                }
            });
            addQueryString("qrcodeList=" + str.toString());
        }
        if ($scope.condition.areaList) {
            var str = new StringBuilder();
            var first = true;
            $scope.condition.areaList.forEach(function (area) {
                if (first) {
                    first = false;
                    str.append(area.uuid);
                } else {
                    str.append(";" + area.uuid);
                }
            });
            addQueryString("areaList=" + str.toString());
        }
        if ($scope.condition.startDate instanceof Date) {
            addQueryString("startDate=" + getDateStr($scope.condition.startDate));
        }
        var requestUrl = REST_PREFIX + "userDataAnalysis/activeUserAnalysis" + $scope.queryString;
        $http.get(requestUrl).success(function (result) {
            $scope.resultData = result.userDataAnalysis;
        });
    };

    //拼接查询条件
    function addQueryString(condition) {
        if ($scope.queryString) {
            $scope.queryString += '&' + condition;
        } else {
            $scope.queryString += '?' + condition;
        }
    }
});
/************* 活跃用户分析控制器 end ****************/

/************* 订单分析控制器 start ****************/
app.controller('OrderAnalysisCtrl', function ($scope, $http, $modal, toaster, SweetAlert, $localStorage, Admin_Constant) {
    $scope.userTypeList = [
        {"value": "O", "name": "预约用户"},
        {"value": "P", "name": "付费用户"}
    ];
    $scope.orderStatus = patientOrderStatus; //订单状态
    $scope.getAttachInfos = function () {
        //获取地区信息
        $scope.jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if (!$scope.jdDistricts) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                $scope.jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = $scope.jdDistricts;
            });
        }
        //获取渠道信息
        $scope.jdQrcodeList = angular.copy($localStorage[Admin_Constant.LocalStorage.QrCodes]);
        if (!$scope.jdQrcodeList) {
            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                $scope.jdQrcodeList = result.jdQrcodeList;
                $localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
                $scope.jdQrcodeList.push({"uuid": "0", "name": "无"});
            });
        } else {
            $scope.jdQrcodeList.push({"uuid": "0", "name": "无"});
        }
    };
    $scope.getAttachInfos();
    //时间选择相关
    $scope.today = new Date();
    $scope.lastWeek = function () {
        var date = new Date();
        var last = date.getTime() - 1000 * 60 * 60 * 24 * 7;
        date.setTime(last);
        return getDateStr(date);
    };
    $scope.thisWeek = function () {
        var date = new Date();
        return getDateStr(date);
    };
    $scope.endOpen = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope.startOpened = false;
        $scope.endOpened = !$scope.endOpened;
    };
    $scope.startOpen = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope.endOpened = false;
        $scope.startOpened = !$scope.startOpened;
    };

    //报表相关
    $scope.chartConfig = {
        options: {
            plotOptions: {
                series: {
                    lineWidth: 1,
                    fillOpacity: 0.5
                }
            },
            chart: {
                width: 1100,
                height: 450,
                backgroundColor: 'transparent'
            },
            exporting: false,
            scrollbar: {
                enabled: true
            },
            xAxis: {
                categories: [],
                max: 20
            },
            yAxis: {
                title: {
                    text: '订单数'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },

            legend: {
                enabled: false
            },
            title: {
                text: '订单数据分析'
            },
            credits: {
                enabled: false
            },
            loading: false,
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
                    dashStyle: 'dash',
                    color: '#898989'
                }
            },
            useHighStocks: false
        },
        series: [{
            name: '订单数',
            data: []
        }],
        func: function (chart) {
            $scope.chartData = chart;
            $scope.chartExport = $.proxy(chart.exportChart, chart);
        }
    };

    //筛选条件
    $scope.condition = {
        startDate: $scope.lastWeek(),
        endDate: $scope.thisWeek(),
        userType: null,
        qrcodeList: null,
        areaList: null,
        statusList: null
    };

    //确定筛选条件
    $scope.resultData = [];
    $scope.ok = function () {
        $scope.queryString = "";
        if ($scope.condition.startDate instanceof Date) {
            addQueryString("startDate=" + getDateStr($scope.condition.startDate));
        } else {
            addQueryString("startDate=" + $scope.condition.startDate);
        }
        if ($scope.condition.endDate instanceof Date) {
            addQueryString("endDate=" + getDateStr($scope.condition.endDate));
        } else {
            addQueryString("endDate=" + $scope.condition.endDate);
        }
        if ($scope.condition.userType) {
            var str = new StringBuilder();
            $scope.condition.userType.forEach(function (type) {
                str.append(type.value);
            });
            addQueryString("userType=" + str.toString());
        }
        if ($scope.condition.qrcodeList) {
            var str = new StringBuilder();
            var first = true;
            $scope.condition.qrcodeList.forEach(function (sqrcode) {
                if (first) {
                    first = false;
                    str.append(sqrcode.uuid);
                } else {
                    str.append(";" + sqrcode.uuid);
                }
            });
            addQueryString("qrcodeList=" + str.toString());
        }
        if ($scope.condition.areaList) {
            var str = new StringBuilder();
            var first = true;
            $scope.condition.areaList.forEach(function (area) {
                if (first) {
                    first = false;
                    str.append(area.uuid);
                } else {
                    str.append(";" + area.uuid);
                }
            });
            addQueryString("areaList=" + str.toString());
        }
        if ($scope.condition.statusList) {
            var str = new StringBuilder();
            var first = true;
            $scope.condition.statusList.forEach(function (status) {
                if (first) {
                    first = false;
                    str.append(status.value);
                } else {
                    str.append(";" + status.value);
                }
            });
            addQueryString("statusList=" + str.toString());
        }
        var requestUrl = REST_PREFIX + "userDataAnalysis/orderAnalysis" + $scope.queryString;
        $http.get(requestUrl).success(function (result) {
            $scope.resultData = result.userDataAnalysisList;
            var categories = [];
            var seriesData = [];
            angular.forEach($scope.resultData, function (data) {
                categories.push(data.dateStr);
                seriesData.push(data.count);
            });
            for (var i = seriesData.length; i < 21; i++) {
                categories.push("");
            }
            $scope.chartConfig.options.xAxis.categories = categories;
            $scope.chartConfig.series[0].data = seriesData;
        });
    };

    //拼接查询条件
    function addQueryString(condition) {
        if ($scope.queryString) {
            $scope.queryString += '&' + condition;
        } else {
            $scope.queryString += '?' + condition;
        }
    }
});
/************* 订单分析控制器 end ****************/

/************* 页面分析控制器 start ****************/
app.controller('PageAnalysisCtrl', function ($scope, $http, $modal, toaster, SweetAlert, $localStorage, Admin_Constant) {
    //受访页面
    $scope.surveyedPages = [
        {"value": "homeHospital", "name": "首页-医院"},
        {"value": "homeDisease", "name": "首页-疾病"},
        {"value": "homeFocus", "name": "首页-关注"},
        {"value": "homeTime", "name": "首页-时间"},
        {"value": "mine", "name": "我的"},
        {"value": "familyContact", "name": "家庭联系人"},
        {"value": "followDoctor", "name": "关注的医生"},
        {"value": "myOrder", "name": "我的预约"},
        {"value": "medicalManagement", "name": "病历管理"},
        {"value": "healthMeasurment", "name": "健康测量"},
        {"value": "cashCoupon", "name": "现金券"},
        {"value": "message", "name": "消息"},
        {"value": "setting", "name": "设置"},
        {"value": "doctorHomePage", "name": "医生主页"}
    ];

    //时间选择相关
    $scope.today = new Date();
    $scope.lastWeek = function () {
        var date = new Date();
        var last = date.getTime() - 1000 * 60 * 60 * 24 * 7;
        date.setTime(last);
        return getDateStr(date);
    };
    $scope.thisWeek = function () {
        var date = new Date();
        return getDateStr(date);
    };
    $scope.endOpen = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope.startOpened = false;
        $scope.endOpened = !$scope.endOpened;
    };
    $scope.startOpen = function ($event) {
        $event.preventDefault();
        $event.stopPropagation();
        $scope.endOpened = false;
        $scope.startOpened = !$scope.startOpened;
    };
    $scope.chartConfig = {
        options: {
            subtitle: {
                text: ''
            },
            chart: {
                width: 1100,
                height: 450,
                backgroundColor: 'transparent'
            },
            scrollbar: {
                enabled: true
            },
            rangeSelector: {
                enabled: false
            },
            plotOptions: {
                series: {
                    lineWidth: 1,
                    fillOpacity: 0.5
                },
                column: {
                    stacking: 'normal'
                },
                area: {
                    stacking: 'normal',
                    marker: {
                        enabled: false
                    }
                }
            },
            exporting: false,
            xAxis: {
                categories: [],
                type: "datetime",
                max: 20
            },
            yAxis: [
                {
                    min: 0,
                    allowDecimals: false,
                    title: {
                        text: 'pv/uv/ip'
                    },
                    labels: {
                        format: '{value}'
                    }
                }
            ],
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            title: {
                text: '页面数据分析',
                x: -20
            },
            credits: {
                enabled: false
            },
            loading: false,
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
                    dashStyle: 'dash',
                    color: '#898989'
                }
            },
            useHighStocks: true
        },
        series: [{
            name: 'PV',
            data: []

        }, {
            name: 'UV',
            data: []
        }, {
            name: 'IP',
            data: []
        }],
        func: function (chart) {
            $scope.chartData = chart;
            $scope.chartExport = $.proxy(chart.exportChart, chart);
        }
    };

    //筛选条件
    $scope.condition = {
        startDate: $scope.lastWeek(),
        endDate: $scope.thisWeek(),
        visitPage: "homeHospital"
    };

    //确定筛选条件
    $scope.resultData = [];
    $scope.ok = function () {
        $scope.queryString = "";
        if ($scope.condition.startDate instanceof Date) {
            addQueryString("startDate=" + getDateStr($scope.condition.startDate));
        } else {
            addQueryString("startDate=" + $scope.condition.startDate);
        }
        if ($scope.condition.endDate instanceof Date) {
            addQueryString("endDate=" + getDateStr($scope.condition.endDate));
        } else {
            addQueryString("endDate=" + $scope.condition.endDate);
        }
        if($scope.condition.visitPage){
            addQueryString("visitPage=" + $scope.condition.visitPage);
        }
        var requestUrl = REST_PREFIX + "userDataAnalysis/pageAnalysis" + $scope.queryString;
        $http.get(requestUrl).success(function (result) {
            $scope.resultData = result.userDataAnalysisList;
            var categories = [];
            var pvSeriesData = [];
            var uvSeriesData = [];
            var ipSeriesData = [];
            var len = result.userDataAnalysisList.length;
            angular.forEach(result.userDataAnalysisList, function (data) {
                categories.push(data.dateStr);
                pvSeriesData.push(data.pv);
                uvSeriesData.push(data.uv);
                ipSeriesData.push(data.ip);
            });
            for (var i = len; i < 21; i++) {
                categories.push("");
            }
            $scope.chartConfig.options.xAxis.categories = categories;
            $scope.chartConfig.series[0].data = pvSeriesData;
            $scope.chartConfig.series[1].data = uvSeriesData;
            $scope.chartConfig.series[2].data = ipSeriesData;
        });
    };

    //拼接查询条件
    function addQueryString(condition) {
        if ($scope.queryString) {
            $scope.queryString += '&' + condition;
        } else {
            $scope.queryString += '?' + condition;
        }
    }

});
/************* 页面分析控制器 end ****************/