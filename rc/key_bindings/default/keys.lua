-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : keys.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-27 10:39:56 (Marcel Arpogaus)
-- @Changed: 2021-07-16 15:41:09 (Marcel Arpogaus)
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
            ['lua execute prompt'] = {{config.modkey}, 'x'},
            ['quit awesome'] = {{config.modkey, 'Shift'}, 'q'},
            ['reload awesome'] = {{config.modkey, 'Control'}, 'r'},
            ['reload theme'] = {{config.modkey, 'Shift', 'Control'}, 'r'},
            ['show help'] = {{config.modkey}, 's'},
            ['show main menu'] = {{config.modkey}, 'w'}
        },
        client = {
            ['focus next by index'] = {{config.modkey}, 'j'},
            ['focus previous by index'] = {{config.modkey}, 'k'},
            ['go back'] = {{config.modkey}, 'Tab'},
            ['jump to urgent client'] = {{config.modkey}, 'u'},
            ['restore minimized'] = {{config.modkey, 'Control'}, 'n'},
            ['swap with next client by index'] = {
                {config.modkey, 'Shift'},
                'j'
            },
            ['swap with previous client by index'] = {
                {config.modkey, 'Shift'},
                'k'
            }
        },
        launcher = {
            ['open a terminal'] = {{config.modkey}, 'Return'},
            ['run prompt'] = {{config.modkey}, 'r'},
            ['show the menubar'] = {{config.modkey}, 'p'}
        },
        layout = {
            ['decrease master width factor'] = {{config.modkey}, 'h'},
            ['decrease the number of columns'] = {
                {config.modkey, 'Control'},
                'l'
            },
            ['decrease the number of master clients'] = {
                {config.modkey, 'Shift'},
                'l'
            },
            ['increase master width factor'] = {{config.modkey}, 'l'},
            ['increase the number of columns'] = {
                {config.modkey, 'Control'},
                'h'
            },
            ['increase the number of master clients'] = {
                {config.modkey, 'Shift'},
                'h'
            },
            ['select next'] = {{config.modkey}, 'space'},
            ['select previous'] = {{config.modkey, 'Shift'}, 'space'}
        },
        screen = {
            ['focus the next screen'] = {{config.modkey, 'Control'}, 'j'},
            ['focus the previous screen'] = {{config.modkey, 'Control'}, 'k'}
        },
        tag = {
            ['go back'] = {{config.modkey}, 'Escape'},
            ['view next'] = {{config.modkey}, 'Right'},
            ['view previous'] = {{config.modkey}, 'Left'}
        }
    }
    keys.client = {
        client = {
            ['(un)maximize horizontally'] = {{config.modkey, 'Shift'}, 'm'},
            ['(un)maximize vertically'] = {{config.modkey, 'Control'}, 'm'},
            ['(un)maximize'] = {{config.modkey}, 'm'},
            ['close'] = {{config.modkey, 'Shift'}, 'c'},
            ['minimize'] = {{config.modkey}, 'n'},
            ['move to master'] = {{config.modkey, 'Control'}, 'Return'},
            ['move to screen'] = {{config.modkey}, 'o'},
            ['toggle floating'] = {{config.modkey, 'Control'}, 'space'},
            ['toggle fullscreen'] = {{config.modkey}, 'f'},
            ['toggle keep on top'] = {{config.modkey}, 't'}
        }
    }
    return keys
end

-- [ return module ] -----------------------------------------------------------
return module
