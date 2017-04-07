var app = angular.module('clipApp', ['aidee-module']);
app.run(['$rootScope', '$state', '$stateParams', '$http',
function ($rootScope, $state, $stateParams, $http) {

    // Attach Fastclick for eliminating the 300ms delay between a physical tap and the firing of a click event on mobile browsers
    FastClick.attach(document.body);

    // Set some reference to access them from any scope
    $rootScope.$state = $state;
    $rootScope.$stateParams = $stateParams;

    $rootScope.$on('$stateChangeStart', function(event, toState) {
    	
    	 $http.get(REST_PREFIX+"resource/menus").error(function(data, status, headers, config) {
             if(status==401) {
                 event.preventDefault();
                 $state.go('error.403');
             }
         });
    	 
        if (toState.authentication) {
            var forbidden = true;
            if(userSearchMenu.length == 0) { //������ˢ��ʱ���֣�����̨�ӿڼ��Ȩ��

                $http.get(REST_PREFIX+"resource/check?uiSref="+toState.name).success(function(result) {
                    if(!result) {
                        event.preventDefault();
                        $state.go('error.403');
                    }
                });
            } else {
                userSearchMenu.forEach(function(menu) {
                    if(menu.url == toState.name) {
                        forbidden = false;
                        return;
                    }
                });
                if(forbidden) {
                    event.preventDefault();
                    $state.go('error.403');
                }
            }
        }
    });

    // GLOBAL APP SCOPE
    // set below basic information
    $rootScope.app = {
        name: '橙医生', // name of your project
        author: '橙医生', // author's name or company name
        description: '后台管理系统', // brief description
        version: '1.0', // current version
        year: ((new Date()).getFullYear()), // automatic current year (for copyright information)
        isMobile: (function () {// true if the browser is a mobile device
            var check = false;
            if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
                check = true;
            }
            return check;
        })(),
        layout: {
            isNavbarFixed: true, //true if you want to initialize the template with fixed header
            isSidebarFixed: true, // true if you want to initialize the template with fixed sidebar
            isSidebarClosed: false, // true if you want to initialize the template with closed sidebar
            isFooterFixed: false, // true if you want to initialize the template with fixed footer
            theme: 'theme-1', // indicate the theme chosen for your project
            logo: 'assets/images/logo.png' // relative path of the project logo
        },
        viewAnimation: 'ng-fadeInUp'
    };
    $rootScope.user = {
        name: 'CYS',
        job: 'ng-Dev',
        picture: 'app/img/user/02.jpg',
        developer: false
    };
    $http.get(REST_PREFIX+"role/checkDeveloper").success(function(result) {
        if(result) {
            $rootScope.user.developer = true;
        }
    });
}]);
// translate config
app.config(['$translateProvider',
function ($translateProvider) {

    // prefix and suffix information  is required to specify a pattern
    // You can simply use the static-files loader with this pattern:
    $translateProvider.useStaticFilesLoader({
        prefix: 'assets/i18n/',
        suffix: '.json'
    });

    // Since you've now registered more then one translation table, angular-translate has to know which one to use.
    // This is where preferredLanguage(langKey) comes in.
    $translateProvider.preferredLanguage('zh_CN');

    // Store the language in the local storage
    $translateProvider.useLocalStorage();

}]);
// Angular-Loading-Bar
// configuration
app.config(['cfpLoadingBarProvider',
function (cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeBar = true;
    cfpLoadingBarProvider.includeSpinner = false;

}]);


//indexedDB
app.service('cysIndexedDB',function($http,$localStorage,$rootScope){
    this.name='cys';
    this.version=1;
    this.db=null;

    //打开数据库
    this.openDB=function(){
        var _this=this;
        var version=_this.version || 1;
        var request=window.indexedDB.open(_this.name,version);
        request.onerror=function(e){
            console.log(e.currentTarget.error.message);
        };
        request.onsuccess=function(e){
            console.log("open success");
            _this.db= e.target.result;
            _this.getAllData('hospital');
            _this.getAllData('qrCode');
        };
        request.onupgradeneeded=function(e){
            var db= e.target.result;

            if(!db.objectStoreNames.contains('hospital')){
                var store=db.createObjectStore('hospital',{keyPath: 'hospitalId'});
                store.createIndex('DistrictId','jdDistrictId',{unique:false});
                store.createIndex('DistrictAreaId','jdDistrictAreaId',{unique:false});
            }

            if(!db.objectStoreNames.contains('qrCode')){
                var store2=db.createObjectStore('qrCode',{keyPath: 'uuid'});
                store2.createIndex('name','name',{unique:false});
                store2.createIndex('createDate','createDate',{unique:false});
            }

        };
    };

    //删除数据库
    this.deleteDB=function(name){
        indexedDB.deleteDatabase(name);
    };

    //添加数据
    this.addData=function(db,storeName,data){
        console.log(storeName);
        var transaction=db.transaction(storeName,'readwrite');
        var store=transaction.objectStore(storeName);
        store.clear();
        for(var i=0;i<data.length;i++){
            store.add(data[i]);
        }
        console.log('add success');
    };

    this.deleteDataByKey=function(db,storeName,value){
        var transaction=db.transaction(storeName,'readwrite');
        var store=transaction.objectStore(storeName);
        store.delete(value);
    };

    this.getAllData=function(storeName){
        var _this=this;
        var transaction=_this.db.transaction(storeName,'readwrite');
        var store=transaction.objectStore(storeName);
        var request=store.getAll();
        request.onsuccess=function(e){
            if(storeName==="hospital"){
                console.log("get hospital all data success!");
                $rootScope.jdHospitals=e.target.result;
            }else if(storeName==="qrCode"){
                console.log("get qrCode all data success!");
                $rootScope.jdQrcodeList=e.target.result;
            }

        };
    };

     this.getMultipleData=function(db,storeName,searchTerm,index){
        console.log(searchTerm);
        var transaction=db.transaction(storeName);
        var store=transaction.objectStore(storeName);
        var index = store.index(index);
        var request=index.openCursor(IDBKeyRange.bound(searchTerm,searchTerm+'\uffff'));
         var arr=[];
        request.onsuccess=function(e){
            var cursor=e.target.result;
            if(cursor){
                arr.push(cursor.value);
                $rootScope.qrCodeList=arr;
                cursor.continue();
            }
        }
    };


});


