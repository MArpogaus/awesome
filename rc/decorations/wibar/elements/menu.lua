-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : menu.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-09 14:36:47 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')
local beautiful = require('beautiful')
local menubar = require('menubar')

local menus = require('rc.menus')
local abstract_element = require('rc.decorations.abstract_element')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local menu_name = config.name or 'mainmenu'
    local icon
    if type(config.icon) == 'string' then
        icon = menubar.utils.lookup_icon(config.icon)
    else
        icon = beautiful[menu_name .. '_icon'] or beautiful.awesome_icon
    end
    return abstract_element.new {
        register_fn = function(_)
            local laucher = awful.widget.launcher(
                {image = icon, menu = menus[menu_name]})
            return laucher
        end,
        unregister_fn = function(_) end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
