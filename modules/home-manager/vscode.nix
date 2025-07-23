{
  nixosConfig,
  lib,
  ...
}: {
  config = {
    xdg.configFile."Code/User/mcp.json" = {
      text = builtins.toJSON {servers = nixosConfig.ai.mcp;};
    };

    xdg.configFile."Code/User/prompts/" = {
      source = ./prompts;
      recursive = true;
    };

    programs.vscode = {
      enable = true;
      profiles = lib.genAttrs nixosConfig.ai.vscode.profileNames (
        name: let
          profile = nixosConfig.ai.vscode.profiles.${name} or {};
        in
          lib.mkMerge [
            profile
            {
              userSettings = lib.mkMerge [
                (profile.userSettings or {})
                {
                  "github.copilot.chat.commitMessageGeneration.instructions" = [
                    {
                      text = lib.readFile ./instructions/commit.md;
                    }
                  ];
                }
              ];
            }
          ]
      );
    };
  };
}
