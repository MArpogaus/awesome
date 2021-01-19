--------------------------------------------------------------------------------
-- @File:   menu.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-04 16:50:04
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
local capi = {awesome = awesome}

-- Standard awesome library
local awful = require('awful')

-- Theme handling library
local beautiful = require('beautiful')

local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup').widget

-- Freedesktop menu
local freedesktop = require('freedesktop')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module objects ] ----------------------------------------------------------
module.init = function(config)

    -- This is used later as the default terminal and editor to run.
    local browser = config.browser
    local filemanager = config.filemanager
    local gui_editor = config.gui_editor
    local terminal = config.terminal
    local lock_command = config.lock_command

    local myawesomemenu = {
        {
            'hotkeys',
            function() return false, hotkeys_popup.show_help end,
            menubar.utils.lookup_icon('preferences-desktop-keyboard-shortcuts')
        },
        {
            'manual',
            terminal .. ' -e man awesome',
            menubar.utils.lookup_icon('system-help')
        },
        {
            'edit config',
            gui_editor .. ' ' .. capi.awesome.conffile,
            menubar.utils.lookup_icon('accessories-text-editor')
        },
        {
            'restart',
            capi.awesome.restart,
            menubar.utils.lookup_icon('system-restart')
        }
    }
    local myexitmenu = {
        {
            'log out',
            function() capi.awesome.quit() end,
            menubar.utils.lookup_icon('system-log-out')
        },
        {
            'lock screen',
            lock_command,
            menubar.utils.lookup_icon('system-lock-screen')
        },
        {
            'suspend',
            'systemctl suspend',
            menubar.utils.lookup_icon('system-suspend')
        },
        {
            'hibernate',
            'systemctl hibernate',
            menubar.utils.lookup_icon('system-suspend-hibernate')
        },
        {
            'reboot',
            'systemctl reboot',
            menubar.utils.lookup_icon('system-reboot')
        },
        {'shutdown', 'poweroff', menubar.utils.lookup_icon('system-shutdown')}
    }

    module.mainmenu = freedesktop.menu.build(
        {
            icon_size = 32,
            before = {
                {
                    'Terminal',
                    terminal,
                    menubar.utils.lookup_icon('utilities-terminal')
                },
                {
                    'Browser',
                    browser,
                    menubar.utils.lookup_icon('internet-web-browser')
                },
                {
                    'Files',
                    filemanager,
                    menubar.utils.lookup_icon('system-file-manager')
                }
            },
            after = {
                {
                    'Awesome',
                    myawesomemenu,
                    '/usr/share/awesome/icons/awesome32.png'
                },
                {
                    'Exit',
                    myexitmenu,
                    menubar.utils.lookup_icon('system-shutdown')
                }
            }
        }
    )
    module.exitmenu = awful.widget.launcher(
        {
            image = beautiful.exitmenu_icon,
            menu = awful.menu({icon_size = 32, items = myexitmenu})
        }
    )
end

-- [ return module ] -----------------------------------------------------------
return module
