-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : rules.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:33:30 (Marcel Arpogaus)
-- @Changed: 2021-02-06 13:14:02 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(_, _, _)
    return {
        -- Add titlebars to dialogs
        titlebars = {
            rule_any = {type = {'dialog'}},
            properties = {titlebars_enabled = true}
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return module
