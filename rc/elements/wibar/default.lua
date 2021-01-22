-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')
local wibox = require('wibox')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(_)
    local element = {}
    local mytextclock = wibox.widget.textclock()
    local mykeyboardlayout = awful.widget.keyboardlayout()
    element.register = function(s)
        -- Create the wibox
        s.mywibar = awful.wibar({position = 'top', screen = s})

        -- Add widgets to the wibox
        s.mywibar:setup{
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                s.mainmenu,
                s.mytaglist,
                s.mypromptbox
            },
            s.mytasklist, -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox
            }
        }
    end
    element.unregister = function(s)
        s.mywibar.widget:reset()
        s.mywibar:remove()
        s.mywibar = nil
    end
    element.update = function(_) end
    return element
end

-- [ sequential code ] ---------------------------------------------------------

-- [ return module ] -----------------------------------------------------------
return module
