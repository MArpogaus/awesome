--------------------------------------------------------------------------------
-- @File:   date_time.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-10-02 10:00:07
-- [ description ] -------------------------------------------------------------
-- date and time widgets
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local os = os

local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')

local utils = require('widgets.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
os.setlocale(os.getenv('LANG')) -- to localize the clock

module.create_wibar_widget = function()
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
        }
    )

    -- popup calendar
    local cal_widget = awful.widget.calendar_popup.month {
        font = utils.set_font_size(beautiful.font, 16),
        week_numbers = true,
        long_weekdays = true,
        opacity = 0.9,
        margin = 5,
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

module.create_desktop_widget = function()
    local time_font_size = beautiful.desktop_widgets_time_font_size or 50
    local date_font_size = beautiful.desktop_widgets_date_font_size or
                               time_font_size / 3
    local create_deskop_clock_box = function()
        local deskop_clock = wibox.widget.textclock(
            utils.markup {
                font = utils.set_font_size(beautiful.font, time_font_size),
                fg_color = beautiful.fg_desktop_widgets_clock_time or
                    beautiful.fg_normal,
                text = '%H:%M'
            }
        )
        return utils.create_boxed_widget(
            deskop_clock,
            beautiful.bg_desktop_widgets_clock or beautiful.bg_focus,
            time_font_size / 2, time_font_size, date_font_size * 1.5
        )
    end

    local create_desktop_widgets_clock_date =
        function()
            return wibox.widget.textclock(
                utils.markup {
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
                }
            )
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
