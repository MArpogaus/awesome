-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:54:57 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
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
local string = string

local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local owfont = require('rc.widgets.utils.owfont')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.set_font_size = function(font, size)
    local font_name = font:match('[^%d]+')
    return string.format('%s %d', font_name, math.floor(size))
end
-- FontAwesome icons -----------------------------------------------------------
module.fa_markup = function(col, ico, size)
    local font_size = size or beautiful.font:match('[%d]+')
    local fa_font = 'FontAwesome ' .. font_size
    return module.markup {font = fa_font, fg_color = col, text = ico}
end

module.fa_ico = function(col, ico, size)
    return wibox.widget {
        markup = module.fa_markup(col, ico, size),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center'
    }
end

-- owfont icons ----------------------------------------------------------------
module.owf_markup = function(col, weather, sunrise, sunset, size)
    local loc_now = os.time() -- local time
    local icon
    if weather then
        weather = weather:lower()
        if type(sunrise, sunset) == 'number' and sunrise + sunrise > 0 then
            if sunrise <= loc_now and loc_now <= sunset then
                icon = owfont.day[weather] or 'N/A'
            else
                icon = owfont.night[weather] or 'N/A'
            end
        else
            icon = owfont.day[weather] or 'N/A'
        end
    else
        icon = 'N/A'
    end
    local font_size = size or beautiful.font:match('[%d]+')
    local owf_font = 'owf-regular ' .. font_size
    return module.markup {font = owf_font, fg_color = col, text = icon}
end
module.owf_ico = function(col, weather_now, size)
    return wibox.widget {
        markup = module.owf_markup(col, weather_now, size),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center'
    }
end

-- inspired by: https://github.com/elenapan/dotfiles/blob/master/config/awesome/noodle/start_screen.lua
-- Helper function that puts a widget inside a box with a specified background color
-- Invisible margins are added so that the boxes created with this function are evenly separated
-- The widget_to_be_boxed is vertically and horizontally centered inside the box
module.create_boxed_widget = function(
    widget_to_be_boxed,
    bg_color,
    radius,
    inner_margin,
    outer_margin
)
    radius = radius or 15
    inner_margin = inner_margin or 30
    outer_margin = outer_margin or 30
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.shape = function(c, h, w)
        gears.shape.rounded_rect(c, h, w, radius)
    end

    local boxed_widget = wibox.widget {
        {
            {
                widget_to_be_boxed,
                margins = inner_margin,
                widget = wibox.container.margin
            },
            widget = box_container
        },
        bottom = outer_margin,
        widget = wibox.container.margin
    }

    return boxed_widget
end

module.create_wibar_widget = function(args)
    local icon_widget
    if type(args.icon) == 'table' then
        icon_widget = args.icon
    else
        icon_widget = module.fa_ico(args.color, args.icon)
    end
    local wibox_widget = wibox.widget {
        {
            -- add margins
            icon_widget,
            left = beautiful.wibar_widget_spacing or 12,
            right = 0.8 * (beautiful.wibar_widget_spacing or 12),
            color = '#FF000000',
            widget = wibox.container.margin
        },
        args.widget,
        layout = wibox.layout.fixed.horizontal,
        expand = 'none'
    }
    return wibox_widget
end

module.create_arc_icon = function(fg, icon, size)
    return module.fa_ico(fg, icon, math.floor(size / 8))
end

module.create_arc_widget = function(args)
    local icon = args.icon
    local widget = args.widget
    local bg = args.bg
    local fg = args.fg
    local min = args.min or 0
    local max = args.max or 100
    local size = args.size or beautiful.desktop_widgets_arc_size or 220
    local thickness = args.thickness or math.sqrt(size)

    local icon_widget
    if type(icon) == 'table' then
        icon_widget = icon
    else
        icon_widget = module.create_arc_icon(fg, icon, size)
    end
    widget.align = 'center'
    local arc_container = wibox.widget {
        {
            nil,
            {
                nil,
                {
                    nil,
                    icon_widget,
                    widget,
                    expand = 'outside',
                    layout = wibox.layout.align.vertical
                },
                nil,
                expand = 'inside',
                layout = wibox.layout.align.vertical
            },
            nil,
            expand = 'outside',
            layout = wibox.layout.align.horizontal
        },
        bg = bg,
        colors = {fg},
        min_value = min,
        max_value = max,
        value = 0,
        thickness = thickness,
        forced_width = size,
        forced_height = size,
        start_angle = 0,
        widget = wibox.container.arcchart
    }
    arc_container:connect_signal('widget::value_changed', function(_, usage)
        arc_container.value = usage
    end)
    return arc_container
end

module.markup = function(args)
    local style = ''
    local font, fg_color, text = args.font, args.fg_color, args.text
    if font then style = style .. string.format(' font=\'%s\'', font) end
    if fg_color then
        style = style .. string.format(' foreground=\'%s\'', fg_color)
    end
    return string.format('<span %s>%s</span>', style, text)
end

-- [ return module ] -----------------------------------------------------------
return module
