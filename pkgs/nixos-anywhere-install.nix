{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "Nixos-Anywhere Installer";
  runtimeInputs = with pkgs; [
    nixos-anywhere
    coreutils-full
    openssh
    agenix
  ];

  text = # bash
    ''
      if [ -z "$1" ] || [ -z "$2" ]; then echo "var is unset"; exit; fi

      # Create a temporary directory
      temp=$(mktemp -d)
      temp2=$(mktemp -d)

      # Function to cleanup temporary directory on exit
      cleanup() {
        rm -rf "$temp"
        rm -rf "$temp2"
      }
      trap cleanup EXIT

      # Create the directory where sshd expects to find the host keys
      install -d -m755 "$temp/etc/ssh"

      ssh-keygen -t ed25519 -f "$temp/etc/ssh/ssh_host_ed25519_key" -N ""

      pub=$(cat "$temp/etc/ssh/ssh_host_ed25519_key.pub")

      # Set the correct permissions so sshd will accept the key
      chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"

      # Manually do re-keying stuff
      echo "The public key is:"
      echo "$pub"

      echo "Put disk secret here:"
      echo "$temp2"

      # echo "my-super-safe-password" > /tmp/disk-1.key

      read -p "Press y to continue" -n 1 -r
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
        # Install NixOS to the host system with our secrets
        nixos-anywhere \
        --extra-files "$temp" \
        --disk-encryption-keys /tmp/secret.key "$temp2/secret.key" \
        --flake "$1" \
        --target-host "$2"
      fi
    '';
}
