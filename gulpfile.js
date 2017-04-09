var gulp = require('gulp');
var connect = require('gulp-connect');
var proxy = require('http-proxy-middleware');

gulp.task('connect', function() {
    connect.server({
        root: '',
        port:"3300",
        livereload:true,
        middleware: function(connect, opt) {
            return [
                proxy('/rest', {
                    target: 'https://staging.chengyisheng.com.cn/',
                    changeOrigin:true
                }),
                proxy('/j_spring_security_check',{
                    target: 'https://staging.chengyisheng.com.cn/',
                    changeOrigin:true
                }),
                proxy('/j_spring_security_logout',{
                    target: 'https://staging.chengyisheng.com.cn/',
                    changeOrigin:true
                })
            ]
        }

    });
});

//检测html文件变化
var htmlSrc='assets/views/**/*.html';
gulp.task('html',function(){
    gulp.src([htmlSrc])
    .pipe(connect.reload())
})

//检测js文件变化
var jsSrc='assets/js/**/*.js';
gulp.task('js',function(){
    gulp.src([jsSrc])
    .pipe(connect.reload())
})


gulp.task('watch',function(){
  gulp.watch([htmlSrc],['html']);
  gulp.watch([jsSrc],['js']);
})

gulp.task("default",['connect',"watch"]);