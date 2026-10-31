class Ut < Formula
  desc "A utility toolkit of most commonly used tools by software developers and IT professionals"
  homepage "https://github.com/ksdme/ut"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.7.0/ut-aarch64-apple-darwin.tar.xz"
      sha256 "7b52f3213a4ef22002763530e7bf1d3fd3e32e18cf0e9ea81a3a7342428010d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.7.0/ut-x86_64-apple-darwin.tar.xz"
      sha256 "2c6c05ab105f05a4a98ea7c32ad46b19f9858432b116cb25246be6c47f1046ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.7.0/ut-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8a36582567193a891e210afb90aaf67081270339c805489e2a24bcc20c5f3db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.7.0/ut-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "39ec132ef8aff6bf78a5d84e65902ce78c2114ae364f258af42790d561e610a4"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ut"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ut"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ut"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ut"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
