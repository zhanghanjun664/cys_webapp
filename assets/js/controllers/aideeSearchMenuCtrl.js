'use strict';
app.filter('propsFilter', function () {
    return function (items, props) {
        var out = [];
        if (angular.isArray(items)) {
            items.forEach(function (item) {
                var itemMatches = false;
                var keys = Object.keys(props);
                for (var i = 0; i < keys.length; i++) {
                    var prop = keys[i];
                    var text = props[prop].toLowerCase();
                    if (item[prop].toString().toLowerCase().indexOf(text) !== -1) {
                        itemMatches = true;
                        break;
                    }
                }
                if (itemMatches) {
                    out.push(item);
                }
            });
        } else {
            out = items;
        }
        return out;
    };
});
app.controller('AideeSearchMenuCtrl', function ($scope) {

    $scope.menu = {};
    $scope.menus = userSearchMenu;

    $scope.menuSelected = function($item) {
        var url = $item.url.replace(/\./g,"/");
        window.location.href = "index.html#/" + url;
    }
});
