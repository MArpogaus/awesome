-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : default.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-09-29 08:18:44 (Marcel Arpogaus)
-- @Changed: 2021-09-29 20:41:47 (Marcel Arpogaus)
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
local menubar = require('menubar')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local lock_command = config.lock_command or 'light-locker-command -l'

    local exitmenu = {
        {
            'log out', function() capi.awesome.quit() end,
            menubar.utils.lookup_icon('system-log-out')
        },
        {
            'lock screen', lock_command,
            menubar.utils.lookup_icon('system-lock-screen')
        },
        {
            'suspend', 'systemctl suspend',
            menubar.utils.lookup_icon('system-suspend')
        }, {
            'hibernate', 'systemctl hibernate',
            menubar.utils.lookup_icon('system-suspend-hibernate')
        },
        {
            'reboot', 'systemctl reboot',
            menubar.utils.lookup_icon('system-reboot')
        },
        {'shutdown', 'poweroff', menubar.utils.lookup_icon('system-shutdown')}
    }
    local menu = awful.menu({items = exitmenu})
    return menu
end

-- [ return module ] -----------------------------------------------------------
return module
