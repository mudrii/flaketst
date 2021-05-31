{ config, pkgs, inputs, ... }:

/*let

  unstable = import inputs.unstable {
    config = config.nixpkgs.config;
    localSyetem = "x84_64-linux';
  };

in*/

{

  imports = [ ./hardware-configuration.nix ];

  fileSystems."/" = {options = [ "noatime" "nodiratime" ];};
  #swapDevices = [{ device = "/.swapfile"; }];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          version = 2;
          efiSupport = true;
          enableCryptodisk = true;
          device = "nodev";
        };
      };

    initrd.luks.devices = {
      crypt = {
        device = "/dev/vda2";
        preLVM = true;
      };
    };
  };

  time.timeZone = "Asia/Singapore";

  networking = {
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
    hostName = "nixtst";
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  users = {
    users.mudrii = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      # mkpasswd -m sha-512 password
      hashedPassword = "$6$ewXNcoQRNG$czTic9vE8CGH.eo4mabZsHVRdmTjtJF4SdDnIK0O/4STgzB5T2nD3Co.dRpVS3/uDD24YUxWrTDy2KRv7m/3N1";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8/tE2+oIwLnCnfzPSTqiZaeW++wUPNW5fOi124eGzWfcnOQGrjuwir3sZDKMS9DLqSTDNtvJ3/EZf6z/MLN/uxUE8lA+aKaSs0yopE7csQ89Aqkvp5fvCpz3BJuZgpxtwebPZyTc7QRGQWE4lM3fix3aJhfj827bdxA+sCiq8OnNiwYSXrIag1cQigafhLy6tYtCKdWcxzJq2ebGJF2wu2LU0zArb1SAOanhEOXxz0dG1I/7yMDBDC92R287nWpL+BwxuQcDv0xh/sWnViKixKv+B9ewJnz98iQPcg3WmYWe9BYAcaqkbgMqbwfUPqOHhFXmiQWUpOjsni2O6VoiN mudrii@nixos" ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      nixFlakes
      binutils
      gnutls
      wget
      curl
      neovim
      archiver
      htop
      gtop
      bind
      mkpasswd
      trash-cli
      exa
    ];

    shellAliases = {
      cp = "cp -i";
      diff = "diff --color=auto";
      dmesg = "dmesg --color=always | lless";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      grep = "grep --color=auto";
      la = "exa -alg --group-directories-first -s=type --icons";
      lless = "set -gx LESSOPEN '|pygmentize -f terminal256 -g -P style=monokai %s' && set -gx LESS '-R' && less -m -g -i -J -u -Q";
      ll = "exa -la";
      ls = "exa";
      mv = "mv -i";
      ping = "ping -c3";
      ps = "ps -ef";
      rm = "trash-put";
      unrm = "trash-restore";
      rmcl = "trash-empty";
      rml = "trash-list";
      sudo = "sudo -i";
      vdir = "vdir --color=auto";
      vim = "nvim";
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
  };

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    autoOptimiseStore = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];

    extraOptions = ''
      experimental-features = nix-command flakes
      '';
  };

  system.stateVersion = "20.09";

}
