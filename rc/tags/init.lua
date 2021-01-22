--------------------------------------------------------------------------------
-- @File:   tags.lua
-- @Author: Marcel Arpogaus
-- @Date:   2020-09-30 09:33:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-11-27 14:43:29
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local awful = require('awful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    -- Table of layouts to cover with awful.layout.inc, order matters.
    awful.layout.layouts = {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal, -- awful.layout.suit.spiral,
        -- awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max, -- awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier
        -- awful.layout.suit.corner.nw,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    }

    awful.layout.default = {awful.layout.layouts[6]}

    if config.dynamic_tagging then
        module.tagnames = {''}
        -- workaround for now
        local new_tag = awful.rules.high_priority_properties.new_tag
        function awful.rules.high_priority_properties.new_tag(c, value, props)
            if not awful.tag.find_by_name(c.screen, value.name) then
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
