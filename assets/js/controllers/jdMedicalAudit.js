'use strict';
app.controller('MedicalRecordCtrl', function ($scope, $http, toaster, $modal, SweetAlert) {
    $scope.recordList = []; //病历结果集
    $scope.medicalStatus = medicalStatus;   //审核状态

    $scope.prevFlag = false;    //标记上一页按钮是否不可用
    $scope.nextFlag = false;    //标记下一页按钮是否不可用
    $scope.page = {
        pageIndex: 1,   //当前页页码
        pageSize: 6,    //当前页大小
        totalCount: 0,  //总数据数
        totalPage: 0     //总页数
    };

    $scope.searchInfos = {orderNumber: null, patientName: null, phoneNumber: null};

    //获得病历列表
    $scope.getRecordList = function () {
        $scope.searchInfos.pageIndex = $scope.page.pageIndex;
        $scope.searchInfos.pageSize = $scope.page.pageSize;
        $scope.queryString = getQueryString($scope.searchInfos);
        var requestUrl = REST_PREFIX + "jdMedicalRecord/auditList" + $scope.queryString;
        $http.get(requestUrl).success(function (result) {
            $scope.recordList = result.resultPage.result;
            $scope.page.pageIndex = result.resultPage.nowPage;
            $scope.page.pageSize = result.resultPage.pageShow;
            $scope.page.totalCount = result.resultPage.totalCount;
            $scope.page.totalPage = result.resultPage.totalPage;
            
            if ($scope.page.pageIndex == 1 || $scope.page.pageIndex == 0) {
                $scope.prevFlag = true;
            } else {
                $scope.prevFlag = false;
            }
            if ($scope.page.pageIndex >= $scope.page.totalPage) {
                $scope.nextFlag = true;
            } else {
                $scope.nextFlag = false;
            }
        });
    };
    $scope.getRecordList();

    //根据审核状态显示审核名称
    $scope.displayMedicalStatus = function (status) {
        return displayMedicalPicStatus(status);
    };

    //病历审核通过
    $scope.passRecord = function (record) {
        var modalInstance = $modal.open({
            templateUrl: 'passRecord.html',
            backdrop: 'static',
            keyboard: false,
            size: 'lg',
            controller: 'PassJdMedicalAuditCtrl',
            resolve: {
                record: function () {
                    return record;
                }
            }
        });
        modalInstance.result.then(function() {
            $scope.getRecordList();
        });
    };
    //病历审核不通过
    $scope.failRecord = function (record) {
        SweetAlert.swal({
            title: "确定审核不通过吗？",
            text: "确认操作后将无法再修改",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
                var submitRecord = {"uuid" : record.uuid};
                $http.put(REST_PREFIX + "jdMedicalRecord/audit/failure", submitRecord).success(function (result) {
                    if (result.result == 0) {
                        toaster.pop("success", "提示", "操作成功");
                    } else {
                        toaster.pop("error", "提示", result.description);
                    }
                    $scope.getRecordList();
                });
            }
        });
    };

    //查询
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchRecord.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdMedicalAuditCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.page.pageIndex = 1;
            $scope.getRecordList();
        });
    };
    //上一页
    $scope.prev = function () {
        $scope.page.pageIndex--;
        $scope.getRecordList();
    };
    //下一页
    $scope.next = function () {
        $scope.page.pageIndex++;
        $scope.getRecordList();
    };

    //图片放大弹出框
    $scope.open = function (record) {
        $modal.open({
            templateUrl: 'recordPic.html',
            controller: 'MedicalPicCtrl',
            size: 'lg',
            resolve: {
                record: function () {
                    return record;
                }
            }
        });
    }
});

//查询控制器
app.controller('searchJdMedicalAuditCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;

    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {orderNumber: null, patientName: null, phoneNumber: null};
    };
});

//图片查看控制器
app.controller('MedicalPicCtrl', function ($scope, $modalInstance, record) {
    $scope.record = record;
    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    }
});

//审核通过控制器
app.controller('PassJdMedicalAuditCtrl', function ($scope, $http, $modalInstance, toaster, SweetAlert, record) {
    $scope.record = record;
    $scope.submitRecord = {};
    $scope.submitRecord.uuid = record.uuid;
    $scope.ok = function() {
        if(!record.medicalRecordChk && !record.prescriptionChk && !record.medicalReportChk) {
            toaster.pop("error", "提示", "请选择通过项目！");
        } else {
            if(record.medicalRecordChk)
                $scope.submitRecord.recordStatus = "AUDITPASS";
            else
                $scope.submitRecord.recordStatus = "AUDITFAIL";
            if(record.prescriptionChk)
                $scope.submitRecord.prescriptionStatus = "AUDITPASS";
            else
                $scope.submitRecord.prescriptionStatus = "AUDITFAIL";
            if(record.medicalReportChk)
                $scope.submitRecord.reportStatus = "AUDITPASS";
            else
                $scope.submitRecord.reportStatus = "AUDITFAIL";
            $http.put(REST_PREFIX + "jdMedicalRecord/audit/pass", $scope.submitRecord).success(function (result) {
                if (result.result == 0) {
                    toaster.pop("success", "提示", "审核通过操作成功");
                    $modalInstance.close('success');
                } else {
                    toaster.pop("error", "提示", result.description);
                }
            });
        }
    };
    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    }
});