; extends

(return_statement
  (expression_list
    "," @_start .
    (_) @parameter.inner
  (#make-range! "parameter.outer" @_start @parameter.inner))
)

(return_statement
  (expression_list
    . (_) @parameter.inner
    . ","? @_end
   (#make-range! "parameter.outer" @parameter.inner @_end))
)

