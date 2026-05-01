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
        trap 'rm -f .luarc.json' EXIT
      '';
    };

    overlays.default = _: prev: {
      nvim-dotfiles = self.packages.${prev.stdenv.system}.nvim-dotfiles;
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

      nvim-dotfiles = pkgs.callPackage (
        {
          stdenv,
          colorscheme,
          ...
        }:
        let
          user_preferences = pkgs.writeText "user_overrides.lua" ''
            return {
                colorscheme = "${colorscheme}",
                use_lsp = false
            }
          '';
        in
        stdenv.mkDerivation (finalAttrs: {
          pname = "nvim-dotfiles";
          version = "1.0.0";
          src = ./.;
          buildPhase = ''
            mkdir $out/lua -p
            ln -sf ${user_preferences} $out/lua/user_overrides.lua
            cp -r ${finalAttrs.src}/* $out/
          '';
        })) { colorscheme = "habamax"; };
    };

  };
}
