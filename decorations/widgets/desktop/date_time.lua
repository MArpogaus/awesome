-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : date_time.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:28 (Marcel Arpogaus)
-- @Changed: 2021-08-10 09:07:38 (Marcel Arpogaus)
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
local os = os

local wibox = require('wibox')
local beautiful = require('beautiful')

local utils = require('decorations.widgets.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
os.setlocale(os.getenv('LANG')) -- to localize the clock

module.init = function(_)
    local time_font_size = beautiful.desktop_widgets_time_font_size or 50
    local date_font_size = beautiful.desktop_widgets_date_font_size or
                               time_font_size / 3
    local create_deskop_clock_box = function()
        local deskop_clock = wibox.widget.textclock(utils.markup {
            font = utils.set_font_size(beautiful.font, time_font_size),
            fg_color = beautiful.fg_desktop_widgets_clock_time or
                beautiful.fg_normal,
            text = '%H:%M'
        })
        return utils.create_boxed_widget(deskop_clock,
                                         beautiful.bg_desktop_widgets_clock or
                                             beautiful.bg_focus,
                                         time_font_size / 2, time_font_size,
                                         date_font_size * 1.5)
    end

    local create_desktop_widgets_clock_date = function()
        return wibox.widget.textclock(utils.markup {
            font = utils.set_font_size(beautiful.font, date_font_size),
            fg_color = beautiful.fg_desktop_widgets_clock or
                beautiful.fg_normal,
            text = 'Today is '
        } .. utils.markup {
            font = utils.set_font_size(beautiful.font, date_font_size),
            fg_color = beautiful.fg_desktop_widgets_clock_day or
                beautiful.fg_normal,
            text = '%A'
        } .. utils.markup {
            font = utils.set_font_size(beautiful.font, date_font_size),
            fg_color = beautiful.fg_desktop_widgets_clock or
                beautiful.fg_normal,
            text = ', the '
        } .. utils.markup {
            font = utils.set_font_size(beautiful.font, date_font_size),
            fg_color = beautiful.fg_desktop_widgets_clock_date or
                beautiful.fg_normal,
            text = '%d.'
        } .. utils.markup {
            font = utils.set_font_size(beautiful.font, date_font_size),
            fg_color = beautiful.fg_desktop_widgets_clock or
                beautiful.fg_normal,
            text = ' of '
        } .. utils.markup {
            font = utils.set_font_size(beautiful.font, date_font_size),
            fg_color = beautiful.fg_desktop_widgets_clock_month or
                beautiful.fg_normal,
            text = '%B'
        } .. utils.markup {
            font = utils.set_font_size(beautiful.font, date_font_size),
            fg_color = beautiful.fg_desktop_widgets_clock or
                beautiful.fg_normal,
            text = '.'
        })
    end

    return wibox.widget {
        nil,
        {

            {
                nil,
                create_deskop_clock_box(),
                nil,
                expand = 'outside',
                layout = wibox.layout.align.horizontal
            },
            create_desktop_widgets_clock_date(),
            layout = wibox.layout.fixed.vertical
        },
        nil,
        expand = 'outside',
        layout = wibox.layout.align.horizontal
    }
end

-- [ return module ] -----------------------------------------------------------
return module
