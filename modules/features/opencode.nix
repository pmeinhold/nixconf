{ ... }:
{
  flake.modules.homeManager.feature-opencode = { lib, pkgs, ... }:
  {
    programs.opencode = {
      enable = true;
      settings = {
        provider = {
          zib = {
            npm = "@ai-sdk/openai-compatible";
            name = "ZIB";
            options = {
              baseURL = "https://ollama.zib.de/api";
              # apiKey = "{env:ZIB_API_KEY}";
            };
            models = {
              "llama3.2:latest" = {
                name = "llama3.2:latest";
                # options = {
                #   structuredOutputs = false;
                # };
              };
              "deepseek-coder-v2:latest".name = "deepseek-coder-v2:latest";
              "deepseek-r1:14b".name = "deepseek-r1:14b";
              "llama3:70b".name = "llama3:70b";
              "qwen3-coder-next:latest".name = "qwen3-coder-next:latest";
            };
          };
        };
      };
    };
  };
}
