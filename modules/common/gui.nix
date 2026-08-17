{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
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

    boot.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm"];

    systemd.services.nvidia-persistenced = {
      serviceConfig.ExecStart = lib.mkForce "/run/current-system/sw/bin/nvidia-persistenced --verbose";
    };

    services.xserver.enable = false;

    programs.hyprland.enable = true;

    security.polkit.enable = true;

    services.displayManager.ly = {
      enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
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

    environment.systemPackages = [
      config.hardware.nvidia.package.bin
    ] ++ (with pkgs; [
      # Gfx tools, maybe remove after testing
      vulkan-tools
      mesa-demos
      # Audio tools
      pavucontrol
      playerctl
      pulseaudio # provides pactl, paplay etc.
    ]);
  };
}
