class AnytypeRpc < Formula
  desc "Anytype gRPC client"
  homepage "https://github.com/stevelr/anytype"
  version "0.3.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.3.1/anytype-rpc-aarch64-apple-darwin.tar.xz"
      sha256 "1737d49f764286cbb3857d886b2f06d4c069f3d053ce388d4c032b93f6719733"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.3.1/anytype-rpc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e56d348450de160867dfe8a84bdf4ac17cce7247016da354dbab70c4fa97b8b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anytype-rpc-v0.3.1/anytype-rpc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab3a9be887732afe1c566f193b476b55448f874da829022ed33511235cfb03b8"
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
