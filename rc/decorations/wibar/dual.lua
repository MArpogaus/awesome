-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-09-27 17:08:24 (Marcel Arpogaus)
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
local abstract_decoration = require('rc.decorations.abstract_decoration')
local default_wibar = require('rc.decorations.wibar.default')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local elements = config.elements or {
        top = {
            {'menu', 'taglist', 'promptbox'}, -- left
            {}, -- middle
            {'widgets'} -- right
        },
        bottom = {
            {'default_tasklist'}, -- left
            {}, -- middle
            {'keyboardlayout', 'systray', 'layout'} -- right
        }
    }

    local top_wibar = default_wibar.init {
        position = 'top',
        elements = elements.top
    }
    local bottom_wibar = default_wibar.init {
        position = 'bottom',
        elements = elements.bottom
    }

    local decoration = abstract_decoration.new {
        meta = true,
        register_fn = function(s)
            top_wibar:register(s)
            bottom_wibar:register(s)
        end,
        unregister_fn = function(s)
            top_wibar:unregister(s)
            bottom_wibar:unregister(s)
        end
    }
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
