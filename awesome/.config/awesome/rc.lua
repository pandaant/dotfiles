-- some variables
hostname = io.popen("uname -n"):read()
home_dir = io.popen("pwd"):read()
host_dir = home_dir .. "/.config/awesome/host_specific/" .. hostname .. "/"

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local lain = require("lain")

local function warp_mouse()
    c = client.focus
    if c then
        local g = c:geometry()
        mouse.coords { x = g.x + 15, y = g.y + 15 }
    end
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- Setup directories
config_dir = (os.getenv("HOME").."/.config/awesome/")
themes_dir = (config_dir .. "/powerarrowf")

beautiful.init(themes_dir .. "/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
browser = "chromium"
musicplayer = "deadbeef"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
filebrowser_cmd = terminal .. " -e vifm" 

-- {{ Powerarrow-dark separators }} --
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_ld = wibox.widget.imagebox()
arrl_ld:set_image(beautiful.arrl_ld)
arrl_dl = wibox.widget.imagebox()
arrl_dl:set_image(beautiful.arrl_dl)

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    lain.layout.uselesstile,
    lain.layout.centerwork,
    awful.layout.suit.floating
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --lain.layout.uselessfair,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
-- for s = 1, screen.count() do
    -- Each screen has its own tag table.
--    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
-- end

tags[1] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9, "im", "mail" }, 1, layouts[1])

if screen.count() == 2 then
    tags[2] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, 2, layouts[1])
end
if screen.count() == 3 then
    tags[2] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, 2, layouts[1])
    tags[3] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, 3, layouts[1])
end

-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

--{{-- Time and Date Widget }} --
tdwidget = wibox.widget.textbox()
vicious.register(tdwidget, vicious.widgets.date, '<span font="Inconsolata 11" color="#AAAAAA" background="#1F2428"> %b %d %I:%M </span>', 20)

clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.clock)

--{{ Battery Widget }} --

batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, '<span font="Inconsolata 11" color="#AAAAAA" background="#1F2428">$1$2% </span>', 30, "BAT0")

baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.ac)
--{{ Net Widget }} --

netwidget = wibox.widget.textbox()
neticon = wibox.widget.imagebox()

vicious.register(netwidget, vicious.widgets.net, function(widgets,args)
        local interface = ""
        if args["{wlp2s0 carrier}"] == 1 then
                interface = "wlp2s0"
        elseif args["{enp7s0 carrier}"] == 1 then
                interface = "enp7s0"
        else
                return ""
        end
        return '<span font="Inconsolata 11" color="#AAAAAA" background="#313131">' ..args["{"..interface.." down_kb}"]..'kbps'..'</span>' end, 10)
netwidget:buttons(awful.util.table.join(awful.button({ }, 1, function() awful.util.spawn_with_shell('wicd-client -n') end)))


