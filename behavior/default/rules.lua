-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : rules.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 15:57:16 (Marcel Arpogaus)
-- @Changed: 2021-10-14 20:17:46 (Marcel Arpogaus)
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
local beautiful = require('beautiful')
local awful = require('awful')

local key_bindings = require('key_bindings')
local mouse_bindings = require('mouse_bindings')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(_)
    local client_buttons = mouse_bindings.client_buttons
    local client_keys = key_bindings.client_keys
    return {
        -- All clients will match this rule.
        all = {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                size_hints_honor = false,
                keys = client_keys,
                buttons = client_buttons,
                screen = awful.screen.preferred,
                placement = awful.placement.center + awful.placement.no_overlap +
                    awful.placement.no_offscreen
            }
        },

        -- Floating clients.
        floating = {
            rule_any = {
                instance = {
                    'DTA', -- Firefox addon DownThemAll.
                    'copyq', -- Includes session name in class.
                    'pinentry'
                },
                class = {
                    'Arandr',
                    'Blueman-manager',
                    'Gpick',
                    'Kruler',
                    'MessageWin', -- kalarm.
                    'Sxiv',
                    'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
                    'Wpa_gui',
                    'veromix',
                    'xtightvncviewer'
                },

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name = {
                    'Event Tester' -- xev.
                },
                role = {
                    'AlarmWindow', -- Thunderbird's calendar.
                    'ConfigManager', -- Thunderbird's about:config.
                    'pop-up' -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
            properties = {floating = true}
        },

        -- Add titlebars to normal clients and dialogs
        titlebars = {
            rule_any = {type = {'normal', 'dialog'}},
            properties = {titlebars_enabled = true}
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return module
