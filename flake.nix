{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      forAllSystems =
        fn:
        let
          systems = [
            "x86_64-linux"
            "aarch64-darwin"
          ];
        in
        nixpkgs.lib.genAttrs systems (
          system:
          fn (
            import nixpkgs {
              inherit system;
            }
          )
        );
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.pnpm
            pkgs.nodejs

            # pkgs.elmPackages.elm
            # pkgs.elmPackages.elm-format
            pkgs.elmPackages.elm-language-server

            pkgs.emmet-ls
            pkgs.nodePackages.typescript-language-server
            pkgs.nodePackages_latest.svelte-language-server
            pkgs.nodePackages."@tailwindcss/language-server"
          ];
        };
      });
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
