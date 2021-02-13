# nix-cfg

## Getting Started

1. Install Nix

```shell
# Ubuntu
$ sh <(curl -L https://nixos.org/nix/install) --daemon
```

```
# Darwin
$ sh <(curl -L https://nixos.org/nix/install) --daemon --darwin-use-unencrypted-nix-store-volume
```

```
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

2. Bootstrap System

```shell
# Ubuntu
$ nix-shell --command switch-home
```

```
# Darwin
$ nix-shell --command switch-darwin
```

```
# NixOS
$ nix-shell --command switch-nixos
```

## Development

```
# Ubuntu
$ nix run .#switchHome
```
```
# Darwin
$ nix run .#switchDarwin
```
```
# NixOS
$ nix run .#switchNixOS
```
