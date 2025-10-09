class Ut < Formula
  desc "A utility toolkit of most commonly used tools by software developers and IT professionals"
  homepage "https://github.com/ksdme/ut"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.3.1/ut-aarch64-apple-darwin.tar.xz"
      sha256 "9199ed19ea7492c6869a419c2ad742392e7853834b85b2cee4ca26c19b734f87"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.3.1/ut-x86_64-apple-darwin.tar.xz"
      sha256 "dd8466816f81fafed955001d17073c6ff0bceb57ce1499d0195b25d147b4e950"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.3.1/ut-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96dd0a1e83e70cfa3809359f69b1af11a7c79f69e9ee92701e9e3b1409f319f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.3.1/ut-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac6ac9db5f4c8d0a1eee8871ad73f65dea14ee8e8ffd064281c6693466794336"
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
