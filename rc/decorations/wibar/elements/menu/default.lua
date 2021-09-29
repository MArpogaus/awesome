-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : default.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-09-29 08:18:44 (Marcel Arpogaus)
-- @Changed: 2021-09-29 20:42:35 (Marcel Arpogaus)
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

local hotkeys_popup = require('awful.hotkeys_popup').widget

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    -- This is used later as the default terminal and editor to run.
    config.apps = config.apps or {}
    local gui_editor = config.apps.gui_editor or os.getenv('EDITOR') or 'nano'
    local terminal = config.apps.terminal or 'xterm'

    -- Create a launcher widget and a main menu
    local awesomemenu = {
        {
            'hotkeys',
            function()
                hotkeys_popup.show_help(nil, awful.screen.focused())
            end
        },
        {'manual', terminal .. ' -e man awesome'},
        {'edit config', gui_editor .. ' ' .. capi.awesome.conffile},
        {'restart', capi.awesome.restart},
        {'quit', function() capi.awesome.quit() end}
    }

    local menu = awful.menu({
        items = {
            {'awesome', awesomemenu, beautiful.awesome_icon},
            {'open terminal', terminal}
        }
    })

    return menu
end

-- [ return module ] -----------------------------------------------------------
return module
