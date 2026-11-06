class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.1.0/caplo_0.1.0_darwin_arm64.tar.gz"
      sha256 "aa770bcdea202df2ab2389b4c5c896aa94f8b46ef2381a63deb14421f0fa6681"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.1.0/caplo_0.1.0_darwin_amd64.tar.gz"
      sha256 "eed91796a6350e8b1110c647541acc96d2f79a0ade95dd9f6946730f88397205"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.1.0/caplo_0.1.0_linux_arm64.tar.gz"
      sha256 "5bb53d5b7b16bdeba0ee80f8ef0ed547718d30babc906444615d883aecd95dd7"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.1.0/caplo_0.1.0_linux_amd64.tar.gz"
      sha256 "79c862c7256c6e9ec5f9f740f52dcde1f9e6eb92c646c3c1d72cb10835eb1a9e"
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
