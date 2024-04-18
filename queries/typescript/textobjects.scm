; extends

((named_imports
   . (import_specifier) @parameter.inner . ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))
((named_imports
   "," @_start . (import_specifier) @parameter.inner . ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))


