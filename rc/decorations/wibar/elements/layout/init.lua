-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 16:17:12 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')
local gears = require('gears')

local abstract_decoration = require('rc.decorations.abstract_decoration')
local layout_popup = require('rc.decorations.wibar.elements.layout_popup')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    local add_layout_popup = config.add_layout_popup or false
    return abstract_decoration.new {
        register_fn = function(s)
            -- Create an imagebox widget which will contain an icon indicating which layout we're using.
            -- We need one layoutbox per screen.
            s.layoutbox = awful.widget.layoutbox(s)
            if add_layout_popup then
                s.layout_popup = layout_popup.init(s.layoutbox)
                s.layoutbox:buttons(gears.table.join(
                    awful.button({}, 4, function()
                        awful.layout.inc(1)
                    end),
                    awful.button({}, 5, function()
                        awful.layout.inc(-1)
                    end)))
            end
        end,
        unregister_fn = function(s)
            s.layoutbox:remove()
            s.layoutbox = nil
            if add_layout_popup then
                layout_popup.reset(s.layout_popup, s.layoutbox)
                s.layout_popup = nil
            end
        end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
