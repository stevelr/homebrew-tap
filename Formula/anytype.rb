class Anytype < Formula
  desc "An ergonomic Anytype API client in rust"
  homepage "https://github.com/stevelr/anytype"
  version "0.3.2"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.2/anytype-aarch64-apple-darwin.tar.xz"
      sha256 "88699b0a8a2eb3db5cf1e1f6f5668897adf48cb215a1042379d287f1d2fe3c8a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.2/anytype-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11eaf08d8fc0ec46df91348d0ecff08a02b0f89634fc517b05a4e0a0f4806e93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.2/anytype-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d5385f66b1cfd0e6d95063fda3829303e66e553a805c28eda2fc2fdc071d569e"
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
    bin.install "anytype-mock-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "anytype-mock-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "anytype-mock-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
