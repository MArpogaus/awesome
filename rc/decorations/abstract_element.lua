-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : abstract_module.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 11:32:32 (Marcel Arpogaus)
-- @Changed: 2021-09-28 12:05:55 (Marcel Arpogaus)
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
local element = {}
element.__index = element
element.unregister = function(self, elements_container, args)
    if not elements_container[self] then
        gears.debug.print_warning(
            'cant unregister: element not registered on this screen.')
    else
        local ret = self.unregister_fn(args)
        if not self.meta then elements_container[self] = nil end
        collectgarbage()
        return ret
    end
end
element.register = function(self, elements_container, args)
    if elements_container[self] then
        gears.debug.print_warning('cant register:' ..
                                      'element is already registered on this screen.')
    else
        local ret = self.register_fn(args)
        if not self.meta then elements_container[self] = true end
        return ret
    end
end
element.update = function(self, args)
    if self.update_fn then
        self.update_fn(args)
    else
        gears.debug.print_warning('no update_fn provided')
    end
end

-- [ module functions ] --------------------------------------------------------
module.new = function(def)
    if def == nil then error('no definition provided') end
    setmetatable(def, element)
    return def
end

-- [ return module ] -----------------------------------------------------------
return module
