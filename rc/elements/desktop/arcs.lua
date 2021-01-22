-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : desktop.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 08:48:11 (Marcel Arpogaus)
-- @Changed: 2021-01-22 19:37:25 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')

local vicious = require('vicious')

local utils = require('rc.utils')

local abstract_element = require('rc.elements.abstract_element')

-- custom wibox widgets
local desktop_widgets = require('rc.widgets.desktop')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local element = abstract_element.new {
        register_fn = function(s)
            -- Create the desktop widget popup
            local arc_widget_containers =
                {
                    spacing = beautiful.desktop_widgets_arc_spacing or 110,
                    layout = wibox.layout.fixed.horizontal
                }
            s.registered_desktop_widgets = {}
            local fg_arcs
            if beautiful.fg_desktop_widgets_arcs and
                #beautiful.fg_desktop_widgets_arcs then
                fg_arcs = beautiful.fg_desktop_widgets_arcs
            else
                fg_arcs = {beautiful.fg_normal}
            end
            local midx = #fg_arcs
            for i, w in pairs(config.arc_widgets) do
                local cidx = (i - 1) % midx + 1
                local color = fg_arcs[cidx]
                local fg_color = utils.reduce_contrast(color, 10)
                local bg_color = utils.set_alpha(fg_color, 50)
                local warg = config.widgets_arg[w] or
                                 config.widgets_arg[gears.string.split(w, '_')[1]] or
                                 {}
                warg = gears.table.clone(warg)
                warg.fg_color = warg.fg_color or fg_color
                warg.bg_color = warg.bg_color or bg_color
                local widget_container, registered_widgets =
                    desktop_widgets.arcs[w](warg)
                table.insert(arc_widget_containers, widget_container)
                s.registered_desktop_widgets =
                    gears.table.join(
                        s.registered_desktop_widgets, registered_widgets
                    )
            end
            local desktop_widgets_clock_container, desktop_widgets_clock_widgets =
                desktop_widgets.clock()
            local desktop_widgets_weather_container,
                desktop_widgets_weather_widgets =
                desktop_widgets.weather(s, config.widgets_arg.weather)

            s.registered_desktop_widgets =
                gears.table.join(
                    s.registered_desktop_widgets,
                    desktop_widgets_weather_widgets,
                    desktop_widgets_clock_widgets
                )
            s.desktop_widget_containers =
                gears.table.join(
                    arc_widget_containers, desktop_widgets_weather_container,
                    desktop_widgets_clock_container
                )
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
                visible = false,
                input_passthrough = true
            }
            if config.wallpaper then
                desktop_popup_arg.border_color = beautiful.border_normal
                desktop_popup_arg.border_width = beautiful.border_width
                desktop_popup_arg.bg = utils.set_alpha(beautiful.bg_normal, 75)
            end

            s.desktop_popup = awful.popup(desktop_popup_arg)
            s.desktop_popup:connect_signal(
                'property::visible', function()
                    if s.desktop_popup.visible then
                        s.activate_desktop_widgets()
                    else
                        s.suspend_desktop_widgets()
                    end
                end
            )
            s.toggle_desktop_widget_visibility =
                function()
                    local is_visible = s.desktop_popup.visible
                    s.desktop_popup.visible = not is_visible
                end
            s.suspend_desktop_widgets = function()
                for _, w in ipairs(s.registered_desktop_widgets) do
                    vicious.unregister(w, true)
                end
            end
            s.activate_desktop_widgets =
                function()
                    for _, w in ipairs(s.registered_desktop_widgets) do
                        vicious.activate(w)
                    end
                end
            -- show hide desktop_popup
            s.desktop_popup.visible = config.desktop_widgets_visible or true
        end,
        unregister_fn = function(s)
            for _, w in ipairs(s.registered_desktop_widgets) do
                vicious.unregister(w)
            end
            s.registered_desktop_widgets = nil
            s.desktop_popup.widget:reset()
            s.desktop_popup = nil
        end,
        update_fn = function(s)
            vicious.force(s.registered_desktop_widgets)
        end
    }
    return element
end

-- [ return module ] -----------------------------------------------------------
return module
