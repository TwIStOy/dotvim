; extends

((named_argument
  (_)
  .
  (_) @_start
  (_)? @_end .)
 (#make-range! "super_right.inner" @_start @_end))

((assignment_expression
  left: (_)
  right: (_) @dotvim_omni_right.inner
))

((initialized_variable_definition
  value: (_) @dotvim_omni_right.inner
))
