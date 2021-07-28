-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : cpu.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:20 (Marcel Arpogaus)
-- @Changed: 2021-07-28 15:15:51 (Marcel Arpogaus)
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

local default_timeout = 1

local default_fg_color = beautiful.fg_normal

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.cpu)

-- [ define widget ] -----------------------------------------------------------
module.init = widgets.new('wibar', function(warg)
    local color = warg.color or default_fg_color

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {widget = ''},
            widget = {
                wtype = vicious.widgets.cpu,
                format = function(_, args)
                    return utils.markup {
                        fg_color = color,
                        text = args[1] .. '%'
                    }
                end
            }
        }
    }
end)

-- [ return module ] -----------------------------------------------------------
return module
