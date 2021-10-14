-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : date_time.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:55:28 (Marcel Arpogaus)
-- @Changed: 2021-08-10 09:07:23 (Marcel Arpogaus)
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
local awful = require('awful')
local beautiful = require('beautiful')

local utils = require('decorations.widgets.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
os.setlocale(os.getenv('LANG')) -- to localize the clock

module.init = function(s, _)
    local clock_icon = utils.fa_ico(beautiful.fg_wibar_widgets_calendar, '')

    local clock_widget = wibox.widget.textclock(
        utils.markup {
            font = beautiful.font,
            fg_color = beautiful.fg_wibar_widgets_calendar,
            text = '%A %d %B'
        } .. utils.markup {
            font = beautiful.font,
            fg_color = beautiful.fg_normal,
            text = ' | '
        } .. utils.markup {
            font = beautiful.font,
            fg_color = beautiful.fg_wibar_widgets_clock,
            text = '%H:%M'
        })

    -- popup calendar
    local cal_widget = awful.widget.calendar_popup.month {
        font = utils.set_font_size(beautiful.font, 16),
        week_numbers = true,
        long_weekdays = true,
        opacity = 0.9,
        margin = 5,
        screen = s,
        style_header = {border_width = 0},
        style_weekday = {border_width = 0},
        style_weeknumber = {border_width = 0, opacity = 0.5},
        style_normal = {border_width = 0},
        style_focus = {border_width = 0}
    }
    cal_widget:attach(clock_widget, 'tr')

    beautiful.cal = cal_widget

    return utils.create_wibar_widget {
        color = beautiful.fg_wibar_widgets_calendar,
        icon = clock_icon,
        widget = clock_widget

    }
end

-- [ return module ] -----------------------------------------------------------
return module
