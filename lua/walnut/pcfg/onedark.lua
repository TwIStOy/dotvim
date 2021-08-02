module('walnut.pcfg.onedark', package.seeall)

function config()
  require('onedark').setup{
    functionStyle = "italic",
    sidebars = {"qf", "vista_kind", "terminal", "packer"},
    variableStyle = "italic",
  }
end

