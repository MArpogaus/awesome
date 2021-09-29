-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : default.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-09-29 08:18:44 (Marcel Arpogaus)
-- @Changed: 2021-09-29 20:42:08 (Marcel Arpogaus)
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
local beautiful = require('beautiful')
local menubar = require('menubar')

local hotkeys_popup = require('awful.hotkeys_popup').widget

local freedesktop = require('freedesktop')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    -- This is used later as the default terminal and editor to run.
    config.apps = config.apps or {}
    local browser = config.apps.browser or 'firefox'
    local filemanager = config.apps.filemanager or 'thunar'
    local gui_editor = config.apps.gui_editor or os.getenv('EDITOR') or 'nano'
    local terminal = config.apps.terminal or 'xterm'

    -- Create a launcher widget and a main menu
    local awesomemenu = {
        {
            'hotkeys',
            function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
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
        },
        {
            'quit',
            function() capi.awesome.quit() end,
            menubar.utils.lookup_icon('system-log-out')
        }
    }

    local menu = freedesktop.menu.build(
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
            after = {{'Awesome', awesomemenu, beautiful.awesome_icon}}
        })

    return menu
end

-- [ return module ] -----------------------------------------------------------
return module
