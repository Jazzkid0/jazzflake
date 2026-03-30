{lib, ...}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "spotify"
      "steam-unwrapped"
      "cuda_cudart"
      "cuda_nvcc"
      "cuda_cccl"
      "libcublas"
    ];
}
