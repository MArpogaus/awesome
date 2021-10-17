-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : weather.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:17 (Marcel Arpogaus)
-- @Changed: 2021-07-28 14:37:56 (Marcel Arpogaus)
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
local vicious_contrib = require('vicious.contrib')

local utils = require('decorations.widgets.utils')
local widgets = require('decorations.widgets')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local default_timeout = 1800

local default_color = beautiful.fg_normal

local default_city_id = ''
local default_app_id = ''

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious_contrib.openweather)

-- [ define widget ] -----------------------------------------------------------
module.init = widgets.new('wibar', function(_, warg)
    local color = warg.color or default_color
    local city_id = warg.city_id or default_city_id
    local app_id = warg.app_id or default_app_id

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {
                widget = utils.owf_ico(color),
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local weather = args['{weather}']
                    local sunrise = args['{sunrise}']
                    local sunset = args['{sunset}']

                    return utils.owf_markup(color, weather, sunrise, sunset)
                end
            },
            widget = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    return utils.markup {
                        fg_color = color,
                        text = args['{temp c}'] .. '°C'
                    }
                end
            }
        }
    }
end)

-- [ return module ] -----------------------------------------------------------
return module
