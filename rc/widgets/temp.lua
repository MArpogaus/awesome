-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : temp.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:05 (Marcel Arpogaus)
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
local beautiful = require('beautiful')

local vicious = require('vicious')

local utils = require('rc.widgets.utils')
local widgets = require('rc.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local temp_icon = ''

local default_timeout = 7

local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal

local default_thermal_zone = 'thermal_zone0'

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.thermal)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(warg)
    local color = warg.color or default_fg_color
    local thermal_zone = warg.thermal_zone or default_thermal_zone

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {widget = temp_icon},
            widget = {
                wtype = vicious.widgets.thermal,
                warg = thermal_zone,
                format = function(_, args)
                    return utils.markup {
                        fg_color = color,
                        text = args[1] .. '°C'
                    }
                end
            }
        }
    }
end
widget_defs.arc = function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color
    local thermal_zone = warg.thermal_zone or default_thermal_zone

    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color},
        widgets = {
            icon = {widget = temp_icon},
            widget = {
                wtype = vicious.widgets.thermal,
                warg = thermal_zone,
                format = function(widget, args)
                    widget:emit_signal_recursive('widget::value_changed',
                                                 args[1])
                    return utils.markup {
                        font = utils.set_font_size(beautiful.font, 8),
                        fg_color = fg_color,
                        text = args[1] .. '°C'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
