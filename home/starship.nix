{ ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;   # bei zsh/fish entsprechend umstellen

    settings = {
      add_newline = true;

      format =
        "[](surface0)$username[](bg:surface1 fg:surface0)$directory[](fg:surface1)";

        right_format = 
        "(bg:surface0 fg:lavender)$cmd_duration$jobs$status$c$rust$golang$nodejs$php$java$kotlin$haskell$python$git_branch$git_status[](fg:surface1) ";

       palette = "catppuccin_mocha";


        username = {
          show_always = true;
          style_user = "bg:surface0 fg:text";
          style_root = "bg:surface0 fg:text";
          format = "[$user]($style)";
        };


        directory = {
          style = "bg:surface1 fg:text";
          format = "[ $path ]($style)";
          truncation_length = 4;
        };


        directory.substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "dev" = "󰲋 ";
        };


        git_branch = {
          symbol = "";
          style = "bg:surface1";
          format = "[[ $symbol $branch ](fg:Text bg:surface1)]($style)";
        };

        git_status = {
          # Formatierung der gesamten Git-Status-Anzeige
          format = "([\\[$all_status$ahead_behind\\]](fg:Text bg:surface1)($style))";
          style = "bold red"; # Standardfarbe für kritische Dinge (z.B. Konflikte)

          # Farbliche Unterlegung der einzelnen Zustände
          staged = "[+$count](fg:green bg:surface1)";          # Grün: Bereit für Commit
          modified = "[!$count](fg:yellow bg:surface1)";       # Gelb: Dateien verändert aber nicht gestaged
          untracked = "[?$count](fg:blue bg:surface1)";        # Blau: Neue, nicht getrackte Dateien
          renamed = "[»$count](fg:yellow bg:surface1)";        # Gelb: Umbennant
          deleted = "[✘$count](fg:red bg:surface1)";           # Rot: Gelöscht
          
          # Zusätzliche nützliche Git-Zustände
          conflicted = "[=](fg:red bg:surface1)";              # Rot: Merge-Konflikt
          ahead = "[⇡$count](fg:green bg:surface1)";           # Grün: Du bist dem Server voraus
          behind = "[⇣$count](fg:yellow bg:surface1)";         # Gelb: Du bist hinter dem Server
          diverged = "[⇕⇡$ahead_count⇣$behind_count](fg:red bg:surface1)"; # Rot: Local und Remote weichen ab
        };

        nodejs = {
          symbol = "";
          style = "bg:surface0 fg:Text";
          format = "[[$symqbol](fg:Text bg:surface0)]($style)";
        };

        c = {
          symbol = " ";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        php = {
          symbol = "";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        java = {
          symbol = " ";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        kotlin = {
          symbol = "";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        haskell = {
          symbol = "";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        python = {
          symbol = "  ";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:surface0 fg:Text";
          format = "[[$symbol](fg:Text bg:surface0)]($style)";
        };

        conda = {
        symbol = "  ";
          style = "bg:surface0 fg:Text";
          format = "[$symbol$environment ]($style)";
          ignore_base = false;
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:lavender";
          format = "[[  $time ](fg:crust bg:lavender)]($style)";
        };

        line_break = {
          disabled = false;
        };

        character = {
          disabled = false;
          success_symbol = "[❯](bold fg:lavender)";
          error_symbol = "[❯](bold fg:red)";
          vimcmd_symbol = "[❮](bold fg:lavender)";
          vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
          vimcmd_replace_symbol = "[❮](bold fg:lavender)";
          vimcmd_visual_symbol = "[❮](bold fg:yellow)";
        };

        jobs = {
          symbol = " ";
          threshold = 1;
          format = "[$symbol$number]($style)";
          style = "fg:Text bg:surface0";
          disabled = false;
        };

        status = {
          disabled = false;
          symbol = " [✘](bold red bg:surface3) ";
          success_symbol = " [✔](fg:bold green bg:surface3) ";
          format = "[$symbol$common_meaning$signal_name$maybe_int]($style)";
          map_symbol = true; # Zeigt spezifische Symbole für Fehlerarten;
          style = "fg:Text bg:surface3";
        };

        cmd_duration = {
          show_milliseconds = false;
          format = "[  $duration]($style)";
          style = "fg:Text bg:surface3";
          disabled = false;
          show_notifications = false; 
          min_time = 20;
          min_time_to_notify = 20;
        };

        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };




      # zeigt an, wenn du in einer nix develop / distrobox-Shell bist:
      nix_shell = {
        symbol = " ";
        format = "[$symbol$name]($style) ";
        style = "bold blue";
      };

    };
  };
}
