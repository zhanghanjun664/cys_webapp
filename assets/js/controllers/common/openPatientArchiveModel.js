var openPatientArchiveModel = function(masterPatientId,$modal,$scope) {
	console.log("member masterPatientId=", masterPatientId);
	$scope.patientArchive = {};
	$scope.patient={};
	var modalInstance = $modal.open({
		templateUrl : '../../../assets/views/common/selectPatientArchive.html',
		//templateUrl: 'selectHealthServicePack.html',
		backdrop : 'static',
		keyboard : false,
		controller : 'selectPatientArchiveCtrl',
		size : "lg",
		resolve : {
			patient : function() {
				$scope.patient.masterPatientId = masterPatientId;
				return $scope.patient;
			}
		}
	});
	modalInstance.result.then(function(result) {
		console.log("selectPatientArchive result=", result);
		for ( var k in result) {
			$scope.patientArchive[k] = result[k];
		}
		console.log("selectPatientArchive =", $scope.patientArchive);
	});
};