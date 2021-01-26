-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-25 17:51:53 (Marcel Arpogaus)
-- @Changed: 2021-01-26 10:58:22 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ local objects ] -----------------------------------------------------------
local module = {}

local assets = {
    default = {
        init = function()
        end
    },
    recolor = require('rc/assets/recolor'),
    mac = require('rc/assets/mac')
}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    assets[config.assets or 'default'].init(config)
end

-- [ return module ] -----------------------------------------------------------
return module
