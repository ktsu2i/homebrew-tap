class Jevgate < Formula
  desc "Decide whether a change can rely on an AI code reviewer's approval"
  homepage "https://github.com/ktsu2i/jevgate"
  head "https://github.com/ktsu2i/jevgate.git", branch: "main"

  depends_on "go" => :build
  depends_on "git"

  def install
    ldflags = "-X github.com/ktsu2i/jevgate/internal/cli.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/jevgate"
  end

  test do
    assert_match "jevgate #{version}", shell_output("#{bin}/jevgate --version")
    assert_match "Usage:", shell_output("#{bin}/jevgate --help")
    assert_match "expected exactly 2 revisions", shell_output("#{bin}/jevgate 2>&1", 2)
  end
end
