{ nixpkgs-default, lib, ... }: let
  tuigreet = "${nixpkgs-default.tuigreet}/bin/tuigreet";
  tuigreetOptions = [
    "--remember"
    "--time"
    "--asterisks"
    "--time-format '%I:%M %p | %a - %h | %F'"
    "--greeting 'Nothing is true, everything is permitted.'"
    "--theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'"
    "--cmd Hyprland"
  ];
  flags = lib.concatStringsSep " " tuigreetOptions;
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} ${flags}";
        user = "evi1_f4iry";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYHangup = true;
    TTYVTDisallocate = true;
  };
}
