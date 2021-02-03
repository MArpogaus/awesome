-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 13:55:07 (Marcel Arpogaus)
-- @Changed: 2021-02-03 16:29:19 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local capi = {root = root, client = client}

local awful = require('awful')
local gears = require('gears')
local gfs = require('gears.filesystem')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local config_path = gfs.get_configuration_dir()

local function load_behavior(behavior, file)
    local file_name
    for _, path in ipairs {'config', 'rc'} do
        file_name = string.format('%s/behavior/%s/%s', path, behavior, file)
        if gfs.file_readable(config_path .. file_name .. '.lua') then
            return require(file_name:gsub('/', '.'))
        end
    end
    return {init = function(_) return {} end}
end

-- [ module functions ] --------------------------------------------------------
module.init = function(config, client_buttons, client_keys)
    local rules = {}
    local signals = {}
    for _, behavior in ipairs(config.behavior) do
        rules = gears.table.crush(rules, load_behavior(behavior, 'rules').init(
            config,client_buttons, client_keys))
        signals = gears.table.crush(signals,
                                    load_behavior(behavior, 'signals').init(
            config))
    end

    for _, rule in pairs(rules) do table.insert(awful.rules.rules, rule) end

    for target, sigs in pairs(signals) do
        for sig_name, sig_fn in pairs(sigs) do
            capi[target].connect_signal(sig_name, sig_fn)
        end
    end

end

-- [ return module ] -----------------------------------------------------------
return module
