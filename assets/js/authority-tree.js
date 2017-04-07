//生成树对象
var AuthorityTreeview = function() {
	"use strict";
	var runTreeView = function(treeData) {
		$('#authorityTree').jstree({
			'plugins' : ["wholerow", "checkbox", "types"],
			'core' : {
				"themes" : {
					"responsive" : false
				},
				'data' : treeData
			},
			"types" : {
				"default" : {
					"icon" : "fa fa-folder text-primary fa-lg"
				},
				"file" : {
					"icon" : "fa fa-file text-primary fa-lg"
				}
			}
		});
	};
	return {
		init : function(treeData) {
			runTreeView(treeData);
		}
	};
}();

//获取角色列表
sendRequest("role/list", "GET", function(result) {
	var str = new StringBuilder();
	result.roleList.forEach(function(role) {
		str.append("<option value=\"" + role.uuid + "\">" + role.name + "</option>");
	});
	$("#roleList").append(str.toString());
	roleChange();
});

var selectedMenu;
//选择的角色改变
function roleChange() {
	var roleId = $("#roleList").val();
	sendRequest("resource/"+roleId+"/tree", "GET", function(result) {
		var authorityMenuIds = result.authorityMenuIds;
		var treeData = [];
		result.menuList.forEach(function(menu) {
			var menuInfo = generateMenu(menu, authorityMenuIds);
			treeData.push(menuInfo);
		});
		$.jstree.destroy();
		AuthorityTreeview.init(treeData);
		$('#authorityTree').on("changed.jstree", function (e, data) {
			selectedMenu = data.selected;
		});
	});
}

//父节点
function generateMenu(menu, authorityMenuIds) {
	var children = [];
	menu.subMenuList.forEach(function(submenu) {
		var submenuInfo = generateSubMenu(submenu, authorityMenuIds);
		children.push(submenuInfo);
	});
	var menuInfo = {
		"id" : menu.uuid,
		"text" : menu.name,
		"state" : { "opened" : true },
		"children" : children
	};
	return menuInfo;
}

//子节点
function generateSubMenu(submenu, authorityMenuIds) {
	var selected = authorityMenuIds.indexOf(submenu.uuid) == -1 ? false : true;
	var submenuInfo = {
		"id" : submenu.uuid,
		"state" : {"selected" : selected},
		"icon" : "fa fa-file text-primary",
		"text" : submenu.name
	};
	return submenuInfo;
}

var submitFlag = false; //防止多次提交
function submitAuthority() {
	if(!submitFlag) {
		submitFlag = true;
		var roleId = $("#roleList").val();
		sendRequest("resource/"+roleId, "POST", selectedMenu.toString(), function(result) {
			swal({
				title: "授权成功!",
				type: "success",
				confirmButtonColor: "#007AFF",
				confirmButtonText: "确定"
			});
			submitFlag = false;
		});
	}
}
