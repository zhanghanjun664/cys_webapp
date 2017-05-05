app.controller('selectPatientCtrl', function ($scope, $http, $modalInstance, ngTableParams, toaster,$localStorage,Admin_Constant,$rootScope){
    $scope.justopen = true;

    $scope.resultPage = {totalCount:0};
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行
    var jdDistricts = []; //地区信息
    var jdDistrictAreas = []; //地区信息

    $scope.getAttachInfos = function () {
        //获取地区信息
        jdDistricts = $localStorage[Admin_Constant.LocalStorage.Districts];
        if(!jdDistricts || jdDistricts.length == 0) {
            $http.get(REST_PREFIX + "jdDistrict/list").success(function (result) {
                jdDistricts = result.districtList;
                $localStorage[Admin_Constant.LocalStorage.Districts] = jdDistricts;
            });
        }
        $scope.jdDistricts = jdDistricts.filter(function(districts){
            if(districts.isProvince){
                return districts;
            }
        });
        //获得市辖区信息
        jdDistrictAreas = $localStorage[Admin_Constant.LocalStorage.DistrictAreas];
        if(!jdDistrictAreas) {
            $http.get(REST_PREFIX + "jdDistrictArea/list").success(function (result) {
                jdDistrictAreas = result.districtAreaList;
                $localStorage[Admin_Constant.LocalStorage.DistrictAreas] = jdDistrictAreas;
            });
        }
        //获取渠道信息
        //$scope.jdQrcodeList = angular.copy($localStorage[Admin_Constant.LocalStorage.QrCodes]);
        if(!$rootScope.jdQrcodeList) {
            $http.get(REST_PREFIX + "jdQrcode/list").success(function (result) {
                $scope.jdQrcodeList = result.jdQrcodeList;
                //$localStorage[Admin_Constant.LocalStorage.QrCodes] = angular.copy(result.jdQrcodeList);
                $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
            });
        } else {
            $scope.jdQrcodeList.push({"uuid":"0","name":"无"});
        }
    };
    $scope.getAttachInfos();



    //根据地区ID显示地区的名称
    $scope.displayDistrictName = function (districtId) {
        for(var i = 0; i < $scope.jdDistricts.length; i++) {
            if($scope.jdDistricts[i].uuid == districtId)
                return $scope.jdDistricts[i].name;
        }
    };

    //根据地区Id得到市辖区信息
    $scope.changeDistrictAreas = function (districtId){
        $scope.jdDistrictAreas = [];
        $scope.searchInfos.districtAreaId = "";
        jdDistrictAreas.forEach(function(item){
            if (item.jdDistrictId == districtId && item.isCity)
                $scope.jdDistrictAreas.push(item);
        });
    };

    $scope.setDistrictArea = function (){
        if($scope.searchInfos != undefined && $scope.searchInfos != null){
            $scope.jdDistrictAreas =[];
            for (var i=0; i<jdDistrictAreas.length; i++){
                if (jdDistrictAreas[i].jdDistrictId == $scope.searchInfos.districtId){
                    $scope.jdDistrictAreas.push(jdDistrictAreas[i]);
                }
            }
        }
    };
    $scope.setDistrictArea();

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            if ($scope.justopen) {
                $scope.justopen = false;
            } else {
                commonResetSelection($scope);
                $scope.patientInfos.pageIndex = params.page();
                $scope.patientInfos.pageSize = params.count();
                $scope.patientInfos.masterOnly = true;
                $scope.queryString = getQueryString($scope.patientInfos);

                var requestUrl = REST_PREFIX + "patient/list" + $scope.queryString;
                $http.get(requestUrl).success(function (result) {
                    $scope.resultPage = result.resultPage;
                    params.total($scope.resultPage.totalCount);
                    params.page($scope.resultPage.nowPage);
                    $scope.data = $scope.resultPage.result;
                    $defer.resolve($scope.data);
                });
            }
        }
    });

    //改变当前选中的行
    $scope.changeSelection = function(index) {
        commonChangeSelection($scope, index);
    };

    $scope.patientInfos = {districtId:null,districtAreaId:null,createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,qrcodeId:null};
    $("#createTimeEnd").val($scope.patientInfos.createTimeEnd);
    $("#createTimeStart").val($scope.patientInfos.createTimeStart);

    //查询
    $scope.query = function () {
        $scope.patientInfos.createTimeStart = $("#createTimeStart").val();
        $scope.patientInfos.createTimeEnd = $("#createTimeEnd").val();
        if($("#districtId").find("option:selected").text() != null
            && $("#districtId").find("option:selected").text() != ''
            && $("#districtId").find("option:selected").text() != '全部'){
            var province = $("#districtId").find("option:selected").text();
            $scope.searchInfos.province =province.replace("省");
        }
        if($("#districtAreaId").find("option:selected").text() != null
            && $("#districtAreaId").find("option:selected").text() != ''
            && $("#districtAreaId").find("option:selected").text() != '全部'){
            var city = $("#districtAreaId").find("option:selected").text();
            $scope.patientInfos.city = city.replace("市","");
        }
        $scope.tableParams.reload();
    };
    $scope.ok = function (e) {
        if ($scope.selections.length == 0) {
            toaster.pop("warning", "", "请选择一条记录", "1000");
        } else if ($scope.selections.length > 1) {
            toaster.pop("warning", "", "请只选择一条记录", "1000");
        } else {
            var rowObject = new Object();
            rowObject.jdPatientId = $scope.selections[0].uuid;
            rowObject.name = $scope.selections[0].name;
            $modalInstance.close(rowObject);
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        commonResetSelection($scope);
        $scope.patientInfos = {districtId:null,districtAreaId:null,createTimeStart:null,createTimeEnd:null,name:null,phoneNumber:null,qrcodeId:null};
    };
});