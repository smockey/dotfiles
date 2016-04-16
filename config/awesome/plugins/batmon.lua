-- This function returns a formatted string with the current battery status. It
-- can be used to populate a text widget in the awesome window manager. Based
-- on the "Gigamo Battery Widget" found in the wiki at awesome.naquadah.org

local naughty = require("naughty")
local beautiful = require("beautiful")

function readBatFile(adapter, ...)
  local basepath = "/sys/class/power_supply/"..adapter.."/"
  for i, name in pairs({...}) do
    file = io.open(basepath..name, "r")
    if file then
      local str = file:read()
      file:close()
      return str
    end
  end
end

function batteryInfo(adapter)
  local battery_state = {
      ["Full\n"]        = "↯",
      ["Unknown\n"]     = "⌁",
      ["Charged\n"]     = "↯",
      ["Charging\n"]    = "+",
      ["Discharging\n"] = "−"
  }

  local fh = io.open("/sys/class/power_supply/"..adapter.."/present", "r")
  if fh == nil then
    battery = "A/C"
    icon = ""
    percent = ""
  else
    local remaining = readBatFile(adapter, "charge_now", "energy_now")
    local capacity = readBatFile(adapter, "charge_full", "energy_full")
    local status = readBatFile(adapter, "status")
    battery = math.floor(remaining * 100 / capacity)

    local current_now = readBatFile(adapter, "current_now", "power_now")
    rate = tonumber(current_now)

    if status:match("Charging") then
      icon = "↑"
      percent = "%"
      timeleft = (tonumber(capacity) - tonumber(remaining)) / tonumber(rate)
    elseif status:match("Discharging") then
      icon = "↓"
      percent = "%"
      timeleft = tonumber(remaining) / tonumber(rate)

      if tonumber(battery) < 15 then
        if tonumber(battery) <= 5 then
          color = "red"
        else
          color = "orange"
        end
        naughty.notify(
          { title    = "Battery low"
          , text     = "<br/><span color = '"..color.."'>"..battery..percent.." ".."left!</span>"
          , timeout  = 5
          , position = "top_right"
          , fg       = beautiful.fg_focus
          , bg       = beautiful.bg_focus }
        )
      end
    else
      battery = "N/A"
      icon = "⌁"
      percent = ""
    end
  end

  if timeleft ~= nil then
    local hoursleft   = math.floor(timeleft)
    local minutesleft = math.floor((timeleft - hoursleft) * 60 )

    time = string.format(" (%02d:%02d)", hoursleft, minutesleft)
  else
    time = ""
  end

  return battery..percent.." "..icon..time
end