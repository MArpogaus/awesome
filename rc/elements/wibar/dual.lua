-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-01-23 20:30:11 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

local abstract_element = require('rc.elements.abstract_element')
local utils = require('rc.elements.wibar.utils')

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
            s.right_widget_container = utils.gen_wibar_widgets(s, config)
            s.right_widget_container.layout = wibox.layout.fixed.horizontal
            if s.myexitmenu then
                local myexitmenu = {
                    -- add margins
                    s.myexitmenu,
                    left = beautiful.wibar_widgets_spacing or 12,
                    widget = wibox.container.margin
                }
                table.insert(s.right_widget_container, myexitmenu)
            end

            s.left_widget_container = {}
            if s.mymainmenu then
                local mymainmenu = {
                    -- add margins
                    s.mymainmenu,
                    right = beautiful.wibar_widgets_spacing or 12,
                    widget = wibox.container.margin
                }
                table.insert(s.left_widget_container, mymainmenu)
            end
            table.insert(s.left_widget_container, s.mytaglist)
            table.insert(s.left_widget_container, s.mypromptbox)
            s.left_widget_container.layout = wibox.layout.fixed.horizontal

            s.mytopwibar:setup{
                layout = wibox.layout.align.horizontal,
                s.left_widget_container, -- Left widgets
                nil, -- Middle widget
                s.right_widget_container -- Right widgets
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
                if s.systray then
                    s.systray:set_screen(s)
                end
            end
            s.mybottomwibar:connect_signal('mouse::enter', s.systray_set_screen)

        end,
        unregister_fn = function(s)
            utils.unregister_wibar_widgtes(s)

            s.mytopwibar.widget:reset()
            s.mytopwibar:remove()
            s.mytopwibar = nil

            s.mybottomwibar.widget:reset()
            s.mybottomwibar:remove()
            s.mybottomwibar = nil
        end,
        update_fn = function(s)
            utils.update_wibar_widgets(s)
        end
    }
    return element
end

-- [ sequential code ] ---------------------------------------------------------

-- [ return module ] -----------------------------------------------------------
return module
