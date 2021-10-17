-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : taglist.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 15:41:47 (Marcel Arpogaus)
-- @Changed: 2021-08-10 08:36:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')

local mouse_bindings = require('mouse_bindings')

local abstract_element = require('decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, _)
    local taglist

    return abstract_element.new {
        register_fn = function(_)
            -- Create a taglist widget
            taglist = awful.widget.taglist {
                screen = s,
                filter = awful.widget.taglist.filter.all,
                buttons = mouse_bindings.taglist_buttons
            }
            return taglist
        end,
        unregister_fn = function(_)
            taglist:reset()
            taglist:remove()
            taglist = nil
        end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
