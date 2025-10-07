class Ut < Formula
  desc "A utility toolkit of most commonly used tools by software developers and IT professionals"
  homepage "https://github.com/ksdme/ut"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.2.0/ut-aarch64-apple-darwin.tar.xz"
      sha256 "66521a672876a62dc94e5be0a7f85c5119b11c8883d604ef2b4bf790fd26e311"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.2.0/ut-x86_64-apple-darwin.tar.xz"
      sha256 "cd294bd4a376d7d4f365c688072028f33aaf29238855854d509d6a899b10b31d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.2.0/ut-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "78de913aaa448a0e7ddc8558649e7e0a41350a646c4ef977ad394223607ecd98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.2.0/ut-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c04c114d90f31f2f11219790d65de5ad1e2bee746b47ad5b5ad39cc37ba4fae5"
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
