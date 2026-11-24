class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.6.0"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.6.0/caplo_0.6.0_darwin_arm64.tar.gz"
      sha256 "876092300de670ad88f20eda723e13770fd331a7471bcdc7180f4b87fcec7460"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.6.0/caplo_0.6.0_darwin_amd64.tar.gz"
      sha256 "98b75ee12b41d8c6adbc8461d75667b67a9ecf89c1f1a32c6357e48f0361a6de"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.6.0/caplo_0.6.0_linux_arm64.tar.gz"
      sha256 "b610538907780cdc54a6dffa6fd853c297e244f3962db9dce31c4e43f56aa70e"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.6.0/caplo_0.6.0_linux_amd64.tar.gz"
      sha256 "e25f434093d22d19cf70050fe04b9efe3fd4de8ac66181b80ca47582789a75a5"
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
