class ZLua < Formula
  desc "New cd command that helps you navigate faster by learning your habits"
  homepage "https://github.com/skywind3000/z.lua"
  url "https://github.com/skywind3000/z.lua/archive/1.8.13.tar.gz"
  sha256 "a1215d727527e358363687a7e0b3605a132465e60a915f8e99bb5338a9c62ec6"
  license "MIT"
  head "https://github.com/skywind3000/z.lua.git", branch: "master"

  depends_on "lua"

  def install
    pkgshare.install "z.lua", "z.lua.plugin.zsh", "init.fish"
    doc.install "README.md", "LICENSE"
  end

  test do
    system "lua", "#{opt_pkgshare}/z.lua", "."
  end
end
