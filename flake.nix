{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }:
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in 
  {

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.lua
        pkgs.lua-language-server
        pkgs.neovim
      ];

      shellHook = ''
        rm -rf .luarc.json
        ln -sf ${self.packages.${system}.luarc-config} .luarc.json
      '';
    };

    packages.${system} = {
      luarc-config = pkgs.writeText ".luarc.json" (builtins.toJSON {
        diagnostics.globals = [ "vim" ];
        workspace.library = [ "${pkgs.neovim-unwrapped}/share/nvim/runtime/lua" ];
      });
      lazy-nvim-src = pkgs.pkgs.fetchgit {
        url = "https://github.com/folke/lazy.nvim";
        rev = "306a05526ada86a7b30af95c5cc81ffba93fef97";
        hash = "sha256-5A4kducPwKb5fKX4oSUFvo898P0dqfsqqLxFaXBsbQY=";
      };
    };

  };
}
