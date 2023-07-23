return function()
  local quick_expand = require("ht.snippets.snippet").quick_expand

  return {
    quick_expand("shrug", "¯\\_(ツ)_/¯"),
    quick_expand("angry", "(╯°□°）╯︵ ┻━┻"),
    quick_expand("happy", "ヽ(´▽`)/"),
    quick_expand("sad", "(－‸ლ)"),
    quick_expand("confused", "(｡･ω･｡)"),
  }
end
