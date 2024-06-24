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
  body: (compound_statement . "{" . (_) @_start @_end (_)? @_end . "}"
 (#make-range! "function.inner" @_start @_end)))

((structured_binding_declarator
   "," @_start . (_) @parameter.inner @_end)
 (#make-range! "parameter.outer" @_start @parameter.inner))
((structured_binding_declarator
   . (_) @parameter.inner . ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))

((for_range_loop
   type: (_) @_start
   declarator: (_) @_end)
 (#make-range! "for_range_loop.inner" @_start @_end))
(for_range_loop
  right: (_) @for_range_loop.inner)


(init_declarator
  value: (_) @dotvim_omni_right.inner)

(initializer_pair
  value: (_) @dotvim_omni_right.inner)

(if_statement
  condition: (condition_clause
               value: (_) @dotvim_omni_if.condition.inner) @dotvim_omni_if.condition.outer)
