class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.2.0/caplo_0.2.0_darwin_arm64.tar.gz"
      sha256 "2b9f75f8ed49336190afde95c936a830d6a8323e05449a4cf84066ec3f91b1ac"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.2.0/caplo_0.2.0_darwin_amd64.tar.gz"
      sha256 "99970dc8ef613ae15bc5bbbe15f44032b5daa6f4d4a8fb2af506b4d1fe07fb7c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.2.0/caplo_0.2.0_linux_arm64.tar.gz"
      sha256 "0c2e50c1e7b897c8b3eba58451d9497b4aba5e0067b02f3921adeb483b164fe4"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.2.0/caplo_0.2.0_linux_amd64.tar.gz"
      sha256 "8eab14b915e870c39db66727b172a0e9b0585f1c7a7d73376d57814b693f94af"
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
