class Richmd < Formula
  include Language::Python::Virtualenv

  desc "Format Markdown in the terminal with Rich"
  homepage "https://github.com/willmcgugan/rich"
  url "https://files.pythonhosted.org/packages/55/84/7edede78686a4ca67a1bb9d8eba31a99d4a2a0a670e80c9febbbc18a7076/rich-10.9.0.tar.gz"
  sha256 "ba285f1c519519490034284e6a9d2e6e3f16dc7690f2de3d9140737d81304d22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "925e9fdad71f19dcb57f18a319ab17ea625f9a7cb21d4dd8f10b19d374d919b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9d52dd444283f0ead1a9757171e0266dd104f8c5ec15d89cc8167b1372565a6"
    sha256 cellar: :any_skip_relocation, catalina:      "6348b72d42cb626946e0d17b6fdd51088f1a2b7da85d45a0602047e379bd0cff"
    sha256 cellar: :any_skip_relocation, mojave:        "8612c2719ab2777e0d89c8092479c66907b22b995f7492a1a7022ba16f0fd18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275746641f373704d2aa7db614944bc8f82e4735801859639c494a231c11ca97" # linuxbrew-core
  end

  depends_on "python@3.9"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  def install
    virtualenv_install_with_resources

    (bin/"richmd").write <<~SH
      #!/bin/bash
      #{libexec/"bin/python"} -m rich.markdown $@
    SH
  end

  test do
    (testpath/"foo.md").write("- Hello, World")
    assert_equal "• Hello, World", shell_output("#{bin}/richmd foo.md").strip
  end
end
