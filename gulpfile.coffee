gulp        = require 'gulp'
concat      = require 'gulp-concat'
browserify  = require 'gulp-browserify'
less        = require 'gulp-less'
zip         = require 'gulp-zip'

Package     = require './package.json'

project =
  dist:   './dist'
  build:  './build'
  style:  './style/*.less'
  static: './static/**'

gulp.task 'default', ['pack']
gulp.task 'build', ['src', 'style', 'static']

gulp.task 'src', ->
  gulp.src('./src/index.coffee',  read: false)
    .pipe(browserify({
      transform:  ['coffeeify']
      extensions: ['.coffee']
    }))
    .pipe(concat('app.js'))
    .pipe(gulp.dest(project.build))

gulp.task 'style', ->
  gulp.src(project.style)
    .pipe(less())
    .pipe(concat('app.css'))
    .pipe(gulp.dest(project.build))

gulp.task 'static', ->
  gulp.src(project.static)
    .pipe(gulp.dest(project.build))

gulp.task 'pack', ['build'], ->
  gulp.src("#{project.build}/**")
    .pipe(zip("#{Package.name}-#{Package.version}.zip"))
    .pipe(gulp.dest(project.dist))
