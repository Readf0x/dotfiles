{ ... }: {
  xdg.desktopEntries = {
    # ukmm = {
    #   name = "UKMM";
    #   comment = "Starts U-King Mod Manager";
    #   exec = "${self.packages.${conf.system}.ukmm-fork}/bin/ukmm %u";
    #   mimeType = [ "x-scheme-handler/bcml" ];
    # };
  };
  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [ "steam -silent" ];
      bind = [
        "$mod, mouse:276, exec, hypr-zoom -duration 250 -steps 50 -target 2"
        "$mod, mouse:275, exec, hypr-zoom -duration 250 -steps 50 -target 1"
      ];
    };
  };
}

