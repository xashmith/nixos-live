{
  description = "Minimal NixOS installation media";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }: {
    packages.x86_64-linux.default = self.nixosConfigurations.exampleIso.config.system.build.isoImage;
    nixosConfigurations = {
      exampleIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, modulesPath, ... }: {
            imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix") ];
            environment.systemPackages = [
              pkgs.tmux
              pkgs.git
              pkgs.vim
              pkgs.vimPlugins.YouCompleteMe
              pkgs.vimPlugins.ale
              pkgs.vimPlugins.vim-airline
              pkgs.vimPlugins.vim-airline-themes
              pkgs.vimPlugins.vim-colorschemes
              pkgs.curl
              pkgs.lf
              pkgs.w3m
              pkgs.lynx
              pkgs.elinks
              pkgs.amfora
              pkgs.lagrange-tui
              pkgs.lagrange
              pkgs.mpv
              pkgs.yt-dlp
              pkgs.ranger
              pkgs.busybox
              pkgs.ripgrep
              pkgs.ripgrep-all
              pkgs.fzf
              pkgs.htop
              pkgs.cointop
              pkgs.lnav
              pkgs.wget
              pkgs.nmap
              pkgs.tcpdump
              pkgs.iptraf-ng
              pkgs.traceroute
              pkgs.wireshark
              pkgs.tshark
              pkgs.dig
              pkgs.libvirt
              pkgs.qemu_kvm
              pkgs.flatpak
              pkgs.waydroid
              pkgs.tree
              pkgs.python3
              pkgs.pipx
              pkgs.poetry
              pkgs.zfs
              pkgs.zoxide
              pkgs.grc
              pkgs.zsh
              pkgs.zsh-powerlevel10k
              pkgs.zsh-syntax-highlighting
              pkgs.zsh-autosuggestions
              pkgs.zsh-powerlevel10k
              pkgs.dash
              pkgs.ksh
              pkgs.eza
              pkgs.apkeep
              pkgs.gnupg
              pkgs.keepassxc
              pkgs.gocryptfs
              pkgs.dnscrypt-proxy
              pkgs.privoxy
              pkgs.kmonad
              pkgs.cod
              pkgs.tor
              pkgs.bubblewrap
              pkgs.i2pd
              pkgs.docker
              pkgs.podman
              pkgs.nq
              pkgs.firefox
              pkgs.firefox-esr
              pkgs.librewolf
              pkgs.qutebrowser
              pkgs.tor-browser
              pkgs.ungoogled-chromium
              pkgs.irssi
              pkgs.toxic
              pkgs.profanity
              pkgs.dust
              pkgs.broot
              pkgs.gcc
              pkgs.clang
              pkgs.bear
              pkgs.gdb
              pkgs.cmake
              pkgs.meson
              pkgs.ninja
              pkgs.openssl
              pkgs.mdcat
              pkgs.mise
              pkgs.fbterm
              pkgs.foot
              pkgs.alacritty
              pkgs.ghostty
              pkgs.ttyd
              pkgs.python313Packages.scapy
              pkgs.jitterentropy-rngd
              pkgs.haveged
              pkgs.usbguard
              pkgs.wireguard-tools
              pkgs.openvpn
              pkgs.arti
              pkgs.oniux
              pkgs.libreoffice
              pkgs.rlwrap
            ];
          })
          home-manager.nixosModules.home-manager
          ./iso.nix
        ];
      };
    };
  };
}
