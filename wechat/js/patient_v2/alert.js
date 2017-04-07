//定义一些通用变量
var Parameter = {
    alert_timer: null,
    window: document.getElementsByTagName('body')[0]
}


//定义创建的弹窗口
var Poptype = {
    html1: '<div class="alert_content" id="alert_content" type="ask"><div class="alert_title" id="alert_title">are you ok?</div><div class="alert_btn" id="alert_btn"><a href="javascript:void(0)">取消</a><a href="javascript:void(0)">确定</a></div></div>',
    html2: '<div class="alert_content" id="alert_content" type="ok"><div class="alert_title" id="alert_title">this is a message!</div><div class="alert_btn" id="alert_btn"><a href="javascript:void(0)">确定</a></div></div>',
    html3: '<div class="alert_content" id="alert_content" type="msg"><div class="alert_title" id="alert_title">Error message!</div></div>',
    html4: '<div class="alert_content" id="alert_content" type="ask"><div class="alert_input"><input type="text" placeholder="输入点什么" id="alert_input"></div><div class="alert_btn" id="alert_btn"><a href="javascript:void(0)">取消</a><a href="javascript:void(0)">确定</a></div></div>'
}

//定义传送过来的属性
function Attribute($) {
    this.number = $.number || '';  //选择的弹窗
    this.title = $.title || '';	   //选择的标题
    this.leftfn = $.leftfn || '';  //左边按钮执行的方法
    this.rightfn = $.rightfn || ''; //右边按钮执行的方法
    this.time = $.time || '';		//消失的时间
    this.placeholder = $.placeholder || '';  //输入框的placeholder
    this.btn = $.btn || '';
    this.create();
};


//执行创建
Attribute.prototype.create = function () {
    var _this = this;
    switch (_this.number) {
        case "1":
            _this.setAttr('1');
            break;

        case "2":
            _this.setAttr('2');
            break;

        case "3":
            _this.setAttr('3');
            break;

        case "4":
            _this.setAttr('4');
            break;

    }

    _this.setPosition();
    _this.setClick();
    _this.setTimer();

}


//设置可定义的属性
Attribute.prototype.setAttr = function (option) {

    //判断弹窗口是否存在
    if (document.getElementById('alert_wrap')) {
        return false;
    }

    //创建了弹窗口
    var _this = this;
    var obj = document.createElement('div');
    obj.className = "alert_wrap";
    obj.setAttribute('id', 'alert_wrap');
    if(!Parameter.window)
        Parameter.window = document.getElementsByTagName('body')[0];
    Parameter.window.appendChild(obj);

    //用户要创建哪种类型的弹窗
    switch (option) {
        case "1":
            obj.innerHTML = Poptype.html1;
            break;

        case "2":
            obj.innerHTML = Poptype.html2;
            break;

        case "3":
            obj.innerHTML = Poptype.html3;
            obj.setAttribute('type', 'normal');
            break;

        case "4":
            obj.innerHTML = Poptype.html4;
            break;

    }

    //定义标题
    var oTitle = document.getElementById('alert_title');
    if (oTitle) {
        oTitle.innerHTML = _this.title;
    }
    ;

    //定义文本域的内容
    var oInput = document.getElementById('alert_input');
    if (oInput) {
        oInput.setAttribute('placeholder', _this.placeholder);
    }
    ;

    //定义左右按钮文字
    var oBtn = document.getElementById('alert_btn');
    if (!oBtn) {
        return false;
    }
    ;

    if (!_this.btn) {
        return;
    }
    ;

    var aBtn = oBtn.getElementsByTagName('a');
    if (aBtn[0]) {
        aBtn[0].innerHTML = _this.btn[0];
    }
    ;

    if (aBtn[1]) {
        aBtn[1].innerHTML = _this.btn[1];
    }
    ;

}

//弹窗位置
Attribute.prototype.setPosition = function () {
    var oContent = document.getElementById('alert_content');
    var height = -(oContent.offsetHeight / 2);
    oContent.style.marginTop = height + 'px';
}


//消失时间设置
Attribute.prototype.setTimer = function (option) {
    var _this = this;
    clearInterval(Parameter.alert_timer);

    if (_this.time == "" || false) {
        return false;
    } else {
        Parameter.alert_timer = setTimeout(function () {
            _this.delalert();
        }, _this.time);
    }
}


//删除的弹窗
Attribute.prototype.delalert = function () {

    if (!document.getElementById('alert_wrap')) {
        return false;
    }
    Parameter.window.removeChild(document.getElementById('alert_wrap'));
}


//截取输入的前后空格
Attribute.prototype.trim = function (ostr) {
    return ostr.value.replace(/^\s+|\s+$/g, "");
}


//判断是否为空
Attribute.prototype.null = function (ostr) {
    var _this = this;
    if (_this.trim(ostr)) {
        return true;
    } else {
        return false;
    }

}


//得到输入的内容
Attribute.prototype.getData = function () {
    var _this = this;
    return _this.trim(document.querySelector("#alert_input"));
}


//按钮的执行方法
Attribute.prototype.setClick = function () {
    var _this = this;

    if (!document.getElementById('alert_btn')) {
        return;
    }
    ;

    var oBtn = document.getElementById('alert_btn');

    var aBtn = oBtn.getElementsByTagName('a');

    var oInput = document.getElementById('alert_input');

    //判断有多少个按钮
    if (parseInt(aBtn.length) >= 2) {


        aBtn[0].onclick = function (ev) {

            if (_this.leftfn) {
                _this.leftfn();
                _this.delalert();
            } else {
                _this.delalert();
            }


            ev.preventDefault();
        }

        aBtn[1].onclick = function (ev) {


            if (!oInput) {
                _this.rightfn();
                _this.delalert();
                ev.preventDefault();
                return false;
            }


            if (_this.null(oInput)) {
                _this.rightfn();
                _this.delalert();
            } else {
                oInput.focus();
            }

            ev.preventDefault();


        }


    } else {

        aBtn[0].onclick = function (ev) {

            if (_this.leftfn) {
                _this.leftfn();
                _this.delalert();
            } else {
                _this.delalert();
            }


            ev.preventDefault();
        }
    }


}













