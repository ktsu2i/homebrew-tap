class Jevgate < Formula
  desc "Decide whether a change can rely on an AI code reviewer's approval"
  homepage "https://github.com/ktsu2i/jevgate"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ktsu2i/jevgate/releases/download/v0.1.0/jevgate_0.1.0_darwin_arm64.tar.gz"
      sha256 "2c75489053626d8ef1e3403e560ea6c86e9b7fa4a558c7309413de893af5bf5a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ktsu2i/jevgate/releases/download/v0.1.0/jevgate_0.1.0_darwin_amd64.tar.gz"
      sha256 "7cabd8038a6eac8b8ed2e307ef07d651d8052adfb183c917cdd35ac1fd17a6e5"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/ktsu2i/jevgate/releases/download/v0.1.0/jevgate_0.1.0_linux_arm64.tar.gz"
      sha256 "d4e71d9a91fec29b1afefd624c0eb639626023434c2f3e45668ce4bb3ef800ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ktsu2i/jevgate/releases/download/v0.1.0/jevgate_0.1.0_linux_amd64.tar.gz"
      sha256 "2ebe9f2119da9abba3296b5a67704d8150a2fc726d11cce4fcf05a9079ee8b0e"
    end
  end

  head do
    url "https://github.com/ktsu2i/jevgate.git", branch: "main"
    depends_on "go" => :build
  end

  def install
    if build.head?
      ldflags = "-X github.com/ktsu2i/jevgate/internal/cli.version=#{version}"
      system "go", "build", *std_go_args(ldflags:), "./cmd/jevgate"
    else
      bin.install "jevgate"
    end
  end

  test do
    assert_match "jevgate #{version}", shell_output("#{bin}/jevgate --version")
    assert_match "Usage:", shell_output("#{bin}/jevgate --help")
    assert_match "expected exactly 2 revisions", shell_output("#{bin}/jevgate 2>&1", 2)
  end
end
