{
  description = "AI modules for NixOS and Home Manager";

  outputs = {self, ...}: {
    nixosModules.default = ./modules/nixos/ai.nix;
  };
}
