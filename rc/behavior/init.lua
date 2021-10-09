-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 13:55:07 (Marcel Arpogaus)
-- @Changed: 2021-10-09 11:49:02 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local capi = {client = client, screen = screen, tag = tag}

local awful = require('awful')
local gears = require('gears')

-- helper functions
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}
-- [ defaults ] ----------------------------------------------------------------
module.defaults = {'default'}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, cfg, client_buttons, client_keys)
    self.config = cfg or module.defaults
    local rules = {}
    for behavior, behavior_cfg in utils.value_with_cfg(self.config) do
        rules = gears.table.crush(rules,
                                  utils.require_submodule('behavior',
                                                          behavior .. '/rules',
                                                          true).init(
            behavior_cfg, client_buttons, client_keys))
        for target, sigs in pairs(utils.require_submodule('behavior',
                                                          behavior ..
                                                              '/signals', true)
                                      .init(behavior_cfg)) do
            for sig_name, sig_fn in pairs(sigs) do
                capi[target].connect_signal(sig_name, sig_fn)
            end
        end
    end

    for _, rule in pairs(rules) do table.insert(awful.rules.rules, rule) end
end

-- [ return module ] -----------------------------------------------------------
return module
