-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : desktop.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 08:48:11 (Marcel Arpogaus)
-- @Changed: 2021-08-18 17:46:29 (Marcel Arpogaus)
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

local vicious = require('vicious')

local utils = require('rc.utils')

local abstract_decoration = require('rc.decorations.abstract_decoration')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config, widgets_args)
    local arc_widgets = config.widgets or {'cpu', 'memory', 'fs', 'volume'}
    local registered_desktop_widgets = setmetatable({}, {__mode = 'kv'}) -- make weak table
    local desktop_widget_containers

    -- show hide desktop_popup
    local desktop_widgets_active = config.visible or true

    local decoration = abstract_decoration.new {
        register_fn = function(s)
            if config.screens and
                not gears.table.hasitem(config.screens, s.index) then
                return
            end

            -- Create the desktop widget popup
            local arc_widget_containers =
                {
                    spacing = beautiful.desktop_widgets_arc_spacing or 110,
                    layout = wibox.layout.fixed.horizontal
                }
            setmetatable(arc_widget_containers, {__mode = 'kv'})
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
                local widget_container, registered_widgets =
                    utils.require_submodule('decorations/widgets/arcs', w)
                        .init(s, warg)
                table.insert(arc_widget_containers, widget_container)
                registered_desktop_widgets =
                    gears.table.join(registered_desktop_widgets,
                                     registered_widgets)
            end
            local desktop_widgets_clock_container,
                desktop_widgets_clock_widgets =
                utils.require_submodule('decorations/widgets/desktop',
                                        'date_time').init()
            local desktop_widgets_weather_container,
                desktop_widgets_weather_widgets =
                utils.require_submodule('decorations/widgets/desktop',
                                        'weather')
                    .init(s, widgets_args.weather)

            registered_desktop_widgets =
                gears.table.join(registered_desktop_widgets,
                                 desktop_widgets_weather_widgets,
                                 desktop_widgets_clock_widgets)
            desktop_widget_containers =
                gears.table.join(arc_widget_containers,
                                 desktop_widgets_weather_container,
                                 desktop_widgets_clock_container)
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
            local desktop_popup_arg = {
                widget = desktop_popup_widget,
                type = 'desktop',
                screen = s,
                placement = awful.placement.centered,
                input_passthrough = true
            }
            if config.wallpaper then
                desktop_popup_arg.border_color = beautiful.border_normal
                desktop_popup_arg.border_width = beautiful.border_width
                desktop_popup_arg.bg = utils.set_alpha(beautiful.bg_normal, 75)
            end

            s.desktop_popup = awful.popup(desktop_popup_arg)
            s.desktop_popup:connect_signal('property::visible', function()
                if s.desktop_popup.visible then
                    s.desktop_widgets_activate()
                else
                    s.desktop_widgets_suspend()
                end
            end)

            s.desktop_widgets_suspend =
                function()
                    for _, w in ipairs(registered_desktop_widgets) do
                        vicious.unregister(w, true)
                    end
                end
            s.desktop_widgets_activate =
                function()
                    for _, w in ipairs(registered_desktop_widgets) do
                        vicious.activate(w)
                    end
                end
            s.desktop_widgets_set_state =
                function(state)
                    s.desktop_popup.visible = state
                    -- keep new screens synchronized
                    desktop_widgets_active = state
                end
            s.desktop_widgets_toggle = function()
                s.desktop_widgets_set_state(not s.desktop_popup.visible)
            end
            s.desktop_widgets_set_state(desktop_widgets_active)
        end,
        unregister_fn = function(s)
            s.desktop_popup.visible = false
            for i, w in ipairs(registered_desktop_widgets) do
                vicious.unregister(w)
                table.remove(registered_desktop_widgets, i)
            end
            registered_desktop_widgets = nil
            for i, c in ipairs(desktop_widget_containers) do
                c:reset()
                table.remove(desktop_widget_containers, i)
            end
            desktop_widget_containers = nil
            s.desktop_popup:get_widget():reset()
            s.desktop_popup = nil
            s.desktop_widgets_set_state = nil
            s.desktop_widgets_toggle = nil
            s.desktop_widgets_suspend = nil
            s.desktop_widgets_activate = nil
        end,
        update_fn = function(_)
            vicious.force(registered_desktop_widgets)
        end
    }
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
