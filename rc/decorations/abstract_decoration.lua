-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : abstract_decoration.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 11:32:32 (Marcel Arpogaus)
-- @Changed: 2021-08-09 08:48:34 (Marcel Arpogaus)
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
local gears = require('gears')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.new = function(def)
    local decoration = {}
    decoration.unregister = function(container, s)
        if not container[decoration] then
            gears.debug.print_warning(
                'cant unregister: decoration not registered on this screen.')
        else
            local ret = def.unregister_fn(s)
            container[decoration] = nil
            return ret
        end
    end
    decoration.register = function(container, s)
        if container[decoration] then
            gears.debug.print_warning('cant register:' ..
                                          'decoration is already registered on this screen.')
        else
            local ret = def.register_fn(s)
            container[decoration] = true
            return ret
        end
    end
    decoration.update = function(s)
        if def.update_fn then
            def.update_fn(s)
        else
            gears.debug.print_warning('no update_fn provided')
        end
    end
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
