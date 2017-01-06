load('@io_bazel_rules_js//js:def.bzl', 'js_library', 'js_binary')

load('@io_bazel_rules_ts//ts/private:rules.bzl', 'ts_srcs')


def ts_repositories():
  native.new_http_archive(
    name   = 'typescript',
    url    = 'http://registry.npmjs.org/typescript/-/typescript-2.1.4.tgz',
    sha256 = '3da407976b10665045d142d1991cb56a36890b8360c6244e43f54f09f5f4493e',
    strip_prefix = 'package',
    build_file   = '@io_bazel_rules_ts//ts/toolchain:typescript.BUILD',
  )


def ts_library(name, **kwargs):
  src_name = name + '.src'
  ts_srcs(name=src_name, **kwargs)

  js_library(
    name = name,
    srcs = [src_name],
    deps = kwargs.get('deps', []),
  )


def ts_binary(name, **kwargs):
  src_name = name + '.src'
  ts_srcs(name=src_name, **kwargs)

  js_binary(
    name = name,
    srcs = [src_name],
    deps = kwargs.get('deps', []),
  )
