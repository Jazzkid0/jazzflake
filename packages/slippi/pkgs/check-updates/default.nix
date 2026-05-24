{
  writeShellApplication,
  curl,
  diffutils,
  jq,
  nix,
  nix-prefetch,
}:
writeShellApplication {
  name = "slippi-check-updates";
  runtimeInputs = [
    curl
    diffutils
    jq
    nix
    nix-prefetch
  ];

  text = ''
    set -euo pipefail

    # Map of package -> (GitHub repo, download URL with %s placeholder for version)
    declare -A REPOS=(
      [launcher]="project-slippi/slippi-launcher"
      [netplay]="project-slippi/Ishiiruka"
      [playback]="project-slippi/Ishiiruka-Playback"
      [netplay-beta]="project-slippi/dolphin"
    )

    declare -A URLS=(
      [launcher]="https://github.com/project-slippi/slippi-launcher/releases/download/v%s/Slippi-Launcher-%s-x86_64.AppImage"
      [netplay]="https://github.com/project-slippi/Ishiiruka/releases/download/v%s/FM-Slippi-%s-Linux.zip"
      [playback]="https://github.com/project-slippi/Ishiiruka-Playback/releases/download/v%s/playback-%s-Linux.zip"
      [netplay-beta]="https://github.com/project-slippi/dolphin/releases/download/v%s/Mainline-Slippi-%s-Linux.zip"
    )

    # Packages using fetchzip (need --unpack for correct hash)
    declare -A UNPACK=(
      [netplay]=true
      [playback]=true
      [netplay-beta]=true
    )

    # Resolve flake root
    FLAKE_DIR="$(dirname "$(readlink -f "$0")")"
    if [ -n "''${FLAKE_SOURCE_DIR:-}" ]; then
      FLAKE_ROOT="$FLAKE_SOURCE_DIR"
    else
      DIR="$FLAKE_DIR"
      while [ "$DIR" != "/" ]; do
        if [ -f "$DIR/hashes.nix" ]; then
          FLAKE_ROOT="$DIR"
          break
        fi
        DIR="$(dirname "$DIR")"
      done
      FLAKE_ROOT="''${FLAKE_ROOT:-$PWD}"
    fi

    bold="$(tput bold 2>/dev/null || echo "")"
    green="$(tput setaf 2 2>/dev/null || echo "")"
    yellow="$(tput setaf 3 2>/dev/null || echo "")"
    reset="$(tput sgr0 2>/dev/null || echo "")"
    red="$(tput setaf 1 2>/dev/null || echo "")"

    apply_mode=false
    if [ "''${1:-}" == "--apply" ] || [ "''${1:-}" == "-a" ]; then
      apply_mode=true
    fi

    get_current_version() {
      local pkg="$1"
      nix eval --raw --file "$FLAKE_ROOT/hashes.nix" "$pkg.version"
    }

    get_latest_release() {
      local repo="$1"
      curl -sfL "https://api.github.com/repos/$repo/releases/latest" |
        jq -r '.tag_name // empty'
    }

    strip_v() {
      printf '%s' "''${1#v}"
    }

    prefetch_hash() {
      local url="$1"
      local unpack="$2"
      local flags=""
      if [ "$unpack" = true ]; then
        flags="--unpack"
      fi
      local raw
      raw="$(nix-prefetch-url --type sha256 $flags "$url" 2>&1 | tail -1 | tr -d '[:space:]')"
      nix hash convert --hash-algo sha256 --to sri "$raw"
    }

    had_updates=0
    declare -A new_version
    declare -A new_hash

    for pkg in launcher netplay playback netplay-beta; do
      repo="''${REPOS[$pkg]}"
      url_template="''${URLS[$pkg]}"

      current="$(get_current_version "$pkg")" || {
        echo "''${yellow}?''${reset} slippi-$pkg: could not determine current version" >&2
        continue
      }

      latest_tag="$(get_latest_release "$repo")" || {
        echo "''${yellow}?''${reset} slippi-$pkg: could not fetch latest release from $repo" >&2
        continue
      }

      latest="$(strip_v "$latest_tag")"

      if [ "$current" = "$latest" ]; then
        echo "''${green}✔''${reset} slippi-$pkg @ $current (up to date)" >&2
      else
        echo "''${bold}''${yellow}↑''${reset} slippi-$pkg: $current -> ''${bold}$latest''${reset}" >&2
        had_updates=1

        if [ "$apply_mode" = true ]; then
          url="''${url_template//%s/$latest}"
          echo "  fetching $url ..." >&2
          fetched_hash="$(prefetch_hash "$url" "''${UNPACK[$pkg]:-false}")" || {
            echo "  ''${red}✗''${reset} failed to prefetch hash" >&2
            continue
          }
          echo "  hash: $fetched_hash" >&2
          new_version[$pkg]="$latest"
          new_hash[$pkg]="$fetched_hash"
        fi
      fi
    done

    if [ "$had_updates" -eq 0 ]; then
      exit 0
    fi

    if [ "$apply_mode" = true ]; then
      # Generate diff
      HASHES="$FLAKE_ROOT/hashes.nix"
      MODIFIED="$(mktemp)"

      cp "$HASHES" "$MODIFIED"

      for pkg in launcher netplay playback netplay-beta; do
        if [ -z "''${new_version[$pkg]:-}" ]; then
          continue
        fi

        old_v="$(get_current_version "$pkg")"
        old_h="$(nix eval --raw --file "$FLAKE_ROOT/hashes.nix" "$pkg.hash")"

        # Replace version line (escape dots in regex)
        escaped_old_v="$(printf '%s' "$old_v" | sed 's/\./\\./g')"
        sed -i "s|version = \"$escaped_old_v\"|version = \"''${new_version[$pkg]}\"|" "$MODIFIED"
        # Replace hash line (use | delimiter since hashes can contain /)
        sed -i "s|hash = \"$old_h\"|hash = \"''${new_hash[$pkg]}\"|" "$MODIFIED"
      done

      echo "" >&2
      echo "Diff for $FLAKE_ROOT/hashes.nix:" >&2
      echo "Apply with:  nix run .#update -- --apply | jj apply -" >&2
      echo "" >&2

      (cd "$FLAKE_ROOT" && diff -u hashes.nix "$MODIFIED") |
        sed 's|^+++ .*|+++ hashes.nix|' || true

      rm -f "$MODIFIED"
    else
      echo ""
      echo "To update: edit $FLAKE_ROOT/hashes.nix, bump versions, then run:" >&2
      echo "  nix build $FLAKE_ROOT#slippi-<pkg>" >&2
      echo "Nix will fail on hash mismatch and print the correct SRI hash." >&2
      echo "" >&2
      echo "Or run with --apply to auto-compute the diff:" >&2
      echo "  nix run .#update -- --apply" >&2
      echo "  nix run .#update -- --apply | jj apply -" >&2
    fi
  '';
}
