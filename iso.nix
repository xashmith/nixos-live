{ config, pkgs, lib, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "cgroups"
        "flakes"
        "nix-command"
      ];
    };
  };

  boot.kernelParams = [
    "consoleblank=300"
    "delayacct"
    "mitigations=auto,nosmt"
    "nosmt=force"
    "spectre_v2=on"
    "spectre_bhi=on"
    "spec_store_bypass_disable=on"
    "ssbd=force-on"
    "l1tf=full,force"
    "mds=full,nosmt"
    "tsx=off"
    "tsx_async_abort=full,nosmt"
    "kvm.nx_huge_pages=force"
    "l1d_flush=on"
    "mmio_stale_data=full,nosmt"
    "retbleed=auto,nosmt"
    "gather_data_sampling=force"
    "reg_file_data_sampling=on"
    "slab_nomerge"
    "slab_debug=FZ"
    "init_on_alloc=1"
    "init_on_free=1"
    "page_alloc.shuffle=1"
    "pti=on"
    "randomize_kstack_offset=on"
    "vsyscall=none"
    "debugfs=on"
    "kfence.sample_interval=100"
    "vdso32=0"
    "amd_iommu=force_isolation"
    "intel_iommu=on"
    "iommu=force"
    "iommu.passthrough=0"
    "iommu.strict=1"
    "efi=disable_early_pci_dma"
    "random.trust_bootloader=off"
    "random.trust_cpu=off"
    "extra_latent_entropy"
    "loglevel=0"
    "hardened_usercopy=1"
    "cfi=kcfi"
    "quiet"
    "splash"
    "copytoram"
    "efi_pstore.pstore_disable=1"
    "erst_disable"
    "spec_store_bypass_disable=on"
  ];

  boot.kernelModules = [
    "uinput"
    "vhci_hcd"
  ];

  zramSwap = {
    enable = true;
    algorithm = "lzo";
    memoryPercent = 25;
  };

  time.timeZone = "America/Toronto";

  i18n.defaultLocale = "en_US.UTF-8";

  console =
  {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "input"
      "uinput"
      "media"
      "adm"
      "dialout"
      "docker"
    ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.dejavu-sans-mono
  ];

  systemd.services.systemd-resolved.enable = lib.mkForce false;

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        require_nolog = true;
        require_nofilter = true;
        force_tcp = true;
        proxy = "socks5h://127.0.0.1:9050";
      };
    };
    i2pd.enable = true;
    tor = {
      enable = true;
      enableGeoIP = false;
      torsocks.enable = true;
      client = {
        enable = true;
      };
    };
    privoxy = {
      enable = true;
      enableTor = true;
    };
    kmonad = {
      enable = true;
      keyboards = {
        myKMONADOutput = {
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = builtins.readFile ./thinkpad_T430_iso.kbd;
        };
      };
    };
  };

  virtualisation.docker = {
    enable =true;
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;

  };

  networking = {
    firewall.enable = true;
    hostName = "janes-phone";
    networkmanager.enable = true;
    nameservers = ["127.0.0.1"  "::1"];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = lib.mkForce "none";
  };

  home-manager.users.nixos = import ./home.nix;
}
