-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-01-26 11:00:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- Copyright (C) 2021 Marcel Arpogaus
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
