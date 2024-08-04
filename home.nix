{ config, pkgs, ... }:
  let
    color.background = "2E3440";
    color.lightbackground = "3E4656";
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

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 1000;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "#${color.foreground}";
          inner_color = "#${color.lightbackground}";
          outer_color = "#${color.background}";
          outline_thickness = 5;
          placeholder_text = "Password";
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      # splash = false;
      # splash_offset = 2.0;

      preload =
        [ "${./assets/background.png}" ];

      wallpaper = [
        "HDMI-A-3,${./assets/background.png}"
        "eDP-1,${./assets/background.png}"
      ];
    };
  };

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

      monitor = ["HDMI-A-3,3840x2160@60,0x0,1" "Unknown-1,disable"];

      input = {
        sensitivity = "-0.25";
        accel_profile = "flat";

        follow_mouse = "1";
      };

      general = {
        gaps_in = "8";
        gaps_out = "24";

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
        "$mainMod, 0, workspace, 10"

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
        "$mainMod SHIFT, 0, movetoworkspace, 10"

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

      misc = {
        disable_hyprland_logo = true;
      };
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
        "clock"= {
          format = "{:%H:%M}";
          format-alt = "{:%A   %d. %B %Y   %R}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#${color.foreground}'><b>{}</b></span>";
              days = "<span color='#${color.foreground}'><b>{}</b></span>";
              weeks = "<span color='#${color.cyan}'><b>W{}</b></span>";
              weekdays = "<span color='#${color.cyan}'><b>{}</b></span>";
              today = "<span color='#${color.yellow}'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        modules-center = ["hyprland/window"];
        modules-right = ["tray" "clock"];
      };
    };
    # font-family: Source Code Pro;
    # #workspaces button {
    #   padding: 0 5px;
    # }
    # margin-left: 5px;
    # margin-right: 5px;
    style = ''
      * {
        border: none;
        border-radius: 20;
        font-size: 16px;
        font-family: "Arimo Nerd Font", "Font Awesome 5 Free", "Font Awesome 6 Free";
      }
      window#waybar {
        background: transparent;
        color: #${color.foreground};
      }

      #workspaces button {        
        padding-left: 10px;
        padding-right: 10px;
        margin-top: 8px;
        margin-left: 5px;
        /*padding-top: 5px;
        padding-bottom: 5px;*/

        background-color: #${color.background};
        color: inherit;
        font-weight: 600;
        border-top: 2px solid #${color.lightbackground};
        border-bottom: 1px solid #${color.lightbackground};
        border-right: 2px solid #${color.background};
        border-left: 2px solid #${color.yellow};
      }

      #workspaces button:hover {
        background: #${color.black};
        box-shadow: inherit;
        text-shadow: inherit;
        border-bottom: 2px solid #${color.yellow};
        border-top: 2px solid #${color.yellow};
        border-right: 2px solid #${color.yellow};
      }

      #workspaces button.focused {
        background: #${color.green};

        /*border-top: 3px solid #${color.cyan};
        border-bottom: 3px solid #${color.cyan};
        border-left: 2px solid #${color.cyan};*/

        color: #${color.cyan};
      }

      #workspaces button.active {
        border-top: 2px solid #${color.yellow};
        border-bottom: 2px solid #${color.yellow};
        border-right: 2px solid #${color.yellow};
        border-left: 2px solid #${color.yellow};
        background: #${color.yellow};
        color: #${color.black};
      }

      #workspaces button:first-child {
        margin-left: 20px;
        /*border-left: 0;*/
      }
      #workspaces button.focused + button {
        border-left: 2px solid #${color.cyan};
      }

      /*#workspaces button.focused:first-child {
        border-left: none;
      }

      #workspaces button.focused:last-child {
        border-right: none;
      }*/

      #workspaces button.urgent {
        background-color: #${color.red};
      }

      #pulseaudio, #cpu, #memory, #disk{
        margin-left: 5px;
        border-left: 2px solid #${color.cyan};
      }

      #window, #disk, #mpd, #pulseaudio, #network, #cpu, #memory, #temperature, #clock {
        padding-left: 8px;
        padding-right: 8px;
        margin-top: 8px;
        border-top: 2px solid #${color.lightbackground};
        border-bottom: 1px solid #${color.lightbackground};
        /*
        padding-top: 5px;
        padding-bottom: 5px;
        */

        background-color: #${color.background};
        color: inherit;
        font-weight: 600;
        /*border-top: 4px solid transparent;
        border-bottom: 3px solid transparent;*/
      }

      #disk, #clock {
        border-left: 2px solid #${color.cyan};
        border-right: 2px solid #${color.yellow};
      }
      
      #window {
        border-left: 2px solid #${color.yellow};
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
        margin-right: 20px;
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
    vscode
    floorp
    nixpkgs-fmt
    fuzzel
    cmatrix
    gnome.nautilus
    gimp
    # audacity
    whatsapp-for-linux

    neofetch
    nnn # terminal file manager
    ncdu
    tldr

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

    # misc
    cowsay
    file
    which
    tree
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

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # fonts
    font-awesome
    liberation_ttf
    nerdfonts


    #games
    # itch
    steam
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Johannes Jeising";
    userEmail = "johannes.jeising@gmail.com";
    aliases = {
      co = "checkout";
      st = "status";
      p = "push";
      c = "commit";
      cm = "commit -m";
      aa = "add --all";
    };
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
      # Go here
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
