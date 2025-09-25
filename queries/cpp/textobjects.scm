; extends

((init_declarator
   declarator: (_) @assignment.lhs
   value: (_) @assignment.rhs))

((assignment_expression
   left: (_) @assignment.lhs
   right: (_) @assignment.rhs))

((initializer_pair
   designator: (_) @assignment.lhs
   value: (_) @assignment.rhs))

(lambda_expression
  body:  (compound_statement)) @function.outer

(lambda_expression
  body: (compound_statement . "{" . (_) @function.inner @function.inner_end (_)? @function.inner . "}"
))

(structured_binding_declarator
  "," @parameter.outer
  .
  (_) @parameter.inner @parameter.outer
)
(structured_binding_declarator
  .
  (_) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer
)


(for_range_loop
  type: (_) @for_range_loop.inner
  declarator: (_) @for_range_loop.inner)
(for_range_loop
  right: (_) @for_range_loop.inner)


(init_declarator
  value: (_) @dotvim_omni_right.inner)

(initializer_pair
  value: (_) @dotvim_omni_right.inner)

(if_statement
  condition: (condition_clause
               value: (_) @dotvim_omni_if.condition.inner) @dotvim_omni_if.condition.outer)

(lambda_capture_initializer
  right: (_) @dotvim_omni_right.inner)

(for_range_loop
  right: (_) @dotvim_omni_right.inner)

(assignment_expression
  right: (_) @dotvim_omni_right.inner)
