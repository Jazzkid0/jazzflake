# Plan: Implementing `jazzpc` as a Full GUI System

## Overview
Build a working flake activation for `jazzpc`, the first full GUI system in the jazzflake network. This includes NVIDIA GPU support via nixos-hardware, Wayland compositor (niri), and user-level GUI tools via Home Manager.

## Architecture Decision

| Component | Location | Rationale |
|-----------|----------|-----------|
| GPU drivers (NVIDIA) | NixOS (`modules/common/gui.nix`) | Uses nixos-hardware, system-level |
| niri compositor | Home Manager / user launch | User starts manually |
| waybar, mako, foot, ghostty | Home Manager | User-level tools with declarative configs |
| wlr-randr (for output config) | Home Manager | User utility |
| Tailscale, SSH | NixOS (`hosts/jazzpc/default.nix`) | System services, imported via common.nix |

---

## Phase 1: Minimal Working Flake Config

Goal: Get jazzpc building as a base system, in line with jazzserver pattern.

### Step 1: Create hardware configuration

**File**: `hosts/jazzpc/hardware-configuration.nix`

Copy from reference (no changes needed):
```
/home/jazzkid/temp/jazzpc-confnix/hardware-configuration.nix
```

### Step 2: Create `hosts/jazzpc/default.nix`

**File**: `hosts/jazzpc/default.nix`

Based on jazzserver pattern:

Imports:
- `./hardware-configuration.nix`

System configuration:
- `boot.loader.systemd-boot.enable = true`
- `boot.loader.efi.canTouchEfiVariables = true`
- `networking.hostName = "jazzpc"`
- `networking.networkmanager.enable = true`
- `services.tailscale.enable = true`
- `programs.zsh.enable = true` (inherited from common.nix)
- `users.users.jazzkid` with:
  - `isNormalUser = true`
  - `description = "jazzkid"`
  - `extraGroups = [ "networkmanager" "wheel" ]`
  - `shell = pkgs.zsh`
  - SSH keys (same as jazzserver, includes jazzkid@jazzpc key)
- `system.stateVersion` (use "25.05" from reference)

### Step 3: Enable jazzpc in flake.nix

**File**: `flake.nix`

Uncomment and configure jazzpc in `nixosConfigurations`:

```nix
jazzpc = mkSystem {
    hostname = "jazzpc";
    user = "jazzkid";
    modules = [
        # gui modules go here
    ];
};
```

### Step 4: Verify Phase 1

- Run `nix build .#nixosConfigurations.jazzpc.config.system.build.toplevel` to verify it builds
- Check for any errors
- At this point, jazzpc should be a headless system

---

## Phase 2: GPU Support and GUI Tools

Goal: Add NVIDIA GPU drivers, Wayland compositor, and user-level GUI tools.

### Step 5: Enable nixos-hardware in flake.nix

**File**: `flake.nix`

- Uncomment the nixos-hardware input
- Pass it to mkSystem specialArgs

```nix
nixos-hardware.url = "github:nixos/nixos-hardware/master";
```

### Step 6: Populate `modules/common/gui.nix`

**File**: `modules/common/gui.nix`

This module provides GUI system configuration:

- Import nixos-hardware NVIDIA module (GTX 1660 SUPER)
- Configure `hardware.graphics.enable = true`
- Set `hardware.graphics.nvidia` options (modesetting, open kernel module)
- Disable X server: `services.xserver.enable = false`
- Add any system-level Wayland packages if needed
- Note: niri is not enabled as a system service (user starts manually)

### Step 7: Update jazzpc to import gui.nix

**File**: `flake.nix`

Update jazzpc modules:

```nix
jazzpc = mkSystem {
    hostname = "jazzpc";
    user = "jazzkid";
    modules = [
        ./modules/common/gui.nix
    ];
};
```

### Step 8: Add GUI Home Manager modules

Create new files in `users/jazzkid/`:

| File | Contents |
|------|----------|
| `waybar.nix` | waybar configuration, modules ( workspaces, clock, battery, network) |
| `mako.nix` | mako notification daemon config |
| `foot.nix` | foot terminal emulator settings |
| `ghostty.nix` | ghostty terminal (if using instead of foot) |
| `niri.nix` | niri config (keybindings, startup apps) |

**Update**: `users/jazzkid/home.nix`

Add imports for the new GUI modules:

```nix
imports = [
   ./programs.nix
   ./packages.nix
   ./waybar.nix
   ./mako.nix
   ./foot.nix
   # ./ghostty.nix  # if using ghostty
   ./niri.nix
];
```

### Step 9: Verify Phase 2

- Run `nix build .#nixosConfigurations.jazzpc.config.system.build.toplevel` to verify full build
- Check for any errors

---

## Summary of Files to Create/Modify

| File | Action | Phase |
|------|--------|-------|
| `hosts/jazzpc/hardware-configuration.nix` | Copy from reference | 1 |
| `hosts/jazzpc/default.nix` | Create | 1 |
| `flake.nix` | Add jazzpc to nixosConfigurations | 1 |
| `flake.nix` | Uncomment nixos-hardware, add to specialArgs | 2 |
| `modules/common/gui.nix` | Populate with NVIDIA + Wayland config | 2 |
| `flake.nix` | Update jazzpc to import gui.nix | 2 |
| `users/jazzkid/waybar.nix` | Create | 2 |
| `users/jazzkid/mako.nix` | Create | 2 |
| `users/jazzkid/foot.nix` | Create | 2 |
| `users/jazzkid/niri.nix` | Create | 2 |
| `users/jazzkid/home.nix` | Add imports for new modules | 2 |

---

## Notes

- All hosts (including jazzpc) already import from `modules/common/` via `mkSystem` in flake.nix
- Tailscale is not explicitly in common.nix but is added per-host (like jazznas/jazzserver)
- GUI user packages (waybar, mako, foot, etc.) go to Home Manager, not NixOS system packages
- niri is NOT enabled as a systemd service - user launches manually
