module('dotvim.loader', package.seeall)

function LoadCrate(crate_name)
  return require('dotvim.crate' .. crate_name)
end

