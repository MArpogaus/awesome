-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:52:54 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local capi = {awesome = awesome}

-- Standard awesome library
local awful = require('awful')

-- Theme handling library

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
            function()
                return false, hotkeys_popup.show_help
            end,
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
                }
            }
        }
    )

    if config.exitmenu then
        local myexitmenu = {
            {
                'log out',
                function()
                    capi.awesome.quit()
                end,
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
            {
                'shutdown',
                'poweroff',
                menubar.utils.lookup_icon('system-shutdown')
            }
        }
        module.exitmenu = awful.menu({icon_size = 32, items = myexitmenu})
    end
end

-- [ return module ] -----------------------------------------------------------
return module
