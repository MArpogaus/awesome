-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-25 17:51:53 (Marcel Arpogaus)
-- @Changed: 2022-01-30 21:53:27 (Marcel Arpogaus)
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
-- helper functions
local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

module.depends_on = {'theme'}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, assets)
    if assets and #assets > 0 then
        self.apply = function()
            for asset, asset_cfg in utils.value_with_cfg(assets) do
                require(utils.get_pkg_name('assets.', asset)).init(asset_cfg)
            end
        end
        self.apply()
    end
end
module.reset = function(self) self.apply = nil end

-- [ return module ] -----------------------------------------------------------
return module
