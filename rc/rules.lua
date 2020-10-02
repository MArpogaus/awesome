--------------------------------------------------------------------------------
-- @File:   rules.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-10-02 14:35:08
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local awful = require('awful')

-- Theme handling library
local beautiful = require('beautiful')

-- mouse / key bindings
local buttons = require('rc.mouse_bindings')
local keys = require('rc.key_bindings')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local client_buttons = buttons.client_buttons
local client_keys = keys.client_keys

-- [ module objects ] ----------------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
module.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = client_keys,
            buttons = client_buttons,
            size_hints_honor = false, -- Remove gaps between terminals
            screen = awful.screen.preferred,
            callback = awful.client.setslave,
            placement = awful.placement.no_overlap +
                awful.placement.no_offscreen
        }
    }, -- Floating clients.
    {
        rule_any = {
            instance = {
                'DTA', -- Firefox addon DownThemAll.
                'copyq' -- Includes session name in class.
            },
            class = {
                'Arandr',
                'Gpick',
                'Kruler',
                'MessageWin', -- kalarm.
                'Sxiv',
                'Wpa_gui',
                'pinentry',
                'veromix',
                'xtightvncviewer',
                'Pavucontrol'
            },
            name = {
                'Event Tester' -- xev.
            },
            role = {
                'AlarmWindow', -- Thunderbird's calendar.
                'pop-up' -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true, intrusive = true}
    }, -- Add titlebars to normal clients and dialogs
    {
        rule_any = {type = {'normal', 'dialog'}},
        properties = {titlebars_enabled = true}
    },
    {
        rule_any = {class = {'Nextcloud'}},
        properties = {
            intrusive = true,
            floating = true,
            titlebars_enabled = false
        }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-- [ return module ] -----------------------------------------------------------
return module
