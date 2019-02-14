syntax clear


syn match crateDash      /\m^-/
syn match cratePlus      /\m^+/
syn match crateStar      /\m*/
syn match crateNotLoaded /\m\(not loaded\)$/
syn match plugNotSourced /\m\(not sourced\)$/
syn match crateName      /\m\(^[+-] \)\@<=[^ ]*:/
syn match plugName       /\m\(^  \* \)\@<=[^ ]*/
syn match dotvimTitle    /\m^Dotvim Crates:/

hi def link crateDash   Special
hi def link cratePlus   Constant
hi def link crateStar   Boolean
hi def link crateName   Label
hi def link plugName    Function
hi def link dotvimTitle Type

hi def link crateNotLoaded Comment
hi def link plugNotSourced Comment

