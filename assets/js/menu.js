// 用户登录成功后的动作--加载用户权限菜单
sendRequest("resource/menus", "GET", function (result) {
    var str = new StringBuilder();
    result.menuList.forEach(function (menu) {
        if (menu.parentMenu) {
            str.append("<li ng-class=\"{'active open':$state.includes('" + menu.parentPrefix + "')}\"><a href=\"javascript:void(0)\"><div class=\"item-content\"><div class=\"item-media\"><i class=\""
                + menu.iconClass + "\"></i></div><div class=\"item-inner\"><span class=\"title\" translate=\"" + menu.translate + "\"></span><i class=\"icon-arrow\"></i></div></div></a>");
            str.append("<ul class=\"sub-menu\">");
            menu.subMenuList.forEach(function (subMenu) {
                var searchMenu = {name: subMenu.name, url: subMenu.uiSref};
                userSearchMenu.push(searchMenu);
                str.append("<li ui-sref-active=\"active\"><a ui-sref=\"" + subMenu.uiSref + "\"><span class=\"title\" translate=\"" + subMenu.translate + "\"></span></a></li>");
            });
            str.append("</ul>");
        } else {
            var searchMenu = {name: subMenu.name, url: subMenu.uiSref};
            userSearchMenu.push(searchMenu);
            str.append("<li ui-sref-active=\"active\"><a ui-sref=\"" + menu.uiSref + "\"><div class=\"item-content\"><div class=\"item-media\"><i class=\"" + menu.iconClass
                + "\"></i></div><div class=\"item-inner\"><span class=\"title\" translate=\"" + menu.translate + "\"></span></div></div></a></li>");
        }
    });
    userMenuList = str.toString();
}, false);