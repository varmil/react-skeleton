gulp = require 'gulp'
pl = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'gulp.*'],
  replaceString: /\bgulp[\-.]/
})
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
browserify = require 'browserify'
watchify = require 'watchify'
minimist = require 'minimist'

app =
  dirRoot: 'app'
  appJs: './app/app.js'

pub =
  dirRoot: 'public'
  dirJs: './public/js/'

# minimist 用の設定
knownOptions = {
  string: ['target', 'prefix'],
  default: { target: app.appJs, prefix: '' }
}
options = minimist process.argv.slice(2), knownOptions

bundleShare = (b, isSandbox) ->
  b
    .transform 'browserify-shim'
    .transform 'reactify'
    .bundle()
    .pipe source options.prefix + 'bundle.js'
    .pipe buffer()
    .pipe pl.if isSandbox, pl.sourcemaps.init
      loadMaps: true
    .pipe pl.if(! isSandbox, pl.uglify())
    .pipe pl.if isSandbox, pl.sourcemaps.write()
    .pipe gulp.dest pub.dirJs

# browserify + uglify
gulp.task 'build', ->
  b =  browserify {
    entries: [options.target]
    debug: false
  }
  bundleShare b, false

gulp.task 'watchify', ->
  b = browserify {
    cache: {}
    packageCache: {}
    fullPaths: true
    entries: [app.appJs]
    debug: true # generate sourcemap
  }
  b = watchify(b);
  b.on 'update', ->
    bundleShare b, true
  b.on 'log', (msg) ->
    console.log msg
  bundleShare b, true

gulp.task 'watch', ['watchify'], ->

gulp.task 'default', ['watch']