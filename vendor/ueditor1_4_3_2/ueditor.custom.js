UE.initEditor = function(obj, id, opt) {
	if (UE.Editor.prototype._bkGetActionUrl) {
		UE.Editor.prototype.getActionUrl = UE.Editor.prototype._bkGetActionUrl;
	}
	if (obj) {
		obj.destroy();
	}
	var defaultOptions = {
		wordCount : false,
		autoHeightEnabled : false,
		elementPathEnabled : false,
		enableAutoSave : false,
		catchRemoteImageEnable : true,
		zIndex : 10000,
		toolbars : [ [ 'source', 'undo', 'redo', '|', 'bold', 'italic', 'underline', 'strikethrough', 'removeformat',
				'formatmatch', 'autotypeset', 'blockquote', 'pasteplain', '|', 'forecolor', 'backcolor',
				'insertorderedlist', 'insertunorderedlist', 'selectall', 'cleardoc', '|', 'rowspacingtop',
				'rowspacingbottom', 'lineheight', '|', 'customstyle', 'paragraph', 'fontfamily', 'fontsize', '|',
				'indent', '|', 'justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|', 'link', 'unlink',
				'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|', 'simpleupload',
				'insertimage', 'attachment', 'map', 'background', '|', 'horizontal', '|', 'inserttable', 'deletetable',
				'mergecells', 'splittocells', , '|', , 'preview', 'searchreplace', ] ]
	};

	var options = $.extend({}, defaultOptions, opt);
	if (opt) {
		if (opt.uploadParam) {
			UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
			UE.Editor.prototype.getActionUrl = function(action) {
				if (action == 'uploadimage' || action == 'uploadscrawl' || action == 'uploadfile'
						|| action == 'uploadvideo') {
					return REST_PREFIX + 'generalinfo/ueUpload?' + opt.uploadParam;
				} else {
					return this._bkGetActionUrl.call(this, action);
				}
			}
		}

		if (opt.actionUrl) {
			UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;
			UE.Editor.prototype.getActionUrl = function(action) {
				if (action == 'uploadimage' || action == 'uploadscrawl' || action == 'uploadfile'
						|| action == 'uploadvideo') {
					return opt.actionUrl;
				} else {
					return this._bkGetActionUrl.call(this, action);
				}
			}
		}

	}

	if ($("#" + id).length < 1) {
		return null;
	}

	return UE.getEditor(id, options);
}