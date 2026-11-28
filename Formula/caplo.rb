class Caplo < Formula
  desc "Command-line interface for Caplo agents, tools, and workspaces"
  homepage "https://app.caplo.si"
  version "0.8.0"

  on_macos do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.8.0/caplo_0.8.0_darwin_arm64.tar.gz"
      sha256 "fd1f13399ac79ccb7d28658ed17bc70be739f90b568083a6dccf2f45c68139b3"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.8.0/caplo_0.8.0_darwin_amd64.tar.gz"
      sha256 "5f1ac7cb010197298b0caed56cb2bf7409d13907f4ef19db985729c162c72d25"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.8.0/caplo_0.8.0_linux_arm64.tar.gz"
      sha256 "74d9cef6a33ba3b3cb5b59076febd2ffe1a444e15cd66491b4327796b7ee4683"
    end
    on_intel do
      url "https://github.com/getcaplo/homebrew-tap/releases/download/v0.8.0/caplo_0.8.0_linux_amd64.tar.gz"
      sha256 "b2148acf49c3429cc109b69c99f4108bdff0c389469cd07d5ef23cf7928faa40"
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
