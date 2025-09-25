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

