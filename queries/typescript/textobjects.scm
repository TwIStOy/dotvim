; extends

(named_imports
  .
  (import_specifier) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)
(named_imports
  "," @parameter.outer
  .
  (import_specifier) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)



