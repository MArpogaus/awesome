--------------------------------------------------------------------------------
-- @File:   tags.lua
-- @Author: Marcel Arpogaus
-- @Date:   2020-09-30 09:33:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-11-27 14:43:29
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
-- grab environment
local screen = screen

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')

-- Tyrannical - tag managment engine
local tyrannical = require('tyrannical')

-- helper functions
local helpers = require('rc.helper_functions')

-- configuration
local config = helpers.load_config()

-- [ layouts ] -----------------------------------------------------------------
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal, -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max, -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

if config.tyrannical then
    -- [ tyrannical properties ] ---------------------------------------------------
    -- Define default layout per screen
    tyrannical.settings.default_layout = awful.layout.suit.tile

    -- Make the matching clients (by classes) on top of the default layout
    tyrannical.properties.ontop = {'Xephyr', 'ksnapshot', 'kruler'}

    -- Force the matching clients (by classes) to be centered on the screen on init
    tyrannical.properties.placement = {kcalc = awful.placement.centered}

    -- Ignore the tiled layout for the matching clients
    tyrannical.properties.floating = {
        'feh',
        'gtksu',
        'Insert Picture',
        'kcalc',
        'kcharselect',
        'kcolorchooser',
        'kmix',
        'kruler',
        'ksnapshot',
        'MPlayer',
        'mythfrontend',
        'New Form',
        'Paste Special',
        'Pavucontrol',
        'pinentry',
        'pinentry',
        'plasmoidviewer',
        'Select Color$',
        'xcalc',
        'xine',
        'yakuake'
    }

    -- Ignore the tag "exclusive" property for the following clients (matched by classes)
    tyrannical.properties.intrusive_popup =
        gears.table.join(
            {
                'About KDE',
                'Background color',
                'feh',
                'Gradient editor',
                'gtksu',
                'Insert Picture',
                'kcalc',
                'kcharselect',
                'kcolorchooser',
                'kmix',
                'kruler',
                'ksnapshot',
                'MPlayer',
                'mythfrontend',
                'New Form',
                'Nm-applet',
                'Paste Special',
                'Pavucontrol',
                'pinentry',
                'plasmaengineexplorer',
                'plasmoidviewer',
                'Polkit-mate-authentication-agent-1',
                'Select Color$',
                'xcalc',
                'Xephyr',
                'Xfce4-settings-manager',
                'xine',
                'yakuake'
            }, tyrannical.properties.floating
        )

    -- [ tyrannical settings ] -----------------------------------------------------
    -- Block popups ()
    tyrannical.settings.block_children_focus_stealing = true

    -- Force popups/dialogs to have the same tags as the parent client
    tyrannical.settings.group_children = true

    -- [ tyrannical tags ] ---------------------------------------------------------
    tyrannical.tags = {
        {
            name = '',
            init = true,
            exclusive = false,
            selected = true,
            screen = {1, 2}, -- Create this tag on screen 1 and screen 2
            fallback = true,
            layout = awful.layout.suit.fair
        },
        {
            name = '',
            init = false,
            exclusive = true,
            screen = screen.count() > 1 and 2 or 1, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
            layout = awful.layout.suit.max,
            class = {
                'Opera',
                'Firefox',
                'Tor Browser',
                'Rekonq',
                'Dillo',
                'Arora',
                'Chromium',
                'nightly',
                'minefield'
            }
        },
        {
            name = '',
            init = false,
            exclusive = true,
            screen = screen.count() > 1 and 2 or 1, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
            layout = awful.layout.suit.magnifier,
            master_width_factor = 0.8,
            class = {'Thunderbird'}
        },
        {
            name = '',
            init = false,
            exclusive = true,
            screen = screen.count() > 1 and 2 or 1, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
            layout = awful.layout.suit.tile.left,
            master_width_factor = 0.8,
            class = {'zoom', 'franz', 'pidgin'}
        },
        {
            name = '',
            init = false,
            exclusive = true,
            screen = 1,
            layout = awful.layout.suit.tile,
            -- exec_once = {'thunar'}, -- When the tag is accessed for the first time, execute this command
            class = {
                'Thunar',
                'Konqueror',
                'Dolphin',
                'ark',
                'Nautilus',
                'emelfm'
            }
        },
        {
            name = '',
            init = false,
            exclusive = true,
            screen = 1,
            layout = awful.layout.suit.tile.bottom,
            master_width_factor = 0.8,
            class = {
                'Kate',
                'KDevelop',
                'Codeblocks',
                'Code::Blocks',
                'DDD',
                'kate4',
                'Sublime_text',
                'Sublime_merge',
                'lxterminal',
                "xterm",
                "urxvt",
                "aterm",
                "URxvt",
                "XTerm",
                "konsole",
                "terminator",
                "gnome-terminal",
                "emacs"
            }
        },
        {
            name = '',
            init = false, -- This tag wont be created at startup, but will be when one of the
            -- client in the "class" section will start. It will be created on
            -- the client startup screen
            screen = screen.count() > 1 and 2 or 1, -- Setup on screen 2 if there is more than 1 screen, else on screen 1
            exclusive = true,
            layout = awful.layout.suit.max,
            class = {
                'Assistant',
                'Okular',
                'Evince',
                'EPDFviewer',
                'xpdf',
                'Xpdf',
                'zathura'
            }
        },
        {
            name = '',
            init = false, -- This tag wont be created at startup, but will be when one of the
            -- client in the "class" section will start. It will be created on
            -- the client startup screen
            exclusive = true,
            layout = awful.layout.suit.fair,
            class = {'mpv', 'vlc', 'Player', 'qvidcap', 'Gpodder', 'Ristretto'}
        },
        {
            name = '',
            init = false, -- This tag wont be created at startup, but will be when one of the
            -- client in the "class" section will start. It will be created on
            -- the client startup screen
            exclusive = true,
            layout = awful.layout.suit.fair,
            class = {'0ad', 'supertuxkart', 'Xonotic', 'Hedgewars'}
        }
    }

else
    awful.util.tagnames = {"1", "2", "3", "4", "5"}
    awful.layout.default = {awful.layout.layouts[1]}
end
