{
  config, pkgs, ...
}:
{
  home.stateVersion = "25.11";
  programs.home-manager.enable  = true;

  dconf = {
    enable =true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita";
        icon-theme = "Adwaita";
      };
    };

  };

  home.file.".vimrc" = {
    source = ./vimrc;
  };

  home.file.".tmux.conf" = {
    source = ./tmux.conf;
  };

  home.file.".zshrc" = {
    source = ./zshrc;
  };

  home.file.".p10k.zsh" = {
    source = ./.p10k.zsh;
  };

  home.file.".dir_colors" = {
    source = ./.dir_colors;
  };

  home.file.".config/htop/htoprc" = {
    source = ./htoprc;
  };

  home.file."thinkpad_T430_iso.kbd" = {
    source = ./thinkpad_T430_iso.kbd;
  };

  home.file.".inputrc" = {
    source = ./.inputrc;
  };

  home.file.".irssi/config" = {
    source = ./.irssi/config;
  };
  home.file.".irssi/termi.theme" = {
    source = ./.irssi/termi.theme;
  };
  home.file.".irssi/scripts/autorun/adv_windowlist.pl" = {
    source = ./.irssi/scripts/autorun/adv_windowlist.pl;
  };
  home.file.".irssi/scripts/autorun/scriptassist.pl" = {
    source = ./.irssi/scripts/autorun/scriptassist.pl;
  };
  home.file.".irssi/scripts/autorun/timezones.pl" = {
    source = ./.irssi/scripts/autorun/timezones.pl;
  };
  home.file.".irssi/scripts/autorun/uberprompt.pl" = {
    source = ./.irssi/scripts/autorun/uberprompt.pl;
  };
  home.file.".irssi/scripts/autorun/vim_mode.pl" = {
    source = ./.irssi/scripts/autorun/vim_mode.pl;
  };
  home.file.".irssi/certs/nick.cer" = {
    source = ./certs/nick.cer;
  };
  home.file.".irssi/certs/nick.key" = {
    source = ./certs/nick.key;
  };
  home.file.".irssi/certs/nick.pem" = {
    source = ./certs/nick.pem;
  };

  home.file."keydb/Passwords.kdbx" = {
    source = ./Passwords.kdbx;
  };

  home.file.".ssh/id_ed25519" = {
    source = ./.ssh/id_ed25519;
  };
  home.file.".ssh/id_ed25519.pub" = {
    source = ./.ssh/id_ed25519.pub;
  };

  home.file."flashli.tar.gz" = {
    source = ./flashli.tar.gz;

  };
}
