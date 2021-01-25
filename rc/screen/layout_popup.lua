-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : layout_popup.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-25 09:58:27 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(lb)
    local p = awful.popup {
        widget = wibox.widget {
            awful.widget.layoutlist {
                source = awful.widget.layoutlist.source.default_layouts,
                screen = 1,
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
        placement = awful.placement.under_mouse + awful.placement.no_offscreen,
        border_color = beautiful.border_color,
        border_width = beautiful.border_width,
        ontop = true,
        hide_on_right_click = true,
        visible = false
    }
    p:bind_to_widget(lb)
    return p
end

-- [ sequential code ] ---------------------------------------------------------

-- [ return module ] -----------------------------------------------------------
return module
