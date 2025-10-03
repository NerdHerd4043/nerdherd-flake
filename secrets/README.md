# How To Add Secrets With Agenix

<https://github.com/ryantm/agenix?tab=readme-ov-file#tutorial>

**Notes:**

- Need to have `agenix` installed, or you can access it via the devShell (`nix develop .`)
- Need to have a valid identity set in [secrets.nix](./secrets.nix) that agenix can use on your current machine (usually `~/.ssh/id_ed25519{.pub}`)
- Run `agenix -e SECRETNAME.age`, it should open `SECRETNAME.age` in your default editor, save and quit to save the secret
- To re-key secrets with newly added identity, run `agenix --rekey`
