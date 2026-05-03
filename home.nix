{
  config, pkgs, ...
}:
{
  home.stateVersion = "26.05";
  programs.home-manager.enable  = true;

  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

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

  programs.tmux = {
    enable = true;

    plugins = with pkgs.tmuxPlugins; [
      yank
      fzf-tmux-url
      tmux-fzf
      copycat
    ];

    extraConfig = ''
      set -g mouse on
      set -g status-bg colour24
      setw -g mode-keys vi
      bind [ copy-mode
      bind -T copy-mode-vi 'v' send -X begin-selection
      bind -T copy-mode-vi 'y' send -X copy-selection-and-cancel
      bind ] paste-buffer
      bind Space choose-buffer
      bind -n C-h clear-history
      bind P pipe-pane -o "cat >>~/.tmuxrecording/#W.log" \; display "Toggled logging to ~/#W.log"
      bind | split-window -h
      bind - split-window -v
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
      bind-key -n C-S-Left swap-window -t -1\; select-window -t -1
      bind-key -n C-S-Right swap-window -t +1\; select-window -t +1
      set-option -g prefix C-a
      set-option -g history-limit 30000
      bind -n C-k next-window
      bind -n C-j previous-window
      set -g default-command "${pkgs.zsh}/bin/zsh -l"
      set -g default-shell "${pkgs.zsh}/bin/zsh"
      set -g default-terminal "screen-256color"
      set -ag terminal-features 'foot*:extkeys'
      set -g extended-keys-format "csi-u"
      set -s extended-keys always
      bind-key -n C-0 "if-shell -F '#{pane_input_off}' 'select-pane -e' 'select-pane -d'"

      set -g pane-active-border-style fg='#875fff',bold
      set -g pane-border-style fg='#5f87ff'
      set -g pane-border-status top
      set -g pane-border-lines heavy
      set -g pane-border-indicators both

      set -g pane-border-format "#{?#{pane_input_off},\
#[fg=colour196]#{pane_index}:#{pane_title}:#{pane_current_command} [#{pane_key_mode}] #{?#{pane_in_mode},[#{pane_mode}],}#{pane_current_path},\
#{pane_index}:#{pane_title}:#{pane_current_command} #[fg=colour75][#{pane_key_mode}] #{?#{pane_in_mode},[#{pane_mode}],}#[fg=colour26]#{pane_current_path}}"

      set -g @yank_selection 'clipboard'
      set -g @yank_action 'copy-pipe-and-cancel'
      set -g @fzf-url-history-limit '2000'
      set -g @fzf-url-fzf-options '-w 70% -h 70% --multi -0 --no-preview --border=sharp'
    '';
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza";
      l = "eza -abgnhHliSmMxUO";
      ll = "eza -F always -abgnhHliSmMxUO --changed --color-scale all --color-scale-mode gradient --icons always --git --git-repos -@";
      la = "exa -a";
      j = "zoxide";
      w3m = ''
        w3m -o user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"
        '';
      v = "vim";
      digg = "dig && clear";
    };

    initContent = ''
      autoload -Uz compinit
      compinit

      zmodload zsh/complist
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      zstyle ':completion:*' menu select
      zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
      zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
      zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
      zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' special-dirs true
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      eval `dircolors ~/.dir_colors`

      setopt APPEND_HISTORY
      setopt EXTENDED_HISTORY
      setopt HIST_FIND_NO_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_NO_STORE
      setopt HIST_REDUCE_BLANKS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_FIND_NO_DUPS
      setopt HIST_VERIFY
      setopt SHARE_HISTORY
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt NO_BEEP
      setopt INTERACTIVE_COMMENTS
      setopt PROMPT_SUBST
# no more C-s and C-q
      unsetopt FLOW_CONTROL
      setopt LONG_LIST_JOBS
      setopt +o nomatch
      export HISTFILE=~/.zsh_history
      setopt LIST_PACKED
      export HISTSIZE=100000
      export SAVEHIST=100000


      eval "$(fzf --zsh)"

      export FZF_TMUX_OPTS="-p 90%,90% --border=sharp"
      export FZF_DEFAULT_OPTS="--color fg:7,bg:0,hl:31,fg+:24,bg+:0,hl+:63,info:34,prompt:27,spinner:24,pointer:24,marker:22"
      export WWW_HOME="https://searx.terminaldweller.com"
      export COLORTERM=truecolor
      export LESS_TERMCAP_mb=$'\e[01;31m'
      export LESS_TERMCAP_md=$'\e[01;38;5;74m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\x1b[48;5;22m\x1b[38;5;0m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[04;38;5;146m'
      export EDITRO="vim"
      export VISUAL="w3m"
      export WWW_HOME="https://searx.terminaldweller.com"

      dig() {
        globalholecounter=0
        local ABBATOIR_PATH="/home/devi/devi/abbatoir"
        mkdir -p ''${ABBATOIR_PATH}
        if test "$("ls" -A ''${ABBATOIR_PATH})"; then
          while [ 1 ]; do
            if [ -d "''${ABBATOIR_PATH}/hole$globalholecounter" ]; then
              # if its not empty
              if test "$("ls" -A "''${ABBATOIR_PATH}/hole$globalholecounter")"; then
                :
              # if its empty
              else
                cd ''${ABBATOIR_PATH}/hole$globalholecounter
                break
              fi
            else
              mkdir ''${ABBATOIR_PATH}/hole$globalholecounter
              cd ''${ABBATOIR_PATH}/hole$globalholecounter
              echo $globalholecounter
              break
            fi
            ((globalholecounter++))
          done
        else
          mkdir ''${ABBATOIR_PATH}
          mkdir ''${ABBATOIR_PATH}/hole$globalholecounter
          cd ''${ABBATOIR_PATH}/hole$globalholecounter
        fi
      }

      burrow() {
        globalholecounter=0
        local FLESH_PIT_PATH="/tmp/fleshpit"
        mkdir -p ''${FLESH_PIT_PATH}
        if test "$("ls" -A ''${FLESH_PIT_PATH})"; then
          while [ 1 ]; do
            if [ -d "''${FLESH_PIT_PATH}/pit$globalholecounter" ]; then
              # if its not empty
              if test "$("ls" -A "''${FLESH_PIT_PATH}/pit$globalholecounter")"; then
                :
              # if its empty
              else
                cd ''${FLESH_PIT_PATH}/pit$globalholecounter
                break
              fi
            else
              mkdir ''${FLESH_PIT_PATH}/pit$globalholecounter
              cd ''${FLESH_PIT_PATH}/pit$globalholecounter
              echo $globalholecounter
              break
            fi
            ((globalholecounter++))
          done
        else
          mkdir -p ''${FLESH_PIT_PATH}
          mkdir ''${FLESH_PIT_PATH}/pit$globalholecounter
          cd ''${FLESH_PIT_PATH}/pit$globalholecounter
        fi
      }

      bindkey -v

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
      [[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

      eval "$(mise activate zsh)"

      export CARGO_HOME="''${CARGO_HOME:-$HOME/.cargo}"
      export RUSTUP_HOME="''${RUSTUP_HOME:-$HOME/.rustup}"
      export PATH="$CARGO_HOME/bin:$PATH"

      bindkey "^@" autosuggest-accept
    '';
  };

  home.file.".vimrc" = {
    source = ./vimrc;
  };

  # home.file.".tmux.conf" = {
  #   source = ./tmux.conf;
  # };

  # home.file.".zshrc" = {
  #   source = ./zshrc;
  # };

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

  home.file.".config/foot/foot.ini" = {
    source = ./foot.ini;
  };

  # home.file."flashli.tar.gz" = {
  #   source = ./flashli.tar.gz;
  # };

  home.file."be-bru-wg-102.conf" = {
    source = ./be-bru-wg-102.conf;
  };
}
