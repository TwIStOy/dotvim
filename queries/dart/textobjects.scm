; extends

(named_argument
  (_)
  .
  (_) @super_right.inner
  (_)? @super_right.inner .)

((assignment_expression
  left: (_)
  right: (_) @dotvim_omni_right.inner
))

((initialized_variable_definition
  value: (_) @dotvim_omni_right.inner
))
