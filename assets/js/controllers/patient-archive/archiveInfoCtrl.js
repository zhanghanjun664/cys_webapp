app.controller('patientArchiveInfoEditCtrl',['$scope','$http','$modal','$location', 'toaster',
                                  function($scope, $http, $modal, $location, $localStorage, toaster){
    var jdDistricts;
    if(!jdDistricts) {
        $http.get('/rest/' + "jdDistrict/list?provinceOnly=true").success(function (result) {
            jdDistricts = result.districtList;
            $scope.jdDistricts = jdDistricts;
        });
    }
    
    
    var jdDistrictAreas;
    if(!jdDistrictAreas) {
        $http.get('/rest/' + "jdDistrictArea/list").success(function (result) {
            jdDistrictAreas = result.districtAreaList;
            $scope.jdDistrictAreas = jdDistrictAreas;
        });
    }
    
    //根据地区Id得到市辖区信息
    $scope.changeDistrictAreas = function (districtId){
        $scope.jdDistrictAreas = [];
        $scope.patient.city = "";
        jdDistrictAreas.forEach(function(item){
            if (item.jdDistrictId == districtId)
                $scope.jdDistrictAreas.push(item);
        });
    };
    
    //根据地区Id得到市辖区信息
    $scope.autoFillDateOfBirth = function (){
        $scope.patient.dateOfBirth = "";
        var idCard = $scope.patient.idCard;
        if (idCard.length == 18 || idCard.length == 15) {
            var year, month, day;
            year = idCard.substring(6, 10);
            month = idCard.substring(10, 12);
            day = idCard.substring(12, 14);
            $scope.patient.dateOfBirthInString = year + '-' + month + '-' + day;
            $scope.autoFillAge();
        }
    };
    
    $scope.autoFillAge = function (){
    	$scope.patient.age = "";
    	var dateOfBirth = $scope.patient.dateOfBirthInString;
        if (dateOfBirth.length > 3) {
        	var year = dateOfBirth.substring(0, 4);
        	console.log(year);
            var myDate = new Date();
            $scope.patient.age = myDate.getFullYear() - year;
        }
    };
    
  //根据地区Id得到市辖区信息
    $scope.autoFillGender = function (idCard){
        $scope.patient.dateOfBirth = "";
        if (idCard.length == 18 || idCard.length == 15) {
            var year, month, day;
            year = idCard.substring(6, 10);
            month = idCard.substring(10, 12);
            day = idCard.substring(12, 14);
            $scope.patient.dateOfBirth = year + '-' + month + '-' + day;
        }
    };
    
    $scope.selectOccupation = function() {
    	if ($scope.occupationSelected == "其他") {
    		$scope.otherOccupationSelected = true;
    		$scope.patient.occupation = $scope.occupationFilled;
    	} else {
    		$scope.otherOccupationSelected = false;
    		$scope.occupationFilled = "";
    		$scope.patient.occupation = $scope.occupationSelected;
    	}
    }

    //初始化市辖区信息
    $scope.setDistrictArea = function (){
        for (var i=0; i<jdDistrictAreas.length; i++){
            if (jdDistrictAreas[i].jdDistrictId == $scope.searchInfos.districtId){
                $scope.jdDistrictAreas.push(jdDistrictAreas[i]);
            }
        }
    };
    
    $scope.ok = function (e) {
        //提交
        if($scope.patient) {
        	$scope.patient.dateOfBirth = undefined;
            $http.post('/rest/' + "archive/general", $scope.patient).success(function(result) {
                if (result.body.code != 2000) {
                    alert("保存数据失败");
                } else {
                	alert("保存成功！");
                }
            });
        }
    };
}]);