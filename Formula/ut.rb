class Ut < Formula
  desc "A utility toolkit of most commonly used tools by software developers and IT professionals"
  homepage "https://github.com/ksdme/ut"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.5.0/ut-aarch64-apple-darwin.tar.xz"
      sha256 "e664b08e6ebc17e6b718b240edb67eeaaf3a9b143fef799d2dc686f08d57ab79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.5.0/ut-x86_64-apple-darwin.tar.xz"
      sha256 "221ac7f4932d6c6285635241c5287f52b89b2c29d8169fb77c916ce06f8df56e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.5.0/ut-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c43bfc90ef0169a334d735922ca5bc5a06b5667a7ec89f82e10978ba2853cfb7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.5.0/ut-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9bb7034ca17a8176ca42542c9f585c9a8bd79ec5cabe05da46582129f469a9e9"
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
