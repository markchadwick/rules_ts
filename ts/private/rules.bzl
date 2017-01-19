load('@io_bazel_rules_js//js/private:rules.bzl',
  'transitive_tars',
  'node_attr',
  'js_dep_attr')

load('//ts/private:flags.bzl', 'tsc_attrs', 'tsc_flags')


ts_type = FileType(['.ts', '.tsx'])

def _compile(ctx, srcs):
  bin_dir = ctx.configuration.bin_dir.path
  inputs  = srcs + [ctx.file._tsc_lib]
  outputs = []
  cmds    = ['mkdir ./node_modules']

  declaration = ctx.attr.declaration

  # First, make sure all dependent tars are extracted into the working
  # directory. If `allow_relative` is set, they will be expanded into the root
  # (making the library and source code all at the same level). Otherwise,
  # library code is expanded into ./node_modules, so that relative imports
  # outside of the current module will not work.
  dep_tars = transitive_tars(ctx.attr.deps)
  for tar in dep_tars:
    inputs.append(tar)

    if ctx.attr.allow_relative:
      cmds.append('tar -xzf %s' % tar.path)
    else:
      cmds.append('tar -xzf %s -C ./node_modules' % tar.path)

  # For each input file, expect it to create a corresponding .js and .d.ts file.
  # If the source is a .d.ts file, pass it to the parser, but don't expect an
  # output file
  for src in srcs:
    if src.path.endswith('.d.ts'):
      continue

    basename = src.basename
    name     = basename[:basename.rfind('.')]

    js_src = name + '.js'
    outputs.append(ctx.new_file(js_src))

    if declaration:
      ts_def = name + '.d.ts'
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
  if srcs and srcs[0].path.startswith(bin_dir):
    root_dir = bin_dir

  # Build up the command to pass node to invoke the TypeScript compiler with the
  # necessary sources
  inputs.append(ctx.executable._node)
  inputs.append(ctx.file._tsc)
  tsc_cmd = [
    ctx.executable._node.path,
    ctx.file._tsc.path,

    '--rootDir', root_dir,
    '--outDir', bin_dir,
  ]

  if declaration:
    tsc_cmd.append('--declaration')

  tsc_cmd += [src.path for src in srcs]
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


def _ts_srcs_impl(ctx):
  return _compile(ctx, ctx.files.srcs)


def _ts_src_impl(ctx):
  return _compile(ctx, ctx.files.src)


attrs = tsc_attrs + {
  'deps': js_dep_attr,

  # Allows importing across module boundaries using relative imports
  'allow_relative': attr.bool(default=False),

  '_node': node_attr,

  '_tsc': attr.label(
    default     = Label('@typescript//:lib/tsc.js'),
    allow_files = True,
    single_file = True),

  '_tsc_lib': attr.label(
    default     = Label('@typescript//:lib/lib.d.ts'),
    allow_files = True,
    single_file = True),
}

ts_srcs = rule(
  _ts_srcs_impl,
  attrs = attrs + {
    'srcs':         attr.label_list(allow_files=ts_type),
    'declaration':  attr.bool(default=True),
  }
)

ts_src = rule(
  _ts_src_impl,
  attrs = attrs + {
    'src':          attr.label(allow_files=ts_type, single_file=True),
    'declaration':  attr.bool(default=False),
  }
)
