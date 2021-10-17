-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : assets.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-19 15:38:22 (Marcel Arpogaus)
-- @Changed: 2021-10-14 09:21:25 (Marcel Arpogaus)
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
local xresources = require('beautiful.xresources')

local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
local function get_colors()
    local xrdb = xresources.get_current_theme()
    local cs = {
        bg = xrdb.background,
        fg = xrdb.foreground,
        colors = {
            xrdb.color0, xrdb.color1, xrdb.color2, xrdb.color3, xrdb.color4,
            xrdb.color5, xrdb.color6, xrdb.color7, xrdb.color8, xrdb.color9,
            xrdb.color10, xrdb.color11, xrdb.color12, xrdb.color13,
            xrdb.color14, xrdb.color15
        }
    }
    local f = io.popen('xrdb -query', 'r')
    local color_pattern = '#[a-fA-F0-9]+'
    for l in f:lines() do
        if l:match('^*(color%d+)') then
            local idx = l:match('^*color(%d+)')
            idx = tonumber(idx + 1)
            cs.colors[idx] = l:match(color_pattern)
        elseif l:match('^*(foreground)') then
            cs.fg = l:match(color_pattern)
        elseif l:match('^*(background)') then
            cs.bg = l:match(color_pattern)
        end
    end
    f:close()
    return cs
end

-- [ module functions ] --------------------------------------------------------
module.init = function()
    local theme = beautiful.get()
    local cs = get_colors()

    -- set colors for buttons and widgets
    theme.titlebar_close_button_bg_focus = cs.colors[2]
    theme.titlebar_maximized_button_bg_focus = cs.colors[3]
    theme.titlebar_minimize_button_bg_focus = cs.colors[4]
    theme.titlebar_ontop_button_bg_focus = cs.colors[7]
    theme.titlebar_sticky_button_bg_focus = cs.colors[5]

    theme.titlebar_close_button_fg_focus =
        utils.reduce_contrast(theme.titlebar_close_button_bg_focus, 50)
    theme.titlebar_maximized_button_fg_focus =
        utils.reduce_contrast(theme.titlebar_maximized_button_bg_focus, 50)
    theme.titlebar_minimize_button_fg_focus =
        utils.reduce_contrast(theme.titlebar_minimize_button_bg_focus, 50)
    theme.titlebar_ontop_button_fg_focus =
        utils.reduce_contrast(theme.titlebar_ontop_button_bg_focus, 50)
    theme.titlebar_sticky_button_fg_focus =
        utils.reduce_contrast(theme.titlebar_sticky_button_bg_focus, 50)

    theme.fg_wibar_widgets = {
        cs.colors[2], cs.colors[3], cs.colors[4], cs.colors[10], cs.colors[6],
        cs.colors[5], cs.colors[7]
    }
    theme.fg_wibar_widgets_clock = cs.colors[4]
    theme.fg_wibar_widgets_calendar = cs.colors[16]

    theme.fg_desktop_widgets_arcs = theme.fg_wibar_widgets
    theme.fg_desktop_widgets_clock = theme.fg_normal
    theme.bg_desktop_widgets_clock = cs.colors[5]
    theme.fg_desktop_widgets_clock_time = theme.bg_normal
    theme.fg_desktop_widgets_clock_day = cs.colors[4]
    theme.fg_desktop_widgets_clock_date = cs.colors[2]
    theme.fg_desktop_widgets_clock_month = cs.colors[3]
    theme.fg_desktop_widgets_weather = theme.fg_normal
    return theme
end

-- [ return module ] -----------------------------------------------------------
return module
