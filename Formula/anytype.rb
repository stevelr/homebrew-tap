class Anytype < Formula
  desc "An ergonomic Anytype API client in rust"
  homepage "https://github.com/stevelr/anytype"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.0/anytype-aarch64-apple-darwin.tar.xz"
      sha256 "305c1a80f4e49fb218e12a4314a7b9ed7903fbe925204609945eed59b8e5451e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.0/anytype-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a20b5a37a85e1eb79194708076113e602cebc216baf3082530c779aedda3e3b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.0/anytype-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ae4c91bec2ca344418def2e584260fab232e934a026d4100c1ad7844614a2a3"
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
