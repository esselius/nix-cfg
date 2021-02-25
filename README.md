# nix-cfg

## Getting Started

### Install Nix

```shell
# Ubuntu
$ sh <(curl -L https://nixos.org/nix/install) --daemon --nix-extra-conf-file nix.conf
```

```shell
# Darwin
$ sh <(curl -L https://nixos.org/nix/install) --daemon --nix-extra-conf-file nix.conf --darwin-use-unencrypted-nix-store-volume
```

### Bootstrap System

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
