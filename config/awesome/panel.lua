local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local dpi = require('beautiful.xresources').apply_dpi

local lain = require("lain")

local colorize = function(widget, value)
  local color

  if value > 80 then
    color = beautiful.colors.red.dark
  elseif value > 70 then
    color = beautiful.colors.red.light
  elseif value > 40 then
    color = beautiful.colors.yellow.dark
  else
    color = beautiful.colors.green.dark
  end

  widget:set_values({ value })
  widget:set_colors({ color })
end

local arcprogress = function(label)
  local text = wibox.widget({
    valign = "center",
    align = "center",
    widget = wibox.widget.textbox,
  })
  local arcchart = wibox.container({
    text,
    widget = wibox.container.arcchart,
    min_value = 0,
    max_value = 100,
    bg = beautiful.colors.white.dark,
    thickness = dpi(3),
  })
  arcchart:connect_signal("widget::redraw_needed", function(widget)
    if widget:get_colors() == nil then return end

    local markup = lain.util.markup(widget:get_colors()[1], label)

    text:set_markup(lain.util.markup.small(markup))
  end)

  return arcchart
end

-- [[ CPU ]] -------------------------------------------------------------------
local cpu = arcprogress("C")
lain.widgets.cpu({
  timeout = 2,
  settings = function(cpu_now) colorize(cpu, cpu_now.usage) end
})

-- [[ MEM ]] -------------------------------------------------------------------
local mem = arcprogress("M")
lain.widgets.mem({
  timeout = 2,
  settings = function(mem_now) colorize(mem, mem_now.perc) end
})

-- [[ Clock ]] -----------------------------------------------------------------
local clock = wibox.widget({
  widget = wibox.widget.textclock,
  format = "%Y.%m.%d %H:%M",
})

-- [[ Battery ]] ---------------------------------------------------------------
local batterytext = wibox.widget.textbox()
local batterybar = wibox.widget({
  widget = wibox.widget.progressbar,
  background_color = beautiful.colors.white.dark,
  bar_shape = gears.shape.rounded_rect,
  forced_width = dpi(90),
  shape = gears.shape.rounded_rect,
})
local battery = wibox.widget({
  batterytext,
  wibox.container.margin(batterybar, dpi(5), dpi(0), dpi(8), dpi(8)),
  layout = wibox.layout.fixed.horizontal
})
local battery_update = function(bat_now)
  if bat_now.status == "N/A" then return end

  local color, legend, icon

  -- legend
  if bat_now.time == "00:00" then
    legend = "100%"
  else
    legend = bat_now.time
  end

  -- color
  if bat_now.perc >= 98 then
    color = beautiful.colors.green.dark
  elseif bat_now.perc > 50 then
    color = beautiful.colors.yellow.dark
  elseif bat_now.perc > 15 then
    color = beautiful.colors.red.light
  else
    color = beautiful.colors.red.dark
  end

  -- icon
  if bat_now.perc == 100 then
    icon = "⚡ "
  else
    if bat_now.status == "Charging" then
      icon = " "
    else
      icon = " "
    end
  end

  batterytext:set_markup(lain.util.markup(color, icon .. legend))
  batterybar:set_color(color)
  batterybar:set_value(bat_now.perc / 100)
end

local pipe = io.popen('ls /sys/class/power_supply | grep BAT')
local batname
-- Pick the first entry in /sys/class/power_supply/BAT* as our battery name
for i in string.gmatch(pipe:read('*a'), "%S+") do
  batname = i
  break
end
pipe:close()

lain.widgets.bat({
  battery = batname,
  timeout = 15,
  settings = battery_update,
  notifications = {
    low = {
      fg = beautiful.colors.yellow.dark,
      bg = beautiful.colors.white.dark
    },
    critical = {
      fg = beautiful.colors.red.dark,
      bg = beautiful.colors.white.dark
    }
  }
})

-- [[ Screen initialization ]] -------------------------------------------------
local init_screen = function(screen)
  local tagbuttons = awful.util.table.join(
    awful.button({}, 1, function(tag) tag:view_only() end)
  )
  local taglist = awful.widget.taglist(
    screen,
    awful.widget.taglist.filter.all,
    tagbuttons,
    { spacing = dpi(6), font = "InconsolataForPowerline Nerd Font 24" }
  )

  local left = wibox.widget({
    wibox.container.margin(taglist, dpi(1), dpi(1), dpi(2), dpi(2)),
    layout = wibox.layout.fixed.horizontal
  })

  local middle = wibox.widget({
    clock,
    layout = wibox.layout.fixed.horizontal,
  })

  local right = wibox.widget({
    wibox.container.margin(cpu, dpi(0), dpi(5), dpi(2), dpi(2)),
    wibox.container.margin(mem, dpi(0), dpi(10), dpi(2), dpi(2)),
    wibox.container.margin(battery, dpi(1), dpi(0), dpi(1), dpi(1)),
    layout = wibox.layout.fixed.horizontal
  })
  right = wibox.container.margin(right, dpi(5), dpi(5), dpi(0), dpi(0))

  local barwidget = wibox.widget({
    left,
    middle,
    right,
    layout = wibox.layout.align.horizontal,
    expand = "none"
  })
  awful.wibar({
    position = "top",
    height = dpi(30),
    screen = screen,
    widget = wibox.container.margin(barwidget, dpi(2), dpi(2), dpi(2), dpi(2))
  })
end
awful.screen.connect_for_each_screen(init_screen)
