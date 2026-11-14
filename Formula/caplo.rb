class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.4.1"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.4.1/caplo_0.4.1_darwin_arm64.tar.gz"
      sha256 "77ebd1daec517923074d51a06e2b4ce45c4b37b260e2c1343d08d89de64741c0"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.4.1/caplo_0.4.1_darwin_amd64.tar.gz"
      sha256 "663bcf4e08018e3c49d3c6dcde624e15f600af3071687332284fd699509d4edc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.4.1/caplo_0.4.1_linux_arm64.tar.gz"
      sha256 "0114c4ad26eca79f8008bb37fd53e91702ef9361332ae4a118242bd14f8189b8"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.4.1/caplo_0.4.1_linux_amd64.tar.gz"
      sha256 "e6d7d14e0b36106183757e5ee8948b7f60dd33ba665d9a66e12a04a9f4c6b317"
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
