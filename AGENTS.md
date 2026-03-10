# AGENTS.md

## Repository Overview

Multi-host system flake. Modular, with remote deployment.

### Flake Structure
The `flake.nix` defines a `mkSystem` helper that creates NixOS configurations with:
- Host-specific config from `hosts/{hostname}/default.nix`
- Common modules from `modules/common/common.nix`
- Home Manager for user configurations from `users/{username}/home.nix`
- Optional gui modules
- Agenix for secrets
