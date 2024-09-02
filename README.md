# Quartz Nix

Nix packaging for [Quartz](https://quartz.jzhao.xyz/). Inspired by https://github.com/zdcthomas/quartz_flake but for non-flake Nix.

## Usage

The Nix Derivation is in `build.nix`. You need to call it with [callPackage](https://nix.dev/tutorials/callpackage.html) and with `content` which contains your notes.

The generated website will be on `result/public/`.

### Example
Assume we have our content in `content/`.

```nix
{
  callPackage,
  fetchFromGitHub,
} :
let
  content = ./content;
  quartz-nix = fetchFromGitHub {
    owner = "onsah";
    repo = "quartz-nix";
    rev = "52508932a4f36635ba0a809249f52d43a2421dfd";
    hash = "sha256-OsLuZAsKVZMeh3Fu5uW+GuWQupwj49Fhhn0/DrRQZm0=";
  };
  quartz = callPackage "${quartz-nix}/quartz.nix" { content = content; };
in
quartz
```

You can serve it with [Caddy](https://caddyserver.com/) using the following `Caddyfile`:
```
:8080 {
    root * result/public/
    file_server
    try_files {path} {path}.html {path}/ =404
}
```
