class Ut < Formula
  desc "A utility toolkit of most commonly used tools by software developers and IT professionals"
  homepage "https://github.com/ksdme/ut"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.3.0/ut-aarch64-apple-darwin.tar.xz"
      sha256 "f6f0839fc43424fdb4732c1f5220852a0fd46f797832f9561cc3b1082d2ba4a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.3.0/ut-x86_64-apple-darwin.tar.xz"
      sha256 "f55491833db28f49775ac42ad4193befbf0e60ac879812a6c1f1e1ae2ebffeaf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ksdme/ut/releases/download/v0.3.0/ut-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57b2d18f7acc713cb51cac4d8be6cb05ca78c4dcf75c7bf08fd9cd77b544e611"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ksdme/ut/releases/download/v0.3.0/ut-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d65970281b4063ef7b80ca6c7ed33d17e5a5a762de81bb6dbb1c9d2d128ef382"
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
