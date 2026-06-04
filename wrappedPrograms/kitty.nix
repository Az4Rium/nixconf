{self, inputs, ...}: {
  perSystem = {pkgs,self', lib, ...}: {
    packages.myKitty = inputs.wrapper-modules.wrappers.kitty.wrap {
      inherit pkgs;
      settings = {
        shell = "${pkgs.lib.getExe self'.packages.fish}";
        enable_audio_bell = "no";

        font_size = 15;
        font_famaly = "JetBrainsMono Nerd Font";

        cursor_text_color = "background";

        allow_remote_control = "yes";
        shell_integration = "enabled";

        cursor_trail = 3;

        # map = [
        #   "alt+1 goto_tab 1"
        #   "alt+2 goto_tab 2"
        #   "alt+3 goto_tab 3"
        #   "alt+4 goto_tab 4"
        #   "alt+5 goto_tab 5"
        #   "alt+6 goto_tab 6"
        #   "alt+7 goto_tab 7"
        #   "alt+8 goto_tab 8"
        #   "alt+9 goto_tab 9"
        #   "ctrl+shift+w close_tab"
        #   "ctrl+t new_tab_with_cwd"
        #   "ctrl+shift+t new_tab"   
        # ];

        background = self.theme.bg;
        foreground = self.theme.fg;

        cursor = self.theme.fg_light;
        selection_foreground = self.theme.fg;
        selection_background = self.theme.selection;
        
        active_tab_foreground = self.theme.accent;
        active_tab_background = self.theme.bg;
        inactive_tab_background = self.theme.bg_dark;

        color0  = self.theme.base00;
        color1  = self.theme.base01;
        color2  = self.theme.base02;
        color3  = self.theme.base03;
        color4  = self.theme.base04;
        color5  = self.theme.base05;
        color6  = self.theme.base06;
        color7  = self.theme.base07;
        color8  = self.theme.base08;
        color9  = self.theme.base09;
        color10 = self.theme.base10;
        color11 = self.theme.base11;
        color12 = self.theme.base12;
        color13 = self.theme.base13;
        color14 = self.theme.base14;
        color15 = self.theme.base15;
      };
    };
  };
}