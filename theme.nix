let
  theme = {
    # --- UI & Base ---
    bg          = "#0a0e14";
    bg_dark     = "#0d1017";
    fg          = "#bfbdb6";
    fg_light    = "#e6e1cf";
    comment     = "#626a73";
    selection   = "#242936";
    line        = "#11151c";
    accent      = "#e6b450";

    # --- Full 16 Terminal Colors (ANSI) ---
    # Normal (0-7)
    base00 = "#0a0e14"; # Black (Background)
    base01 = "#f07178"; # Red
    base02 = "#aad94c"; # Green
    base03 = "#e6b450"; # Yellow
    base04 = "#73d0ff"; # Blue
    base05 = "#d2a6ff"; # Magenta
    base06 = "#95e6cb"; # Cyan
    base07 = "#bfbdb6"; # White (Foreground)

    # Bright (8-15)
    base08 = "#626a73"; # Bright Black (Comments/Grey)
    base09 = "#ff8f40"; # Bright Red (Keyword-ish Orange)
    base10 = "#b8cc52"; # Bright Green
    base11 = "#ffad66"; # Bright Yellow
    base12 = "#73d0ff"; # Bright Blue
    base13 = "#dfe1ff"; # Bright Magenta
    base14 = "#95e6cb"; # Bright Cyan
    base15 = "#e6e1cf"; # Bright White
    
    # --- Semantic Syntax Extensions ---
    keyword    = "#ff8f40";
    string     = "#aad94c";
    function   = "#73d0ff";
    constant   = "#d2a6ff";
    regexp     = "#95e6cb";
    error      = "#f27983";
    warning    = "#ffad66";
  };

  stripHash = str:
    if builtins.substring 0 1 str == "#"
    then builtins.substring 1 (builtins.stringLength str - 1) str
    else str;

  themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
in {
  flake = {
    inherit theme themeNoHash;
  };
}
