{ config, ... }:
{
  config = {
    #allowUnfree = true;
    #acceptLicense = true;
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
      # of just the bare essentials.
      powerManagement.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
    
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enabling PRIME sync introduces better performance and greatly reduces screen tearing,
    # at the expense of higher power consumption since the Nvidia GPU will not go to sleep completely unless called for,
    # as is the case in Offload Mode. It may also cause its own issues in rare cases. 
    # PRIME Sync and Offload Mode cannot be enabled at the same time.
    # 启用 PRIME 同步可带来更好的性能并大大减少屏幕撕裂，但代价是更高的功耗，因为除非需要，
    # Nvidia GPU 不会完全进入睡眠状态，就像卸载模式中的情况一样。在极少数情况下，它也可能会导致其自身的问题。
    # PRIME 同步和卸载模式不能同时启用。
    # PRIME sync may also solve some issues with connecting a display in clamshell mode directly to the GPU.
    # PRIME 同步还可以解决将翻盖模式下的显示器直接连接到 GPU 的一些问题。
    prime = {
      sync.enable = true;
      # Make sure to use the correct Bus ID values for your system!
      # lspci
      nvidiaBusId = "PCI:01:0:0";
      intelBusId = "PCI:00:02:0";
    };
  };

  # intel 这个试过如果启用的话是会无法正常进入图形界面这是应急调度的问题
  #  boot.kernelParams = ["module_blacklist=i915" ];
  boot.kernelParams = [ "nvidia_drm.fbdev=1" "nvidia-drm.modeset=1" ];
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };
}
