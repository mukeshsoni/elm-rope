var gulp = require('gulp'),
    shell = require('gulp-shell');

gulp.task('build-tests', shell.task([
  'elm-make --warn RopeTests.elm --output tests.js'
]))

gulp.task('run-tests', ['build-tests'], shell.task([
  'node tests.js'
]))

gulp.task('default', function () {
  gulp.run('run-tests')

  gulp.watch(['../*.elm', '*.elm'], ['run-tests'])
})
