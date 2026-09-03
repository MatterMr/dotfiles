{ pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    font = {
      name = "Hack Nerd Font Mono";
      size = 12;
    };
    settings = {
      shell = "/run/current-system/sw/bin/fish";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      window_margin_width = 10;
      confirm_os_window_close = 0;
      background_opacity = "0.95";
      background_blur = 16;
      hide_window_decorations = "titlebar-only";

      # Nord theme colors
      foreground = "#D8DEE9";
      background = "#2E3440";
      selection_foreground = "#D8DEE9";
      selection_background = "#4C566A";
      url_color = "#88C0D0";
      cursor = "#D8DEE9";
      cursor_text_color = "#2E3440";

      # Black
      color0 = "#3B4252";
      color8 = "#4C566A";
      # Red
      color1 = "#BF616A";
      color9 = "#BF616A";
      # Green
      color2 = "#A3BE8C";
      color10 = "#A3BE8C";
      # Yellow
      color3 = "#EBCB8B";
      color11 = "#EBCB8B";
      # Blue
      color4 = "#81A1C1";
      color12 = "#81A1C1";
      # Magenta
      color5 = "#B48EAD";
      color13 = "#B48EAD";
      # Cyan
      color6 = "#88C0D0";
      color14 = "#8FBCBB";
      # White
      color7 = "#E5E9F0";
      color15 = "#ECEFF4";
    };
  };
}
