--------------------------------------------------------------------------------
-- @File:   mouse_bindings.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-06 12:46:10
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
-- grab environment
local capi = {client = client, root = root}

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
local function client_menu_toggle_fn()
    local instance = nil
    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({theme = {width = 1000}})
        end
    end
end
-- ref.: https://stackoverflow.com/questions/62286322/grouping-windows-in-the-tasklist
local function client_label(c)
    local theme = beautiful.get()
    local sticky = theme.tasklist_sticky or '▪'
    local ontop = theme.tasklist_ontop or '⌃'
    local above = theme.tasklist_above or '▴'
    local below = theme.tasklist_below or '▾'
    local floating = theme.tasklist_floating or '✈'
    local minimized = theme.tasklist_maximized or '-'
    local maximized = theme.tasklist_maximized or '+'
    local maximized_horizontal = theme.tasklist_maximized_horizontal or '⬌'
    local maximized_vertical = theme.tasklist_maximized_vertical or '⬍'

    local name = c.name
    if c.sticky then name = sticky .. name end

    if c.ontop then
        name = ontop .. name
    elseif c.above then
        name = above .. name
    elseif c.below then
        name = below .. name
    end

    if c.minimized then name = minimized .. name end
    if c.maximized then
        name = maximized .. name
    else
        if c.maximized_horizontal then
            name = maximized_horizontal .. name
        end
        if c.maximized_vertical then name = maximized_vertical .. name end
        if c.floating then name = floating .. name end
    end

    return name
end

local function client_stack_toggle_fn()
    local cl_menu
    return function(c)
        if cl_menu then
            cl_menu:hide()
            cl_menu = nil
        else
            local client_num = 0
            local client_list = {}
            for i, cl in ipairs(capi.client.get()) do
                if cl.class == c.class then
                    client_num = client_num + 1
                    client_list[i] = {
                        client_label(cl),
                        function()
                            capi.client.focus = cl
                            cl:tags()[1]:view_only()
                            cl:raise()
                        end,
                        cl.icon
                    }
                end
            end

            if client_num > 1 then
                cl_menu = awful.menu(
                    {items = client_list, theme = {width = 1000}}
                )
                cl_menu:show()
            else
                capi.client.focus = c
                c:tags()[1]:view_only()
                c:raise()
            end
        end
    end
end

-- [ module function ] ---------------------------------------------------------
module.init = function(config, mainmenu)
    -- Default modkey.
    local modkey = config.modkey

    module.taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t) t:view_only() end), awful.button(
            {modkey}, 1, function(t)
                if capi.client.focus then
                    capi.client.focus:move_to_tag(t)
                end
            end
        ), awful.button({}, 3, awful.tag.viewtoggle), awful.button(
            {modkey}, 3, function(t)
                if capi.client.focus then
                    capi.client.focus:toggle_tag(t)
                end
            end
        ), awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
    )
    if config.tasklist == 'windows' or beautiful.tasklist == 'windows' then
        module.tasklist_buttons = gears.table.join(
            awful.button({}, 1, client_stack_toggle_fn()),
            awful.button({}, 3, client_menu_toggle_fn()),
            awful.button(
                {}, 4, function() awful.client.focus.byidx(1) end
            ), awful.button(
                {}, 5, function() awful.client.focus.byidx(-1) end
            )
        )
    else
        module.tasklist_buttons = gears.table.join(
            awful.button(
                {}, 1, function(c)
                    if c == capi.client.focus then
                        c.minimized = true
                    else
                        c:emit_signal(
                            'request::activate', 'tasklist', {raise = true}
                        )
                    end
                end
            ), awful.button(
                {}, 3,
                function()
                    awful.menu.client_list({theme = {width = 250}})
                end
            ), awful.button(
                {}, 4, function() awful.client.focus.byidx(1) end
            ), awful.button(
                {}, 5, function() awful.client.focus.byidx(-1) end
            )
        )
    end
    module.client_buttons = gears.table.join(
        awful.button(
            {}, 1, function(c)
                capi.client.focus = c;
                c:raise()
                mainmenu:hide()
            end
        ), awful.button({modkey}, 1, awful.mouse.client.move),
        awful.button({modkey}, 3, awful.mouse.client.resize)
    )
    local root = gears.table.join(
        awful.button({}, 1, function() mainmenu:hide() end),
        awful.button({}, 3, function() mainmenu:toggle() end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    )
    capi.root.buttons(root)
end

-- [ return module ] -----------------------------------------------------------
return module