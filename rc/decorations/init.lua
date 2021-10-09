-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:07:01 (Marcel Arpogaus)
-- @Changed: 2021-10-09 12:21:35 (Marcel Arpogaus)
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
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local decorations = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {
    wibar = {'default'},
    desktop = {},
    -- widgets
    widgets_args = {}
}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, cfg)
    self.config = utils.deep_merge(self.defaults, cfg or {}, 0)
    for name, module_cfg in utils.value_with_cfg(self.config.wibar) do
        table.insert(decorations,
                     utils.require_submodule('decorations/wibar', name).init(
            module_cfg, self.config.widgets_args))
    end
    for name, module_cfg in utils.value_with_cfg(self.config.desktop) do
        table.insert(decorations,
                     utils.require_submodule('decorations/desktop', name).init(
            module_cfg, self.config.widgets_args))
    end
end
module.get = function() return decorations end

-- [ return module ] -----------------------------------------------------------
return module
