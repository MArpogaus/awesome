-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : abstract_decoration.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 11:32:32 (Marcel Arpogaus)
-- @Changed: 2021-08-10 15:03:32 (Marcel Arpogaus)
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
local abstract_element = require('rc.decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.new = function(def)
    local element = abstract_element.new(def)
    local decoration = setmetatable({}, element)
    decoration.unregister = function(_, s)
        if not s.decorations then
            error('screen not initialized: call screen.init() first')
        else
            return element:unregister(s.decorations, s)
        end
    end
    decoration.register = function(_, s)
        if not s.decorations then
            error('screen not initialized: call screen.init() first')
        else
            return element:register(s.decorations, s)
        end
    end
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
