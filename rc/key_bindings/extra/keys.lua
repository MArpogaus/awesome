-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : keys.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-27 10:39:56 (Marcel Arpogaus)
-- @Changed: 2021-01-27 16:05:04 (Marcel Arpogaus)
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
-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local keys = {}
    keys.global = {
        awesome = {
            ['lua execute prompt'] = {{config.modkey, config.altkey}, 'r'},
            ['lock screen'] = {{config.modkey}, 'q'},
            ['Mac OSX like \'Exposé\' view'] = {{config.modkey}, 'e'},
            ['toggle wibox'] = {{config.modkey, 'Shift'}, 'b'}
        },
        client = {
            ['decrement useless gaps'] = {{config.altkey, 'Control'}, '-'},
            ['increment useless gaps'] = {{config.altkey, 'Control'}, '+'}
        },
        launcher = {
            ['launch Browser'] = {{config.modkey}, 'b'},
            ['launch org capture'] = {{config.modkey}, 'a'},
            ['launch rofi'] = {{config.modkey}, 'space'}
        },
        layout = {
            ['select next'] = {{config.modkey, 'Shift'}, 'space'},
            ['select previous'] = {
                {config.modkey, 'Control', 'Shift'},
                'space'
            }
        },
        screenshot = {
            ['capture a screenshot of active window'] = {{'Control'}, 'Print'},
            ['capture a screenshot of selection'] = {{'Shift'}, 'Print'}
        },
        tag = {
            ['add new tag'] = {{config.modkey, 'Shift'}, 'n'},
            ['delete tag'] = {{config.modkey, 'Shift'}, 'd'},
            ['fork tag'] = {{config.modkey, 'Shift'}, 'f'},
            ['move tag to the left'] = {{config.modkey, 'Shift'}, 'Left'},
            ['move tag to the right'] = {{config.modkey, 'Shift'}, 'Right'},
            ['rename tag'] = {{config.modkey, 'Shift'}, 'r'}
        },
        theme = {
            ['decrease dpi'] = {{config.modkey, config.altkey, 'Control'}, '-'},
            ['increase dpi'] = {{config.modkey, config.altkey, 'Control'}, '+'},
            ['set dark colorscheme'] = {
                {config.modkey, config.altkey, 'Control'},
                'd'
            },
            ['set light colorscheme'] = {
                {config.modkey, config.altkey, 'Control'},
                'l'
            },
            ['set mirage colorscheme'] = {
                {config.modkey, config.altkey, 'Control'},
                'm'
            }
        },
        widgets = {
            ['toggle desktop widget visibility'] = {
                {config.modkey, config.altkey, 'Shift'},
                'w'
            },
            ['toggle wibar widgets'] = {{config.modkey, 'Shift'}, 'w'},
            ['update widgets'] = {{config.modkey, 'Shift'}, 'u'}
        }
    }
    keys.client = {client = {['close'] = {{config.modkey}, 'x'}}}
    return keys
end

-- [ return module ] -----------------------------------------------------------
return module
