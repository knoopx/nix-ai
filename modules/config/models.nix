{
  pkgs,
  lib,
  ...
}: let
  llamaServer = {
    name,
    context,
    args ? [],
  }: {
    context = context;
    cmd = ''
      ${pkgs.llama-cpp}/bin/llama-server -hf ${name} --ctx-size ${toString context} --port ''${PORT} \
        ${lib.concatStringsSep " " args}
    '';
    # cmd = ''
    #   ${pkgs.podman}/bin/podman run --rm --name llama-server --device=nvidia.com/gpu=all --ipc=host -p ''${PORT}:8080 \
    #     -v /var/cache/llama.cpp/:/root/.cache/llama.cpp/ \
    #     ghcr.io/ggml-org/llama.cpp:server-cuda \
    #     -hf ${name} --ctx-size ${toString context} \
    #     ${lib.concatStringsSep " " args}
    # '';
  };

  vllmServer = {
    name,
    context,
    args ? [],
  }: {
    context = context;
    #     sudo podman run --rm --name vllm --device=nvidia.com/gpu=all -p 8099:8880 -v ~/.cache/huggingface:/root/.cache/huggingface --ipc=host vllm/vllm-openai:latest
    # openai/gpt-oss-20b
    cmd = ''
      ${pkgs.podman}/bin/podman run --rm --name vllm --device=nvidia.com/gpu=all -p ''${PORT}:8880 \
        -v /var/cache/huggingface/:/root/.cache/huggingface/ \
        vllm/vllm-openai:latest ${name}  \
        ${lib.concatStringsSep " " args}
    '';
  };
in {
  ai = {
    models = {
      # "qwen2.5-coder" = llamaServer {
      #   name = "bartowski/Qwen2.5-Coder-32B-Instruct-GGUF:IQ4_NL";
      #   context = 32768;
      #   args = [
      #     "--cache-type-k q8_0"
      #     "--cache-type-v q8_0"
      #     "--flash-attn"
      #     "--jinja"
      #     "--metrics"
      #     "--min-p 0.01"
      #     "--no-context-shift"
      #     "--no-mmap"
      #     "--slots"
      #     "--temp 0.6"
      #     "--top-k 40"
      #     "--top-p 0.95"
      #     "-ngl 99"
      #   ];
      # };

      "qwen3-coder-30b-a3b-instruct" = llamaServer {
        name = "unsloth/Qwen3-Coder-30B-A3B-Instruct-1M-GGUF:IQ4_NL";
        context = 32768;
        args = [
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
          "--flash-attn"
          "--jinja"
          "--metrics"
          "--min-p 0.01"
          "--no-context-shift"
          "--no-mmap"
          "--reasoning-format deepseek"
          "--slots"
          "--temp 0.6"
          "--top-k 40"
          "--top-p 0.95"
          "-ngl 99"
        ];
      };

      "gpt-oss-20b" = vllmServer {
        name = "unsloth/gpt-oss-20b-GGUF";
        context = 128000;
      };

      "kokoro" = {
        unlisted = true;
        cmd = ''
          ${pkgs.podman}/bin/podman run --rm --name kokoro --device=nvidia.com/gpu=all -p ''${PORT}:8880 ghcr.io/remsky/kokoro-fastapi-gpu:latest
        '';
        aliases = [
          "tts-1"
        ];
      };
    };
  };
}
