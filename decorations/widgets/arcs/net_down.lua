-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : net_down.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-07-28 14:34:25 (Marcel Arpogaus)
-- @Changed: 2021-10-14 20:26:57 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, warg)
    warg.value = 'down'

    return require('decorations.widgets.arcs.net').init(s, warg)
end

-- [ return module ] -----------------------------------------------------------
return module
