-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : signals.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:34:33 (Marcel Arpogaus)
-- @Changed: 2021-10-09 12:02:53 (Marcel Arpogaus)
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

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
-- Toggle titlebar on or off depending on s. Creates titlebar if it does not
-- exist.
-- ref: stackoverflow.com/questions/42376294
local function setTitlebar(client, s)
    if s and not client.requests_no_titlebars then
        awful.titlebar.show(client)
    else
        awful.titlebar.hide(client)
    end
end

-- [ module functions ] --------------------------------------------------------
module.init = function(_)
    return {
        -- Signal function to execute when a new client appears.
        client = {
            ['manage'] = function(c)
                setTitlebar(c, c.floating or c.first_tag.layout.name ==
                                'floating')
            end,
            ['property::floating'] = function(c)
                if c.fullscreen then return end
                setTitlebar(c, c.floating or
                                (c.first_tag and c.first_tag.layout.name ==
                                    'floating'))
            end
        },
        tag = {
            ['property::layout'] = function(t)
                for _, c in pairs(t:clients()) do
                    setTitlebar(c, t.layout.name == 'floating' or c.floating)
                end
            end,
            ['tagged'] = function(t, c)
                setTitlebar(c, c.floating or t.layout.name == 'floating')
            end
        }
    }

end

-- [ return module ] -----------------------------------------------------------
return module
