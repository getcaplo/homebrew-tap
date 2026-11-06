#!/bin/sh
# Install a released Caplo binary without root privileges. POSIX sh; macOS and Linux.
set -eu

main() {
  repo=https://github.com/getcaplo/homebrew-tap
  version=${CAPLO_VERSION:-latest}
  install_dir=${CAPLO_INSTALL_DIR:-"$HOME/.local/bin"}
  case "$(uname -s)" in
    Darwin) os=darwin ;;
    Linux) os=linux ;;
    *) echo 'Unsupported OS: use macOS or Linux.' >&2; exit 1 ;;
  esac
  case "$(uname -m)" in
    arm64|aarch64) arch=arm64 ;;
    x86_64|amd64) arch=amd64 ;;
    *) echo 'Unsupported architecture: use ARM64 or AMD64.' >&2; exit 1 ;;
  esac
  for command in curl tar awk mktemp; do
    command -v "$command" >/dev/null 2>&1 || { echo "Required command missing: $command" >&2; exit 1; }
  done
  if command -v sha256sum >/dev/null 2>&1; then
    hash_command=sha256sum
  elif command -v shasum >/dev/null 2>&1; then
    hash_command=shasum
  else
    echo 'Required: sha256sum (Linux) or shasum (macOS).' >&2; exit 1
  fi
  if [ "$version" = latest ]; then
    resolved=$(curl --proto '=https' --tlsv1.2 -fsSL --retry 3 --connect-timeout 15 --max-time 120 -o /dev/null -w '%{url_effective}' "$repo/releases/latest")
    version=${resolved##*/}
  fi
  # Stable versions only: reject path traversal, shell syntax, and malformed URLs.
  if ! printf '%s\n' "$version" | awk '/^v[0-9]+\.[0-9]+\.[0-9]+$/ {ok=1} END {exit !ok}'; then
    echo 'CAPLO_VERSION must be latest or a stable version such as v0.1.0.' >&2; exit 1
  fi
  archive="caplo_${version#v}_${os}_${arch}.tar.gz"
  base="$repo/releases/download/$version"
  tmp=$(mktemp -d)
  staged=
  trap 'rm -rf "$tmp"; if [ -n "$staged" ]; then rm -f "$staged"; fi' EXIT
  trap 'exit 1' HUP INT TERM
  curl --proto '=https' --tlsv1.2 -fsSL --retry 3 --connect-timeout 15 --max-time 300 "$base/$archive" -o "$tmp/$archive"
  curl --proto '=https' --tlsv1.2 -fsSL --retry 3 --connect-timeout 15 --max-time 120 "$base/checksums.txt" -o "$tmp/checksums.txt"
  expected=$(awk -v name="$archive" '$2 == name {hash=$1; count++} END {if(count!=1) exit 1; print hash}' "$tmp/checksums.txt") || {
    echo "Missing or duplicate checksum for $archive" >&2; exit 1;
  }
  if [ "$hash_command" = sha256sum ]; then
    actual=$(sha256sum "$tmp/$archive" | awk '{print $1}')
  else
    actual=$(shasum -a 256 "$tmp/$archive" | awk '{print $1}')
  fi
  [ "$expected" = "$actual" ] || { echo "Checksum mismatch for $archive; nothing installed." >&2; exit 1; }
  tar -xzf "$tmp/$archive" -C "$tmp" caplo
  [ -f "$tmp/caplo" ] && [ ! -L "$tmp/caplo" ] || { echo 'Invalid binary archive.' >&2; exit 1; }
  mkdir -p "$install_dir"
  staged=$(mktemp "$install_dir/.caplo-XXXXXXXX")
  cp "$tmp/caplo" "$staged"
  chmod 755 "$staged"
  mv -f "$staged" "$install_dir/caplo"
  staged=
  printf 'Installed Caplo %s to %s/caplo\n' "$version" "$install_dir"
  case ":$PATH:" in
    *":$install_dir:"*) ;;
    *) printf 'Add this directory to PATH: %s\n' "$install_dir" ;;
  esac
}

main "$@"
