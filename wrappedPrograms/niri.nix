{ self, inputs, ... }: {
   flake.nixosModules.niri = { pkgs, lib, ... }: {
     programs.niri = {
       enable = true;
       package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
     };
      environment.systemPackages = [ pkgs.bibata-cursors ];
   };

  perSystem = { pkgs, lib, self', config, ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = let 
      	noctaliaExe = lib.getExe self'.packages.myNoctalia;
      in {
         spawn-at-startup = [
           (lib.getExe self'.packages.myNoctalia)
         ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        prefer-no-csd = {};
        window-rule = {
            geometry-corner-radius = 4;
            clip-to-geometry = true;
        };

        input = {
          focus-follows-mouse = {};

          keyboard = {
            xkb = {
              layout = "us,ru";
              options = "grp:alt_shift_toggle";
            };
            repeat-rate = 40;
            repeat-delay = 250;
          };

          touchpad = {
            natural-scroll = {};
            tap = {};
          };
          mouse = {
            accel-profile = "flat";
          };
        };

        layout = {
          gaps = 5;
           focus-ring = {
             width = 2;
             active-color = self.theme.accent;
             inactive-color = self.theme.selection;
           };

        };
        cursor = {
          xcursor-theme = "Bibata-Modern-Ice";
          xcursor-size = 24;
        };

        binds = {
          "Mod+Return".spawn-sh = lib.getExe self'.packages.myKitty;
          "Mod+M".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call sessionMenu toggle";

          "Mod+Q".close-window = {};
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+F".maximize-column = {};
          "Mod+G".fullscreen-window = {};
          "Mod+Shift+F".toggle-window-floating = {};
          "Mod+C".center-column = {};

          "Mod+L".focus-column-right = {};
          "Mod+H".focus-column-left = {};
          "Mod+K".focus-window-up = {};
          "Mod+J".focus-window-down = {};

          "Mod+Shift+L".move-column-right = {};
          "Mod+Shift+H".move-column-left = {};
          "Mod+Shift+K".move-window-up = {};
          "Mod+Shift+J".move-window-down = {};

          "Mod+Ctrl+H".set-column-width = "-5%";        
          "Mod+Ctrl+L".set-column-width = "+5%";
          "Mod+Ctrl+J".set-window-height = "-5%";
          "Mod+Ctrl+K".set-window-height = "+5%";

          "Mod+BracketLeft".consume-or-expel-window-left = {};
          "Mod+BracketRight".consume-or-expel-window-right = {};

          "Mod+WheelScrollDown".focus-column-left = {};
          "Mod+WheelScrollUp".focus-column-right= {};
          "Mod+Ctrl+WheelScrollDown".focus-column-left= {};
          "Mod+Ctrl+WheelScrollUp".focus-column-right= {};

          "Mod+1".focus-workspace = "w0";
          "Mod+2".focus-workspace = "w1";
          "Mod+3".focus-workspace = "w2";
          "Mod+4".focus-workspace = "w3";
          "Mod+5".focus-workspace = "w4";
          "Mod+6".focus-workspace = "w5";
          "Mod+7".focus-workspace = "w6";
          "Mod+8".focus-workspace = "w7";
          "Mod+9".focus-workspace = "w8";
          "Mod+0".focus-workspace = "w9";

          "Mod+Shift+1".move-column-to-workspace = "w0";
          "Mod+Shift+2".move-column-to-workspace = "w1";
          "Mod+Shift+3".move-column-to-workspace = "w2";
          "Mod+Shift+4".move-column-to-workspace = "w3";
          "Mod+Shift+5".move-column-to-workspace = "w4";
          "Mod+Shift+6".move-column-to-workspace = "w5";
          "Mod+Shift+7".move-column-to-workspace = "w6";
          "Mod+Shift+8".move-column-to-workspace = "w7";
          "Mod+Shift+9".move-column-to-workspace = "w8";
          "Mod+Shift+0".move-column-to-workspace = "w9";
          
          "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
	        "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
 	        "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
	        "XF86MonBrightnessDown".spawn-sh = "wpctl brightnessctl set 5%-";
	        "XF86MonBrightnessUp".spawn-sh = "wpctl brightnessctl set 5%+";
	        #"XF86TouchpadToggle"
	        "XF86AudioMicMute".spawn-sh = " wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
	        #"XF86Laucnh1"
	  
	  
		
        };
        workspaces = let
          settings = {layout.gaps = 5;};
        in {
          "w0" = settings;
          "w1" = settings;
          "w2" = settings;
          "w3" = settings;
          "w4" = settings;
          "w5" = settings;
          "w6" = settings;
          "w7" = settings;
          "w8" = settings;
          "w9" = settings;
        };
      };
    };
  };
}
