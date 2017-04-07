<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String from = (String) request.getAttribute("from");
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <jsp:include page="../include/doctor_head.jsp"/>
</head>
<body>
<!-- topbar start -->
<header class="fixed topbar">
    <a onclick="backToHome()" class="back-to-home logo">返回首页</a>
    <h3 class="tit">添加银行卡</h3>
</header>
<!-- topbar end -->
<!-- add cards start -->
<div class="main add-cards">
    <form class="form-add-cards" id="form-add-cards">
        <div class="grid mt-10">
            <p>
                <label for="bank-type">银行</label>
                <input type="text" name="bank-type" id="bank-type" placeholder="请选择银行类型" readonly/>
            </p>
            <p>
                <label for="bank-branch">支行</label>
                <input type="text" name="bank-branch" id="bank-branch" placeholder="请输入支行名称"/>
            </p>
            <p>
                <label for="card-num">卡号</label>
                <input type="text" name="card-num" id="card-num" placeholder="请输入银行卡号"/>
            </p>
            <p>
                <label for="cardholder">持卡人</label>
                <input type="text" name="cardholder" id="cardholder" placeholder="请输入持卡人姓名"/>
            </p>
        </div>

        <!-- bank type -->
        <div class="grid bank-type-choose mt-10" style="display:none;">
            <ul>
                <li>工商银行</li>
                <li>中国银行</li>
                <li>建设银行</li>
                <li>农业银行</li>
                <li>交通银行</li>
                <li>招商银行</li>
                <li>民生银行</li>
                <li>光大银行</li>
                <li>华夏银行</li>
                <li>中信银行</li>
            </ul>
        </div>

        <div class="form-submit">
            <input type="button" value="完成" class="btn-submit"/>
        </div>
    </form>
</div>
<!-- add cards end -->
</body>
<script>
    // 选择银行
    $('#bank-type').on('click', function(){
        $(this).parent().parent().hide().siblings('.bank-type-choose').show();
        $('.topbar .tit').text('银行');
    });
    $('.bank-type-choose li').on('click', function(){
        var _thisTxt = $(this).text();
        $(this).parent().parent().hide().prev().show();
        $('.topbar .tit').text('添加银行卡');
        $('#bank-type').val(_thisTxt);
    });

    // 验证银行卡号
    function validateCardNo(cardNo) {
        var bankno = cardNo.replace(/[ ]/g,"");
        if (bankno.length < 16 || bankno.length > 19) {
            return false;
        }
        var num = /^\d*$/;
        if (!num.exec(bankno)) {
            return false;
        }
        var strBin="10,18,30,35,37,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,58,60,62,65,68,69,84,87,88,94,95,98,99";
        if (strBin.indexOf(bankno.substring(0, 2))== -1) {
            return false;
        }
        var lastNum=bankno.substr(bankno.length-1,1);
        var first15Num=bankno.substr(0,bankno.length-1);
        var newArr=new Array();
        for(var i=first15Num.length-1;i>-1;i--){
            newArr.push(first15Num.substr(i,1));
        }
        var arrJiShu=new Array();
        var arrJiShu2=new Array();
        var arrOuShu=new Array();
        for(var j=0;j<newArr.length;j++){
            if((j+1)%2==1){
                if(parseInt(newArr[j])*2<9)
                    arrJiShu.push(parseInt(newArr[j])*2);
                else
                    arrJiShu2.push(parseInt(newArr[j])*2);
            }
            else
                arrOuShu.push(newArr[j]);
        }
        var jishu_child1=new Array();
        var jishu_child2=new Array();
        for(var h=0;h<arrJiShu2.length;h++){
            jishu_child1.push(parseInt(arrJiShu2[h])%10);
            jishu_child2.push(parseInt(arrJiShu2[h])/10);
        }
        var sumJiShu=0;
        var sumOuShu=0;
        var sumJiShuChild1=0;
        var sumJiShuChild2=0;
        var sumTotal=0;
        for(var m=0;m<arrJiShu.length;m++){
            sumJiShu=sumJiShu+parseInt(arrJiShu[m]);
        }
        for(var n=0;n<arrOuShu.length;n++){
            sumOuShu=sumOuShu+parseInt(arrOuShu[n]);
        }
        for(var p=0;p<jishu_child1.length;p++){
            sumJiShuChild1=sumJiShuChild1+parseInt(jishu_child1[p]);
            sumJiShuChild2=sumJiShuChild2+parseInt(jishu_child2[p]);
        }
        sumTotal=parseInt(sumJiShu)+parseInt(sumOuShu)+parseInt(sumJiShuChild1)+parseInt(sumJiShuChild2);
        var k= parseInt(sumTotal)%10==0?10:parseInt(sumTotal)%10;
        var luhm= 10-k;
        if(lastNum==luhm) {
            return true;
        } else {
            return false;
        }
    }

    // 提交保存
    var submitFlag = false;
    $(".btn-submit").on("click", function() {
        if(submitFlag)
            return;
        submitFlag = true;
        var bankName = $("#bank-type").val();
        var subBranch = trim($("#bank-branch").val());
        var receiptAccount = trim($("#card-num").val());
        var receiptName = trim($("#cardholder").val());
        if(bankName.length == 0) {
            layer.alert('请选择银行类型', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
            });
            submitFlag = false;
            return;
        } else if(subBranch.length == 0) {
            layer.alert('请输入支行名称', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $("#bank-branch").focus();
            });
            submitFlag = false;
            return;
        } else if(receiptAccount.length == 0) {
            layer.alert('请输入银行卡号', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $("#card-num").focus();
            });
            submitFlag = false;
            return;
        } else if(!validateCardNo(receiptAccount)) {
            layer.alert('银行卡号不正确，请确认', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $("#card-num").focus();
            });
            submitFlag = false;
            return;
        } else if(receiptName.length == 0) {
            layer.alert('请输入持卡人姓名', {
                title: false,
                closeBtn: false
            }, function () {
                layer.closeAll();
                $("#cardholder").focus();
            });
            submitFlag = false;
            return;
        }
        var data = {"bankName":bankName,"subBranch":subBranch,"receiptAccount":receiptAccount,"receiptName":receiptName};
        sendRequest("saveBankCard.htm", "POST", data, function(result) {
            if(result) {
                layer.alert(result, {
                    title: false,
                    closeBtn: false
                }, function () {
                    layer.closeAll();
                });
                submitFlag = false;
            } else {
                var from = "<%=from%>";
                if(from === "withdrawl") {
                    goto("toWithdrawl.htm");
                } else {
                    goto("toBankCardManage.htm");
                }
            }
        }, function() {
            submitFlag = false;
        });
    });
</script>
</html>
