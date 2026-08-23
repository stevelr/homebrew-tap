class Anyr < Formula
  desc "CLI for Anytype - list, search, and perform CRUD operations on Anytype objects."
  homepage "https://github.com/stevelr/anytype"
  version "0.5.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.2/anyr-aarch64-apple-darwin.tar.xz"
    sha256 "edeea88f6ce13569c242a47951c4366f1550e16dfc2d9b4b7f69a882b22d1829"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.2/anyr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d476e4ca3107307aee5e4effaf73e9e435a97b1cf6eab5774fa5a26c07c5f733"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.2/anyr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d00bd1d24dc53e2878609a70098aa487f5c337636c604469d9e00e6a256faab8"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "anyr"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "anyr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "anyr"
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
