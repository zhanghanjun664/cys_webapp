<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../include/head.jsp" />
    <style>
        html, body {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            font-size: 100%;
            background: #F2F2F2;
        }

        a {
            color: #000000;
            -webkit-tap-highlight-color: transparent;
        }

        img, li, div {
            -webkit-tap-highlight-color: transparent;
        }

        #mainDiv {
            width: 100%;
            display: none;
        }

        #mainDiv .top_ul {
            width: 100%;
            background: #FB9D3B;
            overflow: hidden;
        }

        #mainDiv .top_ul li {
            text-align: center;
            float: left;
        }

        #mainDiv .top_ul li:nth-child(1) {
            width: 11.5%;
            height: 100%;
            background: url(../../wechat/images/larrow.png) center left no-repeat;
            background-size: 70% auto;
        }

        #mainDiv .top_ul li:nth-child(2) {
            width: 76%;
            height: 100%;
            font-size: 2em;
            color: #FFFFFF;
        }

        #mainDiv .top_ul li:nth-child(3) {
            width: 12%;
            height: 100%;
        }

        #mainDiv .top_ul li:nth-child(3) a {
            font-size: 1.6em;
            color: #FFFFFF;
        }
        #ruleul{width:100%;overflow:scroll;padding:1.8em 0 1em 0;position:absolute;left:0;top:0;z-index:100000;background:#FFFFFF;}
        #ruleul li{float:left;}
        #ruleul .ruleul_li0{width:100%;font-size:1.8em;font-weight:bold;text-align:center;margin-bottom:1em;}
        #ruleul .ruleul_li1{width:100%;}
        #ruleul .ruleul_li1 p{width:94%;margin-left:3%;font-size:1.55em;margin-bottom:1.5em;}
        #ruleul .ruleul_li2{width:60%;margin-left:20%;border-radius:0.5em;-webkit-border-radius:0.5em;border:#BDBDBD 0.1em solid;-webkit-border:#BDBDBD 0.1em solid;text-align:center;font-size:1.55em;margin-top:1.5em;}
    </style>
</head>
<body>
<div id="mainDiv">
    <ul class="top_ul">
        <a href="javascript:history.back();">
            <li></li>
        </a>
        <li>注册</li>
        <li><a href="main.htm">首页</a></li>
    </ul>
</div>
<ul id="ruleul">
    <li class="ruleul_li0">橙医生用户服务协议</li>
    <li class="ruleul_li1">
