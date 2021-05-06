class WaylandProtocols < Formula
  desc "Additional Wayland protocols"
  homepage "https://wayland.freedesktop.org"
  url "https://wayland.freedesktop.org/releases/wayland-protocols-1.21.tar.xz"
  sha256 "b99945842d8be18817c26ee77dafa157883af89268e15f4a5a1a1ff3ffa4cde5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "64e9fc4ff59725f13c60644b9157d099d283eaedc35a451f2b5d6814a3cc9b3c"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "wayland" => :build
  depends_on :linux

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "wayland-protocols"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
