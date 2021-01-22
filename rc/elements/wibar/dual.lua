-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-01-22 11:50:41 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')

local wibar_widgets = require('rc.widgets.wibar')
local abstract_element = require('rc.elements.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local element = abstract_element.new {
        register_fn = function(s)
            s.mytopwibar = awful.wibar(
                {
                    position = 'top',
                    screen = s,
                    height = beautiful.top_bar_height,
                    bg = beautiful.bg_normal,
                    fg = beautiful.fg_normal
                }
            )

            -- Add widgets to the wibox
            local myexitmenu = nil
            if s.myexitmenu then
                myexitmenu = {
                    -- add margins
                    s.myexitmenu,
                    left = beautiful.wibar_widgets_spacing or 12,
                    widget = wibox.container.margin
                }
            end

            s.wibar_widget_containers = {layout = wibox.layout.fixed.horizontal}
            s.registered_wibar_widgets = {}
            local fg_wibar_widgets
            if beautiful.fg_wibar_widgets and #beautiful.fg_wibar_widgets then
                fg_wibar_widgets = beautiful.fg_wibar_widgets
            else
                fg_wibar_widgets = {beautiful.fg_normal}
            end
            local midx = #fg_wibar_widgets
            for i, w in pairs(config.wibar_widgets) do
                local cidx = (i - 1) % midx + 1
                local warg = config.widgets_arg[w] or
                                 config.widgets_arg[gears.string.split(w, '_')[1]] or
                                 {}
                warg = gears.table.clone(warg)
                warg.color = warg.color or fg_wibar_widgets[cidx]
                local widget_container, registered_widgets =
                    wibar_widgets[w](warg)
                table.insert(s.wibar_widget_containers, widget_container)
                s.registered_wibar_widgets =
                    gears.table.join(
                        s.registered_wibar_widgets, registered_widgets
                    )
            end
            table.insert(s.wibar_widget_containers, myexitmenu)

            s.mytopwibar:setup{
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    -- s.mylayoutbox,
                    s.mytaglist,
                    s.mypromptbox
                },
                -- Middle widgets
                nil,
                -- Right widgets
                s.wibar_widget_containers
            }

            -- Create the bottom wibox
            s.mybottomwibar = awful.wibar(
                {
                    position = 'bottom',
                    screen = s,
                    height = beautiful.bottom_bar_height,
                    bg = beautiful.bg_normal,
                    fg = beautiful.fg_normal
                }
            )

            -- Add widgets to the bottom wibox
            s.systray = wibox.widget.systray()
            s.mybottomwibar:setup{
                layout = wibox.layout.align.horizontal,
                { -- Left widgets
                    layout = wibox.layout.fixed.horizontal
                },
                s.mytasklist, -- Middle widget
                { -- Right widgets
                    s.systray,
                    awful.widget.keyboardlayout(),
                    s.mylayoutbox,
                    spacing = beautiful.icon_margin_left,
                    layout = wibox.layout.fixed.horizontal
                }
            }

            s.systray_set_screen = function()
                if s.systray then s.systray:set_screen(s) end
            end
            s.mybottomwibar:connect_signal('mouse::enter', s.systray_set_screen)

            s.set_wibar_widget_opacity =
                function(opacity)
                    for _, w in ipairs(s.wibar_widget_containers) do
                        if w.has_registered_widgets then
                            w.opacity = opacity
                            w:emit_signal('widget::redraw_needed')
                        end
                    end
                end
            s.suspend_wibar_widgets = function()
                for _, w in ipairs(s.registered_wibar_widgets) do
                    vicious.unregister(w, true)
                    s.set_wibar_widget_opacity(0.5)
                end
            end
            s.activate_wibar_widgets = function()
                for _, w in ipairs(s.registered_wibar_widgets) do
                    vicious.activate(w)
                    s.set_wibar_widget_opacity(1)
                end
            end
        end,
        unregister_fn = function(s)
            for _, w in ipairs(s.registered_wibar_widgets) do
                vicious.unregister(w)
            end
            s.registered_wibar_widgets = nil

            s.mytopwibar.widget:reset()
            s.mytopwibar:remove()
            s.mytopwibar = nil

            s.mybottomwibar.widget:reset()
            s.mybottomwibar:remove()
            s.mybottomwibar = nil
        end,
        update_fn = function(s) vicious.force(s.registered_wibar_widgets) end
    }
    return element
end

-- [ sequential code ] ---------------------------------------------------------

-- [ return module ] -----------------------------------------------------------
return module
