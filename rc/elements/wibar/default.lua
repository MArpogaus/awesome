-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-01-26 11:00:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local abstract_element = require('rc.elements.abstract_element')
local utils = require('rc.elements.wibar.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local mykeyboardlayout = awful.widget.keyboardlayout()
    local element = abstract_element.new {
        register_fn = function(s)
            -- Create the wibox
            s.mywibar = awful.wibar({position = 'top', screen = s})

            -- Add widgets to the wibox
            s.left_widget_container = {s.mymainmenu, s.mytaglist, s.mypromptbox}
            s.left_widget_container.layout = wibox.layout.fixed.horizontal

            s.right_widget_container = gears.table.join(
                {mykeyboardlayout, wibox.widget.systray()},
                utils.gen_wibar_widgets(s, config),
                {s.mylayoutbox, s.myexitmenu}
            )
            s.right_widget_container.layout = wibox.layout.fixed.horizontal

            -- Add widgets to the wibox
            s.mywibar:setup{
                layout = wibox.layout.align.horizontal,
                s.left_widget_container, -- Left widgets
                s.mytasklist, -- Middle widget
                s.right_widget_container -- Right widgets
            }
        end,
        unregister_fn = function(s)
            utils.unregister_wibar_widgtes(s)

            s.mywibar.widget:reset()
            s.mywibar:remove()
            s.mywibar = nil
        end,
        update_fn = function(s)
            utils.update_wibar_widgets(s)
        end
    }
    return element
end

-- [ sequential code ] ---------------------------------------------------------

-- [ return module ] -----------------------------------------------------------
return module
