load('@io_bazel_rules_js//js/private:rules.bzl',
  'js_dep_providers',
  'transitive_tars')

load('//ts/private:flags.bzl', 'tsc_attrs', 'tsc_flags')


ts_type = FileType(['.ts', '.tsx'])

def _ts_srcs_impl(ctx):
  bin_dir = ctx.configuration.bin_dir.path
  inputs  = list(ctx.files.srcs) + [ctx.file._tsc_lib]
  outputs = []
  cmds = [
    'mkdir ./node_modules',
  ]

  # First, make sure all dependent tars are extracted into a ./node_modules
  # directory
  dep_tars = transitive_tars(ctx)
  for tar in dep_tars:
    inputs.append(tar)
    cmds.append('tar -xzf %s -C ./node_modules' % tar.path)

  # For each input file, expect it to create a corresponding .js and .d.ts file.
  for src in ctx.files.srcs:
    basename = src.basename
    name     = basename[:basename.rfind('.')]

    js_src = name + '.js'
    ts_def = name + '.d.ts'

    outputs.append(ctx.new_file(js_src))
    outputs.append(ctx.new_file(ts_def))

  # We will either be building source files (relative to '.'), or generated
  # files (relative to the bazel-bin directory). Since it's not possible to
  # construct a typescript declaration which mixed the two files, we will assume
  # our source files are relative to '.' unless the first file starts with the
  # bazel-bin directory, then use that as the source root.
  #
  # When tsc tries to infer the source root directory, it will take the longest
  # prefix shared by all source files, which is almost always the path to the
  # module where tsc as been invoked. It likely works well for
  # compile-everything-at-once projects, but would put everything at the top
  # level in a scheme that compiles each module independently.
  root_dir = '.'
  if ctx.files.srcs and ctx.files.srcs[0].path.startswith(bin_dir):
    root_dir = bin_dir

  # Build up the command to pass node to invoke the TypeScript compiler with the
  # necessary sources
  inputs.append(ctx.executable._node)
  inputs.append(ctx.file._tsc)
  tsc_cmd = [
    ctx.executable._node.path,
    ctx.file._tsc.path,

    '--declaration',
    '--rootDir', root_dir,
    '--outDir', bin_dir,
  ] + [src.path for src in ctx.files.srcs]
  tsc_cmd += tsc_flags(ctx.attr)
  cmds.append(' '.join(tsc_cmd))

  ctx.action(
    command  = ' && \n'.join(cmds),
    inputs   = inputs,
    outputs  = outputs,
    mnemonic = 'CompileTS',
  )

  # Nuke ./node_modules. If your OS sandboxing support is a creep and/or
  # crumbum, execution may never reach this command, and you could end up with a
  # dangling `./node_modules` directory. It doesn't appear that we can trap
  # exits with Bazel arguments, so this might be better suited for an external
  # command that unpacks tars, executes the command, cleans up, and exits with
  # the command's exit code.
  cmds.append('rm -rf ./node_modules')

  return struct(files=set(outputs))


ts_srcs = rule(
  _ts_srcs_impl,
  attrs = tsc_attrs + {
    'srcs': attr.label_list(allow_files=ts_type),
    'deps': attr.label_list(providers=js_dep_providers),

    '_node': attr.label(
      default    = Label('@io_bazel_rules_js//js/toolchain:node'),
      cfg        = 'host',
      executable = True),

    '_tsc': attr.label(
      default     = Label('@typescript//:lib/tsc.js'),
      allow_files = True,
      single_file = True),

    '_tsc_lib': attr.label(
      default     = Label('@typescript//:lib/lib.d.ts'),
      allow_files = True,
      single_file = True),
  }
)


