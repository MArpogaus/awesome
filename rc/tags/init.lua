-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-26 16:53:48 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local awful = require('awful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    if config.dynamic_tagging then
        module.tagnames = {''}
        -- workaround for now
        local new_tag = awful.rules.high_priority_properties.new_tag
        function awful.rules.high_priority_properties.new_tag(c, value, props)
            local tag = awful.tag.find_by_name(c.screen, value.name)
            if not tag then
                new_tag(c, value, props)
            end
            awful.rules.high_priority_properties.tag(c, value.name, props)
        end
    else
        module.tagnames = {'1', '2', '3', '4', '5', '6', '7', '8', '9'}
    end
end

-- [ return module ] -----------------------------------------------------------
return module
