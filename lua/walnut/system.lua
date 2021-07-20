module('walnut.system', package.seeall)

raw_os_name = jit.os
raw_os_name = (raw_os_name):lower()

is_windows = false
if raw_os_name:match('windows') then is_windows = true end

is_mac = false
if raw_os_name:match('mac') or raw_os_name:match('darwin') then is_mac = true end

is_linux = false
if raw_os_name:match('linux') or raw_os_name:match('^mingw') or
    raw_os_name:match('^cygwin') then is_linux = true end

