class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data."
  homepage "http://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.13.0.tar.gz"
  sha256 "477552a137f3658d7b476c921a3c6d20506ab0526e89defc1c1b21cd0634d168"

  bottle do
    cellar :any_skip_relocation
    sha256 "186d35d2a8c27aaab3fcf426a4e5434159a6da61f9cd73c21a1fb72dadedc405" => :sierra
    sha256 "186d35d2a8c27aaab3fcf426a4e5434159a6da61f9cd73c21a1fb72dadedc405" => :el_capitan
    sha256 "186d35d2a8c27aaab3fcf426a4e5434159a6da61f9cd73c21a1fb72dadedc405" => :yosemite
    sha256 "0aa4a22f64989034f677d57a9395ae54e3fdd6623912918e8f3bd6c78030295f" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :optional
  depends_on "expat" => :optional
  depends_on "gdal" => :optional
  depends_on "proj" => :optional
  depends_on "doxygen" => :optional
  depends_on "expat" unless OS.mac?

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    mkdir "build" do
      system "cmake", *std_cmake_args, "-DINSTALL_GDALCPP=ON", "-DINSTALL_PROTOZERO=ON", "-DINSTALL_UTFCPP=ON", ".."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.osm").write <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <osm version="0.6" generator="handwritten">
      <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
      <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
      <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
        <nd ref="1"/>
        <nd ref="2"/>
        <tag k="name" v="line"/>
      </way>
      <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
        <member type="node" ref="1" role=""/>
        <member type="way" ref="1" role=""/>
      </relation>
    </osm>
    EOS

    (testpath/"test.cpp").write <<-EOS.undent
    #include <cstdlib>
    #include <iostream>
    #include <osmium/io/xml_input.hpp>

    int main(int argc, char* argv[]) {
      osmium::io::File input_file{argv[1]};
      osmium::io::Reader reader{input_file};
      while (osmium::memory::Buffer buffer = reader.read()) {}
      reader.close();
    }
    EOS

    system ENV.cxx, "-std=c++11", *("-stdlib=libc++" if OS.mac?), "-o", "libosmium_read", "test.cpp", "-lexpat"
    system "./libosmium_read", "test.osm"
  end
end
