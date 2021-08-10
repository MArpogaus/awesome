-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : promptbox.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 15:42:38 (Marcel Arpogaus)
-- @Changed: 2021-08-10 08:36:07 (Marcel Arpogaus)
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
module.init = function(_)
    return abstract_element.new {
        register_fn = function(s)
            -- Create a promptbox for each screen
            s.promptbox = awful.widget.prompt()
            return s.promptbox
        end,
        unregister_fn = function(s) s.promptbox = nil end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
