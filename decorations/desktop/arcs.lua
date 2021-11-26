-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : desktop.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 08:48:11 (Marcel Arpogaus)
-- @Changed: 2021-11-26 10:06:34 (Marcel Arpogaus)
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
local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')

local utils = require('utils')

local abstract_decoration = require('decorations.abstract_decoration')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local desktop_popups = setmetatable({}, {__mode = 'k'}) -- make keys weak

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {
    widgets = {'cpu', 'memory', 'fs', 'volume'},
    widgets_args = {},
    visible = true
}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    config = utils.deep_merge(module.defaults, config or {}, 0)
    local arc_widgets = config.widgets
    local widgets_args = config.widgets_args

    local desktop_widgets_active = config.visible

    local decoration = abstract_decoration.new {
        register_fn = function(s)
            -- Create the desktop widget popup
            local arc_widget_containers =
                {
                    spacing = beautiful.desktop_widgets_arc_spacing or 110,
                    layout = wibox.layout.fixed.horizontal
                }
            local fg_arcs
            if beautiful.fg_desktop_widgets_arcs and
                #beautiful.fg_desktop_widgets_arcs then
                fg_arcs = beautiful.fg_desktop_widgets_arcs
            else
                fg_arcs = {beautiful.fg_normal}
            end
            local midx = #fg_arcs
            for i, w in pairs(arc_widgets) do
                local cidx = (i - 1) % midx + 1
                local color = fg_arcs[cidx]
                local fg_color = utils.reduce_contrast(color, 10)
                local bg_color = utils.set_alpha(fg_color, 50)
                local warg = widgets_args[w] or
                                 widgets_args[gears.string.split(w, '_')[1]] or
                                 {}
                warg = gears.table.clone(warg)
                warg.fg_color = warg.fg_color or fg_color
                warg.bg_color = warg.bg_color or bg_color
                local widget_container =
                    require('decorations.widgets.arcs.' .. w).init(s, warg)
                table.insert(arc_widget_containers, widget_container)
            end
            local desktop_widgets_clock_container =
                require('decorations.widgets.desktop.date_time').init()
            local desktop_widgets_weather_container =
                require('decorations.widgets.desktop.weather').init(s,
                                                                    widgets_args.weather)

            local desktop_widgets_vertical_spacing =
                beautiful.desktop_widgets_vertical_spacing or 170
            local desktop_popup_widget =
                wibox.widget {
                    {
                        -- Align widgets vertically
                        arc_widget_containers,
                        {
                            desktop_widgets_clock_container,
                            widget = wibox.container.margin,
                            top = desktop_widgets_vertical_spacing,
                            bottom = desktop_widgets_vertical_spacing
                        },
                        desktop_widgets_weather_container,
                        layout = wibox.layout.align.vertical
                    },
                    widget = wibox.container.margin,
                    margins = desktop_widgets_vertical_spacing / 2
                }
            if desktop_popups[s] == nil then
                local desktop_popup_arg =
                    {
                        widget = desktop_popup_widget,
                        type = 'desktop',
                        screen = s,
                        placement = awful.placement.centered,
                        input_passthrough = true,
                        visible = false
                    }

                desktop_popups[s] = awful.popup(desktop_popup_arg)
            else
                desktop_popups[s]:set_widget(desktop_popup_widget)
                desktop_popups[s].bg = beautiful.bg_normal
            end
            desktop_popups[s].arc_widgets =
                setmetatable({}, {
                    __index = function(_, fn)
                        return function()
                            for _, w in ipairs(arc_widget_containers) do
                                w[fn]()
                            end
                        end
                    end
                })
            desktop_popups[s].weather_widget =
                desktop_widgets_weather_container
            desktop_popups[s]:connect_signal('property::visible', function()
                if desktop_popups[s].visible then
                    desktop_popups[s].arc_widgets.activate()
                    desktop_popups[s].weather_widget.activate()
                else
                    desktop_popups[s].arc_widgets.suspend()
                    desktop_popups[s].weather_widget.suspend()
                end
            end)

            desktop_popups[s].visible = desktop_widgets_active
        end,
        unregister_fn = function(s)
            local popup = desktop_popups[s]
            popup.visible = false
            popup.arc_widgets.unregister()
            popup.arc_widgets = nil
            popup.weather_widget.unregister()
            popup.weather_widget = nil
            popup:get_widget():reset()
            popup:set_widget(nil)
            desktop_popups[s] = nil
            collectgarbage()
        end,
        update_fn = function(s)
            local popup = desktop_popups[s]
            popup.arc_widgets.update()
            popup.weather_widget.update()
        end,
        toggle = function(s)
            local popup = desktop_popups[s]
            popup.visible = not popup.visible
        end
    }
    decoration.toggle_widgets = decoration.toggle
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
