-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:53:28 (Marcel Arpogaus)
-- @Changed: 2021-01-28 11:23:48 (Marcel Arpogaus)
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
local capi = {screen = screen}

-- Standard awesome library
local awful = require('awful')
local gears = require('gears')

-- Theme handling library
local beautiful = require('beautiful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] ---------------------------------------------------------
module.init = function(config, client_buttons, client_keys)
    -- Rules to apply to new clients (through the "manage" signal).
    module.rules = {
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
                placement = awful.placement.center + awful.placement.no_overlap +
                    awful.placement.no_offscreen,
                switchtotag = true,
                callback = awful.client.setslave
            }
        },
        -- Floating clients.
        {
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
        {
            rule_any = {type = {'dialog'}},
            properties = {titlebars_enabled = true}
        },
        {
            rule = {name = 'doom-capture'},
            properties = {
                tag = awful.screen.focused().selected_tags[0],
                requests_no_titlebars = true,
                titlebars_enabled = false,
                floating = true,
                ontop = true,
                placement = awful.placement.top
                -- maximized_horizontal = true,
            }
        }
    }
    if config.dynamic_tagging then
        gears.table.merge(
            module.rules, {
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
                            'xterm',
                            'urxvt',
                            'aterm',
                            'urxvt',
                            'Emacs'
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
                    rule_any = {
                        class = {'0ad', 'supertuxkart', 'xonotic', 'hedgewars'}
                    },
                    properties = {
                        new_tag = {
                            name = '',
                            volatile = true,
                            layout = awful.layout.suit.fair
                        }
                    }
                }
            }
        )
    end

    -- apply rules
    awful.rules.rules = module.rules
end

-- [ return module ] -----------------------------------------------------------
return module
