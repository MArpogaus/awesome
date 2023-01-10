-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:52:44 (Marcel Arpogaus)
-- @Changed: 2022-03-14 14:41:19 (Marcel Arpogaus)
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
local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {
    keymaps = {'default'},
    bind_numbers_to_tags = true,
    modkey = 'Mod4',
    altkey = 'Mod1'
}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, cfg)
    self.config = utils.deep_merge(self.defaults, cfg or {}, 0)
    local keys = {}
    local actions = {}
    for binding, bind_cfg in utils.value_with_cfg(self.config.keymaps, true) do
        keys = utils.deep_merge(keys,
                                require(
                                    utils.get_pkg_name('key_bindings.',
                                                       binding, '.keys')).init(
            self.config, bind_cfg))
        actions = utils.deep_merge(actions,
                                   require(
                                       utils.get_pkg_name('key_bindings.',
                                                          binding, '.actions')).init(
            self.config, bind_cfg))
    end

    for level, level_keys in pairs(actions) do
        local key_tables = {}
        for group, group_actions in pairs(level_keys) do
            for desc, action in pairs(group_actions) do
                key = keys[level][group][desc]
                table.insert(key_tables, awful.key(key[1], key[2], action, {
                    description = desc,
                    group = group
                }))
            end
        end
        module[level .. '_keys'] = gears.table.join(table.unpack(key_tables))
    end

    if self.config.bind_numbers_to_tags then
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
            self.global_keys = gears.table
                                   .join(self.global_keys, -- View tag only.
            awful.key({self.config.modkey}, '#' .. i + 9, function()
                local s = awful.screen.focused()
                local tag = s.tags[i]
                if tag then tag:view_only() end
            end, descr_view),
                                         awful.key(
                {self.config.modkey, 'Control'}, '#' .. i + 9, function()
                    local s = awful.screen.focused()
                    local tag = s.tags[i]
                    if tag then awful.tag.viewtoggle(tag) end
                end, descr_toggle),
                                         awful.key(
                {self.config.modkey, 'Shift'}, '#' .. i + 9, function()
                    if capi.client.focus then
                        local tag = capi.client.focus.screen.tags[i]
                        if tag then
                            capi.client.focus:move_to_tag(tag)
                        end
                    end
                end, descr_move),
                                         awful.key(
                {self.config.modkey, 'Control', 'Shift'}, '#' .. i + 9,
                function()
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
    capi.root.keys(self.global_keys)
end
module.reset = function(self)
    self.global_keys = nil
    self.client_keys = nil
    self.config = nil
    capi.root.keys({})
end

-- [ return module ] -----------------------------------------------------------
return module
