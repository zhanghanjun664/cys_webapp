'use strict';
app.controller('PushOrderPatientTextMessageCtrl', function ($scope, $http, $modal, toaster, SweetAlert) {
    $scope.content = "";
    $scope.deviceType = {};
    $scope.deviceType = "MO";

    $scope.personSelect = function () {
        if (!$scope.content) {
            toaster.pop("warning", "", "请先输入发送内容", "1000");
        } else {
            var modalInstance = $modal.open({
                templateUrl: 'personSelect.html',
                backdrop: 'static',
                keyboard: false,
                controller: 'PushOrderPatientPersonSelectCtrl',
                size: "lg",
                resolve: {
                    content: function () {
                        return $scope.content;
                    },
                    deviceType: function () {
                        return $scope.deviceType;
                    }
                }
            });
        }
    }
});

app.controller('PushOrderPatientPersonSelectCtrl', function ($scope, $http, $modal, $modalInstance, ngTableParams, toaster, SweetAlert, content, deviceType) {
    $scope.justopen = true;         //刚进入选择界面不立即查询
    $scope.sendFlag = false;

    $scope.searchInfos = {name: null, phoneNumber: null}

    $scope.resultPage = {totalCount: 0};    //后台返回总结果集，从订单中获取
    $scope.data = [];       //患者列表当前页面的结果集

    //重置当前选择按钮为false
    $scope.resetDataSelected = function ($scope) {
        $("#selectAllCheckbox").prop("checked", false);
        $scope.data.forEach(function (item) {
            item.selected = false;
        });
    };

    //根据已选患者列表设置患者列表是否已选
    $scope.setDataSelected = function ($scope) {
        for (var i = 0; i < $scope.data.length; i++) {
            for (var j = 0; j < $scope.personList.length; j++) {
                if ($scope.data[i].uuid == $scope.personList[j].uuid) {
                    $scope.data[i].selected = true;
                }
            }
        }
        $scope.isSelectAll();
    };

    //判断当前页面是否已经全选
    $scope.isSelectAll = function () {
        var i = 0;
        var j = 0;
        for (; i < $scope.data.length; i++) {
            if ($scope.data[i].selected == true) {
                j++;
            }
        }
        if (j == i && i != 0) {
            $("#selectAllCheckbox").prop("checked", true);
        } else {
            $("#selectAllCheckbox").prop("checked", false);
        }
    };

    $scope.tableParams = new ngTableParams({
        page: 1,
        count: 10
    }, {
        total: $scope.resultPage.totalCount,
        getData: function ($defer, params) {
            if ($scope.justopen) {
                $scope.justopen = false;
            } else {
                $scope.resetDataSelected($scope);
                $scope.searchInfos.pageIndex = params.page();
                $scope.searchInfos.pageSize = params.count();
                $scope.queryString = getQueryString($scope.searchInfos);
                var requestUrl = REST_PREFIX + "patient/selectOrderPatientPage" + $scope.queryString;
                $http.get(requestUrl).success(function (result) {
                    $scope.resultPage = result.resultPage;
                    params.total($scope.resultPage.totalCount);
                    params.page($scope.resultPage.nowPage);
                    $scope.data = $scope.resultPage.result;
                    $scope.setDataSelected($scope);
                    $defer.resolve($scope.data);
                });
            }
        }
    });

    $scope.personList = [];     //已选患者列，对象是jdOrderQueryModel类型，(发送方式，消息内容)这两个属性点击发送时添加

    //向已选患者列表添加一个患者
    $scope.addPerson = function (item) {
        var flag = true;
        for (var i = 0; i < $scope.personList.length; i++) {
            if (item.uuid == $scope.personList[i].uuid) {
                flag = false;
                break;
            }
        }
        if (flag) $scope.personList.push(item);
    };

    //向已选患者列表删除一个患者
    $scope.deletePerson = function (item) {
        for (var i = 0; i < $scope.personList.length; i++) {
            if (item.uuid == $scope.personList[i].uuid) {
                $scope.personList.splice(i, 1);
                break;
            }
        }
        for (var j = 0; j < $scope.data.length; j++) {
            if (item.uuid == $scope.data[j].uuid) {
                $scope.data[j].selected = false;
                break;
            }
        }
    };

    //改变当前选中的行
    $scope.changeSelection = function (index) {
        var item = $scope.data.length > 0 ? $scope.data[index] : null;
        if (item) {
            var selected = item.selected;
            if (selected) {
                $scope.addPerson(item);
            } else {
                $scope.deletePerson(item);
            }
        }
        $scope.isSelectAll();
    };

    //全选/全不选
    $scope.selectAll = function () {
        var checkAll = $("#selectAllCheckbox").is(":checked");
        if ($scope.data.length > 0) {
            $scope.data.forEach(function (item) {
                item.selected = checkAll;
            });
            if (checkAll) {
                for (var i = 0; i < $scope.data.length; i++) {
                    $scope.addPerson($scope.data[i]);
                }
            } else {
                for (var i = 0; i < $scope.data.length; i++) {
                    $scope.deletePerson($scope.data[i]);
                }
            }
        }
    };

    //删除
    $scope.delete = function (item) {
        $scope.deletePerson(item);
        item.selected = false;
        $scope.isSelectAll();
    };

    $scope.sendPersons = [];    //发送的患者对象队列
    $scope.person = {name: null, phoneNumber: null, content: null, deviceType: null};//发送的患者对象封装

    //获得要发送信息的患者对象队列
    $scope.getSendPersons = function () {
        $scope.personList.forEach(function (item) {
            $scope.person.name = item.name;
            $scope.person.phoneNumber = item.phoneNumber;
            $scope.person.content = content;
            $scope.person.deviceType = deviceType;
            $scope.sendPersons.push($scope.person);
        });
    };

    //清空查询条件
    $scope.clear = function () {
        $scope.searchInfos = {name: null, phoneNumber: null}
    };

    //查询
    $scope.query = function () {
        $scope.tableParams.reload();
    };

    $scope.cancel = function (e) {
        $modalInstance.dismiss();
    };

    $scope.send = function (e) {
        if ($scope.data.length == 0) {
            toaster.pop("warning", "", "请先查询出结果", "1000");
        } else {
            if (!$scope.sendFlag) {
                if ($scope.personList.length > 0) {
                    $scope.getSendPersons();
                    $http.post(REST_PREFIX + "jdTextMessagePush/pushOrderPatientTextMessage", $scope.sendPersons).success(function (result) {
                        if (result.result == 1){
                            $scope.sendFlag = false;
                            toaster.pop("error","提示",result.description);
                        } else {
                            var description = result.description;
                            toaster.pop("发送成功", "", description, "1000");
                            $modalInstance.close("success");
                        }
                    });
                } else {
                    toaster.pop("warning","","至少选择一名患者！");
                }
            }
        }
    }
    $scope.sendAll = function (e) {
        $modalInstance.dismiss();
        SweetAlert.swal({
            title: "提示",
            text: "你确定要给所有患者发送短信么?",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "确定",
            cancelButtonText: "取消"
        },function(isConfirm){
            if(isConfirm){
                if ($scope.data.length == 0) {
                    toaster.pop("warning", "", "请先查询出结果", "1000");
                }else{
                    $scope.searchInfos.devicetype = deviceType;
                    $scope.searchInfos.content = content;
                    $scope.querySendAllString = getQueryString($scope.searchInfos);
                    var requestUrl = REST_PREFIX + "jdTextMessagePush/pushAllPatientMessage" + $scope.querySendAllString;
                    $http.post(requestUrl).success(function (result) {
                        if (result.result != 0){
                            $scope.sendFlag = false;
                            toaster.pop("error","提示",result.description);
                        } else {
                            var description = result.description;
                            toaster.pop("发送成功", "", description, "1000");
                            $modalInstance.close("success");
                        }
                    });
                }
            }

        });
    }
});
