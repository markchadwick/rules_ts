
_tsc_flags = {

  # Allow javascript files to be compiled.
  'allow_js': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--allowJs',
  },

  # Allow default imports from modules with no default export. This does not
  # affect code emit, just typechecking.
  'allow_synthetic_default_imports': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--allowSyntheticDefaultImports',
  },

  # Do not report errors on unreachable code.
  'allow_unreachable_code': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--allowUnreachableCode',
  },

  # Do not report errors on unused labels.
  'allow_unused_labels': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--allowUnusedLabels',
  },

  # Parse in strict mode and emit "use strict" for each source file
  'always_strict': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--alwaysStrict',
  },

  # Enables experimental support for ES7 decorators.
  'experimental_decorators': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--experimentalDecorators',
  },

  # Disallow inconsistently-cased references to the same file.
  'force_consistent_casing_in_file_names': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--forceConsistentCasingInFileNames',
  },

  # Import emit helpers from 'tslib'.
  'import_helpers': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--importHelpers',
  },

  # Specify JSX code generation: 'preserve' or 'react'
  'jsx': {
    'type': 'value',
    'attr': attr.string(values=['', 'preserve', 'react']),
    'flag': '--jsx',
  },

  # Specify the JSX factory function to use when targeting 'react' JSX emit,
  # e.g. 'React.createElement' or 'h'.
  'jsx_factory': {
    'type': 'value',
    'attr': attr.string(),
    'flag': '--jsxFactory',
  },

  # Specify library files to be included in the compilation:  'es5' 'es6'
  # 'es2015' 'es7' 'es2016' 'es2017' 'dom' 'dom.iterable' 'webworker'
  # 'scripthost' 'es2015.core' 'es2015.collection' 'es2015.generator'
  # 'es2015.iterable' 'es2015.promise' 'es2015.proxy' 'es2015.reflect'
  # 'es2015.symbol' 'es2015.symbol.wellknown' 'es2016.array.include'
  # 'es2017.object' 'es2017.sharedmemory' 'es2017.string'
  'lib': {
    'type': 'value',
    'attr': attr.string(values=['', 'es5', 'es6','es2015', 'es7', 'es2016',
      'es2017', 'dom', 'dom.iterable', 'webworker', 'scripthost', 'es2015.core',
      'es2015.collection', 'es2015.generator', 'es2015.iterable',
      'es2015.promise', 'es2015.proxy', 'es2015.reflect', 'es2015.symbol',
      'es2015.symbol.wellknown', 'es2016.array.include', 'es2017.object',
      'es2017.sharedmemory', 'es2017.string']),
    'flag': '--lib',
  },

  # The maximum dependency depth to search under node_modules and load
  # JavaScript files
  'max_node_module_js_depth': {
    'type': 'value',
    'attr': attr.int(),
    'flag': '--maxNodeModuleJsDepth',
  },

  # Specify module code generation: 'commonjs', 'amd', 'system', 'umd' or
  # 'es2015'
  'module': {
    'type': 'value',
    'attr': attr.string(default='commonjs',
              values=['', 'commonjs', 'amd', 'system', 'umd', 'es2015']),
    'flag': '--module',
  },

  # Specify module resolution strategy: 'node' (Node.js) or 'classic'
  # (TypeScript pre-1.6).
  'module_resolution': {
    'type': 'value',
    'attr': attr.string(values=['', 'node', 'classic']),
    'flag': '--moduleResolution',
  },

  # Specify the end of line sequence to be used when emitting files: 'CRLF'
  # (dos) or 'LF' (unix).
  'new_line': {
    'type': 'value',
    'attr': attr.string(values=['', 'CRLF', 'LF']),
    'flag': '--newLine',
  },

  # Do not emit outputs if any errors were reported.
  'no_emit_on_error': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--noEmitOnError',
  },

  # Report errors for fallthrough cases in switch statement.
  'no_fallthrough_cases_in_switch': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--noFallthroughCasesInSwitch',
  },

  # Raise error on expressions and declarations with an implied 'any' type.
  'no_implicit_any': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--noImplicitAny',
  },

  # Report error when not all code paths in function return a value.
  'no_implicit_returns': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--noImplicitReturns',
  },

  # Raise error on 'this' expressions with an implied 'any' type.
  'no_implicit_this': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--noImplicitThis',
  },

  # Do not emit 'use strict' directives in module output.
  'no_implicit_use_strict': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--noImplicitUseStrict',
  },

  # Report errors on unused locals.
  'no_unused_locals': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--noUnusedLocals',
  },

  # Report errors on unused parameters.
  'no_unused_parameters': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--noUnusedParameters',
  },

  # Do not erase const enum declarations in generated code.
  'preserve_const_enums': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--preserveConstEnums',
  },

  # Stylize errors and messages using color and context. (experimental)
  'pretty': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--pretty',
  },

  # Specify the object invoked for createElement and __spread when targeting
  # 'react' JSX emit
  'react_namespace': {
    'type': 'value',
    'attr': attr.string(),
    'flag': '--reactNamespace',
  },

  # Do not emit comments to output.
  'remove_comments': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--removeComments',
  },

  # Enable strict null checks.
  'strict_null_checks': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--strictNullChecks',
  },

  # Suppress noImplicitAny errors for indexing objects lacking index signatures.
  'suppress_implicit_any_index_errors': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--suppressImplicitAnyIndexErrors',
  },

  # Logs module resolution to stdout
  'trace_resolution': {
    'type': 'flag',
    'attr': attr.bool(),
    'flag': '--traceResolution',
  },
}


tsc_attrs = {}
def _init_tsc_attrs():
  for k, v in _tsc_flags.items():
    tsc_attrs[k] = v['attr']
_init_tsc_attrs()


def tsc_flags(attrs):
  flags = []
  for field, flag in _tsc_flags.items():
    value = getattr(attrs, field)
    if not value: continue

    flag_type = flag['type']
    if flag_type == 'flag':
      flags.append(flag['flag'])
    elif flag_type == 'value':
      flags += [flag['flag'], str(value)]
    else:
      fail('Unknown flag type "%s"' % flag_type)

  return flags
