-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : actions.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-27 11:14:55 (Marcel Arpogaus)
-- @Changed: 2021-08-10 08:50:46 (Marcel Arpogaus)
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
-- grab environment
local capi = {screen = screen}

-- Standard awesome library
local awful = require('awful')

-- Mac OSX like 'Exposé' view
local revelation = require('revelation')

-- helper functions
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config, _)
    local actions = {}
    actions.global = {
        awesome = {
            ['lock screen'] = function()
                awful.spawn(config.lock_command)
            end,
            ['Mac OSX like \'Exposé\' view'] = revelation.expose,
            ['toggle wibar'] = function()
                for s in capi.screen do
                    if s.wibars then
                        for _, w in ipairs(s.wibars) do
                            w.visible = not w.visible
                        end
                    end
                end
            end
        },
        client = {
            ['decrement useless gaps'] = function()
                utils.gaps_resize(-2)
            end,
            ['increment useless gaps'] = function()
                utils.gaps_resize(2)
            end
        },
        launcher = {
            ['launch Browser'] = function()
                awful.spawn(config.browser)
            end,
            ['launch org capture'] = function()
                awful.spawn.with_shell('$HOME/.emacs.d/bin/org-capture')
            end,
            ['launch rofi'] = function()
                awful.spawn('/usr/bin/rofi -show drun -modi drun')
            end
        },
        screenshot = {
            ['capture a screenshot of active window'] = function()
                awful.spawn.with_shell('sleep 0.1 && /usr/bin/i3-scrot -w')
            end,
            ['capture a screenshot of selection'] = function()
                awful.spawn.with_shell('sleep 0.1 && /usr/bin/i3-scrot -s')
            end
        },
        tag = {
            ['add new tag'] = utils.add_tag,
            ['delete tag'] = utils.delete_tag,
            ['fork tag'] = utils.fork_tag,
            ['go back'] = awful.tag.history.restore,
            ['move tag to the left'] = function() utils.move_tag(-1) end,
            ['move tag to the right'] = function() utils.move_tag(1) end,
            ['rename tag'] = utils.rename_tag
        },
        theme = {
            ['decrease dpi'] = function() utils.dec_dpi(10) end,
            ['increase dpi'] = function() utils.inc_dpi(10) end,
            ['set dark colorscheme'] = utils.set_dark,
            ['set light colorscheme'] = utils.set_light,
            ['set mirage colorscheme'] = utils.set_mirage
        },
        widgets = {
            ['toggle desktop widget visibility'] = utils.toggle_desktop_widget_visibility,
            ['toggle wibar widgets'] = utils.toggle_wibar_widgets,
            ['update widgets'] = utils.update_widgets
        }
    }

    actions.client = {}
    return actions
end

-- [ return module ] -----------------------------------------------------------
return module
