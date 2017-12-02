--[[
Licensed under GNU General Public License v2
* (c) 2013-2014  Yauheni Kirylau
--]]

local awful = require("awful")
local beautiful = require("beautiful")


local tag_helpers = {}


function tag_helpers.toggle_gap(t)
  t = t or awful.screen.focused().selected_tag
  local current_gap = t.gap
  local new_gap
  if current_gap == 0 then
    new_gap = beautiful.useless_gap
  else
    new_gap = 0
  end
  t.gap = new_gap
end


function tag_helpers.noempty_list(s)
  s = s or awful.screen.focused()
  local vtags = {}
  for _, t in pairs(s.tags) do
    if awful.widget.taglist.filter.noempty(t) then
      vtags[#vtags + 1] = t
    end
  end
  return vtags
end


function tag_helpers.get_idx(target_tag, tag_list, s)
  s = s or awful.screen.focused()
  tag_list = tag_list or s.tags
  for idx, t in ipairs(tag_list) do
    if t == target_tag then
      return idx
    end
  end
end


function tag_helpers.view_noempty(delta, s)
  s = s or awful.screen.focused()
  local selected_tag = s.selected_tag
  local noempty_tags = tag_helpers.noempty_list(s)
  local target_tag_local_idx = tag_helpers.get_idx(selected_tag, noempty_tags, s) + delta
  if target_tag_local_idx < 1 then
    target_tag_local_idx = #noempty_tags
  elseif target_tag_local_idx > #noempty_tags then
    target_tag_local_idx = 1
  end
  local current_idx = s.selected_tag.index
  local target_idx = noempty_tags[target_tag_local_idx].index
  local idx_delta = current_idx - target_idx
  awful.tag.viewidx(-idx_delta, s)
end


function tag_helpers.get_tiled(t)
    local clients = t:clients()
    local tclients = {}
    -- Remove floating clients
    for _, c in pairs(clients) do
        if not c.floating
            and not c.fullscreen
            and not c.maximized_vertical
            and not c.maximized_horizontal then
            table.insert(tclients, c)
        end
    end
    return tclients
end


return tag_helpers
