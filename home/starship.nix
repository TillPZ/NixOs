{ ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;   # bei zsh/fish entsprechend umstellen

    settings = {
      add_newline = true;

      format = ''
        $directory$git_branch$git_status$nix_shell$cmd_duration
        $character'';

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold yellow";
      };

      # zeigt an, wenn du in einer nix develop / distrobox-Shell bist:
      nix_shell = {
        symbol = " ";
        format = "[$symbol$name]($style) ";
        style = "bold blue";
      };

      cmd_duration = {
        min_time = 500;
        format = "[ $duration]($style) ";
        style = "italic dimmed white";
      };
    };
  };
}
