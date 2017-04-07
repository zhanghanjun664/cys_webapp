var gulp = require('gulp');
var connect = require('gulp-connect');
var proxy = require('http-proxy-middleware');

gulp.task('connect', function() {
    connect.server({
        root: '',
        middleware: function(connect, opt) {
            return [
                proxy('/rest', {
                    target: 'https://staging.chengyisheng.com.cn/',
                    changeOrigin:true
                }),
                proxy('/j_spring_security_check',{
                    target: 'https://staging.chengyisheng.com.cn/',
                    changeOrigin:true
                })
            ]
        }

    });
});