class Anyr < Formula
  desc "CLI for Anytype - list, search, and perform CRUD operations on Anytype objects."
  homepage "https://github.com/stevelr/anytype"
  version "0.4.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.4.1/anyr-aarch64-apple-darwin.tar.xz"
      sha256 "56de6a4b14290ee4c9cf4c23aeb63b163a5e8c6145231371c8fbb10f3c33fc80"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.4.1/anyr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37c7b2c10e0a09813d97cae41363b91880e5931da6694a6a2dd1d3d32d065553"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.4.1/anyr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "671e079f64c026c14558f4699e847d973d9b9c2648b00925f3102c0eeaf28d3e"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
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
    bin.install "anyr" if OS.mac? && Hardware::CPU.arm?
    bin.install "anyr" if OS.linux? && Hardware::CPU.arm?
    bin.install "anyr" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
