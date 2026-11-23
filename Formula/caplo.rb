class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.5.0"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.5.0/caplo_0.5.0_darwin_arm64.tar.gz"
      sha256 "acddb5b671c8476bf3fe860523ada741a123c396fbc36d8a0ff6717a9fad982a"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.5.0/caplo_0.5.0_darwin_amd64.tar.gz"
      sha256 "5626ea5453f7564f0cb9ca0b22dec69d9998e678a0d33d8d1ef45e462d1e5418"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.5.0/caplo_0.5.0_linux_arm64.tar.gz"
      sha256 "d9f338019e79ac88203ac1b0ae221e03a02f808b1b5e9794cb7157a750ffc500"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.5.0/caplo_0.5.0_linux_amd64.tar.gz"
      sha256 "6351223834a4d621d76d8bd012e7532e6eb6c0fe29e3fc9de8d4d7bf48aeb41c"
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
