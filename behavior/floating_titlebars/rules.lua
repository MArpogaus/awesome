-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : rules.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:33:30 (Marcel Arpogaus)
-- @Changed: 2021-02-08 21:15:22 (Marcel Arpogaus)
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
module.init = function(_, _, _)
    return {
        -- Add titlebars to dialogs
        titlebars = {
            rule = {type = 'dialog'},
            properties = {titlebars_enabled = true}
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return module
