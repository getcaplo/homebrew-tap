class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.5.1"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.5.1/caplo_0.5.1_darwin_arm64.tar.gz"
      sha256 "cfd24469f77e0472ab0132e6deef595f686216b116216b18a2ccb1d881612694"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.5.1/caplo_0.5.1_darwin_amd64.tar.gz"
      sha256 "39f1ff67d82d246ec6e9053d4ed3f0f468cf1ec5c9cf28497e0a70d87ebacf08"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.5.1/caplo_0.5.1_linux_arm64.tar.gz"
      sha256 "3b46b55ecc43df75487675c5ab316a21a1061749f0a016950efbcafa0d369a78"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.5.1/caplo_0.5.1_linux_amd64.tar.gz"
      sha256 "de725671b333638ada68d0b79ca0bd3fe02f7131872b0d106668be944807924e"
    end
  end

  def install
    bin.install "caplo"
  end

  test do
    assert_equal "caplo #{version}", shell_output("#{bin}/caplo --version").strip
    ENV["CAPLO_CONFIG_DIR"] = testpath/"config"
    assert_equal "https://api.caplo.si", shell_output("#{bin}/caplo config get api-url").strip
  end
end
