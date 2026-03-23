{...}: {
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      ignore-timeout = false;
      max-visible = 5;

      layer = "overlay";
      anchor = "top-right";

      font = "RobotoMono Nerd Font 14";
      background-color = "#1e1e2e";
      border-color = "#89b4fa";
      text-color = "#cdd6f4";
      border-radius = 8;
      border-size = 2;
      progress-color = "over #89b4fa";

      "mode=do-not-disturb" = {
        invisible = 1;
        default-timeout = 0;
        ignore-timeout = 1;
      };
    };
  };
}
