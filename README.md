# Caplo CLI

Official binary distribution for the Caplo command-line interface. The CLI source is private; this repository contains installation files and public release assets only.

## Install with Homebrew

On macOS or Linux (including Ubuntu), ARM64 or AMD64:

```sh
brew install getcaplo/tap/caplo
caplo --version
```

Update with `brew update && brew upgrade getcaplo/tap/caplo`. Uninstall with `brew uninstall caplo`.

## Install with curl

Requires `curl`, `tar`, and `sha256sum` (Linux) or `shasum` (macOS). Ubuntu: `sudo apt-get install curl ca-certificates tar coreutils`.

```sh
curl -fsSL https://cli.caplo.si/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
caplo --version
```

The custom domain is served by GitHub Pages from this public repository. Release binaries remain on GitHub Releases. The [raw GitHub installer](https://raw.githubusercontent.com/getcaplo/homebrew-tap/main/install.sh) remains available as a fallback.

The installer resolves the latest release once, downloads the matching versioned archive and SHA-256 manifest over HTTPS, and verifies it before atomically installing `~/.local/bin/caplo`. It does not invoke sudo or edit shell configuration. Add the PATH line to your shell profile to keep it.

Pin a version and choose an installation directory:

```sh
curl -fsSL https://raw.githubusercontent.com/getcaplo/homebrew-tap/v0.1.0/install.sh | CAPLO_VERSION=v0.1.0 CAPLO_INSTALL_DIR="$HOME/.local/bin" sh
```

Rerun to upgrade; remove the installed `caplo` file to uninstall. Homebrew and curl are alternative installation methods; avoid keeping two copies on PATH. You may also download and inspect `install.sh` before running it.

## Connect

```sh
caplo auth login
caplo workspace list
caplo workspace use <name-or-id>
```

The defaults are API `https://api.caplo.si`, OIDC issuer `https://auth.caplo.si/realms/caplo`, and public OAuth client `caplo-cli`. The web Console is [app.caplo.si](https://app.caplo.si); the CLI uses API and issuer endpoints directly, with no Console URL setting.

Login precedence is **login flags → nonempty environment variables → saved settings → production defaults**:

```sh
CAPLO_API_URL=https://api.example.com \
CAPLO_ISSUER=https://auth.example.com/realms/caplo \
caplo auth login
# Or: caplo auth login --api-url URL --issuer URL
```

Successful login saves the endpoints. Environment variables apply to login, and do not silently redirect an existing authenticated session. Use `CAPLO_CONFIG_DIR` for separate environments. `caplo config list` shows saved settings (or production defaults); `caplo config set api-url URL` and `caplo config set issuer URL` persist settings. An API change clears the selected workspace. `--workspace` still overrides workspace selection for an individual command.

Tokens use the OS keychain. For headless Linux, use `caplo auth login --device`; if no keychain is available, explicitly choose `--insecure-storage` for a private 0600 token file. Offline tool-package testing requires Node.js 24 and installed package dependencies.

## Downloads and verification

[Releases](https://github.com/getcaplo/homebrew-tap/releases) contain versioned macOS/Linux `.tar.gz` and Windows `.zip` archives for ARM64 and AMD64, `checksums.txt`, and `install.sh`. Homebrew and the shell installer support macOS/Linux. Windows binaries are available for manual installation; local tool testing on Windows requires WSL.

```sh
# In the directory containing a downloaded archive and checksums.txt:
sha256sum --ignore-missing -c checksums.txt  # Linux
# macOS: shasum -a 256 <archive>; compare its line in checksums.txt
```

The release workflow also publishes keyless cosign signatures for `checksums.txt`. Verify with:

```sh
cosign verify-blob checksums.txt \
  --signature checksums.txt.sig --certificate checksums.txt.pem \
  --certificate-identity 'https://github.com/getcaplo/caplo-cli/.github/workflows/release.yaml@refs/tags/v0.1.0' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

Replace the version in the certificate identity with the downloaded release. SHA-256 checks guard integrity; the installer does not itself verify cosign signatures. Release publication and successful installation are not evidence of production API/login acceptance.
