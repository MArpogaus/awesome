-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : default.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-21 18:27:36 (Marcel Arpogaus)
-- @Changed: 2021-08-10 08:59:51 (Marcel Arpogaus)
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
local capi = {client = client}

local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local abstract_element = require('rc.decorations.abstract_element')

-- [ local functions ] ---------------------------------------------------------
local function client_menu_toggle_fn()
    local instance = nil
    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({theme = {width = 1000}})
        end
    end
end
-- ref.: https://stackoverflow.com/questions/62286322/grouping-windows-in-the-tasklist
local function client_label(c)
    local theme = beautiful.get()
    local sticky = theme.tasklist_sticky or '▪'
    local ontop = theme.tasklist_ontop or '⌃'
    local above = theme.tasklist_above or '▴'
    local below = theme.tasklist_below or '▾'
    local floating = theme.tasklist_floating or '✈'
    local minimized = theme.tasklist_maximized or '-'
    local maximized = theme.tasklist_maximized or '+'
    local maximized_horizontal = theme.tasklist_maximized_horizontal or '⬌'
    local maximized_vertical = theme.tasklist_maximized_vertical or '⬍'

    local name = c.name
    if c.sticky then name = sticky .. name end

    if c.ontop then
        name = ontop .. name
    elseif c.above then
        name = above .. name
    elseif c.below then
        name = below .. name
    end

    if c.minimized then name = minimized .. name end
    if c.maximized then
        name = maximized .. name
    else
        if c.maximized_horizontal then
            name = maximized_horizontal .. name
        end
        if c.maximized_vertical then name = maximized_vertical .. name end
        if c.floating then name = floating .. name end
    end

    return name
end

local function client_stack_toggle_fn()
    local cl_menu

    return function(c)
        if cl_menu then
            cl_menu:hide()
            cl_menu = nil
        else
            local client_num = 0
            local client_list = {}
            local t = awful.screen.focused().selected_tag
            for i, cl in ipairs(capi.client.get()) do
                if cl.class == c.class and gears.table.hasitem(cl:tags(), t) then
                    client_num = client_num + 1
                    client_list[i] = {
                        client_label(cl),
                        function()
                            capi.client.focus = cl
                            cl:tags()[1]:view_only()
                            cl:raise()
                        end,
                        cl.icon
                    }
                end
            end

            if client_num > 1 then
                cl_menu = awful.menu({
                    items = client_list,
                    theme = {width = 1000}
                })
                cl_menu:show()
            else
                c:emit_signal('request::activate', 'taskbar', {raise = true})
            end
        end
    end
end

-- [ local objects ] -----------------------------------------------------------
local module = {}
local tasklist_buttons = gears.table.join(
    awful.button({}, 1, client_stack_toggle_fn()),
    awful.button({}, 3, client_menu_toggle_fn()),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end))

-- [ module functions ] --------------------------------------------------------
module.init = function(s, _)
    return abstract_element.new {
        register_fn = function(_)
            local tasklist = awful.widget.tasklist {
                screen = s,
                filter = awful.widget.tasklist.filter.currenttags,
                buttons = tasklist_buttons,
                layout = {
                    spacing = beautiful.systray_icon_spacing,
                    layout = wibox.layout.fixed.horizontal
                },
                -- Notice that there is *NO* wibox.wibox prefix, it is a template,
                -- not a widget instance.
                widget_template = {
                    {
                        wibox.widget.base.make_widget(),
                        forced_height = 5,
                        id = 'clientstack',
                        widget = wibox.container.background
                    },
                    {
                        nil,
                        {id = 'clienticon', widget = awful.widget.clienticon},
                        nil,
                        expand = 'none',
                        id = 'clienticoncontainer',
                        widget = wibox.layout.align.horizontal
                    },
                    nil,
                    create_callback = function(self, c, index, objects) -- luacheck: no unused args
                        self:get_children_by_id('clienticon')[1].client = c
                    end,
                    update_callback = function(self, c, index, objects) -- luacheck: no unused args
                        if c.multiple_instances and c.multiple_instances > 1 then
                            self:get_children_by_id('clientstack')[1].bg =
                                beautiful.fg_normal
                        else
                            self:get_children_by_id('clientstack')[1].bg =
                                beautiful.bg_normal
                        end
                        if capi.client.focus and capi.client.focus.class ==
                            c.class then
                            self:get_children_by_id('clienticoncontainer')[1]
                                .opacity = 1
                        else
                            self:get_children_by_id('clienticoncontainer')[1]
                                .opacity = 0.5
                        end
                        self:emit_signal('widget::redraw_needed')
                    end,
                    layout = wibox.layout.align.vertical
                },
                source = function()
                    -- Get all clients
                    local cls = capi.client.get()

                    -- Filter by an existing filter function and allowing only one client per class
                    local clients = {}
                    local class_seen = {}
                    for _, c in pairs(cls) do
                        if awful.widget.tasklist.filter.currenttags(c, s) then
                            if not class_seen[c.class] then
                                class_seen[c.class] = 1
                                clients[c.class] = c
                            else
                                class_seen[c.class] = class_seen[c.class] + 1
                            end
                            clients[c.class].multiple_instances =
                                class_seen[c.class]
                        end
                    end
                    local ret = {}
                    for _, v in pairs(clients) do
                        table.insert(ret, v)
                    end
                    return ret
                end
            }
            return tasklist
        end,
        unregister_fn = function(_) end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
