-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : default.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-10-09 09:38:10 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
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
local gears = require('gears')
local wibox = require('wibox')

-- [ local objects ] -----------------------------------------------------------
local module = {}
-- [ module functions ] --------------------------------------------------------
module.init = function(c, config)
    local titlebar_buttons = config.buttons or
                                 {
            'floating',
            'maximized',
            'sticky',
            'ontop',
            'close'
        }
    local buttons = gears.table.join(awful.button({}, 1, function()
        c:emit_signal('request::activate', 'titlebar', {raise = true})
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        c:emit_signal('request::activate', 'titlebar', {raise = true})
        awful.mouse.client.resize(c)
    end))

    local titlebar_buttons_container = {layout = wibox.layout.fixed.horizontal}
    for _, tb in ipairs(titlebar_buttons) do
        table.insert(titlebar_buttons_container,
                     awful.titlebar.widget[tb .. 'button'](c))
    end

    awful.titlebar(c):setup{
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align = 'center',
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        -- Right
        titlebar_buttons_container,
        layout = wibox.layout.align.horizontal
    }
end

-- [ sequential code ] ---------------------------------------------------------

-- [ return module ] -----------------------------------------------------------
return module
