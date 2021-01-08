--------------------------------------------------------------------------------
-- @File:   rules.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-10-19 17:04:27
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local capi = {screen = screen}

-- Standard awesome library
local awful = require('awful')

-- Theme handling library
local beautiful = require('beautiful')

-- mouse / key bindings
local buttons = require('rc.mouse_bindings')
local keys = require('rc.key_bindings')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local clientbuttons = buttons.client_buttons
local clientkeys = keys.client_keys

-- [ module objects ] ----------------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
module.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            size_hints_honor = false, -- Remove gaps between terminals
            screen = awful.screen.preferred,
            placement = awful.placement.center + awful.placement.no_overlap +
                awful.placement.no_offscreen,
            switchtotag = true,
            titlebars_enabled = false,
            requests_no_titlebar = false
        }
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry"
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester" -- xev.
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    },
    -- Add titlebars to normal clients and dialogs
    {rule_any = {type = {"dialog"}}, properties = {titlebars_enabled = true}},
    {
        rule = {name = 'doom-capture'},
        properties = {
            tag = awful.screen.focused().selected_tags[0],
            requests_no_titlebars = true,
            titlebars_enabled = false,
            floating = true,
            ontop = true,
            placement = awful.placement.top,
            -- maximized_horizontal = true,
        }
    },
    {
        rule_any = {class = {'firefox', 'tor browser', 'Chromium'}},
        properties = {
            new_tag = {
                name = '',
                volatile = true,
                layout = awful.layout.suit.max
            }
        }
    },
    {
        rule_any = {class = {'Thunderbird'}},
        properties = {
            new_tag = {
                name = '',
                volatile = true,
                layout = awful.layout.suit.magnifier,
                master_width_factor = 0.8
            },
            screen = capi.screen.count() > 1 and 2 or 1
        }
    },
    {
        rule_any = {class = {'zoom', 'Franz', 'Pidgin'}},
        properties = {
            new_tag = {
                name = '',
                volatile = true,
                layout = awful.layout.suit.tile.left,
                master_width_factor = 0.8
            },
            screen = capi.screen.count() > 1 and 2 or 1
        }
    },
    {
        rule_any = {class = {'Thunar'}},
        properties = {
            new_tag = {
                name = '',
                volatile = true,
                layout = awful.layout.suit.tile
            }
        }
    },
    {
        rule_any = {
            class = {
                'Sublime_text',
                'Sublime_merge',
                'lxterminal',
                "xterm",
                "urxvt",
                "aterm",
                "urxvt",
                "Emacs"
            }
        },
        except = {name = 'doom-capture'},
        properties = {
            new_tag = {
                name = '',
                volatile = true,
                layout = awful.layout.suit.tile.bottom,
                master_width_factor = 0.8
            }
        }
    },
    {
        rule_any = {class = {'Evince', 'Zathura'}},
        properties = {
            new_tag = {
                name = '',
                volatile = true,
                layout = awful.layout.suit.max
            },
            screen = capi.screen.count() > 1 and 2 or 1
        }
    },
    {
        rule_any = {class = {'Mpv', 'Vlc', 'Gpodder', 'Ristretto'}},
        properties = {
            new_tag = {
                name = '',
                volatile = true,
                layout = awful.layout.suit.fair
            }
        }
    },
    {
        rule_any = {class = {'0ad', 'supertuxkart', 'xonotic', 'hedgewars'}},
        properties = {
            new_tag = {
                name = '',
                volatile = true,
                layout = awful.layout.suit.fair
            }
        }
    }
}

-- [ return module ] -----------------------------------------------------------
return module
