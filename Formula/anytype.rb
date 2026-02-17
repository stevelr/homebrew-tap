class Anytype < Formula
  desc "An ergonomic Anytype API client in rust"
  homepage "https://github.com/stevelr/anytype"
  version "0.3.1"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.1/anytype-aarch64-apple-darwin.tar.xz"
      sha256 "19ac709893d447d78aa90066c83e72c1883748397199aae39753858a088ec742"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.1/anytype-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fc4622da4d2a16188e3b7cc5029bde57511d57da774caf96905d311a733c6111"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anytype-v0.3.1/anytype-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "76f45b2dc54b4e610e731fb8476e65e1f19876bf84bf062c7a46e87eed8dd711"
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
