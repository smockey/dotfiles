-- Themes define colours, icons, and wallpapers
beautiful.init("/home/tlarrieu/.config/awesome/themes/awesome-solarized/light/theme.lua")

-- Wallpapers
wallpapers = {
  "/home/tlarrieu/Pictures/Wallpapers/transistor/transistor-2.jpg",
  "/home/tlarrieu/Pictures/Wallpapers/transistor/transistor-3.jpg",
  "/home/tlarrieu/Pictures/Wallpapers/hatsune_miku/Vocaloid-Anime-Hatsune-Miku-Append-tsunekun-664585.jpeg",
}
for s = 1, screen.count() do
  gears.wallpaper.maximized(wallpapers[s], s, false)
end

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.magnifier,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
  tags[s] = awful.tag({ "1", "2", "3", "4", "5" }, s, layouts[1])
end
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a systray
--mysystray = widget({ type = "systray" })
mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                      awful.button({        }, 1, awful.tag.viewonly),
                      awful.button({ modkey }, 1, awful.client.movetotag),
                      awful.button({        }, 3, awful.tag.viewtoggle),
                      awful.button({ modkey }, 3, awful.client.toggletag),
                      awful.button({        }, 4, awful.tag.viewnext),
                      awful.button({        }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                            if not c:isvisible() then
                                              awful.tag.viewonly(c:tags()[1])
                                            end
                                            client.focus = c
                                            c:raise()
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
  --mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })
  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])
  if s == 1 then left_layout:add(wibox.widget.systray()) end

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  right_layout:add(mytextclock)
  right_layout:add(mylayoutbox[s])

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)

  mywibox[s]:set_widget(layout)
end
-- }}}
