class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.9/dateutils-0.4.9.tar.xz"
  sha256 "790256d9949b96001fdcc3f7c42226dde4fcc87eb580717c7aabf51a1334c9c3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "329fcec20635c81fa467d609492f7779ec14966333a637de9ccb5b3111b6e837"
    sha256 big_sur:       "c7a4363a86d92e2b50d684c92b140a15a1561fe2c3d3893897e2373a4ff69cd1"
    sha256 catalina:      "7063687db254af7470c99f53c9f48e32582339cc30da5e07b366e7dab9914b74"
    sha256 mojave:        "562a3f8290f1d8f9f5ff0471d0e817375aa46914d34c38ea8ac68a22fe00b799"
    sha256 x86_64_linux:  "4d9332e0514a4d7a08c135b329ec422343aa70c4d80d5dd91683dfd32b2e7c20" # linuxbrew-core
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
    assert_equal "2012-03-01-07", output
  end
end
