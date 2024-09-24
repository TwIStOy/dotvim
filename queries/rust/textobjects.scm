; extends

(reference_type
  (lifetime) @lifetime.inner)

((parameters
  . (self_parameter) @parameter.inner . ","? @_end)
 (#make-range! "parameter.outer" @parameter.inner @_end))

(let_declaration
  value: (_) @dotvim_omni_right.inner)

(field_initializer
  value: (_) @dotvim_omni_right.inner)

(field_declaration
  type: (_) @dotvim_omni_right.inner)

(closure_expression
  body: (_) @dotvim_omni_right.inner)
