# NerdHerd-Flake

A flake for all of NerdHerd 4043's Nix configurations.

NixOS configurations are under [nixos/hosts/](./nixos/hosts/).

Home-Manager configurations are under [home/hosts/](./home/hosts/).

## Systems

### *P*oppy

***P***it Computer. Currently just for displaying a livestream of the current FRC event.

Services: N/A

Specs:
- Intel Core i5-6500T (2c/4t)
- Intel HD Graphics 530 (Integrated)
- 16 GB RAM
- 120 GB Storage


### Caveserver

Mentor's old PC turned into a server.

Services:
- Team Minecraft Server
- (WIP) Team Wiki

Specs:
- Intel Core i7-4820K (4c/8t)
- NVIDIA Quadro FX 3800
- 16 GB RAM
- 1TB Storage


## System Setup

**WIP**

1. Boot a (preferably minimal) [NixOS live USB](https://nixos.org/download/)
2. Use `passwd` to set a password on the live system
3. Clone this repo to your own computer
4. In this repo run `nix develop .` to get required programs
5. Generate a `hardware-configuration.nix` for the relevant system
6. Edit the system configuration to include it, remove `test-hw-conf.nix`
7. Set the correct disk ID in `disk-configuration.nix`
8. Add an SSH key for access
9. Use [Nixos-Anywhere](https://github.com/nix-community/nixos-anywhere/) to install the system:

```sh
nixos-anywhere --generate-hardware-config nixos-generate-config \
./nixos/hosts/HOSTNAME/hardware-configuration.nix \
--flake ".#HOSTNAME" --target-host "nixos@12.34.56.78"
```
