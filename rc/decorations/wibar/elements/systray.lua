-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : systray.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-09 13:45:01 (Marcel Arpogaus)
-- @Changed: 2021-08-10 08:41:52 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local wibox = require('wibox')

local abstract_element = require('rc.decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, _)
    return abstract_element.new {
        register_fn = function(_)
            s.systray = wibox.widget.systray()

            s.systray_set_screen = function()
                if s.systray then s.systray:set_screen(s) end
            end
            return s.systray
        end,
        unregister_fn = function(_)
            s.systray = nil
            s.systray_set_screen = nil
        end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
