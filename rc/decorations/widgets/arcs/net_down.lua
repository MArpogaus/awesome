-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : net_down.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-07-28 14:34:25 (Marcel Arpogaus)
-- @Changed: 2021-07-28 15:11:00 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(warg)
    warg.value = 'down'

    return utils.require_submodule('decorations/widgets/arcs', 'net')
               .init(warg)
end

-- [ return module ] -----------------------------------------------------------
return module
