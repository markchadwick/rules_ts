load('@bazel_tools//tools/build_defs/pkg:pkg.bzl', 'pkg_tar')

load('@io_bazel_rules_js//js/private:rules.bzl', 'js_tar')
load('@io_bazel_rules_js//js:def.bzl', 'js_binary')


# Because we're in an external (`typescript`), the `js_library` is going to want
# to resolve us to `external/typescript`. Instead, build the tar by hand, and
# bless it using the `js_tar` backdoor.
pkg_tar(
  name        = 'js_tar',
  extension   = 'tar.gz',
  files       = ['package.json'] + glob(['lib/*']),
  package_dir = 'typescript',
)

js_tar(
  name   = 'lib',
  js_tar = ':js_tar',
  visibility = ['//visibility:public'],
)

exports_files([
  'lib/tsc.js',
  'lib/lib.d.ts'
], visibility=['//visibility:public'])
