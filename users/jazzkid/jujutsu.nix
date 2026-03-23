{...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        default-command = "log";
        pager = "bat --plain";
        diff-formatter = ["difft" "--color=always" "$left" "$right"];
      };
    };
  };
}
