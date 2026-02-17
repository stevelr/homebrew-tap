class Anyr < Formula
  desc "CLI for Anytype - list, search, and perform CRUD operations on Anytype objects."
  homepage "https://github.com/stevelr/anytype"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.4.0/anyr-aarch64-apple-darwin.tar.xz"
      sha256 "30d2b69b3358276a6ec2b837fd10800617ec76373d3c9a8af9bbccb614094e1f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.4.0/anyr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "70ba78a2cf6fa212cb070d7956adade7f7ac67a3cee1353bf2522f004e313dab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.4.0/anyr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1e554b94511f3cb74b03eb566e6887536ace1f2d5f5aadba422f51dffa9055ed"
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
