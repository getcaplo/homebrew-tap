class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.1.1"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.1.1/caplo_0.1.1_darwin_arm64.tar.gz"
      sha256 "4252158abd5bcfb0cb32cab0175b8864877cb5b6ed871832dc2a8aadeb150a43"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.1.1/caplo_0.1.1_darwin_amd64.tar.gz"
      sha256 "cfff646fbec53f93727d5c4cc3bbff2223ee78f23dcee18769ebeade6a549a3e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.1.1/caplo_0.1.1_linux_arm64.tar.gz"
      sha256 "809339f0bbf399e516efba0ff1c1aa4dac526ff936db5135347b1441c4808c00"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.1.1/caplo_0.1.1_linux_amd64.tar.gz"
      sha256 "01e4bdb0bf73c66086a05f3764d358411fc7830ae776dfeb20fd72c82ed6a4a4"
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
