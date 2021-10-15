-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 13:55:07 (Marcel Arpogaus)
-- @Changed: 2021-10-14 20:29:06 (Marcel Arpogaus)
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
-- grab environment
local capi = {client = client, screen = screen, tag = tag}

local awful = require('awful')
local gears = require('gears')
local protected_call = require('gears.protected_call')

-- helper functions
local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {'default'}

-- [ dependencies ] ------------------------------------------------------------
module.depends_on = {'key_bindings', 'mouse_bindings'}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, cfg)
    self.config = cfg or module.defaults
    local rules = {}
    for behavior, behavior_cfg in utils.value_with_cfg(self.config) do
        local mod =
            protected_call(require, 'behavior.' .. behavior .. '.rules')
        if mod then
            rules = gears.table.crush(rules, mod.init(behavior_cfg))
        end
        mod = protected_call(require, 'behavior.' .. behavior .. '.signals')
        if mod then
            for target, sigs in pairs(mod.init(behavior_cfg)) do
                for sig_name, sig_fn in pairs(sigs) do
                    capi[target].connect_signal(sig_name, sig_fn)
                end
            end
        end
    end

    for _, rule in pairs(rules) do table.insert(awful.rules.rules, rule) end
end

-- [ return module ] -----------------------------------------------------------
return module
