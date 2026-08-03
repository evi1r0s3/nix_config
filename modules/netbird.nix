{ nixpkgs-unstable, ... }:
{
    services.netbird = {
        enable = true;
        package = nixpkgs-unstable.netbird;
    };
    systemd.services.netbird-autoconnect = {
    description = "Automatic connection to Netbird";

    # make sure netbird is running before trying to connect to netbird
    after = [ "network-pre.target" "netbird.service" ];
    wants = [ "network-pre.target" "netbird.service" "run-agenix.d.mount" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with nixpkgs-unstable; ''
      # wait for netbird to settle
      sleep 2

      # check if we are already authenticated to netbird
      set +e
      ${netbird}/bin/netbird status | grep -e LoginFailed
      if [ $? -gt 0 ]; then # if so, then do nothing
        exit 0
      fi
      set -e

      # otherwise authenticate with netbird
      ${netbird}/bin/netbird up -k "19423C02-3C5A-4286-8ED6-D264FE210EA2"
    '';
  };
}
