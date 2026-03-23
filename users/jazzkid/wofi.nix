{
  lib,
  pkgs,
  ...
}: {
  programs.wofi = {
    enable = true;

    settings = {
      width = 400;
      height = 300;
      show = "drun";
      prompt = "Search...";
      allow_images = true;
      image_size = 32;
      allow_markup = true;
      no_actions = false;
      hide_scroll = false;
      matching = " fuzzy";
      key_expand = "Tab";
      key_exit = "Escape";
    };

    style = ''
      window {
        background-color: #1e1e2e;
        border-radius: 8px;
      }
      #input {
        background-color: #313244;
        color: #cdd6f4;
        border-radius: 4px;
        margin: 4px;
        padding: 8px;
      }
      #entry:selected {
        background-color: #89b4fa;
        color: #1e1e2e;
      }
      #text {
        color: #cdd6f4;
      }
      #image {
        margin-right: 8px;
      }
    '';
  };
}
