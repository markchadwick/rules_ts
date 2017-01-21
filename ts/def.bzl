load('@io_bazel_rules_js//js:def.bzl',
  'js_binary',
  'js_library',
  'js_test')

load('@io_bazel_rules_ts//ts/private:rules.bzl', 'ts_src', 'ts_srcs')


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
    ts_defs = src_name,
    deps = kwargs.get('deps', []),
    visibility = kwargs.get('visibility'),
  )


def ts_binary(name, **kwargs):
  src_name = name + '.src'
  ts_src(name=src_name, **kwargs)

  js_binary(
    name = name,
    src  = src_name,
    deps = kwargs.get('deps', []),
  )


def ts_test(name, **kwargs):
  src_name = name + '.src'

  # Remote all test arguments from the compile command and pass them to only the
  # test command. See:
  # https://bazel.build/versions/master/docs/be/common-definitions.html#common-attributes-tests
  js_test_arg_names = [
    'args', 'size', 'timeout', 'flaky', 'local', 'shared_count', 'visibility'
  ]
  js_test_args = {}
  for arg_name in js_test_arg_names:
    if arg_name in kwargs:
      js_test_args[arg_name] = kwargs.pop(arg_name)

  deps = kwargs.pop('deps', [])
  compile_deps = deps + ['@mocha//:lib']

  ts_srcs(
    name        = src_name,
    declaration = False,
    srcs        = kwargs.pop('srcs', []),
    deps        = compile_deps,
    **kwargs)

  js_test(
    name = name,
    srcs = [src_name],
    deps = deps,
    **js_test_args)
