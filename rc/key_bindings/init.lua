-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:52:44 (Marcel Arpogaus)
-- @Changed: 2021-07-19 07:57:05 (Marcel Arpogaus)
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
-- grab environment
local capi = {root = root, client = client}

local awful = require('awful')
local gears = require('gears')

-- helper functions
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config, applications, mainmenu)
    local keys = {}
    local actions = {}
    for _, binding in ipairs(config.keymaps) do
        keys = utils.deep_merge(keys, utils.require_submodule('key_bindings',
                                                              binding ..
                                                                  '/keys')
                                    .init(config))
        actions = utils.deep_merge(actions,
                                   utils.require_submodule('key_bindings',
                                                           binding ..
                                                               '/actions')
                                       .init(applications, mainmenu))
    end

    for level, level_keys in pairs(keys) do
        local key_tables = {}
        for group, group_keys in pairs(level_keys) do
            for desc, key in pairs(group_keys) do
                table.insert(key_tables,
                             awful.key(key[1], key[2],
                                       actions[level][group][desc],
                                       {description = desc, group = group}))
            end
        end
        module[level .. '_keys'] = gears.table.join(table.unpack(key_tables))
    end

    if config.bind_numbers_to_tags then
        -- Bind all key numbers to tags.
        -- Be careful: we use keycodes to make it works on any keyboard layout.
        -- This should map on the top row of your keyboard, usually 1 to 9.
        for i = 1, 9 do
            -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
            local descr_view, descr_toggle, descr_move, descr_toggle_focus
            if i == 1 or i == 9 then
                descr_view = {description = 'view tag #', group = 'tag'}
                descr_toggle = {description = 'toggle tag #', group = 'tag'}
                descr_move = {
                    description = 'move focused client to tag #',
                    group = 'tag'
                }
                descr_toggle_focus = {
                    description = 'toggle focused client on tag #',
                    group = 'tag'
                }
            end
            module.global_keys = gears.table
                                     .join(module.global_keys, -- View tag only.
                                           awful.key({config.modkey},
                                                     '#' .. i + 9, function()
                local s = awful.screen.focused()
                local tag = s.tags[i]
                if tag then tag:view_only() end
            end, descr_view),
                                           awful.key(
                {config.modkey, 'Control'}, '#' .. i + 9, function()
                    local s = awful.screen.focused()
                    local tag = s.tags[i]
                    if tag then awful.tag.viewtoggle(tag) end
                end, descr_toggle),
                                           awful.key({config.modkey, 'Shift'},
                                                     '#' .. i + 9, function()
                if capi.client.focus then
                    local tag = capi.client.focus.screen.tags[i]
                    if tag then
                        capi.client.focus:move_to_tag(tag)
                    end
                end
            end, descr_move),
                                           awful.key(
                {config.modkey, 'Control', 'Shift'}, '#' .. i + 9, function()
                    if capi.client.focus then
                        local tag = capi.client.focus.screen.tags[i]
                        if tag then
                            capi.client.focus:toggle_tag(tag)
                        end
                    end
                end, descr_toggle_focus))
        end
    end

    -- register global key bindings
    capi.root.keys(module.global_keys)
end

-- [ return module ] -----------------------------------------------------------
return module
