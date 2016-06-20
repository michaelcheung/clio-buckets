var input = './app/assets/stylesheets/**/*.scss';
var output = './public/css';
var gulp = require('gulp');
var sass = require('gulp-sass');
var path = require('path');
var rename = require('gulp-rename');
var autoprefixer = require('gulp-autoprefixer');

// create gulp task watchify
require('./gulp/browserify');

var sassOptions = {
  errLogToConsole: true,
  outputStyle: 'compressed'
};

var autoprefixerOptions = {
  browsers: ['last 2 versions', '> 5%', 'Firefox ESR']
};

gulp.task('compileCSS', function() {
  console.log("styles are building");
  gulp
    .src(path.join('app', 'assets', 'stylesheets', 'index.scss'))
    .pipe(sass(sassOptions))
    .pipe(autoprefixer(autoprefixerOptions))
    .pipe(rename('compiled.css'))
    .pipe(gulp.dest('./public'))

});

gulp.task("watch", function() {
  gulp.watch('./app/assets/stylesheets/**/*.scss', ['compileCSS']);
  gulp.watch('./app/assets/javascript/*.js', ['watchify']);
});
