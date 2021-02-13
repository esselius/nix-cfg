# nix-cfg

## Getting Started

### Install Nix

```shell
# Windows - WSL1
$ wsl -- bash -c 'sh <(curl -L https://nixos.org/nix/install)'
```

```shell
# Ubuntu
$ sh <(curl -L https://nixos.org/nix/install) --daemon
```

```shell
# Darwin
$ sh <(curl -L https://nixos.org/nix/install) --daemon --darwin-use-unencrypted-nix-store-volume
```

```shell
# NixOS
$ cowsay time for coffee
 _________________
< time for coffee >
 -----------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

### Bootstrap System

```shell
# Windows - WSL1
$ nix-shell --command switch-home
```

```shell
# Ubuntu
$ nix-shell --command switch-home
```

```shell
# Darwin
$ nix-shell --command switch-darwin
```

```shell
# NixOS
$ nix-shell --command switch-nixos
```

## Development

```shell
# Windows - WSL1
$ nix run .#switchHome
```

```shell
# Ubuntu
$ nix run .#switchHome
```

```shell
# Darwin
$ nix run .#switchDarwin
```

```shell
# NixOS
$ nix run .#switchNixOS
```
