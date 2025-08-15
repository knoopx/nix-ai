{
  pkgs,
  lib,
  ...
}: let
  llamaServer = {
    name,
    context,
    reasoning ? false,
    tools ? false,
    args ? [],
  }: {
    inherit context reasoning tools;
    # cmd = ''
    #   ${pkgs.llama-cpp}/bin/llama-server -hf ${name} --ctx-size ${toString context} --port ''${PORT} \
    #     ${lib.concatStringsSep " " args}
    # '';
    cmd = ''
      ${pkgs.podman}/bin/podman run --rm --name llama-server --replace --device=nvidia.com/gpu=all --ipc=host -p ''${PORT}:8080 \
        -v /var/cache/llama.cpp/:/root/.cache/llama.cpp/ \
        ghcr.io/ggml-org/llama.cpp:server-cuda \
        -hf ${name} --ctx-size ${toString context} \
        ${lib.concatStringsSep " " args}
    '';
  };

  vllmServer = {
    name,
    context,
    reasoning ? false,
    tools ? false,
    args ? [],
  }: {
    inherit context reasoning tools;
    cmd = ''
      ${pkgs.podman}/bin/podman run --rm --name vllm --replace --device=nvidia.com/gpu=all -p ''${PORT}:8880 \
        -v /var/cache/huggingface/:/root/.cache/huggingface/ \
        vllm/vllm-openai:gptoss --model ${name}  \
        ${lib.concatStringsSep " " args}
    '';
  };
in {
  ai = {
    models = {
      "qwen2.5-coder" = llamaServer {
        name = "bartowski/Qwen2.5-Coder-32B-Instruct-GGUF:IQ4_NL";
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
          "--slots"
          "--temp 0.6"
          "--top-k 40"
          "--top-p 0.95"
          "--threads -1"
          "-ngl 99"
          "--temp 1.0"
          "-top-p 1.0"
          "--top-k 0"
        ];
      };

      "qwen3-coder-30b-a3b-instruct" = llamaServer {
        name = "unsloth/Qwen3-Coder-30B-A3B-Instruct-1M-GGUF:IQ4_NL";
        context = 64000;
        reasoning = true;
        tools = true;
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

      "gpt-oss-20b" = llamaServer {
        name = "unsloth/gpt-oss-20b-GGUF";
        reasoning = true;
        tools = true;
        context = 131072;
        args = [
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
          "--flash-attn"
          "--jinja"
          "-ngl 99"
          "--top-k 40"
          "--top-p 0.95"
          "--threads -1"
          "--temp 1.0"
          "--top-p 1.0"
          "--top-k 0"

          # "--cache-type-k q8_0"
          # "--cache-type-v q8_0"
          # "--flash-attn"
          # "--jinja"
          # "--metrics"
          # "--no-context-shift"
          # "--no-mmap"
          # "--slots"
          # "-ngl 99"
        ];
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
