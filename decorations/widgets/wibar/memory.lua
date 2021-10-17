-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : memory.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:58 (Marcel Arpogaus)
-- @Changed: 2021-07-28 14:29:05 (Marcel Arpogaus)
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

local utils = require('decorations.widgets.utils')
local widgets = require('decorations.widgets')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local mem_icon = ''

local default_timeout = 7

local default_fg_color = beautiful.fg_normal

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.mem)

-- [ define widget ] -----------------------------------------------------------
module.init = widgets.new('wibar', function(_, warg)
    local color = warg.color or default_fg_color

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {widget = mem_icon},
            widget = {
                wtype = vicious.widgets.mem,
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
