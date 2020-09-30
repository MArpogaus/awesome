--------------------------------------------------------------------------------
-- @File:   mouse_bindings.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 11:56:04
-- [ description ] -------------------------------------------------------------
-- ...
-- [ license ] -----------------------------------------------------------------
-- ...
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
-- grab environment
local client = client

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')

-- helper functions
local helpers = require('rc.helper_functions')

-- configuration
local config = helpers.load_config()

-- the main menu
local menu = require('rc.menu')
local mymainmenu = menu.mainmenu

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- Default modkey.
local modkey = config.modkey

-- [ local functions ] ---------------------------------------------------------
local function client_menu_toggle_fn()
    local instance = nil
    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({theme = {width = 250}})
        end
    end
end

-- [ module objects ] ----------------------------------------------------------
module.taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end), awful.button(
        {modkey}, 1,
        function(t) if client.focus then client.focus:move_to_tag(t) end end
    ), awful.button({}, 3, awful.tag.viewtoggle), awful.button(
        {modkey}, 3,
        function(t) if client.focus then client.focus:toggle_tag(t) end end
    ), awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)
module.tasklist_buttons = gears.table.join(
    awful.button(
        {}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end
    ), awful.button({}, 3, client_menu_toggle_fn()),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)
module.client_buttons = gears.table.join(
    awful.button(
        {}, 1, function(c)
            client.focus = c;
            c:raise()
            mymainmenu:hide()
        end
    ), awful.button({modkey}, 1, awful.mouse.client.move),
    awful.button({modkey}, 3, awful.mouse.client.resize)
)
module.root = gears.table.join(
    awful.button({}, 1, function() mymainmenu:hide() end),
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
)
-- [ return module ] -----------------------------------------------------------
return module
