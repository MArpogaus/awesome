-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : wibars.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-01-22 09:11:30 (Marcel Arpogaus)
-- @Changed: 2021-10-18 21:58:35 (Marcel Arpogaus)
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
local abstract_decoration = require('decorations.abstract_decoration')
local default_wibar = require('decorations.wibar.default')

-- helper functions
local utils = require('utils')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ defaults ] ----------------------------------------------------------------
module.defaults = {
    elements = {
        top = {
            {['1-menu'] = {main_menu = true}, '2-taglist', '3-promptbox'}, -- left
            {}, -- middle
            {'widgets'} -- right
        },
        bottom = {
            {'default_tasklist'}, -- left
            {}, -- middle
            {'1-keyboardlayout', '2-systray', '3-layout'} -- right
        }
    }
}

-- [ module functions ] --------------------------------------------------------
module.init = function(config)
    config = utils.deep_merge(module.defaults, config, 2)

    local top_wibar = default_wibar.init {
        position = 'top',
        elements = config.elements.top
    }
    local bottom_wibar = default_wibar.init {
        position = 'bottom',
        elements = config.elements.bottom
    }

    local decoration = abstract_decoration.new {
        meta = true,
        register_fn = function(s)
            top_wibar:register(s)
            bottom_wibar:register(s)
        end
    }
    return decoration
end

-- [ return module ] -----------------------------------------------------------
return module
