--------------------------------------------------------------------------------
-- @File:   key_bindings.lua
-- @Author: marcel
-- @Date:   2019-12-03 13:53:32
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-08 11:19:52
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
local capi = {awesome = awesome, client = client, screen = screen, root = root}

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')

-- Theme handling library
local menubar = require('menubar')

-- hotkeys widget
local hotkeys_popup = require('awful.hotkeys_popup').widget

-- Mac OSX like 'Exposé' view
local revelation = require('revelation')

-- helper functions
local helpers = require('rc.helper_functions')
local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.init = function(config, mainmenu)
    -- This is used later as the default terminal and editor to run.
    local browser = config.browser
    local terminal = config.terminal
    local lock_command = config.lock_command

    -- Default modkey.
    local modkey = config.modkey
    local altkey = config.altkey

    module.global_keys = gears.table.join(
        -- [ awesome ]--------------------------------------------------------------
        awful.key(
            {modkey}, 's', hotkeys_popup.show_help,
            {description = 'show help', group = 'awesome'}
        ), awful.key(
            {modkey, 'Control'}, 'r', capi.awesome.restart,
            {description = 'reload awesome', group = 'awesome'}
        ), awful.key(
            {modkey}, 'q', function() awful.spawn(lock_command) end,
            {description = 'lock screen', group = 'awesome'}
        ), awful.key(
            {modkey, 'Shift'}, 'q', capi.awesome.quit,
            {description = 'quit awesome', group = 'awesome'}
        ), awful.key(
            {modkey}, 'w', function() mainmenu:show() end,
            {description = 'show main menu', group = 'awesome'}
        ), awful.key(
            {modkey, 'Shift'}, 'b', function()
                for s in capi.screen do
                    s.mytopwibar.visible = not s.mytopwibar.visible
                    s.mybottomwibar.visible = not s.mybottomwibar.visible
                end
            end, {description = 'toggle wibox', group = 'awesome'}
        ), awful.key(
            {modkey}, 'e', revelation,
            {description = 'Mac OSX like \'Exposé\' view', group = 'awesome'}
        ), awful.key(
            {modkey}, 'r', function()
                awful.prompt.run(
                    {
                        prompt = "Run: ",
                        hooks = {
                            {
                                {},
                                "Return",
                                function(command)
                                    local result = awful.spawn(command)
                                    awful.screen.focused().mypromptbox.widget:set_text(
                                        type(result) == "string" and result or
                                            ""
                                    )
                                    return true
                                end
                            },
                            {
                                {altkey},
                                "Return",
                                function(command)
                                    local result =
                                        awful.spawn(
                                            command, {
                                                tag = awful.screen.focused()
                                                    .selected_tag,
                                                intrusive = true
                                            }
                                        )
                                    awful.screen.focused().mypromptbox.widget:set_text(
                                        type(result) == "string" and result or
                                            ""
                                    )
                                    return true
                                end
                            },
                            {
                                {"Shift"},
                                "Return",
                                function(command)
                                    local result =
                                        awful.spawn(
                                            command, {
                                                intrusive = true,
                                                ontop = true,
                                                floating = true
                                            }
                                        )
                                    awful.screen.focused().mypromptbox.widget:set_text(
                                        type(result) == "string" and result or
                                            ""
                                    )
                                    return true
                                end
                            }
                        }
                    }, awful.screen.focused().mypromptbox.widget, nil,
                    awful.completion.shell,
                    awful.util.getdir("cache") .. "/history"
                )
            end, {description = 'run prompt', group = 'awesome'}
        ), awful.key(
            {modkey}, 'ö', function()
                awful.prompt.run {
                    prompt = 'Run Lua code: ',
                    textbox = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. '/history_eval'
                }
            end, {description = 'lua execute prompt', group = 'awesome'}
        ),
        -- [ tag ]------------------------------------------------------------------
        awful.key(
            {modkey}, 'Left', awful.tag.viewprev,
            {description = 'view previous', group = 'tag'}
        ), awful.key(
            {modkey}, 'Right', awful.tag.viewnext,
            {description = 'view next', group = 'tag'}
        ), awful.key(
            {modkey}, 'Escape', awful.tag.history.restore,
            {description = 'go back', group = 'tag'}
        ), awful.key(
            {modkey, 'Shift'}, 'n', helpers.add_tag,
            {description = 'add new tag', group = 'tag'}
        ), awful.key(
            {modkey, 'Shift'}, 'r', helpers.rename_tag,
            {description = 'rename tag', group = 'tag'}
        ), awful.key(
            {modkey, 'Shift'}, 'Left', function()
                helpers.move_tag(-1)
            end, {description = 'move tag to the left', group = 'tag'}
        ), awful.key(
            {modkey, 'Shift'}, 'Right', function()
                helpers.move_tag(1)
            end, {description = 'move tag to the right', group = 'tag'}
        ), awful.key(
            {modkey, 'Shift'}, 'd', helpers.delete_tag,
            {description = 'delete tag', group = 'tag'}
        ), awful.key(
            {modkey, 'Shift'}, 'f', helpers.fork_tag,
            {description = 'fork tag', group = 'tag'}
        ),
        -- [ screen ]---------------------------------------------------------------
        awful.key(
            {modkey, 'Control'}, 'j',
            function() awful.screen.focus_relative(1) end,
            {description = 'focus the next screen', group = 'screen'}
        ), awful.key(
            {modkey, 'Control'}, 'k',
            function() awful.screen.focus_relative(-1) end,
            {description = 'focus the previous screen', group = 'screen'}
        ),
        -- [ client ]---------------------------------------------------------------
        awful.key(
            {modkey, 'Shift'}, 'j', function()
                awful.client.swap.byidx(1)
            end,
            {description = 'swap with next client by index', group = 'client'}
        ), awful.key(
            {modkey, 'Shift'}, 'k', function()
                awful.client.swap.byidx(-1)
            end, {
                description = 'swap with previous client by index',
                group = 'client'
            }
        ), awful.key(
            {modkey}, 'u', awful.client.urgent.jumpto,
            {description = 'jump to urgent client', group = 'client'}
        ), awful.key(
            {modkey}, 'Tab', function()
                awful.client.focus.history.previous()
                if capi.client.focus then
                    capi.client.focus:raise()
                end
            end, {description = 'go back', group = 'client'}
        ), awful.key(
            {modkey}, 'j', function() awful.client.focus.byidx(1) end,
            {description = 'focus next by index', group = 'client'}
        ), awful.key(
            {modkey}, 'k', function() awful.client.focus.byidx(-1) end,
            {description = 'focus previous by index', group = 'client'}
        ), awful.key(
            {modkey, 'Control'}, 'n', function()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    capi.client.focus = c
                    c:raise()
                end
            end, {description = 'restore minimized', group = 'client'}
        ), awful.key(
            {altkey, "Control"}, "+", function()
                helpers.gaps_resize(2)
            end, {description = "increment useless gaps", group = "client"}
        ), awful.key(
            {altkey, "Control"}, "-", function()
                helpers.gaps_resize(-2)
            end, {description = "decrement useless gaps", group = "client"}
        ), awful.key(
            {altkey}, "Tab", helpers.application_switcher,
            {description = 'restore minimized', group = 'client'}
        ),
        -- [ launcher ]-------------------------------------------------------------
        awful.key(
            {modkey}, 'p', function() menubar.show() end,
            {description = 'show the menubar', group = 'launcher'}
        ), awful.key(
            {modkey}, 'Return',
            function() awful.spawn(terminal, {intrusive = true}) end,
            {description = 'open a terminal', group = 'launcher'}
        ), awful.key(
            {modkey, 'Shift'}, 'Return', function()
                awful.spawn(
                    terminal, {intrusive = true, floating = true, ontop = true}
                )
            end, {description = 'open a floating terminal', group = 'launcher'}
        ), awful.key(
            {modkey}, 'space',
            function()
                awful.spawn('/usr/bin/rofi -show drun -modi drun')
            end, {description = 'launch rofi', group = 'launcher'}
        ), awful.key(
            {modkey}, 'b', function() awful.spawn(browser) end,
            {description = 'launch Browser', group = 'launcher'}
        ), awful.key(
            {modkey}, 'a', function()
                awful.spawn.with_shell('$HOME/.emacs.d/bin/org-capture')
            end, {description = 'launch org capture', group = 'launcher'}
        ),
        -- [ layout ]---------------------------------------------------------------
        awful.key(
            {modkey}, 'l', function() awful.tag.incmwfact(0.05) end,
            {description = 'increase master width factor', group = 'layout'}
        ), awful.key(
            {modkey}, 'h', function() awful.tag.incmwfact(-0.05) end,
            {description = 'decrease master width factor', group = 'layout'}
        ), awful.key(
            {modkey, 'Shift'}, 'h',
            function() awful.tag.incnmaster(1, nil, true) end, {
                description = 'increase the number of master clients',
                group = 'layout'
            }
        ), awful.key(
            {modkey, 'Shift'}, 'l',
            function() awful.tag.incnmaster(-1, nil, true) end, {
                description = 'decrease the number of master clients',
                group = 'layout'
            }
        ), awful.key(
            {modkey, 'Control'}, 'h',
            function() awful.tag.incncol(1, nil, true) end,
            {description = 'increase the number of columns', group = 'layout'}
        ), awful.key(
            {modkey, 'Control'}, 'l',
            function() awful.tag.incncol(-1, nil, true) end,
            {description = 'decrease the number of columns', group = 'layout'}
        ), awful.key(
            {modkey, 'Shift'}, 'space', function()
                awful.layout.inc(1)
            end, {description = 'select previous', group = 'layout'}
        ),
        -- [ screenshot ]-----------------------------------------------------------
        awful.key(
            {}, 'Print', function()
                awful.spawn.with_shell('sleep 0.1 && /usr/bin/i3-scrot -d')
            end, {description = 'capture a screenshot', group = 'screenshot'}
        ), awful.key(
            {'Control'}, 'Print', function()
                awful.spawn.with_shell('sleep 0.1 && /usr/bin/i3-scrot -w')
            end, {
                description = 'capture a screenshot of active window',
                group = 'screenshot'
            }
        ), awful.key(
            {'Shift'}, 'Print', function()
                awful.spawn.with_shell('sleep 0.1 && /usr/bin/i3-scrot -s')
            end, {
                description = 'capture a screenshot of selection',
                group = 'screenshot'
            }
        ),
        -- [ theme ]----------------------------------------------------------------
        awful.key(
            {modkey, altkey, 'Control'}, 'l', util.set_light,
            {description = 'set light colorscheme', group = 'theme'}
        ), awful.key(
            {modkey, altkey, 'Control'}, 'm', util.set_mirage,
            {description = 'set mirage colorscheme', group = 'theme'}
        ), awful.key(
            {modkey, altkey, 'Control'}, 'd', util.set_dark,
            {description = 'set dark colorscheme', group = 'theme'}
        ), awful.key(
            {modkey, altkey, 'Control'}, '+', function()
                util.inc_dpi(10)
            end, {description = 'increase dpi', group = 'theme'}
        ), awful.key(
            {modkey, altkey, 'Control'}, '-', function()
                util.dec_dpi(10)
            end, {description = 'decrease dpi', group = 'theme'}
        ),
        -- [ widgets ]--------------------------------------------------------------
        awful.key(
            {modkey, 'Shift'}, 'w', util.toggle_widgets,
            {description = 'toggle widgets', group = 'widgets'}
        ), awful.key(
            {modkey, altkey, 'Shift'}, 'w',
            util.toggle_desktop_widget_visibility, {
                description = 'toggle desktop widget visibility',
                group = 'widgets'
            }
        ), awful.key(
            {modkey, 'Shift'}, 'u', util.update_widgets,
            {description = 'update widgets', group = 'widgets'}
        )
    )

    module.client_keys = gears.table.join(
        awful.key(
            {modkey}, 'f', function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end, {description = 'toggle fullscreen', group = 'client'}
        ), awful.key(
            {modkey}, 'x', function(c) c:kill() end,
            {description = 'close', group = 'client'}
        ), awful.key(
            {modkey, 'Control'}, 'space', function(c)
                awful.client.floating.toggle(c)
                c:raise()
            end, {description = 'toggle floating', group = 'client'}
        ), awful.key(
            {modkey, 'Control'}, 'Return',
            function(c) c:swap(awful.client.getmaster()) end,
            {description = 'move to master', group = 'client'}
        ), awful.key(
            {modkey}, 'o', function(c) c:move_to_screen() end,
            {description = 'move to screen', group = 'client'}
        ), awful.key(
            {modkey}, 't', function(c) c.ontop = not c.ontop end,
            {description = 'toggle keep on top', group = 'client'}
        ), awful.key(
            {modkey}, 'n', function(c) c.minimized = true end,
            {description = 'minimize', group = 'client'}
        ), awful.key(
            {modkey}, 'm', function(c)
                c.maximized = not c.maximized
                c:raise()
            end, {description = '(un)maximize', group = 'client'}
        ), awful.key(
            {modkey, 'Control'}, 'm', function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end, {description = '(un)maximize vertically', group = 'client'}
        ), awful.key(
            {modkey, 'Shift'}, 'm', function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end, {description = '(un)maximize horizontally', group = 'client'}
        )
    )

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 9 do
        -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
        local descr_view, descr_toggle, descr_move, descr_toggle_focus
        if i == 1 or i == 9 then
            descr_view = {description = 'view tag #', group = 'tag'}
            descr_toggle = {description = 'toggle tag #', group = 'tag'}
            descr_move = {
                description = 'move focused client to tag #',
                group = 'tag'
            }
            descr_toggle_focus = {
                description = 'toggle focused client on tag #',
                group = 'tag'
            }
        end
        module.global_keys = gears.table.join(
            module.global_keys, -- View tag only.
            awful.key(
                {modkey}, '#' .. i + 9, function()
                    local s = awful.screen.focused()
                    local tag = s.tags[i]
                    if tag then tag:view_only() end
                end, descr_view
            ),
            -- [ toggle tag display ]-----------------------------------------------
            awful.key(
                {modkey, 'Control'}, '#' .. i + 9, function()
                    local s = awful.screen.focused()
                    local tag = s.tags[i]
                    if tag then awful.tag.viewtoggle(tag) end
                end, descr_toggle
            ),
            -- [ move client to tag ]-----------------------------------------------
            awful.key(
                {modkey, 'Shift'}, '#' .. i + 9, function()
                    if capi.client.focus then
                        local tag = capi.client.focus.screen.tags[i]
                        if tag then
                            capi.client.focus:move_to_tag(tag)
                        end
                    end
                end, descr_move
            ),
            -- [ toggle tag on focused client ]-------------------------------------
            awful.key(
                {modkey, 'Control', 'Shift'}, '#' .. i + 9, function()
                    if capi.client.focus then
                        local tag = capi.client.focus.screen.tags[i]
                        if tag then
                            capi.client.focus:toggle_tag(tag)
                        end
                    end
                end, descr_toggle_focus
            )
        )
    end

    -- register global key bindings
    capi.root.keys(module.global_keys)
end

-- [ return module ] -----------------------------------------------------------
return module
