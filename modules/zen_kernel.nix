{ nixpkgs-default, config, ... }:

{
  # Linux Kernel
  #boot.kernelPackages = nixpkgs-default.linuxKernel.packages.linux_zen;
#  boot.kernelParams = [ 
#    "quiet"
#    "fbcon=nodefer"
#    "vt.global_cursor_default=0"
#    "kernel.modules_disabled=1"
#    #"lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo"
#    #"lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
#    "usbcore.autosuspend=-1"
#    "video4linux"
#    "acpi_rev_override=5"
#    "security=selinux"
#  ];
  #boot.extraModulePackages = with config.boot.kernelPackages; [
  #  rtl88xxau-aircrack
  #];
#  boot.kernelPatches = [ {
#        name = "selinux-config";
#        patch = null;
#        extraConfig = '' 
#                SECURITY_SELINUX y
#                SECURITY_SELINUX_BOOTPARAM n
#                SECURITY_SELINUX_DEVELOP y
#                SECURITY_SELINUX_AVC_STATS y
#                DEFAULT_SECURITY_SELINUX n
#              '';
#  } ];

#  systemd.package = nixpkgs-default.systemd.override { withSelinux = true; };

  #environment.systemPackages = with nixpkgs-default; [
  #  # policycoreutils
  #  linuxPackages.rtl8821au
  #];
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "mt7921u" ];
}
