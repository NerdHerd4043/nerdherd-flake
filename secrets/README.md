# How To Add Secrets With Agenix

<https://github.com/ryantm/agenix?tab=readme-ov-file#tutorial>

**Notes:**

- Need to have `agenix` installed, or you can access it via the devShell (`nix develop .`)
- Need to have a valid identity set in [secrets.nix](./secrets.nix) that agenix can use on your current machine (usually `~/.ssh/id_ed25519{.pub}`)
- Run `agenix -e SECRETNAME.age`, it should open `SECRETNAME.age` in your default editor, save and quit to save the secret
- To re-key secrets with newly added identity, run `agenix --rekey`

## Onboarding a New User

### For New User

1. Generate a new SSH key as follows: (if it doesn't exist already) `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519`
2. Edit [`secrets.nix`](./secrets.nix) and add the following:

```diff
diff --git a/secrets/secrets.nix b/secrets/secrets.nix
index ce8c792..aefa758 100644
--- a/secrets/secrets.nix
+++ b/secrets/secrets.nix
@@ -5,6 +5,7 @@ let

   # Users (for acccess)
   nullcube = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8qUgVoBKq5DdokVxzqQmIbrpkvp09s8o3PjAO3HuLr";
+  my-user = "<CONTENTS OF ~/.ssh/id_ed25519.pub>";

   keys = [
     # Systems
@@ -13,6 +14,7 @@ let

     # Users (for access)
     nullcube
+    my-user
   ];
 in
 {
```

3. Commit and create PR with changes (e.g. `secrets: add my user`)
4. Wait for PR to get merged and secrets re-keyed, pull new changes
5. Add/access secrets with `agenix`

### Trusted User

1. Review and Merge PR
2. Pull new changes
3. Enter [`secrets/`](./.)
4. Run `agenix --rekey`
5. Commit and push changes (e.g. `secrets: rekey`)
