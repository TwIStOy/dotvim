; extends

(reference_type
  (lifetime) @lifetime.inner)

((parameters
  . (self_parameter) @parameter.inner . ","? @_end)
 (#make-range! "parameter.outer" @parameter.inner @_end))


