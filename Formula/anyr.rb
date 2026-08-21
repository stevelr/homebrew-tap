class Anyr < Formula
  desc "CLI for Anytype - list, search, and perform CRUD operations on Anytype objects."
  homepage "https://github.com/stevelr/anytype"
  version "0.5.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.1/anyr-aarch64-apple-darwin.tar.xz"
    sha256 "2552aa016377101d7f716aa74b564251541b779966c4c668f0595b6b027e0c27"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.1/anyr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b3fc4aa84266155c0cf39097bf6e3316d4748670a489f3f2c41f3121c69f7745"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.1/anyr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28a3b247e0b20f2155841857e8b7a6d0bf78ded91d6450c560c401975b38e53b"
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
