require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.8.0.tgz"
  sha256 "f1b910e334542657a02707619ba80e406352912ad31c0901c048dc99f9e2488c"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce0dd7ef6ba82b4025154f56a49d511c7894363b4391260dec4c4f1051aacdd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f48fa6d16c117127c921ffb8faa2dc184417770c9d310a0fdf48f44571559f4"
    sha256 cellar: :any_skip_relocation, catalina:      "6f48fa6d16c117127c921ffb8faa2dc184417770c9d310a0fdf48f44571559f4"
    sha256 cellar: :any_skip_relocation, mojave:        "6f48fa6d16c117127c921ffb8faa2dc184417770c9d310a0fdf48f44571559f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f4b8336f47d89097850d05c577637256d379e1718cca4755935414a09fd04aa"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
