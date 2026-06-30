{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim

    # Basis, die LazyVim/Treesitter braucht:
    gcc            # Treesitter-Parser kompilieren
    git
    ripgrep
    fd
    lazygit
    fzf
    nodejs         # diverse Tools/LSPs erwarten node

    # Lua (LazyVim editiert man selbst in Lua):
    lua-language-server
    stylua

    # C:
    clang-tools    # clangd + clang-format

    # Rust:
    rust-analyzer

    # Go:
    gopls
    delve
    gofumpt

    # Python:
    pyright
    ruff

    # VHDL:
    vhdl-ls

    # SystemVerilog (Verible: LS + Formatter + Linter):
    verible
    svls          # Alternative/zusätzlicher SV-LS, optional
  ];
}
