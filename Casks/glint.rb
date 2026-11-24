cask "glint" do
  version "0.2.1"
  sha256 "f26d76cf42f2c5b8c53f9e3c92e59e1714f66652eafdedc215ee70032e9c00bf"

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
