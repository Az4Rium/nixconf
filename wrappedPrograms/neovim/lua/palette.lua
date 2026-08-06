local M = {}

local KEYS = { "base00", "base01", "base02", "base03", "base04", "base05", "base06", "base07", "base08", "base09", "base0A", "base0B", "base0C", "base0D", "base0E", "base0F",}

local FALLBACK = {
  base00 = "#0a0e14", -- default background
  base01 = "#11151c", -- lighter background
  base02 = "#242936", -- selection background
  base03 = "#495162", -- comments / muted
  base04 = "#626a73", -- dark foreground
  base05 = "#bfbdb6", -- default foreground
  base06 = "#e6e1cf", -- light foreground
  base07 = "#f2f0ec", -- lightest foreground
  base08 = "#f07178", -- red
  base09 = "#ff8f40", -- orange
  base0A = "#ffb454", -- yellow
  base0B = "#aad94c", -- green
  base0C = "#95e6cb", -- cyan
  base0D = "#73d0ff", -- blue
  base0E = "#d2a6ff", -- magenta
  base0F = "#e6b673", -- brown / orange
}

local function candidates()
  local xdg = vim.fn.expand("$XDG_CONFIG_HOME")
  if xdg == "" then xdg = vim.fn.expand("~/.config") end
  return {
    "/etc/stylix/palette.json",
    xdg .. "/stylix/palette.json",
  }
end

local function read_stylix_palette()
  for _, path in ipairs(candidates()) do
    local file = io.open(path, "r")
    if file then
      local ok, data = pcall(vim.json.decode, file:read("*a"))
      file:close()
      if ok and type(data) == "table" and data.base00 then
        local palette = {}
        for _, key in ipairs(KEYS) do
          palette[key] = data[key] and ("#" .. data[key]) or FALLBACK[key]
        end
        return palette
      end
    end
  end
  return nil
end

function M.get()
  local palette = read_stylix_palette() or {}
  for _, key in ipairs(KEYS) do
    if not palette[key] then palette[key] = FALLBACK[key] end
  end
  return palette
end

return M
