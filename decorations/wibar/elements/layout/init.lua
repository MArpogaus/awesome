-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-08-08 16:17:12 (Marcel Arpogaus)
-- @Changed: 2021-10-03 17:58:53 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local awful = require('awful')
local gears = require('gears')

local abstract_element = require('decorations.abstract_element')
local layout_popup = require('decorations.wibar.elements.layout.popup')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(s, config)
    local use_popup = config.use_popup or false
    local layoutbox, popup
    return abstract_element.new {
        register_fn = function(_)
            -- Create an imagebox widget which will contain an icon indicating which layout we're using.
            -- We need one layoutbox per screen.
            layoutbox = awful.widget.layoutbox(s)
            if use_popup then
                popup = layout_popup.init()
                popup:bind_to_widget(layoutbox)
                layoutbox:buttons(gears.table.join(
                                      awful.button({}, 4, function()
                        awful.layout.inc(1)
                    end), awful.button({}, 5,
                                       function()
                        awful.layout.inc(-1)
                    end)))
            end
            return layoutbox
        end,
        unregister_fn = function(_)
            if use_popup then
                popup:unbind_to_widget(layoutbox)
                popup = nil
            end
            layoutbox:remove()
            layoutbox = nil
        end
    }
end

-- [ return module ] -----------------------------------------------------------
return module
