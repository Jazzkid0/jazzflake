{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  hardware.graphics.enable = true;
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaPersistenced = true;
  };

  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];
  
  services.xserver.enable = false;

  environment.systemPackages = with pkgs; [
    vulkan-tools
    mesa-demos
  ];
}
