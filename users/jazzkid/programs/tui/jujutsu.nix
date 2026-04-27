_: {
  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        default-command = ["log" "-n" "8"];
        pager = "bat --plain";
        diff-formatter = ["difft" "--color=always" "$left" "$right"];
      };
    };
  };
}
