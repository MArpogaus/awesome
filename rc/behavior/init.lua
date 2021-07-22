-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 13:55:07 (Marcel Arpogaus)
-- @Changed: 2021-07-18 22:51:02 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local capi = {client = client, tag = tag}

local awful = require('awful')
local gears = require('gears')

-- helper functions
local utils = require('rc.utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config, client_buttons, client_keys)
    local rules = {}
    for behavior, behavior_cfg in utils.value_with_cfg(config) do
        rules = gears.table.crush(rules,
                                  utils.require_submodule('behavior',
                                                          behavior .. '/rules')
                                      .init(behavior_cfg, client_buttons,
                                            client_keys))
        for target, sigs in pairs(utils.require_submodule('behavior',
                                                          behavior ..
                                                              '/signals').init(
            behavior_cfg)) do
            for sig_name, sig_fn in pairs(sigs) do
                capi[target].connect_signal(sig_name, sig_fn)
            end
        end
    end

    for _, rule in pairs(rules) do table.insert(awful.rules.rules, rule) end
end

-- [ return module ] -----------------------------------------------------------
return module
