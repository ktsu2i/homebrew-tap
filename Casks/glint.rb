cask "glint" do
  version "0.6.0"
  sha256 "0f2d647d25266e99f1ce28bce3d1a1cab5f403ad2f51ab56a0d91e36879d710d"

  url "https://github.com/ktsu2i/glint/releases/download/v#{version}/Glint-#{version}-darwin-universal.zip"
  name "Glint"
  desc "Technical book reader that maps chapters to your local codebase"
  homepage "https://github.com/ktsu2i/glint"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "Glint.app"

  zap trash: [
    "~/Library/Application Support/Glint",
    "~/Library/Caches/io.github.ktsu2i.glint",
    "~/Library/Preferences/io.github.ktsu2i.glint.plist",
    "~/Library/Saved Application State/io.github.ktsu2i.glint.savedState",
    "~/Library/WebKit/io.github.ktsu2i.glint",
  ]

  caveats <<~EOS
    Glint is not notarized by Apple yet, so macOS blocks the first launch.
    Allow it from System Settings > Privacy & Security > "Open Anyway", or run:
      xattr -dr com.apple.quarantine "#{appdir}/Glint.app"
  EOS
end
