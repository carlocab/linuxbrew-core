class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.076.1.tar.gz"
    sha256 "242e0dccf0b5aabd3a886c1aca32e6b197dfef015005f45bd36050f8a4fded5c"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.076.1.tar.gz"
      sha256 "28950dce412e3bba27030464eb91e99621f4f2c0cd0ba680a6361911776f89b0"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.076.1.tar.gz"
      sha256 "d253e6f23d91b8d544dea0b3c8ca4a13abfc2b13642f31f76b6ad2c1dd49615b"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.076.1.tar.gz"
      sha256 "cf42d4e5f9ceb5acfb5bd3000dd9c1ed7120b136f252b33b07fb026f36970e77"
    end
  end

  bottle do
    sha256 "3b52b4fd9f660e97e654b9040b9467c998c77aa57fc17997fb75773587196cf1" => :high_sierra
    sha256 "ce763c7da5b88d2f6e63d990e26cc286a6d96534e975fa1d04c45729885e0f21" => :sierra
    sha256 "fd4a9e180181c408001afc14fdaf6c5118b180c2bf814ff09c5ea4814b3f9285" => :el_capitan
    sha256 "94f880952aee92e7770294c4517cb635aa0978955827f73ba0aca72ad49a241e" => :x86_64_linux
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.076.1-b1.tar.gz"
    version "2.076.1-b1"
    sha256 "7151244b37e46e19b2d71be4d88fbae5becbc29b903705e13937e40c721a4e36"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.076.1-b1.tar.gz"
      version "2.076.1-b1"
      sha256 "80071589fbe75c2ed9549e007d79f4feccbd2dda9580c45e401ca89a296c8ce0"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.076.1-b1.tar.gz"
      version "2.076.1-b1"
      sha256 "992ff709069810bebb5bc26263f6e939d52dff1f27ee80ee095075e6f587f5da"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.076.1-b1.tar.gz"
      version "2.076.1-b1"
      sha256 "a56cf6f00ea0fd17aa8a1219aba08291f71b63cf8a41614b4f59b39b72982280"
    end
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.077.0-beta.1.tar.gz"
    sha256 "370ffa579b42522df5686fd0348fdf5ab262bceee8a4a9dab66b4e70a4f8affd"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.077.0-beta.1.tar.gz"
      sha256 "10546e1c505a69a2f88b1566abc02a39abfe835bb2bc877aec56e569a784a7df"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.077.0-beta.1.tar.gz"
      sha256 "34fd61c21a2a406a38b20288fffa52deae800e6bebf6feb4276865e207f3ac04"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.077.0-beta.1.tar.gz"
      sha256 "91a642a59d77b660cfd800cfd8c447c95c6e50e466ffea545fc99a271254be82"
    end
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  depends_on "unzip" => :build unless OS.mac?

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"
    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    (buildpath/"dmd.conf").write <<-EOS.undent
      [Environment]
      DFLAGS=-I#{opt_include}/dlang/dmd -L-L#{opt_lib}
    EOS
    etc.install "dmd.conf"
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
