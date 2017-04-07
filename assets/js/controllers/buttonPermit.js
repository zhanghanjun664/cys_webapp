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
app.controller('ButtonPermitCtrl', function ($rootScope, $scope, $http, $modal, ngTableParams, toaster, SweetAlert) {
    $scope.user = $rootScope.user;
    $scope.resultPage = {totalCount: 0}; //后台返回总的结果集
    $scope.data = []; //当前页面的结果集
    $scope.selections = []; //当前页面选中的行

    //获得角色列表信息
    $scope.roles = [];
    $scope.getRoleInfos = function () {
        $http.get(REST_PREFIX + "role/list").success(function (result) {
            $scope.roles = result.roleList;
        });
    };
    $scope.getRoleInfos();

    //根据角色ID列表获得角色名串
    $scope.displayRoleNameList = function (list) {
        var roleNameList = "";
        var roleIdList = list.split(",");
        for (var i = 0; i < roleIdList.length; i++) {
            for (var j = 0; j < $scope.roles.length; j++) {
                if ($scope.roles[j].uuid == roleIdList[i]) {
                    roleNameList += $scope.roles[j].name + "  ";
                    break;
                }
            }
        }
        return roleNameList;
    };


    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            commonResetSelection($scope);
            $scope.searchInfos.pageIndex = params.page();
            $scope.searchInfos.pageSize = params.count();
            $scope.queryString = getQueryString($scope.searchInfos);
            var requestUrl = REST_PREFIX + "buttonPermit/list" + $scope.queryString;
            $http.get(requestUrl).success(function (result) {
                $scope.resultPage = result.resultPage;
                params.total($scope.resultPage.totalCount);
                params.page($scope.resultPage.nowPage);
                $scope.data = $scope.resultPage.result;
                $defer.resolve($scope.data);
            });
        }
    });

    //新增
    $scope.edit = function (buttonPermit) {
        var modalInstance = $modal.open({
            templateUrl: 'editbuttonPermit.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'editbuttonPermitCtrl',
            resolve: {
                buttonPermit: function () {
                    return buttonPermit;
                },
                roles: function () {
                    return $scope.roles;
                },
                user: function () {
                    return $scope.user;
                }
            }
        });
        modalInstance.result.then(function (result) {
            $scope.tableParams.reload();
        });
    };

    //删除
    $scope.deleteItem = function (id) {
        SweetAlert.swal({
            title: "确定删除吗?",
            text: "记录删除后将不能恢复",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        }, function (isConfirm) {
            if (isConfirm) {
                $http.delete(REST_PREFIX + "buttonPermit/" + id).success(function (result) {
                    if (result.result != 0) {
                        toaster.pop("error", "提示", result.description);
                    } else {
                        $scope.tableParams.reload();
                    }
                });
            }
        });
    };

    //全选/全不选
    $scope.selectAll = function () {
        commonSelectAll($scope);
    };

    //改变当前选中的行
    $scope.changeSelection = function (index) {
        commonChangeSelection($scope, index);
    };

    //点击删除按钮
    $scope.deleteAll = function () {
        commonDeleteButtonClick(toaster, $scope);
    };

    //点击编辑按钮
    $scope.update = function () {
        commonEditButtonClick(toaster, $scope);
    };

    //点击查询按钮
    $scope.searchInfos = {name: null};
    $scope.search = function () {
        var modalInstance = $modal.open({
            templateUrl: 'searchButtonPermit.html',
            backdrop: 'static',
            keyboard: false,
            controller: 'searchButtonPermitCtrl',
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
    }
});
app.controller('searchButtonPermitCtrl', function ($scope, $modalInstance, searchInfos) {
    $scope.searchInfos = searchInfos;
    $scope.ok = function (e) {
        $modalInstance.close($scope.searchInfos);
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };
    $scope.clear = function () {
        $scope.searchInfos = {name: null};
    };
});
app.controller('editbuttonPermitCtrl', function ($scope, $http, $modalInstance, toaster, roles, buttonPermit, user) {
    $scope.user = user;
    $scope.submitFlag = false; //为防止表单重复提交
    $scope.buttonPermitInfo = {};
    $scope.roles = roles;
    if (buttonPermit) {
        var selectedRoles = [];
        var roleIdList = buttonPermit.roleList.split(",");
        $scope.roles.forEach(function (role) {
            for (var i = 0; i < roleIdList.length; i++) {
                if (role.uuid == roleIdList[i]) {
                    selectedRoles.push(role);
                }
            }
        });
        $scope.buttonPermitInfo.buttonSelectRole = selectedRoles;
        $scope.buttonPermitInfo.uuid = buttonPermit.uuid;
        $scope.buttonPermitInfo.name = buttonPermit.name;
        $scope.buttonPermitInfo.description = buttonPermit.description;
    }
    $scope.ok = function (e) {
        if (!validateFiledNullMax(toaster, $scope.buttonPermitInfo.name, "按钮名称", true, 0)
            || !validateFiledNullMax(toaster, $scope.buttonPermitInfo.description, "按钮描述", true, 0)
            || !validateFiledNullMax(toaster, $scope.buttonPermitInfo.buttonSelectRole, "有权限角色", true, 0))
            return;
        //提交
        if (!$scope.submitFlag) {
            $scope.submitFlag = true;
            var selectedRoles = [];
            angular.forEach($scope.buttonPermitInfo.buttonSelectRole, function(role){
                var selectedRole = {};
                selectedRole.uuid = role.uuid;
                selectedRoles.push(selectedRole);
            });
            $scope.buttonPermitInfo.buttonSelectRole=selectedRoles;
            if (buttonPermit) {
                $http.put(REST_PREFIX + "buttonPermit", $scope.buttonPermitInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "按钮名称【" + $scope.buttonPermitInfo.name + "】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            } else {
                $http.post(REST_PREFIX + "buttonPermit", $scope.buttonPermitInfo).success(function (result) {
                    if (!result) {
                        $scope.submitFlag = false;
                        toaster.pop("error", "提示", "按钮名称【" + $scope.buttonPermitInfo.name + "】已经存在");
                    } else {
                        $modalInstance.close("success");
                    }
                });
            }
        }
    };
    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    }
});