---{{---| Wifi Signal Widget |-------
vicious.register(neticon, vicious.widgets.wifi, function(widget, args)
    local sigstrength = tonumber(args["{link}"])
    if sigstrength > 69 then
        neticon:set_image(beautiful.nethigh)
    elseif sigstrength > 40 and sigstrength < 70 then
        neticon:set_image(beautiful.netmedium)
    else
        neticon:set_image(beautiful.netlow)
    end
end, 120, 'wlp2s0')

-- {{ Volume Widget }} --

volume = wibox.widget.textbox()
vicious.register(volume, vicious.widgets.volume, '<span font="Inconsolata 11" color="#AAAAAA" background="#1F2428"> Vol:$1 </span>', 0.2, "Master")

volumeicon = wibox.widget.imagebox()
vicious.register(volumeicon, vicious.widgets.volume, function(widget, args)
        local paraone = tonumber(args[1])

        if args[2] == "♩" or paraone == 0 then
                volumeicon:set_image(beautiful.mute)
        elseif paraone >= 67 and paraone <= 100 then
                volumeicon:set_image(beautiful.music)
        elseif paraone >= 33 and paraone <= 66 then
                volumeicon:set_image(beautiful.music)
        else
                volumeicon:set_image(beautiful.music)
        end

end, 0.3, "Master")

--{{--| MEM widget |-----------------
memwidget = wibox.widget.textbox()

vicious.register(memwidget, vicious.widgets.mem, '<span background="#1F2428" font="Inconsolata 11"> <span font="Inconsolata 11" color="#AAAAAA" background="#1F2428">$2MB </span></span>', 20)
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.mem)

--{{---| CPU / sensors widget |-----------
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu,
'<span background="#313131" font="Inconsolata 11"> <span font="Inconsolata 11" color="#AAAAAA">$2%<span color="#888888">·</span>$3%<span color="#888888">·</span>$4%<span color="#888888">·</span>$5%<span color="#888888">·</span>$6%<span color="#888888">·</span>$7%</span></span>', 5)

cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.cpu)

--{{---| File Size widget |-----
fswidget = wibox.widget.textbox()

vicious.register(fswidget, vicious.widgets.fs,
'<span background="#313131" font="Inconsolata 11"> <span font="Inconsolata 11" color="#AAAAAA">${/home used_p}%/${/home avail_p} GB </span></span>', 800)

fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.hdd)

-- {{ GMail Widget }} --
mailicon = wibox.widget.imagebox()
vicious.register(mailicon, vicious.widgets.gmail, function(widget, args)
    local newMail = tonumber(args["{count}"])
    if newMail > 0 then
        mailicon:set_image(beautiful.mail)
    else
        mailicon:set_image(beautiful.mailopen)
    end
end, 15)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 16 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    --right_layout:add(arrl_ld)
    --right_layout:add(mailicon)
    --right_layout:add(arrl_dl)
    right_layout:add(arrl_ld)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(arrl_dl)
    --right_layout:add(volumeicon)
    --right_layout:add(volume)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(arrl_ld)
    right_layout:add(fsicon)
    right_layout:add(fswidget)
    right_layout:add(arrl_dl)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(arrl_ld)
    right_layout:add(neticon)
    right_layout:add(netwidget)
    right_layout:add(arrl_dl)
    right_layout:add(clockicon)
    right_layout:add(tdwidget)
    right_layout:add(arrl_ld)
    right_layout:add(mylayoutbox[s])
    right_layout:add(arrl_dl)
    if s == 1 then right_layout:add(wibox.widget.systray()) end

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({modkey}, "#121", function() 
        awful.util.spawn(musicplayer .. " --toggle-pause & ")    
        naughty.notify({text="Play/Pause", timeout = 1})  
    end  ),
    awful.key({}, "#121", function() 
        awful.util.spawn("pamixer --toggle-mute")    
        naughty.notify({text="Mute/Unmute", timeout = 1})  
    end  ),
    awful.key({}, "#122", function() 
        awful.util.spawn("pamixer --decrease 10")    
        naughty.notify({text="Lowering volume", timeout = 1})  
    end  ),
    awful.key({modkey}, "#122", function() 
        awful.util.spawn(musicplayer .. " --prev &")    
        local song = awful.util.pread(musicplayer .. " --nowplaying \"%a - %t\"") 
        naughty.notify({text="Previous song:\n" .. song, timeout = 2})  
    end  ),
    awful.key({}, "#123", function()
        awful.util.spawn("pamixer --increase 10")    
        naughty.notify({text="Increasing volume", timeout = 1}) 
    end  ),
    awful.key({modkey}, "#123", function() 
        awful.util.spawn(musicplayer .. " --next &")    
        local song = awful.util.pread(musicplayer .. " --nowplaying \"%a - %t\"") 
        naughty.notify({text="Next Song:\n" .. song, timeout = 2})  
    end  ),
    awful.key({}, "#148", function() naughty.notify({text="Special Key", timeout = 1})  end  ),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            warp_mouse()
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            warp_mouse()
            if client.focus then client.focus:raise() end
        end),
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "+",      function () awful.util.spawn(browser) end),
    awful.key({ modkey }, "+",      function () awful.util.spawn(filebrowser_cmd) end),
    awful.key({ modkey, "Shift"   }, "o",      function () os.execute(",update_wallpaper") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- additional tags          
    awful.key({ modkey           }, "i",      
                    function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[10]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
    awful.key({ modkey, "Shift"     }, "i",      
                    function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[11]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
    awful.key({ modkey,           }, "b",      function () 
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),
    -- Menubar
    awful.key({ modkey }, "p", function()
        awful.util.spawn( 'rofi -show run -font "Inconsolata 10" -fg "" -bg "#000000" -hlfg "#000000" -hlbg "#CCCCCC" -o 85' )
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Control" }, ".",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     -- fills up useless corners from terminal
                     size_hints_honor = false,
                     buttons = clientbuttons } },
    -- Set Firefox to always map on tags number 2 of screen 1.
     { rule = { class = "Pidgin" },
       properties = { tag = tags[1][10] } },
     { rule = { name = "irssi" },
       properties = { tag = tags[1][10] } },
     { rule = { class = "Thunderbird" },
       properties = { tag = tags[1][11] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- for transparency
os.execute(",run_once xcompmgr")

-- change background every 10 min
os.execute(",run_once ,wallpaper_changer 600")

-- run zeal
os.execute(",run_once zeal")

-- load hostspecific settings
dofile(host_dir .. "post_hook.lua")
