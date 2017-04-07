'use strict';
var cacheButtonCode = [];
app.factory('aideeButtonHelper', function(){
    return {
        getFromCache: function(buttonCode) {
            var len = cacheButtonCode.length;
            var flag = "";
            for(var i = 0; i < len; i++){
                var cache = cacheButtonCode[i];
                if(cache.buttonCode == buttonCode) {
                    flag = cache.flag;
                    break;
                }
            }
            return flag;
        }
    };
});
app.directive('aideeButton', function ($http, aideeButtonHelper) {
    return {
        restrict: 'AC',
        scope: {
          buttonCode: '='
        },
        link: function (scope, elem, attrs) {
            var flag = aideeButtonHelper.getFromCache(scope.buttonCode);
            if(flag) {
                if(flag == "show")
                    elem.removeClass("aidee-button");
            } else {
                $http.get(REST_PREFIX+"buttonPermit/check?buttonCode="+scope.buttonCode).success(function(result) {
                    var cacheObj = {buttonCode:scope.buttonCode, flag:null};
                    if(result) {
                        elem.removeClass("aidee-button");
                        cacheObj.flag = "show";
                    } else {
                        cacheObj.flag = "hide";
                    }
                    var innerFlag = aideeButtonHelper.getFromCache(scope.buttonCode);
                    if(!innerFlag)
                        cacheButtonCode.push(cacheObj);
                });
            }
        }
    };
});