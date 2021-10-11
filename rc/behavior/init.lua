-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 13:55:07 (Marcel Arpogaus)
-- @Changed: 2021-10-10 19:45:53 (Marcel Arpogaus)
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
local key_bindings = require('rc.key_bindings')
local mouse_bindings = require('rc.mouse_bindings')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {'default'}

-- [ dependencies ] ------------------------------------------------------------
module.depends_on = {'key_bindings', 'mouse_bindings'}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, cfg)
    local client_buttons = mouse_bindings.client_buttons
    local client_keys = key_bindings.client_keys
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
