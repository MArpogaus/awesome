-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:07:01 (Marcel Arpogaus)
-- @Changed: 2021-10-11 12:05:25 (Marcel Arpogaus)
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

-- helper functions
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local decorations = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {wibar = {'default'}, desktop = {}}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, cfg)
    self.config = utils.deep_merge(self.defaults, cfg or {}, 0)
    for _, m in ipairs({'wibar', 'desktop'}) do
        for name, module_cfg in utils.value_with_cfg(self.config[m]) do
            local dec = utils.require_submodule('decorations/' .. m, name)
                            .init(module_cfg)
            decorations[dec] = module_cfg.screens or {}
        end
    end
end
module.get = function(s)
    local ret = {}
    for k, v in pairs(decorations) do
        if #v == 0 or gears.table.hasitem(v, s.index) then
            table.insert(ret, k)
        end
    end
    return ret
end

-- [ return module ] -----------------------------------------------------------
return module
