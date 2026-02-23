# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS flake-based configuration repository managing multiple hosts (jazznas, jazzserver, jazzpc). It uses a modular architecture with reusable components, Home Manager for user environments, agenix for secrets, and deploy-rs for remote deployment.

## Common Commands

### Version Control (jj)
```bash
# This repository uses jj (jujutsu), not git
jj status           # Show working copy status
jj log              # Show commit history
jj diff             # Show changes
jj new <change>     # Create new change
jj abandon <id>     # Abandon a change
```

### Building and Testing
```bash
# Build the flake (outputs are in ./result)
nix build

# Check flake validity
nix flake check

# Update flake inputs
nix flake update
```

### Deployment
```bash
# Deploy to a specific host
nix run .#deploy -- --target-host jazznas
nix run .#deploy -- --target-host jazzserver

# Deploy to all hosts
nix run .#deploy
```

### Secrets Management (agenix)
```bash
# Edit a secret (re-encrypts for all keys)
# Note: Use `agenix` CLI after entering nix shell
nix develop
agenix -e secrets/secrets.nix

# When editing secrets, ensure you have the proper SSH keys configured
```

### System Configuration Testing
```bash
# Test a configuration without building
nix repl
nixos-rebuild build --flake .#jazznas  # from target host
nixos-rebuild switch --flake .#jazznas  # from target host
```

## Architecture

### Flake Structure
The `flake.nix` defines a `mkSystem` helper that creates NixOS configurations with:
- Host-specific config from `hosts/{hostname}/default.nix`
- Common modules from `modules/common/common.nix`
- Agenix for secrets
- Home Manager for user configurations from `users/{username}/home.nix`

### Key Directories
- `hosts/` - Per-host configurations (jazznas, jazzserver, jazzpc)
- `hosts/jazznas/hardware/` - Hardware-specific configuration (disks.nix, mounts.nix)
- `modules/common/` - Base system configuration (common.nix, networking.nix, security.nix, gui.nix)
- `modules/server/` - Server-specific optimizations
- `modules/services/` - Individual service configurations (bazarr, jellyfin, jellyseerr, lidarr, nginx, prowlarr, qbittorrent, radarr, readarr, samba, sonarr, transmission)
- `users/` - Home Manager user configurations
- `secrets/` - Agenix-managed encrypted secrets

### Module Patterns
- Service modules are self-contained in `modules/services/`
- Each service module can be imported into host configs as needed
- Media server services use the `nixarr` flake input for unified management
- SSL certificates are managed through Cloudflare DNS with nginx

### Deployment Architecture
- Uses `deploy-rs` for remote deployment via SSH
- Deployments run as root user
- Two active hosts: `jazznas` (nas.jazzkid.xyz) and `jazzserver` (dev.jazzkid.xyz)
- Pre-flight checks run automatically before deployment

## Flake Inputs
- `nixpkgs` - nixos-unstable branch
- `deploy-rs` - Remote deployment
- `home-manager` - User environment management
- `agenix` - Secret encryption
- `fenix` - Rust toolchain
- `nixarr` - Media server stack
- `nvim-config` - Neovim configuration (non-flake)
- `claude-code` - Claude Code Nix integration
