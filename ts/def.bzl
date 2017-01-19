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

  # Use the mocha typedef file as a source when running `ts_test`
  native.new_http_archive(
    name = 'mocha_types',
    url = 'http://registry.npmjs.org/@types/mocha/-/mocha-2.2.37.tgz',
    strip_prefix = 'mocha',
    sha256 = '5d58404cf416052ba01b3c419a431d3cc253b23414bbdabc83e9961f82ac6e0f',
    build_file_content = 'exports_files(["index.d.ts"])',
  )


def ts_library(name, **kwargs):
  src_name = name + '.src'
  ts_srcs(name=src_name, **kwargs)

  js_library(
    name = name,
    srcs = [src_name],
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
  size     = kwargs.pop('size', None)

  srcs = kwargs.pop('srcs', [])
  compile_srcs = srcs + ['@mocha_types//:index.d.ts']

  deps = kwargs.pop('deps', [])
  compile_deps = deps + ['@mocha//:lib']

  ts_srcs(
    name        = src_name,
    declaration = False,
    srcs        = compile_srcs,
    deps        = compile_deps,
    **kwargs)

  js_test(
    name = name,
    size = size,
    srcs = [src_name],
    deps = deps,
    visibility = kwargs.get('visibility'),
  )
