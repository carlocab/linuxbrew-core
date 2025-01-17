class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.9.2.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.2/doxygen-1.9.2.src.tar.gz"
  sha256 "060f254bcef48673cc7ccf542736b7455b67c110b30fdaa33512a5b09bbecee5"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a7ba50b992a11544f4a94ab93374eddeaef6aea5cfb2dfefb0c27a2976ef644"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3c10247d05fe6a007ad97b1131e522eec0729288bee680dfd3e5a4cca2ee5fb"
    sha256 cellar: :any_skip_relocation, catalina:      "d4651ac184617629b57a0842ecb267adb25c34fc0b61b08296d80ee68928b66d"
    sha256 cellar: :any_skip_relocation, mojave:        "cab7c99f874c1a498ce9b27ebd863a46dd9940b75a86da8782eef952d49e709a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb57a0c3c30e0c49a97c4823f1412cdcaccd8af7851c85f2eeb790ecf3cd795" # linuxbrew-core
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "gcc"
  end

  # Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
