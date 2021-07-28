-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : net.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:01 (Marcel Arpogaus)
-- @Changed: 2021-07-28 15:06:15 (Marcel Arpogaus)
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

local net_icons = {down = '', up = ''}

local default_timeout = 3
local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal
local default_interface = 'eth0'
local default_value = 'down'

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.net)

-- [ define widget ] -----------------------------------------------------------
module.init = widgets.new('arc', function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color
    local interface = warg.interface or default_interface
    local value = warg.value or default_value

    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color, max = 50 * 1024},
        widgets = {
            icon = {widget = net_icons[value]},
            widget = {
                wtype = vicious.widgets.net,
                format = function(widget, args)
                    local val =
                        args['{' .. interface .. ' ' .. value .. '_kb}'] or -1
                    widget:emit_signal_recursive('widget::value_changed', val)
                    return utils.markup {
                        font = utils.set_font_size(beautiful.font, 8),
                        fg_color = fg_color,
                        text = val .. 'kb'
                    }
                end
            }
        }
    }
end)

-- [ return module ] -----------------------------------------------------------
return module
