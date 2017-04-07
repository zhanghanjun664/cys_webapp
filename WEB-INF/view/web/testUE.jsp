<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div>
<textarea style="width: 100%; height: 400px" id="newsContent" name="content">${exsitsContent}</textarea>
</div>
<script type="text/javascript" charset="utf-8" src="activity/christmas/js/jquery.js"></script>
<script type="text/javascript" charset="utf-8" src="vendor/ueditor1_4_3_2/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="vendor/ueditor1_4_3_2/ueditor.all.min.js"> </script>
<script type="text/javascript" charset="utf-8" src="vendor/ueditor1_4_3_2/ueditor.custom.js"></script>
<script type="text/javascript" charset="utf-8" src="vendor/ueditor1_4_3_2/lang/zh-cn/zh-cn.js"></script>

<script type="text/javascript">
	var newsContent = UE.initEditor(newsContent, "newsContent");
</script>
