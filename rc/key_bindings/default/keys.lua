-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : keys.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-27 10:39:56 (Marcel Arpogaus)
-- @Changed: 2021-01-27 11:05:18 (Marcel Arpogaus)
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
module.init = function(modkey, _)
    local keys = {}
    keys.global = {
        awesome = {
            ['lua execute prompt'] = {{modkey}, 'x'},
            ['quit awesome'] = {{modkey, 'Shift'}, 'q'},
            ['reload awesome'] = {{modkey, 'Control'}, 'r'},
            ['show help'] = {{modkey}, 's'},
            ['show main menu'] = {{modkey}, 'w'}
        },
        client = {
            ['focus next by index'] = {{modkey}, 'j'},
            ['focus previous by index'] = {{modkey}, 'k'},
            ['go back'] = {{modkey}, 'Tab'},
            ['jump to urgent client'] = {{modkey}, 'u'},
            ['restore minimized'] = {{modkey, 'Control'}, 'n'},
            ['swap with next client by index'] = {{modkey, 'Shift'}, 'j'},
            ['swap with previous client by index'] = {{modkey, 'Shift'}, 'k'}
        },
        launcher = {
            ['open a terminal'] = {{modkey}, 'Return'},
            ['run prompt'] = {{modkey}, 'r'},
            ['show the menubar'] = {{modkey}, 'p'}
        },
        layout = {
            ['decrease master width factor'] = {{modkey}, 'h'},
            ['decrease the number of columns'] = {{modkey, 'Control'}, 'l'},
            ['decrease the number of master clients'] = {
                {modkey, 'Shift'},
                'l'
            },
            ['increase master width factor'] = {{modkey}, 'l'},
            ['increase the number of columns'] = {{modkey, 'Control'}, 'h'},
            ['increase the number of master clients'] = {
                {modkey, 'Shift'},
                'h'
            },
            ['select next'] = {{modkey}, 'space'},
            ['select previous'] = {{modkey, 'Shift'}, 'space'}
        },
        screen = {
            ['focus the next screen'] = {{modkey, 'Control'}, 'j'},
            ['focus the previous screen'] = {{modkey, 'Control'}, 'k'}
        },
        tag = {
            ['go back'] = {{modkey}, 'Escape'},
            ['view next'] = {{modkey}, 'Right'},
            ['view previous'] = {{modkey}, 'Left'}
        }
    }
    keys.client = {
        client = {
            ['(un)maximize horizontally'] = {{modkey, 'Shift'}, 'm'},
            ['(un)maximize vertically'] = {{modkey, 'Control'}, 'm'},
            ['(un)maximize'] = {{modkey}, 'm'},
            ['close'] = {{modkey, 'Shift'}, 'c'},
            ['minimize'] = {{modkey}, 'n'},
            ['move to master'] = {{modkey, 'Control'}, 'Return'},
            ['move to screen'] = {{modkey}, 'o'},
            ['toggle floating'] = {{modkey, 'Control'}, 'space'},
            ['toggle fullscreen'] = {{modkey}, 'f'},
            ['toggle keep on top'] = {{modkey}, 't'}
        }
    }
    return keys
end

-- [ return module ] -----------------------------------------------------------
return module
