; extends

(return_statement
  (expression_list
    "," @parameter.outer
    .
    (_) @parameter.inner @parameter.outer
  )
)

(return_statement
  (expression_list
    . (_) @parameter.inner @parameter.outer
    . ","? @parameter.outer
 )
)

(short_var_declaration
  left: (_)
  right: (_) @dotvim_omni_right.inner
)

(keyed_element
  key: (_)
  value: (_) @dotvim_omni_right.inner
)

(assignment_statement
  left: (_)
  right: (_) @dotvim_omni_right.inner
)

(binary_expression
  left: (_)
  right: (_) @dotvim_omni_right.inner
)
