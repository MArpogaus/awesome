-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : promptbox.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 15:42:38 (Marcel Arpogaus)
-- @Changed: 2021-08-12 10:00:00 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')

local abstract_element = require('decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s)
    return abstract_element.new {
        register_fn = function(_)
            -- Create a promptbox for each screen
            s.promptbox = awful.widget.prompt()
            return s.promptbox
        end,
        unregister_fn = function(_) s.promptbox = nil end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
