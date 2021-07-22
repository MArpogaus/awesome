-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : signals.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:34:33 (Marcel Arpogaus)
-- @Changed: 2021-02-08 21:24:50 (Marcel Arpogaus)
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
        if not client._request_titlebars_called then
            client:emit_signal('request::titlebars', 'rules', {})
        end
        awful.titlebar.show(client)
    else
        if not client._request_titlebars_called then return end
        awful.titlebar.hide(client)
    end
end

-- [ module functions ] --------------------------------------------------------
module.init = function(_)
    return {
        -- Signal function to execute when a new client appears.
        client = {
            ['manage'] = function(c)
                -- Set the windows at the slave,
                -- i.e. put it at the end of others instead of setting it master.
                -- if not awesome.startup then awful.client.setslave(c) end

                if capi.awesome.startup then
                    if not c.size_hints.user_position and
                        not c.size_hints.program_position then
                        -- Prevent clients from being unreachable after screen count changes.
                        awful.placement.no_offscreen(c)
                    end
                    setTitlebar(c, c.floating or c.first_tag.layout.name ==
                                    'floating')
                end
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
