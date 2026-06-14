# Updating Slippi

## Check for updates

```sh
nix run .#slippi-update
```

## Apply updates

```sh
nix run .#slippi-update -- --apply
```

This modifies `packages/slippi/hashes.nix` in place with the new versions and SRI hashes.
Commit the changes when done.

## Verify

```sh
nix build .#slippi-launcher .#slippi-netplay .#slippi-playback .#slippi-netplay-beta
```
