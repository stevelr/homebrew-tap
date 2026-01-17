class Anyr < Formula
  desc "CLI for Anytype - list, search, and perform CRUD operations on Anytype objects."
  homepage "https://github.com/stevelr/anytype"
  version "0.2.4"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.2.4/anyr-aarch64-apple-darwin.tar.xz"
      sha256 "138b27ac1b4ca0ff0f97c3562cdaef96bdb06bff373dd83c52781d648826475e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.2.4/anyr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "062252e0f50b836567311565cdce2ab37072e2c67ed3b536f29c21ef8e094235"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.2.4/anyr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "570962e47eeeaa9856a38c1760045a25646303b9673d7c5c97eb540b0b7e8075"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
