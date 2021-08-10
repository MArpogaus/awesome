-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : volume.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:10 (Marcel Arpogaus)
-- @Changed: 2021-07-28 14:36:50 (Marcel Arpogaus)
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

local fa_vol_icons = {}
fa_vol_icons[0] = '' -- fa-volume-off
fa_vol_icons[1] = '' -- fa-volume-down
fa_vol_icons[2] = '' -- fa-volume-up

local default_timeout = 1

local default_fg_color = beautiful.fg_normal

local default_device = 'Master'

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.volume)

-- [ define widget ] -----------------------------------------------------------
module.init = widgets.new('wibar', function(_, warg)
    local color = warg.color or default_fg_color
    local device = warg.device or default_device

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {
                widget = utils.fa_ico(color, 'N/A'),
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local ico
                    if args[2] == '🔈' then
                        ico = fa_vol_icons[0]
                    else
                        ico =
                            fa_vol_icons[math.min(math.ceil(args[1] / 50), 2)]
                    end
                    return utils.fa_markup(color, ico)
                end
            },
            widget = {
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local vol
                    if args[2] == '🔈' then
                        vol = 'M'
                    else
                        vol = args[1] .. '%'
                    end
                    return utils.fa_markup(color, vol)
                end
            }
        }
    }
end)

-- [ return module ] -----------------------------------------------------------
return module
