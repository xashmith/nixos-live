{ config, pkgs, ... }:
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
  ];

  boot.kernelModules = [
    "uinput"
    "vhci_hcd"
  ];

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
    ];
  };

  # users.groups.uinput.members = ["nixos"];

  fonts.packages = [
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.dejavu-sans-mono
  ];

  services = {
    dnscrypt-proxy2.enable = true;
    i2pd.enable = true;
    tor = {
      enable = true;
      client.dns.enable = true;
      settings.DNSPort = [{
        addr = "127.0.0.1";
        port = 53;
      }];
    };
    resolved = {
      enable = true;
      fallbackDns = [""];
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

  networking.firewall.enable = true;
  networking.hostName = "janes-laptop";
  networking.networkmanager.enable = true;
  networking.nameservers = ["127.0.0.1"];

  home-manager.users.nixos = import ./home.nix;
}
