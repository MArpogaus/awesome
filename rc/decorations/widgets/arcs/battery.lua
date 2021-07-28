-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : battery.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:10 (Marcel Arpogaus)
-- @Changed: 2021-07-28 15:03:57 (Marcel Arpogaus)
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
local beautiful = require('beautiful')

local vicious = require('vicious')

local utils = require('rc.decorations.widgets.utils')
local widgets = require('rc.decorations.widgets')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local fa_bat_icons = {
    '', -- fa-battery-0 (alias) [&#xf244;]
    '', -- fa-battery-1 (alias) [&#xf243;]
    '', -- fa-battery-2 (alias) [&#xf242;]
    '', -- fa-battery-3 (alias) [&#xf241;]
    '' -- fa-battery-4 (alias) [&#xf240;]
}

local default_timeout = 15
local default_bat = 'BAT0'
local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal

-- [ local functions ] ---------------------------------------------------------
local function batt_icon(status, perc)
    local icon = 'N/A'
    if status == '+' then
        icon = ''
    else
        if perc ~= nil then
            icon = fa_bat_icons[math.floor(perc / 25) + 1]
        end
    end
    return icon
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.bat)

-- [ define widget ] -----------------------------------------------------------
module.init = widgets.new('arc', function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color
    local battery = warg.battery or default_bat

    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color},
        widgets = {
            icon = {
                widget = utils.create_arc_icon(fg_color, 'N/A', 150),
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(_, args)
                    local icon = batt_icon(args[1], args[2])
                    return utils.fa_markup(fg_color, icon, math.floor(150 / 8))
                end
            },
            widget = {
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(widget, args)
                    widget:emit_signal_recursive('widget::value_changed',
                                                 args[2])
                    return utils.markup {
                        font = utils.set_font_size(beautiful.font, 8),
                        fg_color = fg_color,
                        text = args[2] .. '%'
                    }
                end
            }
        }
    }
end)

-- [ return module ] -----------------------------------------------------------
return module
