{ config, pkgs, ... }:
  let
    color.background = "2E3440";
    color.foreground = "D8DEE9";
    color.black = "3B4252";
    color.red = "BF616A";
    color.green = "A3BE8C";
    color.yellow = "EBCB8B";
    color.blue = "81A1C1";
    color.magenta = "B48EAD";
    color.cyan = "88C0D0";
    color.white = "E5E9F0";
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

  # services.hyprpaper.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      # default variables
      "$mainMod" = "SUPER";
      "$terminal" = "${pkgs.lib.getExe config.programs.alacritty.package}";
      "$editor" = "${pkgs.lib.getExe pkgs.neovim-unwrapped}";
      "$browser" = "${pkgs.lib.getExe pkgs.floorp}";
      "$launcher" = "${pkgs.lib.getExe pkgs.fuzzel} -b ${color.background}F5 -t ${color.foreground}FF -s ${color.cyan}AF -m ${color.yellow}90 -S ${color.black}FF -M ${color.green}FF -r 40 -B 2 -C ${color.white}F5 -y 30 -P 20";
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
        # "float, class:(steam), title:(Steam)"
        # "float, class:(steam), title:(Friends List)"
        # "nofocus, class:^(steam)$, title:^()$"

        # flameshot
        # "float, title:^(flameshot)"
        # "move 0 0, title:^(flameshot)"
        # "suppressevent fullscreen, title:^(flameshot)"

        # satty
        "noanim, class:(com.gabm.satty)"
        "float, class:(com.gabm.satty)"

        "opacity 0.9 0.9, class:^(.*)$"
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

        follow_mouse = "1";
      };

      general = {
        gaps_in = "8";
        gaps_out = "24";

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

        "$mainMod, r, resizeactive"

        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

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
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 10;
        modules-left = [
          "hyprland/workspaces"
          "pulseaudio"
          "cpu"
          "memory"
          "disk"
        ];
        "cpu" = {
          interval=1;
          format=" &#xf2db; {icon} ";
          format-icons={
            default= [
              "          "
              "|         "
              "||        "
              "|||       "
              "||||      "
              "|||||     "
              "||||||    "
              "|||||||   "
              "||||||||  "
              "||||||||| "
              "||||||||||"
            ];
          };
        };
        "memory" = {
          interval=1;
          format=" &#xf3ff; {icon} ";
          format-icons={
            default= [
              "          "
              "|         "
              "||        "
              "|||       "
              "||||      "
              "|||||     "
              "||||||    "
              "|||||||   "
              "||||||||  "
              "||||||||| "
              "||||||||||"
            ];
          };
        };
        "disk" = {
          interval=1;
          format=" &#xf1c0; {free} ";
        };
        "pulseaudio"= {
          format="{icon}";
          format-muted="&#xF6A9;        ";
          format-icons={
            default= [
              "&#xF026;        "
              "&#xF027;        "
              "&#xF028;        "
              "&#xF028; )      "
              "&#xF028; )|     "
              "&#xF028; )||    "
              "&#xF028; )|||   "
              "&#xF028; )||||  "
              "&#xF028; )||||| "];
          };
          on-click="wpctl set-mute @DEFAULT_SINK@ toggle";
          on-click-right="pavucontrol";
        };
        modules-center = ["hyprland/window"];
        modules-right = ["tray" "clock"];
      };
    };
    # font-family: Source Code Pro;
    # #workspaces button {
    #   padding: 0 5px;
    # }
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-size: 14px;
        font-family: "Arimo Nerd Font", "Font Awesome 5 Free", "Font Awesome 6 Free";
      }
      window#waybar {
        background: transparent;
        color: #${color.foreground};
      }

      #workspaces button {
        padding-left: 10px;
        padding-right: 10px;
        /*padding-top: 5px;
        padding-bottom: 5px;*/

        background-color: #${color.background};
        color: inherit;
        font-weight: 600;
        border-top: 4px solid transparent;
        border-bottom: 3px solid transparent;
        border-left: 2px solid #${color.yellow};
      }

      #workspaces button:hover {
        background: #${color.black};
        box-shadow: inherit;
        text-shadow: inherit;
        border-bottom: 3px solid #${color.yellow};
        border-top: 3px solid #${color.yellow};
      }

      #workspaces button.focused {
        background: #${color.green};

        border-top: 3px solid #${color.cyan};
        border-bottom: 3px solid #${color.cyan};
        border-left: 2px solid #${color.cyan};

        color: #${color.cyan};
      }

      #workspaces button.active {
        background: #${color.yellow};
        color: #${color.black};
      }

      #workspaces button:first-child {
        border-left: 0;
      }
      #workspaces button.focused + button {
        border-left: none;
      }

      #workspaces button.focused:first-child {
        border-left: none;
      }

      #workspaces button.focused:last-child {
        border-right: none;
      }

      #workspaces button.urgent {
        background-color: #${color.red};
      }

      #window, #disk, #mpd, #pulseaudio, #network, #cpu, #memory, #temperature, #clock {
        padding-left: 8px;
        padding-right: 8px;
        /*
        padding-top: 5px;
        padding-bottom: 5px;
        */

        background-color: #${color.background};
        color: inherit;
        font-weight: 600;
        border-top: 4px solid transparent;
        border-bottom: 3px solid transparent;
        border-left: 2px solid #${color.cyan};
      }

      #window, #disk {
        border-right: 2px solid #${color.cyan};
      }

      #tray {
        background-color: #${color.background};
        padding-left: 8px;
        padding-right:8px;
        min-width: 40px;
        border-left: 2px solid #${color.cyan};
        font-size: 20px;
      }

      #clock {
        font-size: 18px;
      }

      @keyframes blink {
        to {
            background-color: #ffffff;
            color: black;
        }
      }
    '';
    systemd.enable = true;
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
    nixpkgs-fmt
    fuzzel
    cmatrix
    gnome.nautilus
    # gimp
    # audacity
    whatsapp-for-linux

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

    htop
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

    # fonts
    fira-code
    fira-code-symbols
    font-awesome
    liberation_ttf
    mplus-outline-fonts.githubRelease
    nerdfonts
    noto-fonts
    noto-fonts-emoji
    proggyfonts
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
    settings = builtins.fromTOML (builtins.readFile ./alacritty/nord.toml);
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
  home.stateVersion = "24.05";
  home.enableNixpkgsReleaseCheck = false;

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
