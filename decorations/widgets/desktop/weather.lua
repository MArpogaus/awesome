-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : weather.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:56:17 (Marcel Arpogaus)
-- @Changed: 2021-07-28 15:18:59 (Marcel Arpogaus)
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
local math = math

local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')
local vicious_contrib = require('vicious.contrib')

local utils = require('decorations.widgets.utils')
local widgets = require('decorations.widgets')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local default_timeout = 1800

local default_city_id = ''
local default_app_id = ''

-- [ local functions ] ---------------------------------------------------------
local function markup_color_size(size, color, text)
    return utils.markup {
        font = utils.set_font_size(beautiful.font, size),
        fg_color = color,
        text = text
    }
end

local function weather_widget_container(args)
    -- define widgets
    local font_size = args.font_size
    local color = args.color
    local spacing = args.spacing

    local weather_icon = args.weather_icon
    local weather_widget = args.weather_widget
    local weather_temp_min = args.weather_temp_min
    local weather_temp_max = args.weather_temp_max
    local weather_descr = args.weather_descr
    local weather_unit = wibox.widget.textbox(
        markup_color_size(font_size, color, '°C'))

    weather_widget.align = 'center'
    weather_descr.align = 'center'
    weather_unit.align = 'center'

    -- define widget layout
    local weather_box = wibox.widget {
        {
            nil,
            {
                weather_icon,
                {
                    {
                        weather_widget,
                        {
                            nil,
                            {
                                weather_temp_min,
                                weather_temp_max,
                                layout = wibox.layout.fixed.horizontal
                            },
                            nil,
                            expand = 'outside',
                            layout = wibox.layout.align.horizontal
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    weather_unit,
                    layout = wibox.layout.fixed.horizontal
                },
                spacing = 15,
                layout = wibox.layout.fixed.horizontal
            },
            nil,
            expand = 'outside',
            layout = wibox.layout.align.horizontal
        },
        weather_descr,
        spacing = spacing,
        layout = wibox.layout.fixed.vertical
    }

    -- return widget
    return wibox.widget {
        nil,
        {
            nil,
            weather_box,
            nil,
            expand = 'none',
            layout = wibox.layout.align.vertical
        },
        nil,
        expand = 'none',
        layout = wibox.layout.align.horizontal
    }
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious_contrib.openweather)

-- [ define widget ] -----------------------------------------------------------
module.init = widgets.new('desktop', function(_, warg)
    local city_id = warg.city_id or default_city_id
    local app_id = warg.app_id or default_app_id

    local font_size = beautiful.desktop_widgets_weather_font_size or 50

    local font_size_temp = 0.8 * font_size
    local font_size_range = 0.2 * font_size
    local font_size_descr = 0.3 * font_size

    return {
        default_timeout = default_timeout,
        widget_container = weather_widget_container,
        container_args = {
            font_size = font_size,
            color = beautiful.fg_desktop_widgets_weather,
            spacing = font_size_descr / 2
        },
        widgets = {
            weather_icon = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local weather = args['{weather}']
                    local sunrise = args['{sunrise}']
                    local sunset = args['{sunset}']

                    return utils.owf_markup(
                        beautiful.fg_desktop_widgets_weather, weather, sunrise,
                        sunset, font_size)
                end
            },
            weather_widget = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local temp = args['{temp c}']
                    return markup_color_size(font_size_temp,
                                             beautiful.fg_desktop_widgets_weather,
                                             temp)
                end
            },
            weather_temp_min = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local temp_min = math.floor(
                        tonumber(args['{temp min c}']) or 0)
                    return markup_color_size(font_size_range,
                                             beautiful.fg_desktop_widgets_weather,
                                             temp_min .. ' / ')
                end
            },
            weather_temp_max = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local temp_max = math.ceil(
                        tonumber(args['{temp max c}']) or 0)
                    return markup_color_size(font_size_range,
                                             beautiful.fg_desktop_widgets_weather,
                                             temp_max)
                end
            },
            weather_descr = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local weather = args['{weather}']
                    return markup_color_size(font_size_descr,
                                             beautiful.fg_desktop_widgets_weather,
                                             weather)
                end
            }
        }
    }
end)

-- [ return module ] -----------------------------------------------------------
return module
