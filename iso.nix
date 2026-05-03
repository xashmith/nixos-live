{ config, pkgs, lib, inputs, ... }:
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

  # skip deno's tests since they are failing
  nixpkgs.overlays = [
    (final: prev: {
      deno = prev.deno.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];

  # disable zfs since its broken for kernel 7.0.2
  boot.supportedFilesystems = {
    zfs = lib.mkForce false;
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
    "iomem=relaxed"
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   lkrg
  # ];

   boot.blacklistedKernelModules = [
     "dccp"
     "sctp"
     "rds"
     "tipc"
     "n-hdlc"
     "ax25"
     "netrom"
     "x25"
     "rose"
     "decnet"
     "econet"
     "af_802154"
     "ipx"
     "appletalk"
     "psnap"
     "p8023"
     "p8022"
     "can"
     "atm"
     "firewire-core"
     "firewire_core"
     "firewire-ohci"
     "firewire_ohci"
     "firewire_sbp2"
     "firewire-sbp2"
     "firewire-net"
 "#thunderbolt"
 "#ohci1394"
 "#sbp2"
 "#dv1394"
 "#raw1394"
 "#video1394"
     "cramfs"
     "freevxfs"
     "jffs2"
     "hfs"
     "hfsplus"
     "udf"
 "#cifs"
 "#nfs"
 "#nfsv3"
 "#nfsv4"
 "#ksmbd"
     "gfs2"
     "reiserfs"
     "kafs"
     "orangefs"
     "9p"
     "adfs"
     "affs"
     "afs"
     "befs"
 "#ceph"
     "coda"
 "#ecryptfs"
     "jfs"
     "minix"
     "nilfs2"
     "ocfs2"
 "#romfs"
     "ubifs"
     "zonefs"
     "sysv"
     "ufs"
     "vivid"
     "gnss"
     "gnss-mtk"
     "gnss-serial"
     "gnss-sirf"
     "gnss-usb"
     "gnss-ubx"
 "#bluetooth"
 "#btusb"
     "joydev"
     "ath_pci"
     "#cdrom"
 "#sr_mod"
   ];

  boot.extraModprobeConfig = ''
    install dccp ${pkgs.coreutils}/bin/false
    install sctp ${pkgs.coreutils}/bin/false
    install rds ${pkgs.coreutils}/bin/false
    install tipc ${pkgs.coreutils}/bin/false
    install n-hdlc ${pkgs.coreutils}/bin/false
    install ax25 ${pkgs.coreutils}/bin/false
    install netrom ${pkgs.coreutils}/bin/false
    install x25 ${pkgs.coreutils}/bin/false
    install rose ${pkgs.coreutils}/bin/false
    install decnet ${pkgs.coreutils}/bin/false
    install econet ${pkgs.coreutils}/bin/false
    install af_802154 ${pkgs.coreutils}/bin/false
    install ipx ${pkgs.coreutils}/bin/false
    install appletalk ${pkgs.coreutils}/bin/false
    install psnap ${pkgs.coreutils}/bin/false
    install p8023 ${pkgs.coreutils}/bin/false
    install p8022 ${pkgs.coreutils}/bin/false
    install can ${pkgs.coreutils}/bin/false
    install atm ${pkgs.coreutils}/bin/false
    install firewire-core ${pkgs.coreutils}/bin/false
    install firewire_core ${pkgs.coreutils}/bin/false
    install firewire-ohci ${pkgs.coreutils}/bin/false
    install firewire_ohci ${pkgs.coreutils}/bin/false
    install firewire_sbp2 ${pkgs.coreutils}/bin/false
    install firewire-sbp2 ${pkgs.coreutils}/bin/false
    install firewire-net ${pkgs.coreutils}/bin/false
#install thunderbolt ${pkgs.coreutils}/bin/false
#install ohci1394 ${pkgs.coreutils}/bin/false
#install sbp2 ${pkgs.coreutils}/bin/false
#install dv1394 ${pkgs.coreutils}/bin/false
#install raw1394 ${pkgs.coreutils}/bin/false
#install video1394 ${pkgs.coreutils}/bin/false
    install cramfs ${pkgs.coreutils}/bin/false
    install freevxfs ${pkgs.coreutils}/bin/false
    install jffs2 ${pkgs.coreutils}/bin/false
    install hfs ${pkgs.coreutils}/bin/false
    install hfsplus ${pkgs.coreutils}/bin/false
    install udf ${pkgs.coreutils}/bin/false
#install cifs ${pkgs.coreutils}/bin/false
#install nfs ${pkgs.coreutils}/bin/false
#install nfsv3 ${pkgs.coreutils}/bin/false
#install nfsv4 ${pkgs.coreutils}/bin/false
#install ksmbd ${pkgs.coreutils}/bin/false
    install gfs2 ${pkgs.coreutils}/bin/false
    install reiserfs ${pkgs.coreutils}/bin/false
    install kafs ${pkgs.coreutils}/bin/false
    install orangefs ${pkgs.coreutils}/bin/false
    install 9p ${pkgs.coreutils}/bin/false
    install adfs ${pkgs.coreutils}/bin/false
    install affs ${pkgs.coreutils}/bin/false
    install afs ${pkgs.coreutils}/bin/false
    install befs ${pkgs.coreutils}/bin/false
#install ceph ${pkgs.coreutils}/bin/false
    install coda ${pkgs.coreutils}/bin/false
#install ecryptfs ${pkgs.coreutils}/bin/false
    install jfs ${pkgs.coreutils}/bin/false
    install minix ${pkgs.coreutils}/bin/false
    install nilfs2 ${pkgs.coreutils}/bin/false
    install ocfs2 ${pkgs.coreutils}/bin/false
    install romfs ${pkgs.coreutils}/bin/false
    install ubifs ${pkgs.coreutils}/bin/false
    install zonefs ${pkgs.coreutils}/bin/false
    install sysv ${pkgs.coreutils}/bin/false
#install ufs ${pkgs.coreutils}/bin/false
    install vivid ${pkgs.coreutils}/bin/false
    install gnss ${pkgs.coreutils}/bin/false
    install gnss-mtk ${pkgs.coreutils}/bin/false
    install gnss-serial ${pkgs.coreutils}/bin/false
    install gnss-sirf ${pkgs.coreutils}/bin/false
    install gnss-usb ${pkgs.coreutils}/bin/false
    install gnss-ubx ${pkgs.coreutils}/bin/false
#install bluetooth ${pkgs.coreutils}/bin/false
#install btusb ${pkgs.coreutils}/bin/false
    install joydev ${pkgs.coreutils}/bin/false
    install ath_pci ${pkgs.coreutils}/bin/false
#install cdrom ${pkgs.coreutils}/bin/false
#install sr_mod ${pkgs.coreutils}/bin/false
  '';

  boot.kernelModules = [
    "uinput"
    "vhci_hcd"
    "chipsec"
    "wireguard"
  ];

  boot.kernel.sysctl = {
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.icmp_echo_ignore_all" = 1;
    "net.ipv6.icmp.echo_ignore_all" = 1;
    "net.ipv4.tcp_timestamps" = 0;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.*.send_redirects" = 0;
    "net.ipv4.conf.*.accept_redirects" = 0;
    "net.ipv6.conf.*.accept_redirects" = 0;
    "net.ipv4.conf.*.shared_media" = 0;
    "net.ipv4.conf.*.arp_filter" = 1;
    "net.ipv4.conf.*.arp_ignore" = 2;
    "net.ipv4.conf.all.drop_gratuitous_arp" = 1;
    "net.ipv4.conf.*.accept_source_route" = 0;
    "net.ipv6.conf.*.accept_source_route" = 0;
    "net.ipv4.tcp_sack" = 0;
    "net.ipv4.tcp_dsack" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 2;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.sysrq" = 0;
    "kernel.perf_event_paranoid" = 3;
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.oops_limit" = 100;
    "kernel.warn_limit" = 100;
    "kernel.panic" = -1;
    "fs.binfmt_misc.status" = 0;
    "fs.suid_dumpable" = 0;
    "fs.protected_regular" = 2;
    "fs.protected_fifos" = 2;
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "dev.tty.ldisc_autoload" = 0;
    "vm.unprivileged_userfaultfd" = 0;
    "kernel.printk" = "3 3 3 3";
    "kernel.kexec_load_disabled" = 1;
    "kernel.core_pattern" = "|/bin/false";
    "kernel.io_uring_disabled" = 2;
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_rnd_compat_bits" = 16;
    "kernel.randomize_va_space" = 2;
    "vm.mmap_min_addr" = 65536;
    "vm.max_map_count" = 1048576;
  };


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
  isoImage.forceTextMode = true;

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
      "wireshark"
      "console"
    ];
  };

  fonts.packages = [
    pkgs.nerd-fonts.droid-sans-mono
    pkgs.nerd-fonts.dejavu-sans-mono
  ];

  systemd.services.systemd-resolved.enable = lib.mkForce false;

  services = {
    dnscrypt-proxy = {
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
    haveged = {
      enable = true;
    };
    syslogd = {
      enable = true;
    };
    thermald = {
      enable = true;
    };
    ntpd-rs = {
      enable = true;
    };
    jitterentropy-rngd = {
      enable = true;
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
    # displayManager.gdm.enable = lib.mkForce false;
  };

  virtualisation.docker = {
    enable =true;
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.waydroid.enable = true;

  networking = {
    firewall.enable = true;
    hostName = "janes-phone";
    networkmanager.enable = true;
    nameservers = ["127.0.0.1"  "::1"];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = lib.mkForce "none";
    wg-quick.interfaces.wg0.configFile = "./be-bru-wg-102.conf";
  };

  home-manager.users.nixos = import ./home.nix;
}
