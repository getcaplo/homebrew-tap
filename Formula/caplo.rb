class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.3.0"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.3.0/caplo_0.3.0_darwin_arm64.tar.gz"
      sha256 "d3b28109b7e8247d59c9703ed5168aea66e3164731505fd6d825aa14bc292c00"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.3.0/caplo_0.3.0_darwin_amd64.tar.gz"
      sha256 "73ba26853fe0ecb90030defcca042602b2faad6300409b9bd35c4bf0f2807c6c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.3.0/caplo_0.3.0_linux_arm64.tar.gz"
      sha256 "d61c6d63e77444ce0f7b2e30819418f1472fc07bfc0d0f681c484c3fdbd0238d"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.3.0/caplo_0.3.0_linux_amd64.tar.gz"
      sha256 "1095480f346362cb2e02c490aadec590640f28c8a2f7494a0bc3cc8f0e97d60c"
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