<p>感谢您使用橙医生产品（以下简称“橙医生”）。<br>
一、总则<br>
1、橙医生是指由广州桔叶信息科技有限公司构建的医疗健康交流互通平台为您提供相关服务，包括但不限于网站、微信服务号、APP。为确保您能正常地使用橙医生的服务，您应当阅读并遵守《橙医生用户服务协议》（以下简称“本协议”）。请您务必审慎阅读、充分理解各条款内容，特别是免除或限制责任的相应条款，以及开通或使用某项服务的单独协议，并选择接受或不接受。<br>
2、除非您已阅读并接受本协议所有条款，否则您无权使用橙医生的服务（以下简称“本服务”）。您对本服务的登录、查看、发布信息等行为即视为您已阅读并同意本协议的约束，包括接受更新后的本协议条款。当您与本平台发生争议时，应以最新的服务协议为准。<br>
3、橙医生为您提供全面的医疗健康服务，为充分保护您对于橙医生提供的各项服务的知情权，橙医生就其提供的各项服务的相关性、有效性以及限制性提供以下注册条款。橙医生在此特别提醒您，在您使用注册前已确实仔细阅读了本用户服务协议，如果您对本协议的任何条款或者将来随时可能修改、补充的条款有异议，您可选择不注册成为橙医生的用户。<br>
4、您在进行注册程序过程中，根据声音、文字或图形提示可以选择表示“同意”的操作，当您点选“同意”按钮时即视为您已仔细阅读本协议，同意接受本协议项下的所有条款，包括接受橙医生对本协议条款随时所做的任何修改，并愿意受其拘束。这之后方能按系统提示完成全部注册程序、问答程序、享受挂号服务及医疗健康信息服务程序。<br>
5、您在橙医生挂号、提问、搜索、享受医疗健康信息、与其它用户交流及其他健康类服务，即代表您已经同意本协议。<br>
6、本协议与《免责条款》具备同等的法律效力。本协议的条款适用于橙医生提供的各种服务，但当您使用橙医生某一特定服务时，如该服务另有单独的服务条款、指引或规则，您应遵守本协议及橙医生随时公布的与该服务相关的服务条款、指引或规则等。前述所有的指引和规则，均构成本协议的一部分。除非本协议另有其他明示规定，新推出的产品或服务、增加或强化目前本服务的任何新功能，均受到本协议之规范。<br>
二、服务对象<br>
“本服务”仅向能够根据相关法律订立具有法律约束力的合约的个人、企业和社会团体提供。因此，您的年龄必须在十八周岁或以上，并按本协议要求或本平台要求提供相关证明材料橙医生审核通过后，才可使用本服务。如不符合本项条件，请勿使用“本服务”。橙医生可随时自行全权决定拒绝向任何人士提供“服务”。“服务”不会提供给被暂时或永久终止资格的本网站会员。<br>
三、服务暂停、变更与中止条款<br>
1、鉴于移动互联网服务的特殊性，橙医生有权随时变更、中断或终止部分或全部的服务。如变更、中断或终止的服务属于免费服务，橙医生无需通知您，也无需对任何您或任何第三方承担任何责任。<br>
2、您理解，橙医生需要定期或不定期地对提供本服务的平台或相关的设备进行检修或者维护，如因此类情况而造成本服务在合理时间内的中断，橙医生无需为此承担任何责任，但橙医生应尽可能事先进行通告。<br>
3、橙医生有权在必要时修改本协议条款，协议条款一旦发生变动，届时将在您界面提示修改内容，该提示行为视为橙医生已经通知您修改内容，如果您不同意所作的修改，可以主动取消获得的网络服务，进行注销。如果您继续享有橙医生提供的服务，则被视为接受协议变动。当发生有关争议时，以最新的服务协议为准。<br>
4、如发生下列任何一种情形，橙医生有权随时中断或终止向您提供本协议项下的服务而无需对您或任何第三方承担任何责任：<br>
(1) 您提供的个人资料不真实；<br>
(2) 您违反本协议中的规定；<br>
(3) 您违反橙医生所发布的政策；<br>
(4) 橙医生认为其他不适宜的地方。<br>
5、您应保证：提供详尽、真实、准确和完整的个人资料。如果资料发生变动，您应及时更改。若您提供任何错误、不实、过时或不完整的资料，并为橙医生所确知；或者橙医生有合理理由怀疑前述资料为错误、不实、过时或不完整的资料，橙医生有权暂停或终止您的帐号，并拒绝现在或将来使用本服务的全部或一部分。在此情况下，您可通过橙医生的申诉途径与橙医生取得联系并修正个人资料经橙医生核实后恢复账号使用。<br>
四、您的帐号、密码和安全性<br>
您一旦注册成功，成为橙医生的合法用户，将得到一个您的帐号和密码。您的帐号和密码由您负责保管。您都要对任何以您帐号进行的所有活动和事件负全责，且您有权随时根据指示更改您的密码。若发现任何非法使用您的帐号或存在安全漏洞的情况，请立即通知橙医生。因黑客行为或您的保管疏忽等情况导致帐号、密码遭他人非法使用，橙医生不承担责任。为向您提供本服务，您同意并授权橙医生将您在注册、使用本服务过程中提供、形成的信息传递给为您提供您所要求的产品和服务、而必须和第三方分享您的个人信息，向您提供其他服务的第三方，或从提供其他服务的第三方获取您在注册、使用其他服务期间提供、形成的信息。橙医生将根据法律法规的要求，履行其作为移动互联网信息服务提供者应当履行的义务。<br>
五、隐私保护<br>
1、保护您隐私是橙医生的一项基本政策，橙医生保证不对外公开或向第三方提供您的注册资料及您在使用本服务或通过橙医生平台进行相关购买活动时存储在橙医生的非公开内容，但下列情况除外：<br>
(1) 事先获得您的明确授权；<br>
(2) 根据有关的法律法规要求；<br>
(3) 按照相关政府主管部门的要求；<br>
(4) 为维护社会公众的利益；<br>
(5) 为维护橙医生的合法权益。<br>
2、橙医生可能会与第三方合作向您提供相关的网络服务，在此情况下，您同意并授权橙医生将您的注册资料等提供给该第三方。<br>
3、在不透露单个您隐私资料的前提下，您同意橙医生对整个您数据库进行分析并对您数据库进行商业上的利用。<br>
六、特别授权<br>
您完全理解并不可撤销地授予橙医生下列权利：<br>
1、一旦您向橙医生作出任何形式的承诺，且相关机构已确认您违反了该承诺，则橙医生有权立即按您的承诺或协议约定的方式对您的账户采取限制措施，包括中止或终止向您提供服务，并公示相关机构确认的您的违约情况。您了解并同意，橙医生无须就相关违约事项与您核对事实，或另行征得您的同意，且橙医生无须就此限制措施或公示行为向您或任何第三方承担任何的责任。<br>
2、一旦您违反本协议、或与橙医生签订其他协议的约定，橙医生有权以任何方式通知本服务或其他相关橙医生，要求其对您的权益采取限制措施，包括但不限于要求中止、终止对您提供的部分或全部服务，且在其经营或实际控制的网站或APP公示您的违约情况。<br>
3、您授权橙医生通过您注册、使用本服务过程中形成的信息通过短信、邮件、电话、视频、音频或其他形式向您传送橙医生提供的服务。您同意接受橙医生通过短信、邮件、电话、视频、音频或其他形式向您发送活动、服务或其他相关商业信息。如果您不需要橙医生提供的部分或全部服务的活动、服务或其他相关商业信息的服务，在您向橙医生客服提出申请后予以中止、终止对您提供的该部分或全部服务。<br>
七、橙医生拒绝提供担保<br>
1、您对移动网络服务的使用承担风险，以及其因为使用移动网络服务而产生的一切后果。橙医生对此不作任何类型的担保，不论是明确的或隐含的，但是不对商业性的隐含担保、特定目的和不违反规定的适当担保作限制。<br>
2、橙医生不担保服务一定能完全满足您的要求，也不担保各项服务不会受网络、黑客、通信技术、银行方面的问题等原因而中断，对服务的及时性、安全性、错误程序的发生都不作担保。<br>
3、橙医生因受合作医疗机构等资源限制，就您所提预约挂号等请求不担保服务一定能够成功。<br>
4、橙医生对在橙医生产品上得到的任何有关健康的咨询意见、用药情况的保证效果等，不作担保。<br>
5、橙医生所展示的内容（文、图、视频、音频）均以传播有益健康资讯为目的，不对其真实性、科学性、严肃性做任何形式的保证。<br>
八、免责条款<br>
1、橙医生所有信息仅供参考，不做个别诊断、用药和使用的根据。橙医生作为医疗健康交互平台致力于尽量提供正确、完整的健康资讯，但不保证信息的绝对正确性和完整性，且不对因信息的不正确或遗漏导致的任何损失或损害承担责任。橙医生所展现的任何医药资讯，仅供参考，不能替代医师和其他医务人员的诊疗建议，如自行使用橙医生资料发生偏差，橙医生不承担任何法律责任。<br>
2、橙医生为您提供展示平台。您应当对自己提供的个人信息以及发布的信息的真实性、合法性负全部责任。若任何第三方因信任该些信息而采取某些行为，并因此遭受损失或给其它方造成损失的，由您承担所有法律责任并予以赔偿。橙医生对此不承担责任。<br>
3、您的言论仅代表您个人观点，不代表橙医生同意您的说法，橙医生不承担因您的言论不当所引起任何的法律责任。<br>
九、对您信息的存储和限制<br>
橙医生不对您所发布信息的删除或储存失败负责。橙医生积极采用数据备份加密等措施保障您数据的安全，但不对由于因意外因素导致的数据损失和泄漏负责。橙医生有权审查和监督您的行为是否符合本协议、免责条款的要求，如果您违背了本协议和免责条款的规定，则橙医生有权中断您的服务。<br>
十、用户管理<br>
1、您在进行注册过程中，您的用户名注册与使用应符合网络道德，遵守中华人民共和国的相关法律法规。您的用户名和昵称中不能含有威胁、淫秽、谩骂、非法、侵害他人正当合法权益等有争议性的文字。您在橙医生上的言论不得违法、不得违反公序良俗、不得使用攻击性语言恶意中伤他人，或作出虚假性陈述。您保证您在橙医生上提供的信息的真实性、合法性和有效性。您单独承担在橙医生上发布内容的一切相关责任。您使用或提供的服务应遵守所有适用于橙医生的地方法律、国家法律和国际法律标准。<br>
2、您应遵守从中国境内向外传输技术性资料时必须符合中国有关法律法规。<br>
3、您使用本服务不得从事洗钱、窃取商业秘密等非法用途。<br>
4、您不得干扰或扰乱本服务。不得盗用他人帐号，并对由此行为造成的后果自负。<br>
5、您应遵守所有使用本服务的各项协议、规定、程序和惯例。您须承诺不传输任何非法的、骚扰性的、影射或中伤他人的、辱骂性的、恐吓性的、伤害性的、庸俗的、带有煽动性的、可能引起公众恐慌的、淫秽的、散播谣言等信息资料。另外，您也不能传输任何教唆他人构成犯罪行为、危害社会治安、侵害自己或他人人身安全的资料；不能传输助长国内不利条件和涉及国家安全的资料；不能传输任何不符合当地法规、国家法律和国际法律的资料。未经许可而非法进入其它电脑系统是禁止的。<br>
6、您不得发布任何不基于事实、虚构、编造及无亲身经历的信息；不得发布涉及政治、性别、种族歧视或攻击他人的文字、图片或语言等信息；不得发布医托、广告性质的内容；不得有其它涉及违反当地法规、国家法律和国际法律的行为。<br>
7、若您的行为不符合本协议的规定，橙医生有权做出独立判断，并立即停止向该您帐号提供服务。您需对自己在网上的行为承担法律责任。您若在橙医生上散布和传播反动、色情或其他违反国家法律的信息，橙医生的系统记录有可能作为您违反法律的证据。<br>
8、您的授权行为：对橙医生而言，您帐号和密码是唯一验证您真实性的依据，只要使用了正确的您帐号和密码无论是谁登录均视为已经得到注册您本人的授权。<br>
十一、咨询功能的使用<br>
橙医生具有通过图、文、视频等方式进行医疗健康信息在线咨询的功能，您应当遵循本协议的约定发表言论，且您所提的问题应当仅限于医疗健康类，对以下几类问题橙医生的注册医师有权不予回复：<br>
（1）非医疗健康类问题，如涉黄、涉赌、涉毒等问题；<br>
（2）胎儿性别鉴定问题；<br>
（3）可能危害他人、自己或社会安全可能的问题；<br>
（4）渲染悲愤、误导他人的问题；<br>
（5）其它有伤社会风化、橙医生认为有必要予以禁止的问题。<br>
十二、保障<br>
您同意保障和维护橙医生的利益，如果因为您违反有关法律、法规或本协议的任何规定而给橙医生或任何其他第三方造成任何损失，您统一承担由此产生的损害赔偿责任，其中包括橙医生为此而支付的律师费用。<br>
十三、违约责任<br>
您同意保障和维护橙医生的利益，如果因为您违反有关法律、法规或本协议的任何规定而给橙医生或任何其他第三方造成任何损失，您统一承担由此产生的全部损害赔偿责任，其中包括橙医生为此而支付的律师费用。<br>
十四、争议解决<br>
您和橙医生因执行本协议而发生争议的，双方先协商解决；协商不成, 您或橙医生均可向被告住所地有管辖权的法院提起诉讼。<br>
橙医生对注册医师过失或违约时放弃本协议规定的权利的，不能视为橙医生对咨询医师的其他或以后同类之过失或违约行为弃权。<br>
本协议的每一条款均可分割且独立于其他每一条款，如果在任何时候本协议的任何一条或多条条款成为无效、不合法或不能执行，本协议其他条款的有效性、合法性和可执行性并不因此而受到影响。<br>
十五、结束服务<br>
您或橙医生可随时根据您的权利义务等规范（参见本协议的第五条）和实际情况中断一项或多项橙医生提供的服务，橙医生无需对您或任何其他第三方负责。您对本协议的修改有异议，或对橙医生的服务不满，可以行使如下权利。<br>
1、停止使用橙医生提供的服务。<br>
2、通告橙医生停止对该您帐号的服务。结束您的服务后，您使用橙医生服务的权利马上终止，即刻，橙医生不对您承担任何义务和责任。<br>
十六、广告说明<br>
1、橙医生上为您的便利而提供的外部链接，包括但不限于任何广告内容链接，以及该链接所指向网页之所有内容，均系该网页所属第三方橙医生的所有者制作和提供（以下简称“第三方网页”）。第三方网页并非也不反映橙医生之任何意见和主张，也不表示橙医生同意或支持该第三方网页上的任何内容、主张或立场。橙医生对第三方网页中内容之合法性、准确性、真实性、适用性、安全性和完整性等概不承担任何负责。任何单位或个人如需要第三方网页中内容（包括资讯、资料、消息、产品或服务介绍、报价等），并欲据此进行交易或其他行为前，应慎重辨别这些内容的合法性、准确性、真实性、适用性、完整性和安全性（包括下载第三方网页中内容是否会感染电脑病毒），并采取谨慎的预防措施。如您不确定这些内容是否合法、准确、真实、实用、完整和安全，建议您先咨询专业人士。<br>
2、任何单位或者个人因相信、使用第三方网页中信息、服务、产品等内容，或据此进行交易等行为，而引致的人身伤亡、财产毁损（包括因下载而感染电脑病毒）、名誉或商誉诽谤、版权或知识产权等权利的侵犯等事件，及因该等事件所造成的损害后果，橙医生概不承担任何法律责任。无论何种原因，橙医生不对任何非与橙医生直接发生的交易和行为承担任何直接、间接、附带或衍生的损失和责任。<br>
十七、网络服务的内容所有权<br>
橙医生提供网络服务的内容包括：文字、软件、声音、照片、视频、录像、图表、网页、广告中的全部内容；电子邮件中的全部内容；橙医生为您提供的其他信息。所有这些信息均受版权、商标和其他财产所有权法律的保护。除本协议另有约定外，未经相关权利人同意，上述资料均不得在任何媒体直接或间接发布、播放、出于播放或发布目的而改写或再发行，或者被用于其他任何商业目的。所有这些资料或资料的任何部分仅可作为私人和非商业用途而保存在某台计算机内。橙医生的所有内容版权归原文作者和橙医生共同所有，任何人需要转载橙医生的内容，必须获得原文作者和橙医生的明确授权。<br>
十八、法律适用<br>
1、本协议之效力、解释、执行和争议的解决均适用中华人民共和国之法律。如本协议之任何一部分与中华人民共和国法律相抵触，则该部分条款应按有关法律规定重新解释，部分条款之无效或重新解释不影响其它条款之法律效力。<br>
2、您和橙医生因执行本协议而发生争议的，双方先协商解决；协商不成, 您或橙医生均可向被告住所地有管辖权的法院提起诉讼。<br>
3、橙医生对注册医师过失或违约时放弃本协议规定的权利的，不能视为橙医生对咨询医师的其他或以后同类之过失或违约行为弃权。<br>
4、本协议的每一条款均可分割且独立于其他每一条款，如果在任何时候本协议的任何一条或多条条款成为无效、不合法或不能执行，本协议其他条款的有效性、合法性和可执行性并不因此而受到影响。<br>
</p>
    </li>
    <li class="ruleul_li2" onClick="javascript:history.back();">我知道了</li>
</ul>
</body>
</html>
<script>
    var mw = $(window).width();
    var mh0 = $(window).height();
    var mh = 1136 * mw / 640;
    window.onload = function () {
        $('#mainDiv').width(mw);
        $('.top_ul').width(mw).height(mh*0.07);
        $('.top_ul li').height(mh*0.07);
        $('.top_ul li').css('line-height',mh*0.07+'px');
        $('#mainDiv').show();

        $('#ruleul').width(mw).height(mh*0.9);
        $('#ruleul').css({left:0,top:mh*0.075});
        $('.ruleul_li2').width(mw*0.6).height(mh*0.06);
        $('.ruleul_li2').css('line-height',mh*0.06+'px');
    }
</script>