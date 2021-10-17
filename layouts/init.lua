-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : init.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 20:34:11 (Marcel Arpogaus)
-- @Changed: 2021-10-10 19:22:57 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- Copyright (C) 2021 Marcel Arpogaus
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- Standard awesome library
local awful = require('awful')

-- helper functions
local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {
    default_layout = 0,
    layouts = {
        awful.layout.suit.floating, awful.layout.suit.tile,
        awful.layout.suit.tile.left, awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top, awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal, awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle, awful.layout.suit.max,
        awful.layout.suit.max.fullscreen, awful.layout.suit.magnifier,
        awful.layout.suit.corner.nw
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    }
}

-- [ module functions ] --------------------------------------------------------
module.init = function(self, cfg)
    self.config = utils.deep_merge(self.defaults, cfg or {}, 1)

    -- Table of layouts to cover with awful.layout.inc, order matters.
    awful.layout.layouts = self.config.layouts

    self.default = awful.layout.layouts[self.config.default_layout]
end

-- [ return module ] -----------------------------------------------------------
return module
