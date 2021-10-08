-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : signals.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:34:33 (Marcel Arpogaus)
-- @Changed: 2021-10-07 15:06:12 (Marcel Arpogaus)
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local capi = {awesome = awesome}

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
