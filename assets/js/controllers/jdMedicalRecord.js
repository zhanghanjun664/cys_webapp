'use strict';
app.controller('JdMedicalRecordCtrl', function ($scope, $http, $modal, ngTableParams) {
    $scope.resultPage = {totalCount: 0};
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "jdMedicalRecord/page" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);
            });
        }
    });

    //点击查询按钮
    $scope.searchInfos = {
        hospitalName: null,
        doctorName: null,
        visitedDateStart: null,
        visitedDateEnd: null,
        patientName: null,
        phoneNumber: null
    };
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchJdMedicalRecord.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchJdMedicalRecordCtrl',
            resolve: {
                searchInfos: function () {
                    return $scope.searchInfos;
                }
            }
        });
        modalInstance.result.then(function (searchInfos) {
            $scope.searchInfos = searchInfos;
            $scope.tableParams.reload();
        });
    };

    //更多
    $scope.more = function (jdMedicalRecord) {
        var modalInstance = $modal.open({
            templateUrl: 'moreJdMedicalRecordInfo.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'moreJdMedicalRecordInfoCtrl',
            size:'lg',
            resolve: {
                jdMedicalRecord: function () {
                    return jdMedicalRecord;
                }
            }
        });
    };
});
app.controller('searchJdMedicalRecordCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;
    $("#visitedDateStart").val($scope.searchInfos.visitedDateStart);
    $("#visitedDateEnd").val($scope.searchInfos.visitedDateEnd);

    $scope.ok = function (e) {
        $scope.searchInfos.visitedDateStart = $("#visitedDateStart").val();
        $scope.searchInfos.visitedDateEnd = $("#visitedDateEnd").val();
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {
            hospitalName: null,
            doctorName: null,
            visitedDateStart: null,
            visitedDateEnd: null,
            patientName: null,
            phoneNumber: null
        };
    };
});
app.controller('moreJdMedicalRecordInfoCtrl', function ($scope, $http, $modalInstance, jdMedicalRecord) {
    $scope.jdMedicalRecordInfo = jdMedicalRecord;
    $scope.medicalRecordPic = false;
    $scope.prescriptionPic = false;
    $scope.medicalReportPic = false;
    if ($scope.jdMedicalRecordInfo.medicalRecord) $scope.medicalRecordPic = true;
    if ($scope.jdMedicalRecordInfo.prescription) $scope.prescriptionPic = true;
    if ($scope.jdMedicalRecordInfo.medicalReport) $scope.medicalReportPic = true;

    $scope.displayMedicalPicStatus = function (status) {
        return displayMedicalPicStatus(status);
    }
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
});