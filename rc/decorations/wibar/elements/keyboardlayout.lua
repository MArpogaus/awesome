-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : keyboardlayout.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-09 13:38:17 (Marcel Arpogaus)
-- @Changed: 2021-08-09 15:28:07 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')

local abstract_element = require('rc.decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function()
    return abstract_element.new {
        register_fn = function(_) return awful.widget.keyboardlayout() end,
        unregister_fn = function(_) end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
