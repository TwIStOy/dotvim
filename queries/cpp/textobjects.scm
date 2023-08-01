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
  

