-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:53:48 (Marcel Arpogaus)
-- @Changed: 2021-10-18 15:22:56 (Marcel Arpogaus)
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

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {'1', '2', '3', '4', '5', '6', '7', '8', '9'}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, tagnames)
    if tagnames and #tagnames > 0 then
        self.tagnames = tagnames
    else
        self.tagnames = self.defaults
    end
end
module.reset = function(self) self.tagnames = nil end
-- [ return module ] -----------------------------------------------------------
return module
