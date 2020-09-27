module('dotvim.api.system', package.seeall)

raw_os_name = jit.os
raw_os_name = (raw_os_name):lower()

isWindows = false
if raw_os_name:match('windows') then
   isWindows = true
end

isMac = false
if raw_os_name:match('mac') or raw_os_name:match('darwin') then
   isMac = true
end

isLinux = false
if raw_os_name:match('linux') or raw_os_name:match('^mingw')
                              or raw_os_name:match('^cygwin') then
   isLinux = true
end


