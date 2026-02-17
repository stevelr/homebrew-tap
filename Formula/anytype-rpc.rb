class AnytypeRpc < Formula
  desc "Anytype gRPC client"
  homepage "https://github.com/stevelr/anytype"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.3.0/anytype-rpc-aarch64-apple-darwin.tar.xz"
      sha256 "c668ebc39528eb1bf18d54edf9354d0b1d80fa2d9e7e97bbe471ad68a6bb5579"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.3.0/anytype-rpc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "972155ce6a7532c59fac446982b3ca255ec27cd420ae813d8b98abd6896f6905"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.3.0/anytype-rpc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d42a10f8691c97ac3faa63ffd811d783098071a7ae44082d537291704f9c4c99"
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
    bin.install "anytype-rpc" if OS.mac? && Hardware::CPU.arm?
    bin.install "anytype-rpc" if OS.linux? && Hardware::CPU.arm?
    bin.install "anytype-rpc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
