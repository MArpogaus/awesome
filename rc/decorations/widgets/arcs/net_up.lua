-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : net_up.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-07-28 14:31:16 (Marcel Arpogaus)
-- @Changed: 2021-07-28 15:11:07 (Marcel Arpogaus)
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
    warg.value = 'up'

    return utils.require_submodule('decorations/widgets/arcs', 'net')
               .init(warg)
end

-- [ return module ] -----------------------------------------------------------
return module
