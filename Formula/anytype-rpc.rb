class AnytypeRpc < Formula
  desc "Anytype gRPC client"
  homepage "https://github.com/stevelr/anytype"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.2.1/anytype-rpc-aarch64-apple-darwin.tar.xz"
      sha256 "8eaa17c46843de933ee7685e717d8f14db90d146f7653a7ae2c9d48c3e1aa6cd"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.2.1/anytype-rpc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "77b8d6c0514731e049e1aa760d949a1d5b89653b5003271037a4542223c5c8ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.2.1/anytype-rpc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d05edcb40e83137aae5546cf120e8a422be2616373faee7fcb2df275d1a8ae74"
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
