local awful = require("awful")
require("awful.rules")
local beautiful = require("beautiful")
local helpers = require("helpers")

awful.rules.rules = {
  -- [[ Common rules ]] --------------------------------------------------------
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      keys = clientkeys,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      buttons = clientbuttons,
      placement = awful.placement.no_overlap +
        awful.placement.no_offscreen +
        awful.placement.centered,
      screen = awful.screen.preferred,
      callback = helpers.create_tag_and_attach_to
    },
  },

  -- [[ Kitty ]] ---------------------------------------------------------------
  {
    rule = { class = "kitty" },
    properties = { size_hints_honor = false },
  },

  -- [[ Flash player ]] --------------------------------------------------------
  {
    rule = { class = "Plugin-container" },
    properties = {
      floating = true,
      ontop = true,
      border = 0,
    },
  },

  -- [[ Multimedia ]] ----------------------------------------------------------
  {
    rule_any = {
      class = {
        "mpv",
        "Pavucontrol",
        "ncpamixer",
      },
    },
    properties = { fullscreen = true },
  },

  -- [[ Gnuplot ]] -------------------------------------------------------------
  {
    rule = { class = "Gnuplot" },
    properties = { fullscreen = true },
  },

  -- [[ Games ]] ---------------------------------------------------------------
  {
    rule_any = {
      class = {
        "Minecraft",
        "Gvba",
        "mednafen",
      },
    },
    properties = { floating = true },
  },

  {
    rule = { class = "Slay the Spire" },
    properties = { fullscreen = true },
  },
}
