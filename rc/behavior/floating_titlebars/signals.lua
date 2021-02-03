-- [ author ] -*- time-stamp-pattern: "@Changed[\s]?:[\s]+%%$"; -*- ------------
-- @File   : signals.lua
-- @Author : Marcel Arpogaus <marcel dot arpogaus at gmail dot com>
--
-- @Created: 2021-02-03 16:34:33 (Marcel Arpogaus)
-- @Changed: 2021-01-20 08:37:53 (Marcel Arpogaus)
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
        if client.titlebar == nil then
            client:emit_signal('request::titlebars', 'rules', {})
        end
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
                -- Set the windows at the slave,
                -- i.e. put it at the end of others instead of setting it master.
                -- if not awesome.startup then awful.client.setslave(c) end

                if capi.awesome.startup and not c.size_hints.user_position and
                    not c.size_hints.program_position then
                    -- Prevent clients from being unreachable after screen count changes.
                    awful.placement.no_offscreen(c)
                end
                setTitlebar(c, c.floating or c.first_tag.layout.name ==
                                'floating')
            end,
            ['property::floating'] = function(c)
                local l = awful.layout.get(c.screen).name
                setTitlebar(c, c.floating or l == 'floating')
            end
        },
        tag = {
            ['property::layout'] = function(t)
                for _, c in pairs(t:clients()) do
                    if (t.layout.name == 'floating' or c.floating) then
                        setTitlebar(c, true)
                    else
                        setTitlebar(c, false)
                    end
                end
            end
        }
    }

end

-- [ return module ] -----------------------------------------------------------
return module
