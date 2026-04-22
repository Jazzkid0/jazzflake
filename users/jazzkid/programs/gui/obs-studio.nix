{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      # check these before committing, updates may mean not needed
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-shaderfilter
    ];
  };
}
