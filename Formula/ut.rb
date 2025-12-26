class Ut < Formula
  desc "A utility toolkit of most commonly used tools by software developers and IT professionals"
  homepage "https://github.com/ksdme/ut"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.6.0/ut-aarch64-apple-darwin.tar.xz"
      sha256 "e985246500d3b16905889bcba3a6f4773442cfc325c773a418eadf880d635c67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.6.0/ut-x86_64-apple-darwin.tar.xz"
      sha256 "7aa7588ae5e140a5e3f1f77ed5574b94ece3a24635bab78490b500698dcbcde9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.6.0/ut-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c8bf5892f288241758bfe03f213034f6d7dd592adf059c1b926f02d5095bdc1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.6.0/ut-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa5c44084e05ce777ea3739709a4ef8511396218e0806b5f5c560736db468183"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ut" if OS.mac? && Hardware::CPU.arm?
    bin.install "ut" if OS.mac? && Hardware::CPU.intel?
    bin.install "ut" if OS.linux? && Hardware::CPU.arm?
    bin.install "ut" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
