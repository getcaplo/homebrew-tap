class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.4.0"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.4.0/caplo_0.4.0_darwin_arm64.tar.gz"
      sha256 "d501282646235c68d72d1370ecaf1cff794161ec3271d3fde2b83b33766717df"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.4.0/caplo_0.4.0_darwin_amd64.tar.gz"
      sha256 "ba155ba76a7c9dfb2fec31cb8a1c2f77b2ae80892683bb5c16cfd3ea77ca42c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.4.0/caplo_0.4.0_linux_arm64.tar.gz"
      sha256 "76936daddf788bd2ede9cb142de14dc9b9c1f00f788a03a139dd47673dedd382"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.4.0/caplo_0.4.0_linux_amd64.tar.gz"
      sha256 "487b6dffcbc6d90df83584726f97d41656af2c7da8bb8bf6fc034e8396ab0174"
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
