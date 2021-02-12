# nix-cfg

## Getting Started

1. Install Nix & Enable Flakes

```shell
$ sh <(curl -L https://nixos.org/nix/install) --daemon --darwin-use-unencrypted-nix-store-volume
$ . /etc/zshrc
$ nix-env -iA nixpkgs.nixFlakes
```

2. Disable SIP

[For fancy yabai features](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection#how-do-i-disable-system-integrity-protection)

3. Bootstrap System Config

```
$ nix --experimental-features "nix-command flakes" build github:esselius/nix-cfg#nix-darwin-installer
$ ./result/sw/bin/darwin-rebuild switch --flake github:esselius/nix-cfg
$ unlink result
```

4. Enable SIP

In Recovery mode

```
$ csrutil enable
```

## Updating

```
$ darwin-rebuild switch --flake github:esselius/nix-cfg
```

## Development

```
$ darwin-rebuild switch --flake ~/src/github.com/esselius/nix-cfg
```
