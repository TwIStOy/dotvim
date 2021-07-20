module('ht.plugs.utils', package.seeall)

function config(plug)
  return ([[require('ht.plugs.%s').config()]]):format(plug)
end

function setup(plug)
  return ([[require('ht.plugs.%s').setup()]]):format(plug)
end

