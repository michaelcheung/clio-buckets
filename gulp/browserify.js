gulp = require('gulp');

browserify = require('browserify');
watchify = require('watchify');
source = require('vinyl-source-stream');
derequire = require('gulp-derequire');

var isWatching = false;

var jsFiles = {
  input: ['./app/assets/javascript/index.js'],
  output: 'compiled.js',
  destination: './public/'
}

var createBundle = function(options) {
  browserifyOptions = {
    cache: {},
    packageCache: {},
    fullPaths: true,
    entries: options.input
  }

  if(options.standalone != null) {
    browserifyOptions.standalone = options.standalone
  }

  var bundler = browserify(browserifyOptions);

  var rebundle = function() {
    var startTime = new Date().getTime();

    bundler
      .bundle()
      .on("error", function() { console.log(arguments) })
      .pipe(source(options.output))
      .pipe(derequire())
      .pipe(gulp.dest(options.destination))
      .on("end", function() {
        var time = (new Date().getTime() -startTime) / 1000;
        console.log(options.output + " was browserified: " + time);
      })
  };

  if(isWatching) {
    var bundler = watchify(bundler);
    bundler.on("update", function(){ rebundle });
  }

  rebundle();
}

gulp.task('compileJS', function() {
  createBundle(jsFiles);
});

gulp.task('browserify-setWatch', function() {
  isWatching = true;
});

gulp.task('watchify', ['browserify-setWatch', 'compileJS'])
