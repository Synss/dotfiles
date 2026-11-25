{
  config,
  lib,
  sys,
  pkgs,
  ...
}:
let
  packages =
    with pkgs;
    [
      docker
      docker-credential-helpers
      k3d
      kubectl
      tilt
    ]
    ++ sys.onLinux pkgs.k3s;

  hasDocker = lib.elem pkgs.docker packages;
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;

  rosettaRuntime = "/Library/Apple/usr/libexec/oah/libRosettaRuntime";

  vm = rosetta: {
    cpu = lib.mkDefault 8;
    memory = lib.mkDefault 16;
    disk = lib.mkDefault 100;
    vmType = "vz";
    mountType = "virtiofs";
    inherit rosetta;
    mounts = [
      {
        location = "${config.home.homeDirectory}/src";
        writable = true;
      }
    ];
  };

  colima = config.services.colima;
  usesRosetta = lib.any (p: p.settings.rosetta or false) (lib.attrValues colima.profiles);

  shortcut = name: ''
    ${name}() {
      colima status ${name} &>/dev/null || colima start ${name} || return
      colima ssh -p ${name} -- "$@"
    }
  '';
in
{
  home.packages = packages;

  services.colima = {
    enable = sys.isDarwin;
    profiles = {
      linux = {
        isService = true;
        isActive = true;
        setDockerHost = hasDocker && isAarch64;
        mutableSettings = true;
        settings = vm false;
      };
      linux-amd64 = {
        mutableSettings = true;
        settings = vm true // {
          autoActivate = false;
        };
      };
    };
  };

  programs.zsh.initContent = lib.mkIf colima.enable (
    lib.concatMapStrings shortcut (lib.attrNames colima.profiles)
  );

  home.activation.rosetta = lib.mkIf (colima.enable && usesRosetta) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e ${rosettaRuntime} ]; then
        warnEcho "Rosetta is missing: softwareupdate --install-rosetta --agree-to-license"
      fi
    ''
  );
}
