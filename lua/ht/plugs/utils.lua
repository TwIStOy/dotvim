module('ht.plugs.utils', package.seeall)

function _config(plug)
  return ([[require('ht.plugs.%s').config()]]):format(plug)
end

function _setup(plug)
  return ([[require('ht.plugs.%s').setup()]]):format(plug)
end

