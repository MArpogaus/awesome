-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : tasklist.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-21 18:27:36 (Marcel Arpogaus)
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
local capi = {client = client}

local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.default = function(s, tasklist_buttons)
    local tasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }
    return tasklist
end

module.windows = function(s, tasklist_buttons)
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
                if capi.client.focus and capi.client.focus.class == c.class then
                    self:get_children_by_id('clienticoncontainer')[1].opacity =
                        1
                else
                    self:get_children_by_id('clienticoncontainer')[1].opacity =
                        0.5
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
                    clients[c.class].multiple_instances = class_seen[c.class]
                end
            end
            local ret = {}
            for _, v in pairs(clients) do table.insert(ret, v) end
            return ret
        end
    }
    return tasklist
end

-- [ return module ] -----------------------------------------------------------
return module

