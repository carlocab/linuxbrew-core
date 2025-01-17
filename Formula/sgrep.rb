class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  url "https://www.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/old/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  # The current formula version (1.94a) is an alpha version, so this regex
  # has to allow for unstable versions. If/when a new stable version after 0.99
  # ever appears, the optional `[a-z]?` part of this regex should be removed,
  # so it will only match stable versions.
  livecheck do
    url "https://www.cs.helsinki.fi/pub/Software/Local/Sgrep/"
    regex(/href=.*?sgrep[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:      "fedcff86ec032617015882c5729298bbe1f1fcbda14cdde6167b00ae2af586b8"
    sha256 cellar: :any_skip_relocation, catalina:     "29e528a52ae36131ded52bb08d9cf9b12b1455fbc715f7b7bbd3b97f637862e5"
    sha256 cellar: :any_skip_relocation, mojave:       "bfb1f484dd474727fec463b1b90ffe7250f5c82e0e65bec96903e38f6e0a8e48"
    sha256 cellar: :any_skip_relocation, high_sierra:  "a243589e79a4cde4f7bba21ec618e3c323c049589707bde6e2c20c4bf1014464"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ff024211da0c2b68e6f037a286c40c812d040aeb1c1bd1fda04791576d1f980e" # linuxbrew-core
  end

  uses_from_macos "m4"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.eps")
    assert_equal "2", shell_output("#{bin}/sgrep -c '\"mark\"' #{input}").strip
  end
end
