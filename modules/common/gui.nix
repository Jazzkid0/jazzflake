{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  config = {
    hardware.graphics.enable = true;
    
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaPersistenced = true;
    };

    boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
    
    services.xserver.enable = false;

    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    # Audio configuration
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # Gfx tools, maybe remove after testing
      vulkan-tools
      mesa-demos
      # Audio tools
      pavucontrol
      playerctl
      pulseaudio # provides pactl, paplay etc.
    ];
  };
}
