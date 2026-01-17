class AnyEdit < Formula
  desc "Edit Anytype documents in an external editor"
  homepage "https://github.com/stevelr/anytype"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/any-edit-v0.1.2/any-edit-aarch64-apple-darwin.tar.xz"
      sha256 "9cad75ccf652b78bef131ce38d852f25663c74815f340c272e62ffc7574e1b1b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/any-edit-v0.1.2/any-edit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc8c086062e69c7399e618ab1e9d51eb26e48fbe01c9e4be4a4c588f186b22f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/any-edit-v0.1.2/any-edit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3667f2ce4567432a5d76122ddd88dc7af5760cc47899159360bfe6ee6ecc66c9"
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
    bin.install "any-edit" if OS.mac? && Hardware::CPU.arm?
    bin.install "any-edit" if OS.linux? && Hardware::CPU.arm?
    bin.install "any-edit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
