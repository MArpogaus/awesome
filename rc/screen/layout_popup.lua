-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : layout_popup.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-25 09:58:27 (Marcel Arpogaus)
-- @Changed: 2021-02-09 17:59:14 (Marcel Arpogaus)
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
local beautiful = require('beautiful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, lb)
    if module.popup == nil then
        module.popup = awful.popup {
            widget = wibox.widget {
                awful.widget.layoutlist {
                    base_layout = wibox.widget {
                        spacing = 5,
                        forced_num_cols = 3,
                        layout = wibox.layout.grid.vertical
                    },
                    widget_template = {
                        {
                            {
                                id = 'icon_role',
                                forced_height = 32,
                                forced_width = 32,
                                widget = wibox.widget.imagebox
                            },
                            margins = 4,
                            widget = wibox.container.margin
                        },
                        id = 'background_role',
                        -- forced_width    = 24,
                        -- forced_height   = 24,
                        shape = gears.shape.rounded_rect,
                        widget = wibox.container.background
                    }
                },
                margins = 4,
                widget = wibox.container.margin
            },
            border_color = beautiful.border_color,
            border_width = beautiful.border_width,
            ontop = true,
            hide_on_right_click = true,
            visible = false
        }
    end
    module.popup:bind_to_widget(lb)
    return module.popup
end
module.reset = function(lp, lb) lp:unbind_to_widget(lb) end

-- [ return module ] -----------------------------------------------------------
return module
