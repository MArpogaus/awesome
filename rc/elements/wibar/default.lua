-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-01-23 19:47:17 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

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
            s.wibar_widget_containers = utils.gen_wibar_widgets(s, config)
            table.insert(s.wibar_widget_containers, mykeyboardlayout)
            table.insert(s.wibar_widget_containers, wibox.widget.systray())
            if s.myexitmenu then
                local myexitmenu = {
                    -- add margins
                    s.myexitmenu,
                    left = beautiful.wibar_widgets_spacing or 12,
                    widget = wibox.container.margin
                }
                table.insert(s.wibar_widget_containers, myexitmenu)
            end
            s.wibar_widget_containers.layout = wibox.layout.fixed.horizontal

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
                s.wibar_widget_containers -- Right widgets
            }
        end,
        unregister_fn = function(s)
            utils.unregister_wibar_widgtes(s)

            s.mywibar.widget:reset()
            s.mywibar:remove()
            s.mywibar = nil
        end,
        update_fn = function(s) utils.update_wibar_widgets(s) end
    }
    return element
end

-- [ sequential code ] ---------------------------------------------------------

-- [ return module ] -----------------------------------------------------------
return module
