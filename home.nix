{ config, pkgs, ... }:
  let
    gatito.black = "252B2E";
    gatito.gray = "D4D4D4";
    gatito.red = "E15A60";
    gatito.green = "99C794";
    gatito.yellow = "FAC863";
    gatito.blue = "6699CC";
    gatito.purple = "C594C5";
    gatito.turquoise = "5FB3B3";
  in 
{
  home.username = "jsqu4re";
  home.homeDirectory = "/home/jsqu4re";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 24;
    "Xft.dpi" = 200;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # default variables
      "$mainMod" = "SUPER";
      "$terminal" = "${pkgs.lib.getExe config.programs.alacritty.package}";
      "$editor" = "${pkgs.lib.getExe pkgs.neovim-unwrapped}";
      "$browser" = "${pkgs.lib.getExe pkgs.floorp}";
      "$launcher" = "${pkgs.lib.getExe pkgs.fuzzel} -b ${gatito.black}F5 -t ${gatito.gray}FF -s ${gatito.red}AF -m ${gatito.yellow}90 -S ${gatito.gray}FF -M ${gatito.green}FF -r 40 -B 20 -C 252B2EF5";
      "$fileManager" = "${pkgs.lib.getExe pkgs.cinnamon.nemo-with-extensions}";

      env = [
        # use igpu for hyprland
        # "WLR_DRM_DEVICES,/dev/dri/card1"
        "WLR_NO_HARDWARE_CURSORS,1"

        # xdg
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        # "XDG_SCREENSHOTS_DIR,${config.screenshotsDir}"

        # qt
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"

        # utilities
        "TERMINAL,$terminal"
        "EDITOR,$editor"
        "BROWSER,$browser"
      ];

      windowrulev2 = [
        # steam
        "float, class:(steam), title:(Steam)"
        "float, class:(steam), title:(Friends List)"
        "nofocus, class:^(steam)$, title:^()$"

        # flameshot
        # "float, title:^(flameshot)"
        # "move 0 0, title:^(flameshot)"
        # "suppressevent fullscreen, title:^(flameshot)"

        # satty
        "noanim, class:(com.gabm.satty)"
        "float, class:(com.gabm.satty)"
      ];

      layerrule = [
        "blur, rofi"
        "ignorezero, rofi"

        # ags
        "blur, ags-*"
        "ignorezero, ags-*"

        # sexshell
        "blur, quickshell"
        "ignorezero, quickshell"
      ];

      monitor = ",preferred,auto,1";

      input = {
        sensitivity = "-0.25";
        accel_profile = "flat";

        follow_mouse = "0";
      };

      general = {
        gaps_in = "4";
        gaps_out = "8";

        no_cursor_warps = "true";

        layout = "dwindle";
      };

      decoration = {
        rounding = "10";

        drop_shadow = "false";
        # shadow_range = "4";
        # shadow_render_power = "3";
        # "col.shadow" = "rgba(1a1a1aee)";

        # dim_inactive = "true";

        blur = {
          enabled = "true";
          size = "8";
          passes = "4";
          # popups = "true";
        };
      };

      #device = {
      #  name = "elan1300:00-04f3:3057-touchpad";
      #  enabled = false;
      #};

      bind = [
        # apps
        "$mainMod, return, exec, $terminal"
        "$mainMod, q, exec, $browser"
        "$mainMod, d, exec, $launcher"
        "$mainMod, e, exec, $fileManager"

        # toggle floating window
        "$mainMod, SPACE, togglefloating"

        # close active window
        "$mainMod SHIFT, q, killactive"

        "$mainMod, f, fullscreen"

        # close hyprland session
        "$mainMod SHIFT, e, exit"

        # move focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # switch workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"

        # move active window to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"

        # scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        
        # scroll through workspaces
        "CTRL $mainMod, right, workspace, e+1"
        "CTRL $mainMod, left, workspace, e-1"

        # obs studio pass
        "$mainMod, F10, pass, ^(com\.obsproject\.Studio)$"

        # screenshotting
        ", PRINT, exec, grimblast copysave screen"
        "CTRL, PRINT, exec, grimblast copysave area"
        "ALT, PRINT, exec, grimblast save area - | satty -f -"
        "SHIFT, PRINT, exec, grimblast copysave active"
      ];

      bindm = [
        # move & resize windows
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      binde = [
        # pipewire volume control
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        # brightness control
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
      ];
    };
  };
  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  # programs.eww = {
  #   configDir = ./eww/config;
  #   enable = true;
  # };

  programs.waybar = {
    enable = true;
    # systemd.enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    wl-clipboard
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    vscode
    fuzzel

    neofetch
    nnn # terminal file manager
    ncdu
    tldr

    steam

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Johannes Jeising";
    userEmail = "johannes.jeising@gmail.com";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 16;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
  home.enableNixpkgsReleaseCheck = false;

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
