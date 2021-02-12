# nix-cfg

## Getting Started

1. Install Nix

```shell
$ sh <(curl -L https://nixos.org/nix/install) --daemon --darwin-use-unencrypted-nix-store-volume
```

2. Bootstrap System Config

```
$ nix-shell --command switch-darwin
```

## Development

```
$ nix run .#switchDarwin
```
